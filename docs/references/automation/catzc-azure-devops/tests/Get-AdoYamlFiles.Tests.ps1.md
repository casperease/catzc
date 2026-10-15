---
catzc:
  derived:
    path: docs/references/automation/catzc-azure-devops/tests/Get-AdoYamlFiles.Tests.ps1.md
    kind: comment-page
    body_sha: "3386c2d57cbd"
    adrs:
      - ADR-AUTO-TEST#20
---

# automation/Catzc.Azure.DevOps/tests/Get-AdoYamlFiles.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `$violations = @(foreach ($result in $results) {`, written with `#`.

```text
One Should over the violating set — a Should per discovered file pays Pester's
per-assertion cost times the whole repo's YAML count.
A foreach projection, not member enumeration: .RelativePath on the (passing) empty set throws under
strict mode.
```

## comment:2

Above `It 'excludes .git directory by default' -Tag 'integrity' {`, written with `#`.

```text
Its own integrity tag keeps this a distinct, named check in the manual test plan (a facet worth
citing on its own), while reusing the one scan above rather than re-walking the repo
([ADR-AUTO-TEST#20](/docs/adr/automation/test-automation.md#rule-adr-auto-test20)).
```
