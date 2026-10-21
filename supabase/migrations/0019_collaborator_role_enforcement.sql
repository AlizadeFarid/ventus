-- Migration 0019: Enforce collaborator role (editor vs viewer) in RLS.
--
-- Bug: `is_active_collaborator()` (introduced in 0017) only checks
-- `status = 'active'` and is used as the write-gate (insert/update/delete)
-- for trips and every trip sub-resource. It never checks `role`, so a
-- collaborator invited as 'viewer' — documented in the app as
-- "Can view the trip but not make changes" (see
-- lib/features/trips/domain/collaborator_role.dart) — has exactly the same
-- database write access as an 'editor'. Any active collaborator can
-- insert/update/delete a shared trip's stops, itinerary, checklist,
-- documents, budget, and expenses by calling the Supabase REST API
-- directly, regardless of their assigned role.
--
-- Fix: keep `is_active_collaborator()` as the *read* gate (any active
-- collaborator, editor or viewer, may see the trip), and introduce
-- `is_active_editor()` as a stricter *write* gate that additionally
-- requires `role = 'editor'`. Every insert/update/delete policy that
-- previously used `is_active_collaborator()` is redefined to use
-- `is_active_editor()` instead. Select policies are untouched.

-- Stricter helper: only an active collaborator with the 'editor' role.
create or replace function public.is_active_editor(_trip_id text, _user_id uuid)
returns boolean as $$
begin
  return exists (
    select 1 from public.trip_collaborators
    where trip_id = _trip_id
      and invited_user_id = _user_id
      and status = 'active'
      and role = 'editor'
  );
end;
$$ language plpgsql security definer;

-- Trips: update only (insert/delete were already owner-only, untouched).
drop policy if exists "Users can update their own trips" on public.trips;
create policy "Users can update their own trips"
  on public.trips for update
  using (auth.uid() = user_id OR public.is_active_editor(id, auth.uid()))
  with check (auth.uid() = user_id OR public.is_active_editor(id, auth.uid()));

-- Trip Stops
drop policy if exists "Users can update their own stops" on public.trip_stops;
create policy "Users can update their own stops"
  on public.trip_stops for update
  using (auth.uid() = user_id OR public.is_active_editor(trip_id, auth.uid()));

drop policy if exists "Users can insert their own stops" on public.trip_stops;
create policy "Users can insert their own stops"
  on public.trip_stops for insert
  with check (auth.uid() = user_id OR public.is_active_editor(trip_id, auth.uid()));

drop policy if exists "Users can delete their own stops" on public.trip_stops;
create policy "Users can delete their own stops"
  on public.trip_stops for delete
  using (auth.uid() = user_id OR public.is_active_editor(trip_id, auth.uid()));

-- Itinerary Items
drop policy if exists "Users can update their own itinerary items" on public.itinerary_items;
create policy "Users can update their own itinerary items"
  on public.itinerary_items for update
  using (auth.uid() = user_id OR public.is_active_editor(trip_id, auth.uid()));

drop policy if exists "Users can insert their own itinerary items" on public.itinerary_items;
create policy "Users can insert their own itinerary items"
  on public.itinerary_items for insert
  with check (auth.uid() = user_id OR public.is_active_editor(trip_id, auth.uid()));

drop policy if exists "Users can delete their own itinerary items" on public.itinerary_items;
create policy "Users can delete their own itinerary items"
  on public.itinerary_items for delete
  using (auth.uid() = user_id OR public.is_active_editor(trip_id, auth.uid()));

-- Checklist Items
drop policy if exists "Users can update their own checklist items" on public.checklist_items;
create policy "Users can update their own checklist items"
  on public.checklist_items for update
  using (auth.uid() = user_id OR public.is_active_editor(trip_id, auth.uid()));

drop policy if exists "Users can insert their own checklist items" on public.checklist_items;
create policy "Users can insert their own checklist items"
  on public.checklist_items for insert
  with check (auth.uid() = user_id OR public.is_active_editor(trip_id, auth.uid()));

drop policy if exists "Users can delete their own checklist items" on public.checklist_items;
create policy "Users can delete their own checklist items"
  on public.checklist_items for delete
  using (auth.uid() = user_id OR public.is_active_editor(trip_id, auth.uid()));

-- Documents
drop policy if exists "Users can update their own documents" on public.documents;
create policy "Users can update their own documents"
  on public.documents for update
  using (auth.uid() = user_id OR public.is_active_editor(trip_id, auth.uid()));

drop policy if exists "Users can insert their own documents" on public.documents;
create policy "Users can insert their own documents"
  on public.documents for insert
  with check (auth.uid() = user_id OR public.is_active_editor(trip_id, auth.uid()));

drop policy if exists "Users can delete their own documents" on public.documents;
create policy "Users can delete their own documents"
  on public.documents for delete
  using (auth.uid() = user_id OR public.is_active_editor(trip_id, auth.uid()));

-- Trip Budgets
drop policy if exists "Users can update their own budget" on public.trip_budgets;
create policy "Users can update their own budget"
  on public.trip_budgets for update
  using (auth.uid() = user_id OR public.is_active_editor(trip_id, auth.uid()));

drop policy if exists "Users can insert their own budget" on public.trip_budgets;
create policy "Users can insert their own budget"
  on public.trip_budgets for insert
  with check (auth.uid() = user_id OR public.is_active_editor(trip_id, auth.uid()));

drop policy if exists "Users can delete their own budget" on public.trip_budgets;
create policy "Users can delete their own budget"
  on public.trip_budgets for delete
  using (auth.uid() = user_id OR public.is_active_editor(trip_id, auth.uid()));

-- Expenses
drop policy if exists "Users can update their own expenses" on public.expenses;
create policy "Users can update their own expenses"
  on public.expenses for update
  using (auth.uid() = user_id OR public.is_active_editor(trip_id, auth.uid()));

drop policy if exists "Users can insert their own expenses" on public.expenses;
create policy "Users can insert their own expenses"
  on public.expenses for insert
  with check (auth.uid() = user_id OR public.is_active_editor(trip_id, auth.uid()));

drop policy if exists "Users can delete their own expenses" on public.expenses;
create policy "Users can delete their own expenses"
  on public.expenses for delete
  using (auth.uid() = user_id OR public.is_active_editor(trip_id, auth.uid()));
