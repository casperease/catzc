---
catzc:
  immutable:
    with_body_sha: db6cee771e6d
    repo_status: locked
    path: docs/references/automation/catzc-base-rootconfig/Build-RootConfig.ps1.md
    folder: docs/references/automation/catzc-base-rootconfig
    name: build-root-config-ps1
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    tracktype: documentation
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
---

# automation/Catzc.Base.RootConfig/Build-RootConfig.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Materialises every opted-in managed root file from its in-repo source of truth — the writer behind the
"root configs are managed" contract.

### description

Reads the root-config registry (configs/rootconfig.yml, via Get-Config -Config rootconfig), filters it to
the opted-in entries (Get-RootConfigTargets), and reproduces each target from its single source of truth:
a `source` entry copies the authored file out under the generated-file head, a
`generator` entry renders the content through Invoke-RootConfigGenerator (e.g. New-Importer for
importer.ps1) and gets the same head, and a `copyAsLink` source entry skips content entirely — the target is materialised as a
filesystem link to the source (Set-FileLink), so the root file IS the source. Whether the target is
gitignored (committed false) or tracked (committed true) changes nothing here — content is produced the
same way; `committed` only governs git membership, asserted by the integrity test.

A generator renders either one file (the entry's target) or, for a wildcard target such as
`go/tests/*/go.mod`, one { Target; Content } record per file (Get-RootConfigRenderedFile): each file is
written on its own and reported in its own result row, under its own path.

Idempotent and fast by construction, so the importer runs it on every load (see importer.ps1): the write
goes through Write-FileIfChanged (canonical UTF-8/LF output, EOL-insensitive compare, write-on-change), so
a clean tree is a true no-op. See [ADR-REPO-ROOTCFG](../../../adr/repository/generated-root-configs.md).

The managed root files are materialised from the source tree, so in build mode
([ADR-DSGN-RUNMODE](../../../adr/design/run-modes.md)) this is a
no-op that reports why and returns nothing — a skip, not a throw, because the importer's janitor tail calls
it on every load and a janitor never breaks the load.

### parameter Target

Materialise only this repo-relative path: the entry whose target equals it (e.g.
'PSScriptAnalyzerSettings.psd1', or a wildcard entry's own pattern for all its files), or the one file of a
wildcard entry it matches (e.g. 'go/tests/widget/go.mod'). Throws when it selects no opted-in entry, or no file
of the wildcard entry it matches. Default: every opted-in entry.

### parameter DryRun

Report what would change without writing any file. The composed content is the same either way; -DryRun
only skips the write. See [ADR-AUTO-DRYRUN](../../../adr/automation/dry-run.md).

### parameter Silent

The per-file status lines are verbose-level — shown only when this function is run with -Verbose. -Silent
suppresses them entirely, even under -Verbose (used by the importer tail so a session with -Verbose on
does not chatter during import).

### parameter PassThru

Return one result object per managed file ({ Target, Source, Generator, Committed, Path, Changed, DryRun })
instead of the paths. A wildcard entry reports one object per rendered file, each with that file's Target.

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

## comment:1

Above `$sourcePath = Resolve-RepoPath $entry.source`, written with `#`.

```text
A link entry skips content composition entirely: the target IS the source, verified or
(re)created as a filesystem link by the one mechanism owner (Set-FileLink, Catzc.Base.Files).
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
A target that is currently a LINK is stale regardless of content equality: a comment:none entry
flipped back from copyAsLink composes bytes identical to its source, which the compare would read
through the link and call current — leaving the link in place while the registry says copy.
```

## comment:4

Above `$changed = Write-FileIfChanged -Path $targetPath -Content $file.Content...`, written with `#`.

```text
Canonicalise, EOL-insensitively compare, and write-on-change via the one shared primitive
(Write-FileIfChanged, Catzc.Base.Files).
```
