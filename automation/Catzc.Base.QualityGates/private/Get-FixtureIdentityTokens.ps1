<#
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/private/Get-FixtureIdentityTokens.ps1
    kind: automation-function
    language: powershell
    track: automation
    module: Catzc.Base.QualityGates
    visibility: private
    relatives:
      page: docs/references/automation/catzc-base-qualitygates/private/Get-FixtureIdentityTokens.ps1.md
      test: automation/Catzc.Base.QualityGates/tests/Get-FixtureIdentityTokens.Tests.ps1
    adrs:
      - ADR-REPO-LANG
  config:
    synopsis: |-
      Derives the set of TEST-fixture identity tokens — the deliberately-distinct customers, subscriptions, org,
      tenants, and environments the hermetic tests use — that must NEVER appear in a shipped config value
      — the reverse of Get-LiveIdentityTokens.
    description: |-
      Symmetric to Get-LiveIdentityTokens: the authoritative source is the config itself, here the FIXTURE
      configs under every `tests/assets/config/` (the `azure.yml` / `customer.yml` a logic test redirects to).
      Reading them means the fixture set is always current — a fixture customer added to a test config is
      immediately banned from shipped config. Each fixture file is constructed as the C# config type the config
      registry (configs.yml) registers for its name, exactly as Get-Config constructs a shipped config, so a
      malformed fixture fails the same way a malformed shipped config does. A small set of neutral in-memory
      fixtures that never live in a config file (widget/gadget/faketool) is added explicitly.

      Backs Test-ConfigIdentityHygiene: a shipped `configs/*.yml` or `infrastructure/**` file whose parsed VALUES
      (or keys) contain one of these tokens has a test fixture where a live identity belongs, and a fixture token
      that is also a live identity (Get-LiveIdentityTokens) is no fixture at all.
    outputs: '[string[]] the distinct fixture identity tokens.'
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
    $automationRoot = Join-Path (Get-RepositoryRoot) 'automation'
    # A fixture config sits five levels below automation: module, tests, assets, config, file.
    $fixtureConfigs = Get-ChildPath $automationRoot -File -Filter 'azure.yml', 'customer.yml' -Depth 5 -PruneVendor $true |
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
