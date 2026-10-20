<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Base.Contracts/New-CatsCommandLookup.ps1
    name: new-cats-command-lookup
    filetype: ps1
    role: function
    subkind: writer
    language: powershell
    track: pwsh
    tracktype: modules
    module: Catzc.Base.Contracts
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  edges:
    test: pwsh/Catzc.Base.Contracts/tests/New-CatsCommandLookup.Tests.ps1
    docs: "[New-CatsCommandLookup.ps1.md](docs/references/pwsh/catzc-base-contracts/New-CatsCommandLookup.ps1.md)"
    cites:
      - ADR-REPO-CMDCONTRACT-ONEREADER
---
#>

function New-CatsCommandLookup {
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [string] $RepositoryRoot = (Get-RepositoryRoot)
    )

    $lines = [System.Collections.Generic.List[string]]::new()
    $lines.Add('# shellcheck shell=bash')
    $lines.Add('# The command lookup `cats` reads before it starts pwsh (ADR-REPO-CMDCONTRACT-ONEREADER): one line per contracted parameter of')
    $lines.Add('# contracts/catzc/0.0.0, tab-separated: command, parameter, type, list (1 or 0), mandatory (1 or 0), pipeline (1 or 0), asset,')
    $lines.Add('# the parameter''s sets (comma-separated, empty for every set) and the command''s default set (empty for none). A command with no')
    $lines.Add('# parameter has one line with an empty parameter.')
    $lines.Add("_catzc_commands='")
    $contracts = @(Get-CommandContract -RepositoryRoot $RepositoryRoot | Sort-Object -Property Name -Culture ([System.Globalization.CultureInfo]::InvariantCulture))
    foreach ($contract in $contracts) {
        $asset = $contract.Asset.AssetPath
        $defaultSet = [string] $contract.default_set
        $parameters = @($contract.parameters)
        if ($parameters.Count -eq 0) {
            $lines.Add(($contract.Name, '', '', '0', '0', '0', $asset, '', $defaultSet) -join "`t")
            continue
        }
        foreach ($parameter in $parameters) {
            $sets = $parameter.Sets -join ','
            $lines.Add(($contract.Name, $parameter.Name, $parameter.Type, [int] $parameter.IsList, [int] $parameter.Mandatory, [int] $parameter.Pipeline, $asset, $sets, $defaultSet) -join "`t")
        }
    }
    $lines.Add("'")
    ($lines -join "`n") + "`n"
}
