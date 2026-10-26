# pwsh/Catzc.Base.QualityGates/private/Get-ImprintStepFile.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Lists the files one imprint step may write, in its own scope.

### description

A step is never named by a language: which languages it covers is configuration, so this only answers which files the step reads.

It rests on
[ADR-REPO-FORMAT-CONFIGUREDFORMATTERS](../../../../drs/repository/uniform-formatting.md#rule-adr-repo-format-configuredformatters).

### parameter `Step`

The step name, as languages.yml spells it.

### parameter `RepositoryRoot`

The repository root.

### parameter `Path`

Optional files or folders to limit the scope to.

### outputs

`[string[]]` Absolute paths.

## comment:1

Above `$scope = Get-FormatScope -RepositoryRoot $root -Path $Path`, written with `#`.

```text
The formatter's own scope, so vendored code is never rewritten, narrowed to the PowerShell code files.
Get-FormatScope returns its paths as one array: assign it, so the filter walks the paths, not the array.
```

## comment:2

Above `if ($Path) {`, written with `#`.

```text
Format-Code -Path also formats files outside the repository, which no step's scope covers: they are left out, not
refused.
```

## comment:3

Above `$plans = Get-Config -Config plans`, written with `#`.

```text
The step rewrites the master and the value overlay; it is in scope with no -Path, or one in, or above, the
plans folder.
```
