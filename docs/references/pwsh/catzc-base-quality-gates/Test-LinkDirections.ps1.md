# pwsh/Base.QualityGates/Test-LinkDirections.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

The link-direction quality gate: fails on every relation that points a way the direction rows do not allow.

### description

Reads every relation the files write through the same walk as Test-Links (Invoke-LinkEngine -IncludeEdge), and every relation their
declarations imply among the same files (Get-ConventionEdge), builds the endpoint of each distinct file once (Get-LinkEndpoint), and judges
each relation against the rows of link-directions.yml: the first matching row decides, and a relation no row allows is denied. A file named
under the config's `exempt` is skipped with its reason. A run that read no relation at all is a finding, never a pass, because it proves
nothing.

A quality gate ([ADR-AUTO-TEST-QUALITYGATE](../../../drs/automation/test-automation.md#rule-adr-auto-test-qualitygate)): it ends through
Write-QualityGateReport, which writes out/test-link-directions/, prints every issue, and throws once listing them all. Each issue reads
'`<file>:<line>` `[<relation>]` `<from class>` -> `<to class>`' and then the deciding row and its rule code, "no row allows it", or the path
that has no endpoint. It needs the source tree: it throws in build mode.

### parameter `Path`

Files or folders to check. Default: every git-tracked file.

### parameter `RepositoryRoot`

The repository root. Default: the loaded repository.

### parameter `OutputFolder`

Where the report is written. Default: out/test-link-directions/.

### parameter `PassThru`

Returns the result, with the file count, the relation count and the convention-relation count as facts, instead of only reporting it.

### outputs

`[Catzc.Base.Reports.QualityGateResult]`

## comment:1

Above `$settings = Get-Config -Config links`, written with `#`.

```text
The relations come from the same walk as Test-Links, so the two gates agree on what a link is
([ADR-REPO-LINKS-CHECKEDBYONEGATE](/docs/drs/repository/links-in-repository.md#rule-adr-repo-links-checkedbyonegate)).
```
