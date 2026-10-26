# pwsh/Base.QualityGates/private/Invoke-FileMetaEngine.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Computes the meta block of every in-scope file — the one place Format-FileMeta and Test-FileMeta share.

### description

Each file's `warning` line and `edges` part are rebuilt from the registry and its imprint kinds, and its authored `config` part is kept as
written. An `immutable` part in an authored head is removed and reported as Drift that names it, since only a generated head has one. A file
whose block holds a key no kind owns is reported as Unowned and left unchanged, since writing it would drop the author's key
([ADR-REPO-FILEMETA-KINDSCOPE](../../../../drs/repository/file-meta.md#rule-adr-repo-filemeta-kindscope)).

### parameter `RepositoryRoot`

The repository root paths are relative to.

### parameter `Path`

Optional files or folders to limit the scope to.

### parameter `Config`

The meta-kind registry. Default: the shipped one.

### parameter `Entry`

The files to check, each { Path; Carrier }, instead of the scope git and the registries give.

### outputs

`[pscustomobject]` @{ FileCount; Files } — Files holds every file with a finding: @{ Path; Findings; Fixed }, each finding @{ Path; Line;
Kind; Actual; Expected }.

## comment:1

Above `$entries = foreach ($entry in $files) {`, written with `#`.

```text
The block's first level is wholly the engine's but for the authored config part: a key no kind owns there is
dropped on imprint.
```

## comment:2

Above `if (-not [System.IO.File]::Exists((Join-Path $RepositoryRoot $file))) {`, written with `#`.

```text
A path the index lists but the working tree has lost, a deletion not yet staged, has nothing to imprint or to
look beside.
```

## comment:3

Above `if (-not $state.CanHoldMetaBlock) {`, written with `#`.

```text
A parent key written as a flow mapping or a scalar is the author's to open up; the block cannot nest under
it.
```

## comment:4

Above `if ($findings.Count -eq 0 -and $policy -eq...`, written with `#`.

```text
A forbidden block that holds an authored config part is the author's to move: stripping it would drop their
keys.
```

## comment:5

Above `if ($findings.Count -eq 0) {`, written with `#`.

```text
The writers drop a block whose facts and config part are all empty, so a file with no fact to show carries no
head.
```

## comment:6

Above `$drifted = if ('immutable' -in @($state.Sections)) {`, written with `#`.

```text
An authored head has no immutable part: Format-FileMeta removes one, and the finding says so before it
does.
```
