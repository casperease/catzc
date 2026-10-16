---
catzc:
  immutable:
    with_body_sha: fd534558e021
    path: docs/references/automation/catzc-base-typessystem/tests/Clear-ModuleTypeCache.Tests.ps1.md
    folder: docs/references/automation/catzc-base-typessystem/tests
    name: clear-module-type-cache-tests-ps1
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    tracktype: documentation
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
---

# automation/Catzc.Base.TypesSystem/tests/Clear-ModuleTypeCache.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `BeforeEach {`, written with `#`.

```text
The fixture DLL name (BeforeEach) and the real-repo drift check both use the ONE shared hash
(Get-CombinedTypeHash, loaded by the importer) — the same function the janitor under test calls, so there is
no separate mirror to keep in step. The independent oracle for that function is the cross-language MSBuild
stamp (see the Import-CSharpTypes test file's 'IDE project build stamps …' test).
```

## comment:2

Above `foreach ($m in 'Mod.One', 'Mod.Two') {`, written with `#`.

```text
Build the fixture with [System.IO] rather than New-Item/Set-Content — the cmdlets carry ~20ms of
per-call overhead on Windows, which dominated this per-test setup. CreateDirectory makes parents too.
```
