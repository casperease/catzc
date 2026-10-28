# pwsh/Base.QualityGates/Format-Links.ps1

The link aligner of the repository: it rewrites DRS citations in code comments into canonical code links and repository-rooted markdown
links into relative ones, in place. `Test-Links` reports what it cannot fix.

## help

### synopsis

Aligns the repository's links in place: code links repository-rooted, markdown links relative.

### description

The link aligner and the repository-wide migration in one command
([ADR-REPO-LINK-ALIGNEDBYTOOL](../../../drs/repository/markdown-links.md#rule-adr-repo-link-alignedbytool)). Every record reference in a
comment of a code file becomes a canonical code link — `[ADR-<CODE>#<n>](/docs/drs/<path>.md#rule-adr-<code><n>)`, or
`[ADR-<CODE>](/docs/drs/<path>.md)` for a whole record — whatever spelling it had: a bare, ../, or rooted docs/drs path, a record file name,
a bare citation (`ADR-X`, `ADR-X:n`, `ADR-X#n`), a path followed by its citation, or a link in another shape. The citation code is the
source of truth, so a path to a moved record is re-pointed. In markdown files a repository-rooted link becomes relative to its file, and a
prose rule citation `ADR-X:n` becomes `ADR-X#n`. In a code file's string literals a rule citation `ADR-X:n` becomes `ADR-X#n` too, and stays
plain data (only the ':' changes), except in a `### Rule` heading the string builds and in a file links.yml's string_citations exempts. A
string is data its code consumes, so align it together with whatever reads it.

A comment line that outgrows its line limit (.editorconfig max_line_length, with links.yml overrides) is wrapped per -Wrap: broken before
the link, never inside it, continuing with the same comment prefix and indent.

What cannot be fixed mechanically — a dangling path, an unknown citation code or rule, a bad anchor — is left as written and listed as
unfixable; Test-Links reports it. The engine is compiled C# (Catzc.Base.QualityGates.LinkEngine) and runs files in parallel, so a
whole-repository run is fast. Files are written as UTF-8 without a BOM, with their own line endings kept. A source-tree tool: it throws in
build mode (Assert-SourceTree).

### parameter `Path`

Files or folders to align. Default: every git-tracked file.

### parameter `Kind`

Which link kinds to align: Code, Markdown, or Both (default).

### parameter `Wrap`

How an aligned comment line that outgrows its limit is wrapped: Break or Off. Default: links.yml's wrap.

### parameter `RepositoryRoot`

The repository root links resolve against. Default: the loaded repository root.

### parameter `MoveMap`

A csv of moves (an `old` and a `new` column per row, repository-relative). Before the links are aligned, every link that one of those moves
broke is re-pointed to the file's new path, and a moved file's own links are resolved from where it stood. Default: no move map.

### parameter `DryRun`

Report what would change without writing any file.

### parameter `PassThru`

Return a result object ({ ChangedCount, ChangedFiles, Fixed, Unfixable, DryRun, ElapsedMs }) instead of only the changed paths.

### outputs

`[string[]]` the repository-relative paths changed (or, under -DryRun, that would change); with -PassThru, the result object.

### example 1

```powershell
Format-Links
```

### example 2

```powershell
Format-Links -DryRun -PassThru
```

### example 3

```powershell
Format-Links -Path pwsh/Base.Docs -Kind Code
```
