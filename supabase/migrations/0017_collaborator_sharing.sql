-- Migration 0017: Collaborator Sharing & Notifications
-- This enables users to see trips they are invited to and sends them notifications.

-- 1. Add invited_user_id to trip_collaborators so we can identify the invited user
alter table public.trip_collaborators add column if not exists invited_user_id uuid references auth.users (id) on delete cascade;

-- Helper to check if a user is an active collaborator on a trip
create or replace function public.is_active_collaborator(_trip_id text, _user_id uuid)
returns boolean as $$
begin
  return exists (
    select 1 from public.trip_collaborators
    where trip_id = _trip_id
      and invited_user_id = _user_id
      and status = 'active'
  );
end;
$$ language plpgsql security definer;

-- 2. Update RLS on trip_collaborators so invitees can see and update their own invites
drop policy if exists "Collaborators are viewable by the owner" on public.trip_collaborators;
create policy "Collaborators are viewable by owner or invitee"
  on public.trip_collaborators for select
  using (auth.uid() = user_id OR auth.uid() = invited_user_id);

drop policy if exists "Users can update their own collaborators" on public.trip_collaborators;
create policy "Users can update their own collaborators"
  on public.trip_collaborators for update
  using (auth.uid() = user_id OR auth.uid() = invited_user_id);

-- 3. Update RLS on Trips to allow active collaborators to view and update
drop policy if exists "Trips are viewable by their owner" on public.trips;
create policy "Trips are viewable by their owner or active collaborators"
  on public.trips for select
  using (auth.uid() = user_id OR public.is_active_collaborator(id, auth.uid()));

drop policy if exists "Users can update their own trips" on public.trips;
create policy "Users can update their own trips"
  on public.trips for update
  using (auth.uid() = user_id OR public.is_active_collaborator(id, auth.uid()));

-- 4. Update RLS on related trip entities
-- Trip Stops
drop policy if exists "Stops are viewable by their owner" on public.trip_stops;
create policy "Stops are viewable by owner or active collaborators"
  on public.trip_stops for select
  using (auth.uid() = user_id OR public.is_active_collaborator(trip_id, auth.uid()));

drop policy if exists "Users can update their own stops" on public.trip_stops;
create policy "Users can update their own stops"
  on public.trip_stops for update
  using (auth.uid() = user_id OR public.is_active_collaborator(trip_id, auth.uid()));

drop policy if exists "Users can insert their own stops" on public.trip_stops;
create policy "Users can insert their own stops"
  on public.trip_stops for insert
  with check (auth.uid() = user_id OR public.is_active_collaborator(trip_id, auth.uid()));

drop policy if exists "Users can delete their own stops" on public.trip_stops;
create policy "Users can delete their own stops"
  on public.trip_stops for delete
  using (auth.uid() = user_id OR public.is_active_collaborator(trip_id, auth.uid()));

-- Itinerary Items
drop policy if exists "Itinerary items are viewable by their owner" on public.itinerary_items;
create policy "Itinerary items viewable by owner or active collaborators"
  on public.itinerary_items for select
  using (auth.uid() = user_id OR public.is_active_collaborator(trip_id, auth.uid()));

drop policy if exists "Users can update their own itinerary items" on public.itinerary_items;
create policy "Users can update their own itinerary items"
  on public.itinerary_items for update
  using (auth.uid() = user_id OR public.is_active_collaborator(trip_id, auth.uid()));

drop policy if exists "Users can insert their own itinerary items" on public.itinerary_items;
create policy "Users can insert their own itinerary items"
  on public.itinerary_items for insert
  with check (auth.uid() = user_id OR public.is_active_collaborator(trip_id, auth.uid()));

drop policy if exists "Users can delete their own itinerary items" on public.itinerary_items;
create policy "Users can delete their own itinerary items"
  on public.itinerary_items for delete
  using (auth.uid() = user_id OR public.is_active_collaborator(trip_id, auth.uid()));

-- Checklist Items
drop policy if exists "Checklist items are viewable by their owner" on public.checklist_items;
create policy "Checklist items viewable by owner or active collaborators"
  on public.checklist_items for select
  using (auth.uid() = user_id OR public.is_active_collaborator(trip_id, auth.uid()));

drop policy if exists "Users can update their own checklist items" on public.checklist_items;
create policy "Users can update their own checklist items"
  on public.checklist_items for update
  using (auth.uid() = user_id OR public.is_active_collaborator(trip_id, auth.uid()));

drop policy if exists "Users can insert their own checklist items" on public.checklist_items;
create policy "Users can insert their own checklist items"
  on public.checklist_items for insert
  with check (auth.uid() = user_id OR public.is_active_collaborator(trip_id, auth.uid()));

drop policy if exists "Users can delete their own checklist items" on public.checklist_items;
create policy "Users can delete their own checklist items"
  on public.checklist_items for delete
  using (auth.uid() = user_id OR public.is_active_collaborator(trip_id, auth.uid()));

-- Documents
drop policy if exists "Documents are viewable by their owner" on public.documents;
create policy "Documents viewable by owner or active collaborators"
  on public.documents for select
  using (auth.uid() = user_id OR public.is_active_collaborator(trip_id, auth.uid()));

drop policy if exists "Users can update their own documents" on public.documents;
create policy "Users can update their own documents"
  on public.documents for update
  using (auth.uid() = user_id OR public.is_active_collaborator(trip_id, auth.uid()));

drop policy if exists "Users can insert their own documents" on public.documents;
create policy "Users can insert their own documents"
  on public.documents for insert
  with check (auth.uid() = user_id OR public.is_active_collaborator(trip_id, auth.uid()));

drop policy if exists "Users can delete their own documents" on public.documents;
create policy "Users can delete their own documents"
  on public.documents for delete
  using (auth.uid() = user_id OR public.is_active_collaborator(trip_id, auth.uid()));

-- Trip Budgets
drop policy if exists "Budgets are viewable by their owner" on public.trip_budgets;
create policy "Budgets viewable by owner or active collaborators"
  on public.trip_budgets for select
  using (auth.uid() = user_id OR public.is_active_collaborator(trip_id, auth.uid()));

drop policy if exists "Users can update their own budget" on public.trip_budgets;
create policy "Users can update their own budget"
  on public.trip_budgets for update
  using (auth.uid() = user_id OR public.is_active_collaborator(trip_id, auth.uid()));

drop policy if exists "Users can insert their own budget" on public.trip_budgets;
create policy "Users can insert their own budget"
  on public.trip_budgets for insert
  with check (auth.uid() = user_id OR public.is_active_collaborator(trip_id, auth.uid()));

drop policy if exists "Users can delete their own budget" on public.trip_budgets;
create policy "Users can delete their own budget"
  on public.trip_budgets for delete
  using (auth.uid() = user_id OR public.is_active_collaborator(trip_id, auth.uid()));

-- Expenses
drop policy if exists "Expenses are viewable by their owner" on public.expenses;
create policy "Expenses viewable by owner or active collaborators"
  on public.expenses for select
  using (auth.uid() = user_id OR public.is_active_collaborator(trip_id, auth.uid()));

drop policy if exists "Users can update their own expenses" on public.expenses;
create policy "Users can update their own expenses"
  on public.expenses for update
  using (auth.uid() = user_id OR public.is_active_collaborator(trip_id, auth.uid()));

drop policy if exists "Users can insert their own expenses" on public.expenses;
create policy "Users can insert their own expenses"
  on public.expenses for insert
  with check (auth.uid() = user_id OR public.is_active_collaborator(trip_id, auth.uid()));

drop policy if exists "Users can delete their own expenses" on public.expenses;
create policy "Users can delete their own expenses"
  on public.expenses for delete
  using (auth.uid() = user_id OR public.is_active_collaborator(trip_id, auth.uid()));

-- 5. Trigger to auto-populate invited_user_id and send notification when an invite is created
create or replace function public.handle_new_collaborator()
returns trigger as $$
declare
  v_invited_uid uuid;
  v_trip_title text;
  v_inviter_email text;
begin
  -- Find if the invited email exists in auth.users
  select id into v_invited_uid from auth.users where email = NEW.email;

  if v_invited_uid is not null then
    NEW.invited_user_id = v_invited_uid;
    
    -- Get trip title and inviter email for the notification
    select title into v_trip_title from public.trips where id = NEW.trip_id;
    select email into v_inviter_email from auth.users where id = NEW.user_id;

    -- Insert a notification for the invited user
    insert into public.notifications (id, user_id, kind, trip_id, trip_title, subject, created_at)
    values (gen_random_uuid()::text, v_invited_uid, 'collaboratorInvited', NEW.trip_id, v_trip_title, v_inviter_email, now());
  end if;

  return NEW;
end;
$$ language plpgsql security definer;

drop trigger if exists on_collaborator_added on public.trip_collaborators;
create trigger on_collaborator_added
  before insert on public.trip_collaborators
  for each row execute function public.handle_new_collaborator();

-- 6. Trigger to handle users who register AFTER being invited
create or replace function public.handle_new_user_invites()
returns trigger as $$
begin
  -- Link existing invites to this new user
  update public.trip_collaborators
  set invited_user_id = NEW.id
  where email = NEW.email and invited_user_id is null;

  -- Create notifications for them for all pending invites they just got access to
  insert into public.notifications (id, user_id, kind, trip_id, trip_title, subject, created_at)
  select gen_random_uuid()::text, NEW.id, 'collaboratorInvited', tc.trip_id, t.title, u.email, now()
  from public.trip_collaborators tc
  join public.trips t on t.id = tc.trip_id
  join auth.users u on u.id = tc.user_id
  where tc.email = NEW.email and tc.status = 'pending';

  return NEW;
end;
$$ language plpgsql security definer;

drop trigger if exists on_user_registered on auth.users;
create trigger on_user_registered
  after insert on auth.users
  for each row execute function public.handle_new_user_invites();
