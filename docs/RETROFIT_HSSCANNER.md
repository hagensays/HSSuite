# HSScanner Retrofit Plan

Recommendation: create HSSuite independently, then retrofit HSScanner. Do not derive the suite standard from HSScanner.

## Why

HSScanner contains valuable patterns, but it is product-specific: read-only scanning, scan/export workflow, scanner-specific safety checks and a UI optimized around inventory. Making it the canonical template would cause accidental coupling between future tools and scanner assumptions.

## Retrofit sequence

1. Treat current HSScanner `main` as authoritative.
2. Create the next HSScanner semantic-version branch.
3. Port only HSSuite's universal shell/resources:
   - color tokens
   - typography
   - button/input styles
   - standard header
   - status bar
   - spacing/card conventions
   - generic output helper improvements where compatible
4. Preserve HSScanner's scanner-specific safety model and scan/export behavior.
5. Do not rewrite the scan engine merely for visual consistency.
6. Run HSScanner's existing safety CI and build CI.
7. Compare the resulting UI against HSSuite and fix visual drift.
8. Merge/release only after the normal HSScanner workflow passes.

## Desired outcome

HSScanner should look like the first production member of HSSuite without pretending it was architecturally generated from the template. Future apps can then start directly from HSSuite.
