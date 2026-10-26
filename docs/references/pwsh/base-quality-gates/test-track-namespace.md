# pwsh/Base.QualityGates/Test-TrackNamespace.ps1

The quality gate for track namespaces: it fails on a tracked path that spells its track's namespace on disk, and writes a report to the
output folder.

## help

### synopsis

Fails on a tracked path that spells its track's namespace on disk, and writes a report to the output folder.

### description

A folder or file under a track drops the namespace its track declares; only a file the track exempts keeps it
([DDR-TRACK-MODULENAMESPACE](../../../drs/design/tracks.md#rule-ddr-track-modulenamespace)). For every track that declares a namespace, each
git-tracked path whose segment spells the namespace with the track's join is an issue, named by the track and the segment. A quality gate
([ADR-AUTO-TEST-QUALITYGATE](../../../drs/automation/test-automation.md#rule-adr-auto-test-qualitygate)): it ends through
Write-QualityGateReport, and -PassThru returns the result object instead.

### parameter `OutputFolder`

The report base folder. Defaults to `<out>/test-track-namespace`.

### parameter `PassThru`

Return a result object instead of throwing.

### example 1

```powershell
Test-TrackNamespace -PassThru
```

## Rule

A folder or file under a track drops the namespace its track declares. Only a file the track exempts keeps it
([DDR-TRACK-MODULENAMESPACE](../../../drs/design/tracks.md#rule-ddr-track-modulenamespace)).
