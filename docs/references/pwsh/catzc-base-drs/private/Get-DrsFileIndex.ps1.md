# pwsh/Base.Drs/private/Get-DrsFileIndex.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Indexes the markdown files under docs/drs/ by "`<domain folder>/<slug>`", and maps each rule set to its one ADR file.

### description

Enumerates every `docs/drs/**/*.md` once and keys it by its first folder under docs/drs/ (the domain folder; empty for a file at the root)
and its file name without extension, so a slug shared across domains (one in automation/, one in research/) stays distinct and a slug
repeated within one domain's subfolders shows as two files under one key. FileOf maps a rule set's External code to its file when exactly
one file has its key; a rule set with none or several is a finding of the registry quality gate (Test-DrsRegistry), so the checks that read
rule files skip it.

Private helper for Test-DrsRegistry and Test-DrsEngineNeutrality; not exported.

### parameter `RuleSets`

The rule sets of the ADR registry (DrsConfig.RuleSets).

### parameter `DrsRoot`

The absolute docs/drs/ folder.

### outputs

`[pscustomobject]` { Root; Relative; ByKey; FileOf }: Relative lists every file's path under docs/drs/ ('/'-separated), ByKey maps each key
to its list of relative paths, and FileOf maps an External code to its one relative path.

## comment:1

Above `$folders = @($RuleSets.Folder | Sort-Object -Unique | Sort-Object -Property...`, written with `#`.

```text
A page belongs to the domain with the longest folder that holds it, so a domain folder nested in another domain's
folder keeps its own pages.
```
