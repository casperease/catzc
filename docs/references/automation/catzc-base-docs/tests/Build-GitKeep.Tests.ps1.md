---
catzc:
  derived:
    path: docs/references/automation/catzc-base-docs/tests/Build-GitKeep.Tests.ps1.md
    kind: comment-page
    language: markdown
    filetype: md
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: "4d1d384d1c2c"
    adrs:
      - ADR-AUTO-ASSETDEP#3
---

# automation/Catzc.Base.Docs/tests/Build-GitKeep.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `$script:fake = New-FakeRepositoryRoot -Modules @{ 'Catzc.Fixture' = @{} }...`, written with `#`.

```text
Redirect the repository root to a fixture tree (TestKit) so the walk and the writes bind inside it.
One stale .gitkeep, one nested one, one deep inside out/ (must never be touched — the walk checks
out/.gitkeep itself but does not descend), and one under a vendored module (not ours to manage).
```

## comment:2

Above ``$script:expected = "This widget folder is kept by a fixture .gitkeep.`n"``, written with `#`.

```text
A fixture source through the asset seam, so the logic never reads the shipped assets/gitkeep
(that is the integrity block's job below).
```

## comment:3

Above `Describe 'Build-GitKeep — shipped assets/gitkeep' -Tag 'L1', 'integrity',...`, written with `#`.

```text
Reads the SHIPPED assets/gitkeep through Build-GitKeep's real lookup (nothing mocked on the read) and writes
only into a fixture repository, so it runs in both the source run and the build run
([ADR-AUTO-ASSETDEP#3](/docs/adr/automation/internal-asset-dependencies.md#rule-adr-auto-assetdep3)).
```

## comment:4

Above `$script:fake = New-FakeRepositoryRoot -WorkingRootOnly -Files @{...`, written with `#`.

```text
-WorkingRootOnly: the .gitkeep files live in the fixture working root, but the asset under test is the one
shipped in the loaded Catzc.Base.Docs, so the code root stays on the loaded modules
```

## comment:5

Above `Describe 'Build-GitKeep — managed .gitkeep files' -Tag 'L1', 'integrity',...`, written with `#`.

```text
Reads only the repository's own .gitkeep files and readme.yml mappings — the same answer in both run modes,
so the build run skips it.
```
