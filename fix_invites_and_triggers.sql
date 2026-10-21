-- 1. Fix old invites that were missing invited_user_id
UPDATE public.trip_collaborators tc
SET invited_user_id = u.id
FROM auth.users u
WHERE tc.email = u.email AND tc.invited_user_id IS NULL;

-- 2. Fix the trigger so role updates don't send duplicate notifications
drop trigger if exists on_collaborator_added on public.trip_collaborators;

create or replace function public.populate_collaborator_user_id()
returns trigger as $$
declare
  v_invited_uid uuid;
begin
  select id into v_invited_uid from auth.users where email = NEW.email;
  if v_invited_uid is not null then
    NEW.invited_user_id = v_invited_uid;
  end if;
  return NEW;
end;
$$ language plpgsql security definer;

create trigger populate_collaborator_user_id_trigger
  before insert or update on public.trip_collaborators
  for each row execute function public.populate_collaborator_user_id();

create or replace function public.notify_new_collaborator()
returns trigger as $$
declare
  v_trip_title text;
  v_inviter_email text;
begin
  if NEW.invited_user_id is not null then
    select title into v_trip_title from public.trips where id = NEW.trip_id;
    select email into v_inviter_email from auth.users where id = NEW.user_id;

    insert into public.notifications (id, user_id, kind, trip_id, trip_title, subject, created_at)
    values (gen_random_uuid()::text, NEW.invited_user_id, 'collaboratorInvited', NEW.trip_id, v_trip_title, v_inviter_email, now());
  end if;
  return NEW;
end;
$$ language plpgsql security definer;

create trigger notify_new_collaborator_trigger
  after insert on public.trip_collaborators
  for each row execute function public.notify_new_collaborator();
