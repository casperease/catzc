---
catzc:
  immutable:
    with_body_sha: a8e691394734
    repo_status: locked
    path: docs/references/automation/internal/tests/Get-LoadedTypeDrift.Tests.ps1.md
    folder: docs/references/automation/internal/tests
    name: get-loaded-type-drift-tests-ps1
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    tracktype: documentation
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
  edges:
    cites:
      - ADR-AUTO-TYPES#12
---

# automation/.internal/tests/Get-LoadedTypeDrift.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `BeforeAll {`, written with `#`.

```text
Get-LoadedTypeDrift over fixture code roots in $TestDrive. A fixture source named for a type this process has
loaded (Catzc.Base.Objects/ConsoleText) counts as loaded; a neutral one (Catzc.Widget/Gadget) never is. Each case
writes its own session record for its own fixture root, and removes it after, so the real roots' records are
untouched ([ADR-AUTO-TYPES#12](/docs/adr/automation/BCL/native-csharp-types.md#rule-adr-auto-types12)).
```
