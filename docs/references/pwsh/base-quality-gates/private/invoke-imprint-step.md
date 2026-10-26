# pwsh/Base.QualityGates/private/Invoke-ImprintStep.ps1

Runs one imprint step over the given files and returns what it changed and what it cannot repair. One switch maps each step name to the
function that does it.

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

## Empty lists

Each case first returns for an empty list. A run with no files still proves that the step has its adapter, and an empty list never reaches a
command whose default is the whole repository.

## Comment pages

The comments step writes a file and its comment page, so the page is a companion of the file and not a second subject of the step. The paths
stay absolute, because the link check resolves a relative `-Path` against the current location, which is not the root.

The help step reads the `## help` section of the file's comment page. It only reports what a person must settle and changes no file.

## Plan step counts

The counts are derived from the plans beside each overlay, so each folder the files sit in is rewritten once. A rewritten overlay can lie
outside `-Path`, past the formatter's pass, so the step formats what it wrote itself.
