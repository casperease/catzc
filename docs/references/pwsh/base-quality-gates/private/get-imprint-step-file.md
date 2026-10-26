# pwsh/Base.QualityGates/private/Get-ImprintStepFile.ps1

The scope of one imprint step of `Format-Code`: it answers which files the named step reads, so the step is never tied to a language.

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

## Paths outside the repository

`Format-Code -Path` also formats files outside the repository, which no step's scope covers: they are left out, not refused.

## The plan-counts step

The `plan-counts` step rewrites the plans master and the value overlay, so it is in scope with no `-Path`, or with one in, or above, the
plans folder.
