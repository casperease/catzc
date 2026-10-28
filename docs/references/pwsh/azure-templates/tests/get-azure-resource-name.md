# pwsh/Azure.Templates/tests/Get-AzureResourceName.Tests.ps1

<!-- cspell:ignore alweufxosmplst weuwkspvm stfxosmplalweu alweusmplvm vmsmplalweu weufxosmplst -->

The L0 tests of `Get-AzureResourceName`.

## Patterns

The pattern selects the environment segment (long gives the name, restricted gives the shortcode) and the separator (a hyphen for long and
kv, none for storage and vm). The order arranges the segments. The tests use the base slot, so the slot segment is dropped.
