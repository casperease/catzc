# pwsh/Base.Config/private/Get-ConfigOverlayRoot.ps1

The private helper that finds the consumer overlay root `Get-Config` merges fragments from, cached per pair of session anchors.

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

## Cache probe

The cache entry is probed strict-clean
([ADR-PWSH-CACHE-STRICTSAFEPROBE](../../../../drs/automation/pwsh/script-scope-caching.md#rule-adr-pwsh-cache-strictsafeprobe)).

## Source mode

Source mode reads only this repository's own config fragments, under `.catzc/<the modules folder>`
([PDR-CATS-FOLDERSUSECATZC](../../../../drs/principles/cats-and-catzc.md#rule-pdr-cats-foldersusecatzc)), so a consumer's overlay can never
leak into the source tree.
