# automation/.scriptanalyzer/NoBareCacheEntryRead.psm1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per
section (Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
A module function file holds one function and no top-level statements
([ADR-PWSH-ONEFUNC](/docs/adr/pwsh/one-function-per-file.md)), so nothing declares
a $script: cache entry at import: the first call reads a variable that was never set, and strict mode throws.
The function must either assign the cache entry before reading it, or probe it with
`$ExecutionContext.SessionState.PSVariable.GetValue('script:<entry>')`
([ADR-PWSH-CACHE#4](/docs/adr/pwsh/script-scope-caching.md#rule-adr-pwsh-cache4)).

Scope: everything except a .psm1 and a Pester file. A .psm1 module can declare its cache entries at load, and a
Pester file shares state through $script: on purpose. Within a function, a read is accepted when the same function
probes that cache entry with GetValue('script:<entry>') anywhere, or assigns it (a plain `$script:<entry> = …`)
earlier in the text, or when the script declares that cache entry at top level, outside any function.
```

## comment:2

Above `$path = "$($ScriptBlockAst.Extent.File)"`.

```text
Skip a .psm1 (it can declare its cache entries at load) and a Pester file — by name, or by its Describe calls when
an editor buffer has no file name. Any other in-memory definition is analysed.
```

## comment:3

Above `$isFunction = {`.

```text
Predicates as locals, not inlined in FindAll's parens — dodges a cross-version indent skew
([ADR-PWSH-FORMAT#6](/docs/adr/pwsh/powershell-formatting.md#rule-adr-pwsh-format6)).
```

## comment:4

Above `$declared =...`.

```text
Cache entries the script itself declares at load (a top-level `$script:<entry> = …`, outside any function). This
covers a .psm1 the editor analyses as an in-memory buffer, where the file name — and so the skip above — is lost.
```
