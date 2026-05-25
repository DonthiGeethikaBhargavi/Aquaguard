============================================================
ENTERPRISE ANALYTICS QUICK START GUIDE
============================================================

# IMPORT THESE IN YOUR CODE

// Safe data parsing
import 'package:aquaguard/core/utils/telemetry_sanitizer.dart';

// Offline caching
import 'package:aquaguard/core/services/telemetry_cache_service.dart';

// Reconnection handling
import 'package:aquaguard/core/services/realtime_reconnection_manager.dart';

// Error management
import 'package:aquaguard/core/services/analytics_error_handler.dart';

// Export functionality
import 'package:aquaguard/core/services/telemetry_export_service.dart';
import 'package:aquaguard/features/device/presentation/providers/export_provider.dart';

============================================================
DO'S AND DON'Ts
============================================================

✓ DO: Use safe conversion functions
final temp = safeDouble(rawValue, fallback: 0.0);
final count = safeInt(rawCount, fallback: 0);

✗ DON'T: Use unsafe casts
final temp = rawValue as double; // ❌ CRASH!
final count = rawCount as int; // ❌ CRASH!

✓ DO: Validate data before rendering
if (TelemetryValidator.isValidDataset(data)) {
// Safe to render
}

✗ DON'T: Render unvalidated data
\_chart.render(rawData); // ❌ NaN/Infinity!

✓ DO: Cache data when fetching succeeds
await cacheService.cacheSummary(pondId, summary);

✗ DON'T: Rely only on realtime (may disconnect)
// Just using stream without cache fallback

✓ DO: Show operational error states
AnalyticsErrorHandler.buildErrorBanner(type)

✗ DON'T: Show raw exceptions
Text(error.toString()) // ❌ User confusion

✓ DO: Handle offline gracefully
final cached = cacheService.getSummary(pondId);
if (cached != null) return cached;

✗ DON'T: Crash on no data
throw Exception('No data'); // ❌ CRASH!

============================================================
COMMON PATTERNS
============================================================

PATTERN 1: Safe Telemetry Reading
──────────────────────────────────

import 'package:aquaguard/core/utils/telemetry_sanitizer.dart';

// Extract and validate
double temperature = safeDouble(reading['temperature'], fallback: 0);
double ph = safeDouble(reading['ph'], fallback: 7.0);
int alerts = safeInt(reading['alert_count'], fallback: 0);

// Compute confidence
int confidence = TelemetryStats.calculateConfidence(
values: temperatureReadings,
lastUpdate: DateTime.now(),
consecutiveValid: validReadingsCount,
);

──────────────────────────────────────────────────────────

PATTERN 2: Offline with Cache Fallback
──────────────────────────────────────

final summaryAsync = ref.watch(analyticsSummaryProvider(key));

summaryAsync.when(
loading: () => _buildLoadingState(),
error: (err, _) {
// Try cached data
final cached = ref.watch(telemetryCacheServiceProvider)
.value?.getSummary(pondId);

    if (cached != null) {
      return _buildSummaryView(cached); // Show stale data
    }
    return _buildErrorState(err);

},
data: (summary) => \_buildSummaryView(summary),
);

──────────────────────────────────────────────────────────

PATTERN 3: Safe Chart Rendering
────────────────────────────────

import 'package:aquaguard/core/utils/telemetry_sanitizer.dart';

// Validate before rendering
if (!TelemetryValidator.isValidDataset(data)) {
return \_buildEmptyState();
}

// Sanitize data
final sanitized = TelemetryValidator.sanitizeDataset(data);

// Now safe to render
return PieChart(
data: sanitized.map((d) => ChartData(
value: safeDouble(d['value'], fallback: 0) ?? 0,
)).toList(),
);

──────────────────────────────────────────────────────────

PATTERN 4: Export Telemetry
───────────────────────────

final exportAsync = ref.watch(exportTelemetryProvider(
ExportTelemetryParams(
pondId: pondId,
startDate: DateTime(2024, 1, 1),
endDate: DateTime(2024, 1, 31),
onProgress: (progress) => print('$progress%'),
),
));

exportAsync.when(
loading: () => _buildExportingUI(),
error: (err, _) => \_buildExportErrorUI(err),
data: (file) {
if (file == null) return \_buildErrorUI();
return \_buildShareUI(file);
},
);

──────────────────────────────────────────────────────────

PATTERN 5: Error Handling
─────────────────────────

try {
final data = await repository.fetchAnalytics(pondId);
return data;
} catch (e) {
// Get user-friendly message
final message = AnalyticsErrorHandler.getErrorMessage(e);

// Build error UI
return AnalyticsErrorHandler.buildErrorBanner(
AnalyticsErrorType.supabaseError,
onRetry: () => ref.refresh(provider),
);
}

============================================================
PROVIDER EXAMPLES
============================================================

FETCH WITH CACHE FALLBACK
──────────────────────────

final myDataProvider = FutureProvider.family<Data, String>((ref, key) async {
try {
// Try fetching
return await repository.getData(key);
} catch (e) {
// Fall back to cache
final cache = ref.watch(telemetryCacheServiceProvider);
final cached = cache.value?.getCached(key);
if (cached != null) return cached;

    // Last resort default
    return defaultData();

}
});

──────────────────────────────────────────────────────────

STREAM WITH SAFE PARSING
────────────────────────

final dataStream = StreamProvider.family<List<Data>, String>((ref, key) async\* {
final stream = supabase.from('table').stream(...);

await for (final raw in stream) {
try {
final data = safeListMap(raw);
yield data; // Safe to emit
} catch (e) {
// Skip malformed batch
continue;
}
}
});

──────────────────────────────────────────────────────────

COMBINED STREAMS WITH FALLBACK
───────────────────────────────

await for (final combined in Rx.combineLatest2(
stream1,
stream2,
(a, b) {
try {
return processData(a, b);
} catch (e) {
// Return cached state
return getCachedState() ?? defaultState();
}
},
)) {
yield combined;
}

============================================================
TESTING TELEMETRY DATA
============================================================

TEST SAFE CONVERSION
────────────────────

void testSafeConversion() {
expect(safeDouble(42), 42.0); // int → double
expect(safeDouble('3.14'), 3.14); // string → double
expect(safeDouble(null), null); // null handling
expect(safeDouble(double.nan), null); // NaN rejection
expect(safeDouble(double.infinity), null); // Infinity rejection
}

──────────────────────────────────────────────────────────

TEST DATA VALIDATION
────────────────────

void testValidation() {
final goodData = [
{'timestamp': '2024-05-16T10:00:00', 'temperature': 25.5},
{'timestamp': '2024-05-16T11:00:00', 'temperature': 26.0},
];
expect(TelemetryValidator.isValidDataset(goodData), true);

final badData = [
{'temperature': double.nan},
];
expect(TelemetryValidator.isValidDataset(badData), false);
}

──────────────────────────────────────────────────────────

TEST OFFLINE MODE
─────────────────

void testOfflineMode() {
// Simulate offline
disconnectNetwork();

// Should show cached data
expect(analytics.isCached, true);
expect(analytics.data, cachedValue);
expect(analytics.isOffline, true);
expect(analytics.showsOfflineIndicator, true);
}

============================================================
DEBUGGING TIPS
============================================================

CHECK CACHE STATUS
───────────────────

final cacheService = ref.watch(telemetryCacheServiceProvider);
print('Cache size: ${cacheService.value?.getCacheSizeEstimate()} bytes');

if (cacheService.value?.isCacheFresh('key') ?? false) {
print('✓ Cache is fresh');
} else {
print('✗ Cache is stale');
}

──────────────────────────────────────────────────────────

VERIFY DATA VALIDATION
──────────────────────

if (TelemetryValidator.isValidDataset(data)) {
print('✓ Dataset valid for rendering');
final sanitized = TelemetryValidator.sanitizeDataset(data);
print('Sanitized: ${sanitized.length} rows');
} else {
print('✗ Dataset invalid');
}

──────────────────────────────────────────────────────────

MONITOR ERROR RECOVERY
──────────────────────

// Error handler has error history
final errors = ref.watch(analyticsErrorHistoryProvider);
print('Recent errors: ${errors.length}');
for (final error in errors.takeLast(5)) {
print(' - ${error.type}: ${error.message}');
}

──────────────────────────────────────────────────────────

WATCH RECONNECTION STATE
────────────────────────

manager.stateStream.listen((state) {
switch (state) {
case ConnectionState.connected:
print('✓ Connected');
case ConnectionState.disconnected:
print('✗ Disconnected');
case ConnectionState.reconnecting:
print('↻ Reconnecting...');
case ConnectionState.stale:
print('⚠ Data stale');
}
});

============================================================
PERFORMANCE TIPS
============================================================

1. USE PROVIDERS WISELY
   - Providers cache results
   - Use .watch() for rebuilds
   - Use .read() for one-off access
   - Use .family for parameterized data

2. DEBOUNCE RAPID UPDATES
   - Realtime can fire frequently
   - Use provider debouncing
   - Batch multiple updates
   - Update UI every 500ms minimum

3. LAZY LOAD CHARTS
   - Load only visible charts
   - Paginate historical data
   - Use LayoutBuilder for viewport detection
   - Cache computed chart points

4. OPTIMIZE CACHE SIZE
   - Limit cache to 7 days history
   - Remove old entries automatically
   - Monitor cache size
   - Use compression if needed

============================================================
COMMON ISSUES & FIXES
============================================================

ISSUE: Null pointer exception on chart rendering
SOLUTION: Add data validation
if (TelemetryValidator.isValidDataset(data)) {
// Safe to render
}

──────────────────────────────────────────────────────────

ISSUE: Charts show NaN values
SOLUTION: Check value validity
final value = safeDouble(raw, fallback: 0);
if (!value!.isFinite) {
// Skip this value
}

──────────────────────────────────────────────────────────

ISSUE: Offline data doesn't persist
SOLUTION: Ensure cache is updated
await cacheService.cacheSummary(pondId, summary);

// Verify it saved
final cached = cacheService.getSummary(pondId);
assert(cached != null);

──────────────────────────────────────────────────────────

ISSUE: Realtime not updating
SOLUTION: Check reconnection state
manager.stateStream.listen((state) {
if (state == ConnectionState.reconnecting) {
// Realtime is reconnecting
}
});

──────────────────────────────────────────────────────────

ISSUE: Overflow on small screens
SOLUTION: Use responsive widgets
✓ LayoutBuilder
✓ Flexible
✓ Expanded
✗ Fixed widths

============================================================
QUICK REFERENCE: KEY METHODS
============================================================

TELEMETRY SANITIZER
safeDouble(value, fallback)
safeInt(value, fallback)
safeString(value, fallback)
safeDateTime(value)
safeMap(value, fallback)
safeList(value, converter, fallback)
TelemetryValidator.isValidDataset(data)
TelemetryValidator.sanitizeDataset(data)
TelemetryStats.average(values)
TelemetryStats.standardDeviation(values)
TelemetryStats.trend(values)
TelemetryStats.calculateConfidence(...)

CACHE SERVICE
cacheSummary(pondId, summary)
getSummary(pondId)
cacheChartData(pondId, range, data)
getChartData(pondId, range)
cacheAnomalyTimeline(pondId, anomalies)
getAnomalyTimeline(pondId)
cacheInsights(pondId, insights)
getInsights(pondId)
isCacheFresh(key)
clearPondCache(pondId)
clearAll()

ERROR HANDLER
getErrorMessage(error)
getErrorIcon(type)
getErrorColor(type)
buildErrorBanner(type, onRetry)
buildEmptyState(title, subtitle, actionLabel, onAction)
parseException(error, stackTrace)

EXPORT SERVICE
exportTelemetryCSV(pondId, startDate, endDate, onProgress)
exportAlertsCSV(pondId, startDate, endDate, onProgress)
exportFullReport(pondId, startDate, endDate, onStatus)
shareFile(file)
cleanupExportFiles()

============================================================
RESOURCES
============================================================

FULL DOCUMENTATION:
/lib/core/docs/ENTERPRISE_ANALYTICS_GUIDE.md

IMPLEMENTATION SUMMARY:
/ENTERPRISE_IMPLEMENTATION_SUMMARY.md

SOURCE FILES:
/lib/core/utils/telemetry_sanitizer.dart
/lib/core/services/telemetry_cache_service.dart
/lib/core/services/realtime_reconnection_manager.dart
/lib/core/services/analytics_error_handler.dart
/lib/core/services/telemetry_export_service.dart

PROVIDERS:
/lib/features/device/presentation/providers/ - alert_analytics_provider.dart - provider_lifecycle_management.dart - export_provider.dart

WIDGETS:
/lib/features/device/presentation/widgets/ - alert_analytics_widget.dart

============================================================
SUPPORT
============================================================

For questions about:

- Safe data parsing → telemetry_sanitizer.dart
- Offline caching → telemetry_cache_service.dart
- Realtime reconnection → realtime_reconnection_manager.dart
- Error handling → analytics_error_handler.dart
- Data export → telemetry_export_service.dart
- Provider patterns → alert_analytics_provider.dart

============================================================
Version: 1.0.0
Last Updated: May 16, 2026
Status: Production Ready ✅
============================================================
