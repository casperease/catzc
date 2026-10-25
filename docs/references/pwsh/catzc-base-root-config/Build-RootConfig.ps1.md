# pwsh/Catzc.Base.RootConfig/Build-RootConfig.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Materialises every opted-in managed root file from its in-repo source of truth — the writer behind the "root configs are managed" contract.

### description

Reads the root-config registry (configs/rootconfig.yml, via Get-Config -Config rootconfig), filters it to the opted-in entries
(Get-RootConfigTargets), and reproduces each target from its single source of truth: a `source` entry copies the authored file out under the
generated-file head, a `generator` entry renders the content through Invoke-RootConfigGenerator (e.g. New-Importer for importer.ps1) and
gets the same head; the root file is never a link to its template. Whether the target is gitignored (committed false) or tracked (committed
true) changes nothing here — content is produced the same way; `committed` only governs git membership, asserted by the integrity test.

A generator renders either one file (the entry's target) or, for a wildcard target such as `go/tests/*/go.mod`, one { Target; Content }
record per file (Get-RootConfigRenderedFile): each file is written on its own and reported in its own result row, under its own path.

Idempotent and fast by construction, so the importer runs it on every load (see importer.ps1): the write goes through Write-FileIfChanged
(canonical UTF-8/LF output, EOL-insensitive compare, write-on-change), so a clean tree is a true no-op. See
[ADR-REPO-ROOTCFG](../../../drs/repository/generated-root-configs.md).

The managed root files are materialised from the source tree, so in build mode ([DDR-RUNMODE](../../../drs/design/run-modes.md)) this is a
no-op that reports why and returns nothing — a skip, not a throw, because the importer's janitor tail calls it on every load and a janitor
never breaks the load.

### parameter `Target`

Materialise only this repo-relative path: the entry whose target equals it (e.g. 'PSScriptAnalyzerSettings.psd1', or a wildcard entry's own
pattern for all its files), or the one file of a wildcard entry it matches (e.g. 'go/tests/widget/go.mod'). Throws when it selects no
opted-in entry, or no file of the wildcard entry it matches. Default: every opted-in entry.

### parameter `DryRun`

Report what would change without writing any file. The composed content is the same either way; -DryRun only skips the write. See
[ADR-AUTO-DRYRUN](../../../drs/automation/dry-run.md).

### parameter `Silent`

The per-file status lines are verbose-level — shown only when this function is run with -Verbose. -Silent suppresses them entirely, even
under -Verbose (used by the importer tail so a session with -Verbose on does not chatter during import).

### parameter `PassThru`

Return one result object per managed file ({ Target, Source, Generator, Committed, Path, Changed, DryRun }) instead of the paths. A wildcard
entry reports one object per rendered file, each with that file's Target.

### outputs

`[string[]]` The paths to the managed files (with -PassThru, one result object per file instead).

### example 1

```powershell
Build-RootConfig
Reproduces every opted-in managed root file from its source of truth.
```

### example 2

```powershell
Build-RootConfig -DryRun -PassThru
Reports which managed root files are stale without writing them.
```

### example 3

```powershell
Build-RootConfig 'PSScriptAnalyzerSettings.psd1'
Reproduces only that managed file.
```

## comment:2

Above `foreach ($listed in $entry.sources) {`, written with `#`.

```text
A generator's rendered output (which owns its whole content below the head): one file, or one
record per file of a wildcard target.
```

## comment:3

Above `$item = Get-Item -LiteralPath $targetPath -Force -ErrorAction Ignore`, written with `#`.

```text
A target that is currently a LINK is stale regardless of content equality: the compare would read
through the link, and the write would reach the file it points at, so the link is deleted first and
the copy is written as a file of its own.
```

## comment:4

Above `$changed = Write-FileIfChanged -Path $targetPath -Content $file.Content...`, written with `#`.

```text
Canonicalise, EOL-insensitively compare, and write-on-change via the one shared primitive
(Write-FileIfChanged, Catzc.Base.Files).
```

## comment:5

Above `$whole = -not $Target -and -not $DryRun -and -not $PassThru`, written with `#`.

```text
A whole run is skipped when nothing it declares as an input in generated-files.yml (its generators, sources and targets) changed
since its last run: the one writer memo every generated-file writer reads.
```
