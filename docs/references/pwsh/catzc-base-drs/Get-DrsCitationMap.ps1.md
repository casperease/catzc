# pwsh/Catzc.Base.Drs/Get-DrsCitationMap.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Builds the ADR citation map: every citation code to its ADR's path and declared rule numbers.

### description

Reads the rule-citation registry in `<root>/docs/drs/index.md` (Get-CatsDrsIndex) and each listed ADR's `### Rule <CODE>:<n>` headings
(Get-CatsDrsRules), and returns one immutable `[Catzc.Base.Drs.DrsCitationMap]`: code -> repository-relative ADR path and rule numbers, the
reverse path -> code map, and a unique-slug -> path map over every markdown file under docs/drs/ (so a stale path to a moved ADR resolves by
its file name). The link engine derives every code link's destination from it
([ADR-REPO-LINK-CODELINKS](../../../drs/repository/markdown-links.md#rule-adr-repo-link-codelinks)).

A pure function of the files on disk, memoized per resolved repository root for the session (re-run the importer to refresh — see
[ADR-AUTO-CACHE](../../../drs/automation/caching.md)); a test passes a fixture root, so the fixture map and the real one never collide.

### parameter `RepositoryRoot`

The repository root whose [index](../../../drs/index.md) is read. Defaults to the loaded repository root.

### outputs

`[Catzc.Base.Drs.DrsCitationMap]`

### example 1

```powershell
(Get-DrsCitationMap).Destination('ADR-PWSH-ERROR', 3)   # /docs/drs/automation/pwsh/error-handling.md#rule-adr-pwsh-error-thrownotwriteerror
```

## comment:1

Above `$script:adrCitationMapCache = @{}`, written with `#`.

```text
strict-clean probe of the lazy cache entry
([ADR-PWSH-CACHE-STRICTSAFEPROBE](/docs/drs/automation/pwsh/script-scope-caching.md#rule-adr-pwsh-cache-strictsafeprobe))
```
