# automation/Catzc.Base.QualityGates/private/Get-LinkLineLimit.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its
comment sat above (Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Resolves the per-extension comment line limits the link aligner wraps to.

### description

Reads max_line_length from the repository's .editorconfig sections of the form `[*.ext]` and `[*.{a,b}]` — the
source of truth for formatting — then applies links.yml's line_limit overrides on top. An extension neither names
takes the config's default_line_limit
([ADR-AUTO-DEFAULT#6](../../../../adr/automation/sensible-defaults.md#rule-adr-auto-default6)), which the caller passes to
the engine separately.

### parameter RepositoryRoot

The repository root whose .editorconfig is read; a missing file yields only the overrides.

### parameter Override

links.yml's line_limit map (extension -> limit).

### outputs

`[System.Collections.Generic.Dictionary[string,int]]` extension ('.ps1') -> limit.
