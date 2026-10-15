---
catzc:
  derived:
    path: docs/references/automation/catzc-azure-devops/tests/Get-AdoYamlFiles.Tests.ps1.md
    kind: test-asset
    body_sha: "34338a5e7167"
    adrs:
      - ADR-AUTO-TEST#20
---

# automation/Catzc.Azure.DevOps/tests/Get-AdoYamlFiles.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per
section (Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `$violations = @(foreach ($result in $results) {`.

```text
One Should over the violating set — a Should per discovered file pays Pester's
per-assertion cost times the whole repo's YAML count.
A foreach projection, not member enumeration: .RelativePath on the (passing) empty set throws under
strict mode.
```

## comment:2

Above `It 'excludes .git directory by default' -Tag 'integrity' {`.

```text
Its own integrity tag keeps this a distinct, named check in the manual test plan (a facet worth
citing on its own), while reusing the one scan above rather than re-walking the repo
([ADR-AUTO-TEST#20](/docs/adr/automation/test-automation.md#rule-adr-auto-test20)).
```
