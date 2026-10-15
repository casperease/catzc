---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/private/Import-VendoredPester.ps1.md
    kind: reference
    body_sha: "294452e3d264"
    adrs:
      - ADR-AUTO-ASSETDEP#1
      - ADR-AUTO-CONSOLE#11
      - ADR-PWSH-VENDOR#5
---

# automation/Catzc.Base.QualityGates/private/Import-VendoredPester.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
Pester's import is deferred at import time for speed
([ADR-PWSH-VENDOR#5](/docs/adr/pwsh/vendor-toolset-dependencies.md#rule-adr-pwsh-vendor5)); the
test entry points that need
it in the parent session — for a discovery pass, or an in-session run — load it here, once. It is vendored
inside the code tree, so it resolves from the code root
([ADR-AUTO-ASSETDEP#1](/docs/adr/automation/internal-asset-dependencies.md#rule-adr-auto-assetdep1)), and the load
is announced
([ADR-AUTO-CONSOLE#11](/docs/adr/automation/console-output-matters.md#rule-adr-auto-console11)). A
session that already has the vendored version loaded from the vendor folder is left as it is — a check of a few
milliseconds; any other Pester in the session (a system install, another version) is removed and replaced, and
the replacement is named in the announcement.
```
