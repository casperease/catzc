<#
---
catzc:
  immutable:
    with_body_sha: "8440356b92cf"
  edges:
    test: pwsh/Catzc.Azure.Cli/tests/Test-AzCliBicep.Tests.ps1
    docs: "[Test-AzCliBicep.ps1.md](docs/references/pwsh/catzc-azure-cli/Test-AzCliBicep.ps1.md)"
    cites:
      - ADR-AUTO-ENTERP
      - ADR-AZ-CLI-AZBYDEFAULT
---
#>

function Test-AzCliBicep {
    [OutputType([bool])]
    param()

    (Get-AzCliBicepState).meets_minimum
}
