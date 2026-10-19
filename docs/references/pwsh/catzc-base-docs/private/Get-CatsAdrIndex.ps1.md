# automation/pwsh/Catzc.Base.Docs/private/Get-CatsAdrIndex.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Parses the ADR index ([index](../../../../adr/index.md)) into the code -> ADR entries that Show-Cats presents.

### description

Reads the rule-citation registry tables in [index](../../../../adr/index.md) and returns one entry per ADR: its citation code, its title
slug, and its index-relative path. A pure function of the file on disk, memoized per resolved index path for the session (re-run the
importer to refresh — see [ADR-AUTO-CACHE](../../../../adr/automation/caching.md)). Inline code-span mentions of a code (in prose) are not
table rows and are ignored.

Private helper for Show-Cats; not exported.

### parameter `IndexPath`

Absolute path to the ADR index. Defaults to [index](../../../../adr/index.md) under the repository root. A test points this at a fixture
index; the cache keys on the path, so a fixture path and the real path never collide.

### outputs

`[object[]]` One { Code; Title; Path } per ADR row in the index.

## comment:1

Above `$script:catsAdrIndexCache = @{}`, written with `#`.

```text
strict-clean probe of the lazy cache entry
([ADR-PWSH-CACHE-STRICTSAFEPROBE](/docs/adr/automation/pwsh/script-scope-caching.md#rule-adr-pwsh-cache-strictsafeprobe))
```
