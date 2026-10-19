# automation/pwsh/.scriptanalyzer/NoBareCacheEntryRead.psm1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `function Measure-NoBareCacheEntryRead {`, written with `#`.

```text
.SYNOPSIS
    Custom PSScriptAnalyzer rule: a function file reads a lazy $script: cache entry only after probing or assigning it.
.DESCRIPTION
    Nothing declares a cache entry at import, so the first read of an unset entry throws under strict mode.
    [comment:1](/docs/references/pwsh/scriptanalyzer/NoBareCacheEntryRead.psm1.md#comment1)
```

## comment:2

Above `$path = "$($ScriptBlockAst.Extent.File)"`, written with `#`.

```text
Skip a .psm1 (it can declare its cache entries at load) and a Pester file — by name, or by its Describe calls when
an editor buffer has no file name. Any other in-memory definition is analysed.
```

## comment:3

Above `$isFunction = {`, written with `#`.

```text
Predicates as locals, not inlined in FindAll's parens — dodges a cross-version indent skew
([ADR-PWSH-FORMAT-MULTILINEPREDICATEBOUND](/docs/adr/automation/pwsh/powershell-formatting.md#rule-adr-pwsh-format-multilinepredicatebound)).
```

## comment:4

Above `$declared =...`, written with `#`.

```text
Cache entries the script itself declares at load (a top-level `$script:<entry> = …`, outside any function). This
covers a .psm1 the editor analyses as an in-memory buffer, where the file name — and so the skip above — is lost.
```
