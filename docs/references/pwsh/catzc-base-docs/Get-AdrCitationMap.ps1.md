# pwsh/Catzc.Base.Docs/Get-AdrCitationMap.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Builds the ADR citation map: every citation code to its ADR's path and declared rule numbers.

### description

Reads the rule-citation registry in `<root>/docs/adr/index.md` (Get-CatsAdrIndex) and each listed ADR's `### Rule <CODE>:<n>` headings
(Get-CatsAdrRules), and returns one immutable `[Catzc.Base.Docs.AdrCitationMap]`: code -> repository-relative ADR path and rule numbers, the
reverse path -> code map, and a unique-slug -> path map over every markdown file under docs/adr/ (so a stale path to a moved ADR resolves by
its file name). The link engine derives every code link's destination from it
([ADR-REPO-LINK#3](../../../adr/repository/markdown-links.md#rule-adr-repo-link3)).

A pure function of the files on disk, memoized per resolved repository root for the session (re-run the importer to refresh — see
[ADR-AUTO-CACHE](../../../adr/automation/caching.md)); a test passes a fixture root, so the fixture map and the real one never collide.

### parameter `RepositoryRoot`

The repository root whose [index](../../../adr/index.md) is read. Defaults to the loaded repository root.

### outputs

`[Catzc.Base.Docs.AdrCitationMap]`

### example 1

```powershell
(Get-AdrCitationMap).Destination('ADR-PWSH-ERROR', 3)   # /docs/adr/pwsh/error-handling.md#rule-adr-pwsh-error3
```

## comment:1

Above `$script:adrCitationMapCache = @{}`, written with `#`.

```text
strict-clean probe of the lazy cache entry
([ADR-PWSH-CACHE#4](/docs/adr/pwsh/script-scope-caching.md#rule-adr-pwsh-cache4))
```
