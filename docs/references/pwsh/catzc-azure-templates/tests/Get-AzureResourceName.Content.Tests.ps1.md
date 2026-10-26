# pwsh/Azure.Templates/tests/Get-AzureResourceName.Content.Tests.ps1

The data-driven tests of `Get-AzureResourceName`, sourced from `tests/assets/Get-AzureResourceName.Content.yml`.

## Cases

Each case is an input splat plus an expected name, or an expected error. The input is read through `$case.input` and not bound as a
`-ForEach` variable, because `$input` is a PowerShell automatic variable.
