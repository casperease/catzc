# pwsh/Base.QualityGates/private/Write-TestResultMarker.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Keeps one test-result marker per failing test file, `out/test-results/<repository path of the test file>.failed`.

### description

The editor's lamps read a test failure from the marker's existence and timestamp alone (DDR-FILTER-ENGINEADAPTSSOURCES). A failing file's
marker is written with its failed test count and run folder; a passing file's marker is deleted. A file outside the repository gets none.

### parameter `Outcome`

One item per test file the run executed: `Path` (the file's source path), `Failed` (whether it failed) and `FailedCount`.

### parameter `RunDirectory`

The run's folder, named in a written marker.

### parameter `KeepPassing`

The run was filtered to some tests, so it records failures and clears no marker.

### parameter `RepositoryRoot`

The root the markers' paths are relative to; the repository root by default.

### parameter `OutputRoot`

The output root that holds `test-results`; the repository's by default.

### outputs

`[string[]]` The markers written.

## comment:1

Above `$markerRoot = Join-Path $OutputRoot 'test-results'`, written with `#`.

```text
One marker per failing test file at a fixed path, out/test-results/<repository path of the test file>.failed, so a reader (the
editor's lamps) needs only its existence and its timestamp; a passing file's marker is deleted. Returns the markers written.
```

## comment:2

Above `[switch] $KeepPassing,`, written with `#`.

```text
A run filtered to some tests says nothing of the others, so it only records failures and never clears a
marker.
```
