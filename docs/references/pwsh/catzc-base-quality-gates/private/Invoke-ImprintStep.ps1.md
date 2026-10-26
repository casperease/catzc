# pwsh/Catzc.Base.QualityGates/private/Invoke-ImprintStep.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Runs one imprint step over the given files and returns what it changed and what it cannot repair.

### description

A language is never named here: which language runs which step is configuration, not code.

It rests on
[PDR-CONFIG-NEWINSTANCEISCONFIGCHANGE](../../../../drs/principles/configure-not-program.md#rule-pdr-config-newinstanceisconfigchange) and
[ADR-REPO-FORMAT-CONFIGUREDFORMATTERS](../../../../drs/repository/uniform-formatting.md#rule-adr-repo-format-configuredformatters).

### parameter `Step`

The step name, as languages.yml spells it.

### parameter `File`

Absolute paths of the files to imprint.

### parameter `RepositoryRoot`

The repository root.

### parameter `DryRun`

List the files the step would change without writing them.

### outputs

`[pscustomobject]` @{ Changed; Unfixable } — absolute paths changed (or, under -DryRun, that would change), and a map of absolute path to
the problem for the files a person must repair.

## comment:1

Above `switch -CaseSensitive ($Step) {`, written with `#`.

```text
Each case first returns for an empty list, so a run with no files still proves the step has its adapter, and an empty list
never reaches a command whose default is the whole repository.
```

## comment:2

Above `$moved = @(Export-Comments -Path $File -RepositoryRoot $root -DryRun:$DryRun)`, written with `#`.

```text
The step writes a file and its comment page, so the page is a companion of the file, not a second subject of the step.
The paths stay absolute: the link scope resolves a relative -Path against the current location, which is not the root.
```

## comment:3

Above `$commentPages = Get-Config -Config comment-pages`, written with `#`.

```text
The help is the ## help section of the file's comment page, so the step only reports what a person must
settle and changes no file.
```

## comment:4

Above `$plans = Get-Config -Config plans`, written with `#`.

```text
The counts are derived from the plans beside each overlay, so each folder the files sit in is rewritten
once.
```

## comment:5

Above `if (-not $DryRun -and $outcome.Changed.Count -gt 0) {`, written with `#`.

```text
A rewritten overlay can lie outside -Path, past the formatter's pass, so the step formats what it wrote
itself.
```
