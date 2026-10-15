---
catzc:
  derived:
    path: docs/references/automation/catzc-base-config/private/Merge-ConfigFragment.ps1.md
    kind: comment-page
    body_sha: "60239eaf0856"
    adrs: []
---

# automation/Catzc.Base.Config/private/Merge-ConfigFragment.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
A fragment states only the keys that differ ([ADR-AUTO-OVERLAY](/docs/adr/automation/consumer-overlay.md)):
  - a map merges into the bundled map recursively;
  - a scalar or a list replaces the bundled value (a list is never appended to, so the result is predictable);
  - an explicit null removes the key, so the config type's declared default applies.
A key the fragment does not name keeps the bundled value. Neither input is changed; the result is a new
ordered dictionary, which the config's own type then validates like any parsed config.
```
