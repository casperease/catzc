# pwsh/Base.QualityGates/Test-Comments.ps1

The comment-page gate: every long comment lives in its file's comment page, and every page section still names a code line of the file.

## help

### synopsis

Quality gate: every long comment lives in its file's comment page, and every page section still names a code line of the file.

### description

A quality gate ([ADR-AUTO-TEST-QUALITYGATE](../../../drs/automation/test-automation.md#rule-adr-auto-test-qualitygate)) over the files in
scope (Get-CommentScope). A file keeps no long comment and the prose lives once, in the file's comment page
([PDR-ONELIVE-ONEVERSION](../../../drs/principles/one-living-version.md#rule-pdr-onelive-oneversion)); it lists every issue:

- a comment long enough to move that is still in the file (run Export-Comments);
- a page section whose code line the file no longer has, so its prose belongs to nothing.

What the configured thresholds are is comments.yml's
([PDR-CONFIG-VARYINGBEHAVIOURISCONFIG](../../../drs/principles/configure-not-program.md#rule-pdr-config-varyingbehaviourisconfig)). A
source-tree tool: it throws in build mode (Assert-SourceTree).

### parameter `Path`

Files or folders to check. Default: every file in scope.

### parameter `RepositoryRoot`

The repository root paths and pages resolve against. Default: the loaded repository root.

### parameter `OutputFolder`

The report base folder. Default: the reports.yml folder for this gate.

### parameter `PassThru`

Return the report object instead of throwing on issues.

### outputs

`[Catzc.Base.Reports.QualityGateResult]` With -PassThru only.

### example 1

```powershell
Test-Comments
```

### example 2

```powershell
Test-Comments -Path pwsh/Base.Files -PassThru
```
