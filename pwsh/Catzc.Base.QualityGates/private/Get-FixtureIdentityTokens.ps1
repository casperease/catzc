<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Base.QualityGates/private/Get-FixtureIdentityTokens.ps1
    folder: private
    name: get-fixture-identity-tokens
    filetype: ps1
    role: function
    language: powershell
    track: pwsh
    tracktype: modules
    module: Catzc.Base.QualityGates
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: private
  edges:
    test: pwsh/Catzc.Base.QualityGates/tests/Get-FixtureIdentityTokens.Tests.ps1
    docs: "[Get-FixtureIdentityTokens.ps1.md](docs/references/pwsh/catzc-base-qualitygates/private/Get-FixtureIdentityTokens.ps1.md)"
    cites:
      - ADR-REPO-LANG
---
#>

function Get-FixtureIdentityTokens {
    [CmdletBinding()]
    [OutputType([string[]])]
    param()

    $ret = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::OrdinalIgnoreCase)
    $add = {
        param($token)
        $value = "$token"
        if (-not [string]::IsNullOrWhiteSpace($value)) {
            [void] $ret.Add($value)
        }
    }

    Assert-SourceTree
    $registry = (Get-Config -Config configs).configs
    $modulesRoot = Get-CatzcModulesRoot
    # A fixture config sits five levels below pwsh/: module, tests, assets, config, file.
    $fixtureConfigs = Get-ChildPath $modulesRoot -File -Filter 'azure.yml', 'customer.yml' -Depth 5 -PruneVendor $true |
        Where-Object { $_ -match '[\\/]tests[\\/]assets[\\/]config[\\/](azure|customer)\.yml$' }

    foreach ($file in $fixtureConfigs) {
        $name = [System.IO.Path]::GetFileNameWithoutExtension($file)
        $type = [type] $registry[$name]
        $config = $type::new(([System.IO.File]::ReadAllText($file) | ConvertFrom-Yaml -Ordered))

        if ($name -eq 'customer') {
            foreach ($key in $config.customers.Keys) {
                & $add $key
                & $add $config.customers[$key].shortcode
            }
            continue
        }

        & $add $config.org
        foreach ($key in $config.tenants.Keys) {
            & $add $key
        }
        foreach ($key in $config.subscriptions.Keys) {
            & $add $key
        }
        # The per-subscription identity envs (nsub/psub) are shared structural vocabulary, not a fixture identity.
        foreach ($key in $config.environments.Keys) {
            $environment = $config.environments[$key]
            if (-not $environment.per_subscription) {
                & $add $key
                & $add $environment.shortcode
            }
        }
    }

    foreach ($token in 'widget', 'gadget', 'faketool') {
        & $add $token
    }

    [string[]] @($ret)
}
