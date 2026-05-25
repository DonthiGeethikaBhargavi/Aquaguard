============================================================
ENTERPRISE ANALYTICS MIGRATION CHECKLIST
============================================================

Use this checklist when integrating enterprise analytics
into your Aquaguard features.

============================================================
PHASE 1: UNDERSTANDING THE SYSTEM
============================================================

□ Read ENTERPRISE_IMPLEMENTATION_SUMMARY.md
□ Read QUICK_START_GUIDE.md
□ Read /lib/core/docs/ENTERPRISE_ANALYTICS_GUIDE.md
□ Understand safe data parsing concepts
□ Understand offline caching architecture
□ Understand error handling patterns

============================================================
PHASE 2: REPLACE UNSAFE CODE
============================================================

SCAN FOR UNSAFE PATTERNS
─────────────────────────

□ Search for: "as double"
✓ Replace with: safeDouble(value)

□ Search for: "as int"
✓ Replace with: safeInt(value)

□ Search for: "as num"
✓ Replace with: safeDouble(value)

□ Search for: "?.toDouble()"
✓ Replace with: safeDouble(value)

□ Search for: ".toString().toDouble()"
✓ Replace with: safeDouble(value)

AUDIT NULLABLE VALUES
──────────────────────

□ Find all: data['key']
✓ Ensure: handled with ?? fallback
✓ Or use: safeString/safeDouble/safeInt

□ Find all: response.first
✓ Ensure: check isEmpty first

□ Find all: .toList()
✓ Ensure: use safeList() instead

VALIDATE BEFORE RENDERING
──────────────────────────

□ All PieChart data: use TelemetryValidator
□ All LineChart data: use TelemetryValidator
□ All BarChart data: use TelemetryValidator
□ All text values: use safeString()
□ All numeric display: use safeDouble/safeInt

============================================================
PHASE 3: ADD OFFLINE SUPPORT
============================================================

IMPORT CACHE SERVICE
────────────────────

□ Add import for telemetry_cache_service
□ Add import for telemetryCacheServiceProvider

WRAP PROVIDERS WITH CACHE
──────────────────────────

For each FutureProvider:
□ Add cache fallback on error
□ Add cache update on success
□ Add safe defaults if cache unavailable

Example:

```dart
try {
  final result = await repository.fetch(key);
  await cache.value?.cacheSummary(key, result);
  return result;
} catch (e) {
  final cached = cache.value?.getSummary(key);
  if (cached != null) return cached;
  return defaultValue();
}
```

For each StreamProvider:
□ Add cache fallback on realtime error
□ Update cache on each successful emit
□ Return empty list/map if cache missing

Example:

```dart
await for (final data in stream) {
  try {
    await cache.value?.cacheData(key, data);
    yield data;
  } catch (e) {
    final cached = cache.value?.getCached(key);
    if (cached != null) yield cached;
    else yield [];
  }
}
```

ADD OFFLINE MODE INDICATOR
───────────────────────────

□ Add connectivity check to widget
□ Show offline banner when disconnected
□ Display "Using cached data" message
□ Keep all UI functional in offline mode

============================================================
PHASE 4: ERROR HANDLING
============================================================

REPLACE GENERIC ERROR HANDLING
───────────────────────────────

OLD:

```dart
error: (_, __) => Text('Error: $_'),
```

NEW:

```dart
error: (error, _) => AnalyticsErrorHandler.buildErrorBanner(
  AnalyticsErrorType.supabaseError,
  onRetry: () => ref.refresh(provider),
),
```

ADD TRY-CATCH BLOCKS
────────────────────

□ Wrap all Supabase queries
□ Wrap all data parsing
□ Wrap all file operations
□ Wrap all async operations

PROVIDE USER-FRIENDLY MESSAGES
───────────────────────────────

□ Never show raw exception messages
□ Use: AnalyticsErrorHandler.getErrorMessage()
□ Show: Operational error states
□ Provide: Retry buttons where appropriate

============================================================
PHASE 5: MOBILE OPTIMIZATION
============================================================

TEST ON SMALL SCREENS
─────────────────────

□ Test on 360px width (small phone)
□ Test on 480px width (regular phone)
□ Test on 600px width (tablet)
□ Verify: No horizontal overflow
□ Verify: Text readable
□ Verify: All buttons accessible
□ Verify: Proper spacing maintained

FIX OVERFLOW ISSUES
───────────────────

□ Remove hardcoded widths
□ Use: LayoutBuilder for responsive sizing
□ Use: Flexible and Expanded widgets
□ Use: ConstrainedBox with maxWidth
□ Add: Text ellipsis for long text

COMPACT VERTICAL SPACE
──────────────────────

□ Card heights: 90px (not 110px)
□ Padding: 12px (not 18px)
□ Spacing: 10px (not 18px)
□ Run spacing: 10px (not 18px)

============================================================
PHASE 6: EXPORT/SHARE
============================================================

IF IMPLEMENTING EXPORT
──────────────────────

□ Use: telemetry_export_service.dart
□ Import: export_provider.dart
□ Generate CSV from real Supabase data
□ Add progress indicator
□ Add retry on failure
□ Implement share functionality

IF IMPLEMENTING SHARE
─────────────────────

□ Use: Share from share_plus
□ Support: Android scoped storage
□ Handle: Permission requests
□ Clean up: Temporary files

============================================================
PHASE 7: VERIFICATION
============================================================

CODE REVIEW CHECKLIST
─────────────────────

□ No unsafe casts (as double, as int, as num)
□ No direct property access without null check
□ All data validated before use
□ All errors handled gracefully
□ Cache used as fallback
□ Offline mode supported
□ Mobile layout tested
□ No hardcoded values
□ Comments explain complex logic

FUNCTIONALITY TESTING
─────────────────────

□ Online mode: Real data displays
□ Offline mode: Cached data displays
□ Reconnect: Auto-sync works
□ Error state: Proper message shown
□ Retry: Refreshes provider correctly
□ Export: CSV generated correctly
□ Share: Opens native share sheet
□ Empty state: Shows proper message

CRASH TESTING
─────────────

□ Malformed realtime data → no crash
□ Null values in dataset → no crash
□ Missing required fields → no crash
□ Network timeout → graceful error
□ Supabase down → use cached data
□ NaN/Infinity values → filtered out
□ Large datasets → no memory spike
□ Rapid updates → no flutter jank

MOBILE TESTING
───────────────

□ 360px width: No overflow
□ 480px width: Proper layout
□ 600px width: Full feature width
□ Landscape: Rotates correctly
□ Large text scaling: Readable
□ Small text scaling: Not too small
□ Touch targets: Min 48dp

OFFLINE TESTING
────────────────

□ Turn off internet
□ App still shows cached data
□ Offline indicator displays
□ Charts still visible
□ Scrolling works
□ Turn on internet
□ Auto-reconnect works
□ Data syncs silently

============================================================
PHASE 8: DEPLOYMENT
============================================================

FINAL VERIFICATION
───────────────────

□ All imports are correct
□ All providers are accessible
□ No compile errors
□ No runtime crashes
□ All tests pass
□ Code review approved
□ Documentation updated
□ Team trained

DEPLOYMENT STEPS
─────────────────

□ Commit to feature branch
□ Create pull request
□ Ensure all CI checks pass
□ Get code review approval
□ Merge to main
□ Tag release version
□ Deploy to staging
□ Test in staging
□ Deploy to production
□ Monitor error logs

POST-DEPLOYMENT
────────────────

□ Monitor crash reports
□ Check error log frequency
□ Verify cache hit ratio
□ Monitor realtime reconnects
□ Track export success rate
□ Get user feedback
□ Address issues quickly

============================================================
COMMON ISSUES & FIXES
============================================================

ISSUE: "Type 'dynamic' is not a subtype of type 'double'"
SOLUTION:
✗ Don't use: value as double
✓ Use instead: safeDouble(value)

FIX:
import 'package:aquaguard/core/utils/telemetry_sanitizer.dart';
final temp = safeDouble(rawValue, fallback: 0.0);

─────────────────────────────────────────────────────────

ISSUE: Charts show NaN or Infinity values
SOLUTION:
✗ Don't render unvalidated data
✓ Use TelemetryValidator

FIX:
if (TelemetryValidator.isValidDataset(data)) {
final sanitized = TelemetryValidator.sanitizeDataset(data);
// Now safe to render
}

─────────────────────────────────────────────────────────

ISSUE: App crashes when offline
SOLUTION:
✗ Don't ignore network errors
✓ Provide cache fallback

FIX:
try {
return await fetch();
} catch (e) {
final cached = cache.getSummary(pondId);
if (cached != null) return cached;
return defaultValue();
}

─────────────────────────────────────────────────────────

ISSUE: RenderFlex overflow on small screens
SOLUTION:
✗ Don't use fixed widths
✓ Use responsive layout

FIX:
✗ width: 240
✓ width: constraints.maxWidth / 2 - padding

─────────────────────────────────────────────────────────

ISSUE: "null is not of type 'List'"
SOLUTION:
✗ Don't assume type
✓ Use safeList()

FIX:
final items = safeList(raw, (item) => item as String);

============================================================
ROLLBACK PROCEDURES
============================================================

IF ISSUES OCCUR
────────────────

□ Check error logs for patterns
□ Review recent provider changes
□ Test offline mode manually
□ Verify cache service is working
□ Monitor CPU/memory usage
□ Check Supabase status

ROLLBACK STEPS
───────────────

□ Identify problematic commit
□ Create rollback branch
□ Revert to stable version
□ Test thoroughly
□ Deploy rollback
□ Post-mortem analysis
□ Fix root cause
□ Re-deploy

============================================================
SUCCESS CRITERIA
============================================================

STABILITY
✓ Crash rate < 0.1%
✓ No "red screen" errors
✓ All errors handled gracefully

OFFLINE SUPPORT
✓ Cached data preserved
✓ Auto-sync on reconnect
✓ No empty screens

PERFORMANCE
✓ Loads in < 2 seconds
✓ 60 FPS animations
✓ No jank on updates

MOBILE OPTIMIZATION
✓ Responsive on all sizes
✓ No overflow
✓ Touch-friendly

EXPORT RELIABILITY
✓ CSV generated correctly
✓ Real data included
✓ Share works on Android

USER EXPERIENCE
✓ Clear error messages
✓ Smooth interactions
✓ Professional appearance

============================================================
SIGN-OFF
============================================================

Team Lead: ********\_******** Date: ****\_\_****

Developer: ********\_******** Date: ****\_\_****

QA Tester: ********\_******** Date: ****\_\_****

Product: ********\_\_******** Date: ****\_\_****

============================================================
Version: 1.0.0
Last Updated: May 16, 2026
Status: READY FOR DEPLOYMENT ✅
============================================================
