-- Migration 0018: Fix Collaborator Triggers
-- Splits the collaborator invite logic into a BEFORE trigger (to set the user ID)
-- and an AFTER INSERT trigger (to send the notification). This prevents duplicate
-- notifications when an existing collaborator is updated (e.g. changing roles) 
-- via an UPSERT which fires BEFORE INSERT triggers even if it results in an UPDATE.

-- 1. Function and Trigger to populate invited_user_id
create or replace function public.populate_invited_user_id()
returns trigger as $$
begin
  -- Only attempt to find the user if it's not already set
  if NEW.invited_user_id is null then
    select id into NEW.invited_user_id from auth.users where email = NEW.email;
  end if;
  return NEW;
end;
$$ language plpgsql security definer;

drop trigger if exists before_collaborator_added on public.trip_collaborators;
create trigger before_collaborator_added
  before insert or update on public.trip_collaborators
  for each row execute function public.populate_invited_user_id();


-- 2. Function and Trigger to send notification ONLY on successful insert
create or replace function public.send_collaborator_invite_notification()
returns trigger as $$
declare
  v_trip_title text;
  v_inviter_email text;
begin
  -- If the user exists, send them a notification immediately
  if NEW.invited_user_id is not null then
    select title into v_trip_title from public.trips where id = NEW.trip_id;
    select email into v_inviter_email from auth.users where id = NEW.user_id;

    insert into public.notifications (id, user_id, kind, trip_id, trip_title, subject, created_at)
    values (gen_random_uuid()::text, NEW.invited_user_id, 'collaboratorInvited', NEW.trip_id, v_trip_title, v_inviter_email, now());
  end if;

  return NEW;
end;
$$ language plpgsql security definer;

-- Drop the old trigger from 0017 that caused the duplicates
drop trigger if exists on_collaborator_added on public.trip_collaborators;

-- Create the new AFTER INSERT trigger
drop trigger if exists after_collaborator_added on public.trip_collaborators;
create trigger after_collaborator_added
  after insert on public.trip_collaborators
  for each row execute function public.send_collaborator_invite_notification();
