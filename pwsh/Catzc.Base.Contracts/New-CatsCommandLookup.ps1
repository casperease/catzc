<#
---
catzc:
  immutable:
    with_body_sha: f6a7cc5bbb78
  edges:
    test: pwsh/Catzc.Base.Contracts/tests/New-CatsCommandLookup.Tests.ps1
    docs: "[New-CatsCommandLookup.ps1.md](../../docs/references/pwsh/catzc-base-contracts/New-CatsCommandLookup.ps1.md)"
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

    # Every name is keyed by its normal form and carries its two renderings: kebab, as cats takes it, and PowerShell's, as pwsh binds it.
    $languages = Get-Config -Config languages
    $normalForm = $languages.naming_normal_form
    $commandLanguage = $languages.languages | Where-Object name -ceq 'powershell' | Select-Object -First 1
    $functionCase = $commandLanguage.naming.function[0]
    $render = { param([string] $name, [string] $case) [Catzc.Base.Objects.NameCase]::FromNormal($name, $case, $normalForm) }

    $lines = [System.Collections.Generic.List[string]]::new()
    $lines.Add('# shellcheck shell=bash')
    $lines.Add('# The command lookup `cats` reads before it starts pwsh (ADR-REPO-CMDCONTRACT-ONEREADER): one line per contracted parameter of')
    $lines.Add('# contracts/catzc/0.0.0, tab-separated: command, parameter, type, list (1 or 0), mandatory (1 or 0), pipeline (1 or 0), asset,')
    $lines.Add('# the parameter''s sets (comma-separated, empty for every set), the command''s default set (empty for none), then the command and')
    $lines.Add('# the parameter in kebab case, as cats takes them, and in PowerShell''s case, as pwsh binds them. Names are in the normal form; a')
    $lines.Add('# command with no parameter has one line with an empty parameter.')
    $lines.Add("_catzc_commands='")
    $contracts = @(Get-CommandContract -RepositoryRoot $RepositoryRoot | Sort-Object -Property Name -Culture ([System.Globalization.CultureInfo]::InvariantCulture))
    foreach ($contract in $contracts) {
        $asset = $contract.Asset.AssetPath
        $defaultSet = [string] $contract.default_set
        $command = @((& $render $contract.Name 'kebab'), (& $render $contract.Name $functionCase))
        $parameters = @($contract.parameters)
        if ($parameters.Count -eq 0) {
            $lines.Add(($contract.Name, '', '', '0', '0', '0', $asset, '', $defaultSet, $command[0], '', $command[1], '') -join "`t")
            continue
        }
        foreach ($parameter in $parameters) {
            $sets = $parameter.Sets -join ','
            $lines.Add(($contract.Name, $parameter.Name, $parameter.Type, [int] $parameter.IsList, [int] $parameter.Mandatory, [int] $parameter.Pipeline, $asset, $sets, $defaultSet,
                    $command[0], (& $render $parameter.Name 'kebab'), $command[1], (& $render $parameter.Name 'pascal')) -join "`t")
        }
    }
    $lines.Add("'")
    ($lines -join "`n") + "`n"
}
