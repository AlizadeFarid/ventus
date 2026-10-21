import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'app_database.g.dart';

/// Local-first store for trips. The Drift row class is named `TripRow` to avoid
/// clashing with the domain `Trip` model; mapping between them lives in the
/// trips data layer.
@DataClassName('TripRow')
class Trips extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text().nullable()();
  TextColumn get title => text()();
  TextColumn get country => text()();
  TextColumn get coverImagePath => text().nullable()();
  DateTimeColumn get startDate => dateTime()();
  DateTimeColumn get endDate => dateTime()();
  IntColumn get plannedPercent => integer().withDefault(const Constant(0))();
  IntColumn get adults => integer().withDefault(const Constant(2))();
  IntColumn get children => integer().withDefault(const Constant(0))();
  TextColumn get travelerType => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

/// A place on a trip's route, ordered by [position]. Each row belongs to a trip
/// via [tripId]; the data layer deletes/inserts a trip's stops as a set.
@DataClassName('TripStopRow')
class TripStops extends Table {
  TextColumn get id => text()();
  TextColumn get tripId => text()();
  TextColumn get name => text()();
  TextColumn get country => text()();
  IntColumn get position => integer().withDefault(const Constant(0))();
  // Geographic coordinates for the map; null for stops without a resolved point.
  RealColumn get lat => real().nullable()();
  RealColumn get lon => real().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

/// A single activity on a trip's day-by-day plan. Belongs to a trip via
/// [tripId] and to a [day] (1-based). [startMinutes] is the optional start time
/// (minutes from midnight, null = no fixed time). The row class is named
/// `ItineraryItemRow` to avoid clashing with the domain `ItineraryItem` model.
@DataClassName('ItineraryItemRow')
class ItineraryItems extends Table {
  TextColumn get id => text()();
  TextColumn get tripId => text()();
  IntColumn get day => integer()();
  IntColumn get startMinutes => integer().nullable()();
  TextColumn get title => text()();
  TextColumn get place => text().nullable()();
  TextColumn get kind => text().withDefault(const Constant('activity'))();
  IntColumn get position => integer().withDefault(const Constant(0))();
  // Geographic coordinates of [place], resolved by the geocoder; null while
  // unresolved (or when the place text couldn't be matched) — such activities
  // are listed on the Map tab as "no location yet" instead of getting a pin.
  RealColumn get lat => real().nullable()();
  RealColumn get lon => real().nullable()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

/// A single to-do on a trip's checklist. Belongs to a trip via [tripId],
/// ordered by [position]. The row class is named `ChecklistItemRow` to avoid
/// clashing with the domain `ChecklistItem` model.
@DataClassName('ChecklistItemRow')
class ChecklistItems extends Table {
  TextColumn get id => text()();
  TextColumn get tripId => text()();
  TextColumn get title => text()();
  BoolColumn get done => boolean().withDefault(const Constant(false))();
  TextColumn get category =>
      text().withDefault(const Constant('beforeYouGo'))();
  DateTimeColumn get dueDate => dateTime().nullable()();
  IntColumn get position => integer().withDefault(const Constant(0))();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

/// A user-uploaded file attached to a trip (ticket, voucher, ID, policy).
/// The binary lives in the private `trip-docs` Storage bucket at [storagePath];
/// this row is the metadata. Belongs to a trip via [tripId]; the row class is
/// named `DocumentRow` to avoid clashing with the domain `TripDocument` model.
@DataClassName('DocumentRow')
class Documents extends Table {
  TextColumn get id => text()();
  TextColumn get tripId => text()();
  TextColumn get name => text()();
  TextColumn get type => text().withDefault(const Constant('other'))();
  TextColumn get storagePath => text()();
  TextColumn get ext => text().nullable()();
  TextColumn get mimeType => text().nullable()();
  IntColumn get sizeBytes => integer().nullable()();
  IntColumn get day => integer().nullable()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

/// A trip's budget setup — one row per trip. [allocations] is a JSON-encoded
/// map of category name -> amount (Postgres stores it as JSONB). The row class
/// is named `TripBudgetRow` to avoid clashing with the domain `TripBudget`.
@DataClassName('TripBudgetRow')
class TripBudgets extends Table {
  TextColumn get tripId => text()();
  TextColumn get currency => text().withDefault(const Constant('USD'))();
  RealColumn get total => real().withDefault(const Constant(0))();
  TextColumn get allocations => text().withDefault(const Constant('{}'))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {tripId};
}

/// A single logged expense on a trip. Belongs to a trip via [tripId], optionally
/// to a 1-based [day]. [amount] is in the trip's currency. The row class is
/// named `ExpenseRow` to avoid clashing with the domain `Expense` model.
@DataClassName('ExpenseRow')
class Expenses extends Table {
  TextColumn get id => text()();
  TextColumn get tripId => text()();
  TextColumn get category => text().withDefault(const Constant('other'))();
  RealColumn get amount => real().withDefault(const Constant(0))();
  TextColumn get note => text().nullable()();
  IntColumn get day => integer().nullable()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

/// A destination the user hearted in Explore, keyed by [destinationId]. Display
/// fields are denormalised so the Saved tab works offline. The row class is
/// named `SavedPlaceRow` to avoid clashing with the domain `SavedPlace` model.
@DataClassName('SavedPlaceRow')
class SavedPlaces extends Table {
  TextColumn get destinationId => text()();
  TextColumn get userId => text().nullable()();
  TextColumn get name => text()();
  TextColumn get country => text()();
  TextColumn get imageUrl => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {destinationId};
}

/// A person invited to co-plan a trip (prototype `Profile.jsx` → Collaborators):
/// an [email] with a [role] (editor/viewer) and a [status] (pending/active). The
/// trip owner is NOT stored here — it's derived from the trip. The row class is
/// named `CollaboratorRow` to avoid clashing with the domain `Collaborator`.
@DataClassName('CollaboratorRow')
class Collaborators extends Table {
  TextColumn get id => text()();
  TextColumn get tripId => text()();
  TextColumn get userId => text().nullable()();
  TextColumn get email => text()();
  TextColumn get name => text().nullable()();
  TextColumn get role => text().withDefault(const Constant('viewer'))();
  TextColumn get status => text().withDefault(const Constant('pending'))();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

/// An activity-feed entry for the signed-in user (prototype `Profile.jsx` →
/// NotificationsFeed). [kind] drives the icon/colour/copy; [tripTitle] and
/// [subject] are denormalised so the feed renders offline. The row class is
/// named `NotificationRow` to avoid clashing with the domain `AppNotification`.
@DataClassName('NotificationRow')
class Notifications extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text().nullable()();
  TextColumn get kind => text().withDefault(const Constant('generic'))();
  TextColumn get tripId => text().nullable()();
  TextColumn get tripTitle => text().nullable()();
  TextColumn get subject => text().nullable()();
  BoolColumn get read => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

/// The app's on-device SQLite database (via Drift).
///
/// A [QueryExecutor] can be injected for tests (e.g. an in-memory database);
/// in the app it defaults to a file-backed database managed by `drift_flutter`.
@DriftDatabase(
  tables: [
    Trips,
    TripStops,
    ItineraryItems,
    ChecklistItems,
    Documents,
    TripBudgets,
    Expenses,
    SavedPlaces,
    Collaborators,
    Notifications,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor])
    : super(executor ?? driftDatabase(name: 'ventus'));

  @override
  int get schemaVersion => 13;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) async {
      await m.createAll();
      await _createSyncPendingTable();
    },
    onUpgrade: (m, from, to) async {
      // v2 adds multi-stop routes + traveler fields and renames the cover
      // column to a Storage object *path*. Trips are a synced mirror of
      // Supabase, so the simplest correct upgrade is to rebuild the local
      // copy: it re-populates on the next sync. (Dev-stage; revisit once
      // offline-created rows must survive — see DriftTripsRepository.sync.)
      if (from < 2) {
        await m.deleteTable('trips');
        await m.createTable(trips);
        await m.createTable(tripStops);
      }
      // v3 adds the day-by-day itinerary. Additive — just create the table;
      // it re-populates from the remote on the next per-trip sync.
      if (from < 3) {
        await m.createTable(itineraryItems);
      }
      // v4 adds the trip checklist. Additive, same rationale.
      if (from < 4) {
        await m.createTable(checklistItems);
      }
      // v5 adds checklist categories + an optional reminder date. Columns
      // have defaults / are nullable, so existing rows upgrade cleanly.
      if (from < 5) {
        await m.addColumn(checklistItems, checklistItems.category);
        await m.addColumn(checklistItems, checklistItems.dueDate);
      }
      // v6 adds trip documents. Additive — just create the table; it
      // re-populates from the remote on the next per-trip sync.
      if (from < 6) {
        await m.createTable(documents);
      }
      // v7 adds the budget (per-trip setup + expenses). Additive.
      if (from < 7) {
        await m.createTable(tripBudgets);
        await m.createTable(expenses);
      }
      // v8 adds map coordinates to trip stops. Columns are nullable, so
      // existing rows upgrade cleanly (and refill lat/lon on the next sync).
      if (from < 8) {
        await m.addColumn(tripStops, tripStops.lat);
        await m.addColumn(tripStops, tripStops.lon);
      }
      // v9 adds saved (hearted) Explore destinations. Additive.
      if (from < 9) {
        await m.createTable(savedPlaces);
      }
      // v10 adds trip collaborators (co-planning invites). Additive — just
      // create the table; it re-populates from the remote on the next sync.
      if (from < 10) {
        await m.createTable(collaborators);
      }
      // v11 adds the activity-feed notifications. Additive — just create
      // the table; it re-populates from the remote on the next sync.
      if (from < 11) {
        await m.createTable(notifications);
      }
      // v12 adds a lightweight "sync_pending" tracking table used to mark
      // rows with local changes that haven't been confirmed pushed to the
      // remote yet (see markPendingSync/clearPendingSync/pendingSyncIds
      // below). It's a plain SQL table rather than a Drift `Table` class —
      // it doesn't need typed query support, only the raw insert/delete/
      // select used by the sync-repositories, so adding it this way avoids
      // a codegen round-trip for what is otherwise a one-off bookkeeping
      // table. Fixes: full-mirror `sync()` calls across the trips/budget/
      // checklist/documents/collaborators/itinerary/saved-places/
      // notifications repositories used to delete-and-replace local data
      // wholesale, silently discarding any row created or edited while
      // offline that hadn't yet round-tripped to the server.
      if (from < 12) {
        await _createSyncPendingTable();
      }
      // v13 adds map coordinates to itinerary activities, so the Map tab
      // can plot the day-by-day plan and not just the city stops. Columns
      // are nullable, so existing rows upgrade cleanly and fill in as the
      // geocoder resolves them.
      if (from < 13) {
        await m.addColumn(itineraryItems, itineraryItems.lat);
        await m.addColumn(itineraryItems, itineraryItems.lon);
      }
    },
  );

  Future<void> _createSyncPendingTable() => customStatement(
    'CREATE TABLE IF NOT EXISTS sync_pending ('
    'table_name TEXT NOT NULL, '
    'row_id TEXT NOT NULL, '
    'PRIMARY KEY (table_name, row_id))',
  );

  /// Marks [rowId] in [table] as having local changes not yet confirmed
  /// pushed to the remote. Call this before/while writing locally, whenever a
  /// remote push might fail or hasn't been attempted yet.
  Future<void> markPendingSync(String table, String rowId) => customStatement(
    'INSERT OR REPLACE INTO sync_pending (table_name, row_id) VALUES (?, ?)',
    [table, rowId],
  );

  /// Clears the pending-sync marker for [rowId] in [table] — call this once
  /// the remote push for that row has actually succeeded.
  Future<void> clearPendingSync(String table, String rowId) => customStatement(
    'DELETE FROM sync_pending WHERE table_name = ? AND row_id = ?',
    [table, rowId],
  );

  /// All row ids in [table] that currently have unpushed local changes. A
  /// repository's `sync()` must never delete or overwrite these rows with
  /// server data — that data hasn't reached the server yet, so the server's
  /// copy is stale (or the row doesn't exist there at all).
  Future<Set<String>> pendingSyncIds(String table) async {
    final rows = await customSelect(
      'SELECT row_id FROM sync_pending WHERE table_name = ?',
      variables: [Variable<String>(table)],
    ).get();
    return rows.map((r) => r.read<String>('row_id')).toSet();
  }

  /// Wipes every table. Called on sign-out / user change so one account's
  /// local-first data never leaks into the next session (the brief flash of the
  /// previous user's trips, etc.). Each module re-pulls from the backend on the
  /// next sync.
  Future<void> clearAllData() async {
    await transaction(() async {
      for (final table in allTables) {
        await delete(table).go();
      }
      await customStatement('DELETE FROM sync_pending');
    });
  }
}
