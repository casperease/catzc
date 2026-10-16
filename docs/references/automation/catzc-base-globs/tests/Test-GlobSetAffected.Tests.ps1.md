---
catzc:
  derived:
    path: docs/references/automation/catzc-base-globs/tests/Test-GlobSetAffected.Tests.ps1.md
    kind: comment-page
    language: markdown
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: "34ee83c679f3"
    adrs:
      - ADR-AUTO-TEST#3
      - ADR-REPO-PROTGLOB#5
---

# automation/Catzc.Base.Globs/tests/Test-GlobSetAffected.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Describe 'Test-GlobSetAffected' -Tag 'L0', 'logic' {`, written with `#`.

```text
The in-pipeline "is there anything here for us to process?" check — reflects the context's diff and reports
whether the named unit is touched, fail-open on any doubt
([ADR-REPO-PROTGLOB#5](/docs/adr/repository/protected-globs.md#rule-adr-repo-protglob5)), fail-fast on a typo'd name.
```

## comment:2

Above `$script:config = [Catzc.Base.Globs.GlobsConfig]::new(@{`, written with `#`.

```text
Neutral fixture names (widget/gadget), not the shipped set names, so this logic test owns its
inputs ([ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)).
```
