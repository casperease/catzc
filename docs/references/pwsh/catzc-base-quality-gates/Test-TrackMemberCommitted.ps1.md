# pwsh/Catzc.Base.QualityGates/Test-TrackMemberCommitted.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Quality gate: every track member's committed fact agrees with the git index.

### description

A track declares each member with a `committed` fact
([DDR-TRACK-TRACKISPLACEDCLUSTER](../../../drs/design/tracks.md#rule-ddr-track-trackisplacedcluster)), and the git index is what it must
agree with. A committed member of which files lie on disk but none is tracked is one issue, and a member declared not committed of which git
tracks a file is one issue naming the first tracked file. A committed member with nothing on disk yet, such as an empty landing address, has
nothing to disagree with. The members come from Get-TrackMember and the index from Get-GitTrackedPath, so the gate sits above both
Catzc.Base.Variants and the git readers.

Ends with Write-QualityGateReport: the report lands in out/test-track-member-committed/, and the gate throws once listing every issue (or
returns the result with -PassThru). Needs the source tree (Assert-SourceTree).

### parameter `OutputFolder`

The report base folder. Defaults to Write-QualityGateReport's (out/test-track-member-committed).

### parameter `PassThru`

Return the gate result { Subject; IssueCount; Issues; ReportPath; Members } instead of throwing on issues.

### outputs

`[Catzc.Base.Reports.QualityGateResult]` With -PassThru only.

### example 1

```powershell
Test-TrackMemberCommitted
```

### example 2

```powershell
(Test-TrackMemberCommitted -PassThru).Issues
```

## comment:1

Above `$root = Get-RepositoryRoot`, written with `#`.

```text
A member's committed fact is declared, and the git index is what it must agree with
([DDR-TRACK-TRACKISPLACEDCLUSTER](/docs/drs/design/tracks.md#rule-ddr-track-trackisplacedcluster)); a committed
member with nothing on disk yet, such as an empty landing address, has nothing to disagree with.
```
