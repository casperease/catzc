<#
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/private/Get-FixtureIdentityTokens.ps1
    kind: function
    module: Catzc.Base.QualityGates
    visibility: private
---
#>

<#
.SYNOPSIS
    Derives the set of TEST-fixture identity tokens — the deliberately-distinct customers, subscriptions, org,
    tenants, and environments the hermetic tests use — that must NEVER appear in a shipped config value
    ([ADR-REPO-LANG](/docs/adr/repository/domain-language-separation.md), the reverse of Get-LiveIdentityTokens).
.DESCRIPTION
    Read from the fixture configs, so a fixture customer added to a test config is banned from shipped config at once.
    [comment:1](/docs/references/automation/catzc-base-qualitygates/private/Get-FixtureIdentityTokens.ps1.md#comment1)
.OUTPUTS
    [string[]] the distinct fixture identity tokens.
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

    # Fixtures live only in the source tree, as tests never ship in a build, hence the guard.
    # [comment:2](/docs/references/automation/catzc-base-qualitygates/private/Get-FixtureIdentityTokens.ps1.md#comment2)
    Assert-SourceTree
    $registry = (Get-Config -Config configs).configs
    $automationRoot = Join-Path (Get-RepositoryRoot) 'automation'
    $fixtureConfigs = [System.IO.Directory]::EnumerateFiles($automationRoot, '*.yml', [System.IO.SearchOption]::AllDirectories) |
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

    # Logic tests build these globset and tool fixtures inline, so no fixture config file would name them.
    # [comment:3](/docs/references/automation/catzc-base-qualitygates/private/Get-FixtureIdentityTokens.ps1.md#comment3)
    foreach ($token in 'widget', 'gadget', 'faketool') {
        & $add $token
    }

    [string[]] @($ret)
}
