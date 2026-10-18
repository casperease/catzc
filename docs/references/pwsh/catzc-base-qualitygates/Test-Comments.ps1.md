# automation/Catzc.Base.QualityGates/Test-Comments.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Quality gate: every long comment lives in its file's comment page, and every page section still names a code line of the file.

### description

A quality gate ([ADR-AUTO-TEST#35](../../../adr/automation/test-automation.md#rule-adr-auto-test35)) over the files in scope
(Get-CommentScope). A file keeps no long comment and the prose lives once, in the file's comment page
([ADR-PRIN-ONELIVE#1](../../../adr/principles/one-living-version.md#rule-adr-prin-onelive1)); it lists every issue:

- a comment long enough to move that is still in the file (run Export-Comments);
- a page section whose code line the file no longer has, so its prose belongs to nothing.

What the configured thresholds are is comments.yml's
([ADR-PRIN-CONFIG#1](../../../adr/principles/configure-not-program.md#rule-adr-prin-config1)). A source-tree tool: it throws in build mode
(Assert-SourceTree).

### parameter `Path`

Files or folders to check. Default: every file in scope.

### parameter `RepositoryRoot`

The repository root paths and pages resolve against. Default: the loaded repository root.

### parameter `OutputFolder`

The report base folder. Default: the reports.yml folder for this gate.

### parameter `PassThru`

Return the report object instead of throwing on issues.

### outputs

`[pscustomobject]` With -PassThru only.

### example 1

```powershell
Test-Comments
```

### example 2

```powershell
Test-Comments -Path automation/Catzc.Base.Files -PassThru
```
