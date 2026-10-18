# automation/Catzc.Base.QualityGates/private/Invoke-Prettier.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

The prettier formatter engine: formats the given files with Prettier and returns the files it changed.

### description

One Format-Code engine adapter ([ADR-PRIN-CONFIG#2](../../../../adr/principles/configure-not-program.md#rule-adr-prin-config2)): every file
language languages.yml gives `formatter: prettier` is formatted here. Prettier picks its parser from each file's extension and applies the
root .prettierrc.yml and .editorconfig, so the Markdown and pipeline YAML rules live in those files, not in a command per language.

`prettier --list-different` names the files that differ; without -DryRun, `prettier --write` then rewrites exactly those. The files go to
Prettier in batches that keep each command line short. Exit codes: 0 = clean, 1 = files differ (expected), anything higher is a tool error
(a file Prettier cannot parse), which throws with Prettier's own output.

Prettier must be on PATH — install it once with Install-Prettier.

### parameter File

Absolute paths of the files to format.

### parameter DryRun

List the files Prettier would change without writing them.

### outputs

`[string[]]` Absolute paths of the files changed (or, under -DryRun, that would change).
