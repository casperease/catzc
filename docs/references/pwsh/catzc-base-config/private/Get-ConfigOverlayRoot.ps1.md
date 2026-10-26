# pwsh/Catzc.Base.Config/private/Get-ConfigOverlayRoot.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Returns the consumer overlay root Get-Config merges fragments from, cached per pair of session anchors.

### description

Get-Config sits on the hot path, so the overlay root (Get-CatzcOverlayRoot, which derives the run mode from the two roots) is worked out
once per RepositoryRoot / CatzcModulesRoot pair and kept for the session
([ADR-PWSH-CACHE](../../../../drs/automation/pwsh/script-scope-caching.md)). A change of either anchor — a new working root, or a switch of
run mode — is a new key, so the answer never outlives the roots it came from.

### outputs

`[string]` The overlay root, or nothing.

## comment:1

Above `if...`, written with `#`.

```text
strict-clean probe of the lazy cache entry
([ADR-PWSH-CACHE-STRICTSAFEPROBE](/docs/drs/automation/pwsh/script-scope-caching.md#rule-adr-pwsh-cache-strictsafeprobe))
```

## comment:2

Above `$fragmentRoot = [System.IO.Path]::GetFullPath((Join-Path (Get-RepositoryRoot)...`, written with `#`.

```text
Source mode reads only this repository's own config fragments, under .catzc/<the modules folder>
([PDR-CATS-FOLDERSUSECATZC](/docs/drs/principles/cats-and-catzc.md#rule-pdr-cats-foldersusecatzc)).
```

## comment:3

Above `$fragmentRoot = [System.IO.Path]::GetFullPath((Join-Path (Get-RepositoryRoot)...`, written with `#`.

```text
A source run reads only this repository's own fragments, so a consumer's overlay can never leak into the
source tree.
```
