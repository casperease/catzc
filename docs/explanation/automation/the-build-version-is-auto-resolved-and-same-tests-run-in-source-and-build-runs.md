---
catzc:
  warning: "Experimental: this article merges two rules into one and holds nothing beyond what they say"
  edges:
    cites:
      - ADR-AUTO-BUNDLE-AUTOVERSION
      - ADR-AUTO-TEST-SAMETESTSBOTHRUNS
---

# The build version is auto resolved and same tests run in source and build runs

This article is one rule: [ADR-AUTO-BUNDLE-AUTOVERSION](../../drs/automation/platform-bundle.md#rule-adr-auto-bundle-autoversion) and
[ADR-AUTO-TEST-SAMETESTSBOTHRUNS](../../drs/automation/test-automation.md#rule-adr-auto-test-sametestsbothruns) merged into one. It holds
nothing beyond what those two rules say.

`Build-Modules -Version` defaults to `auto`, resolved by `Resolve-CatzcBuildVersion`, with a devbox build the fixed `6.6.666` placeholder.
The same tests run in two kinds of test run, one per run mode: the source run (`Test-Automation`) loads the modules from the code root
through the source entry script, and the build run (`Test-CatzcBuild`) builds the selected modules and loads them through the build's entry
script.
