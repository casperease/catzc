<#
.SYNOPSIS
    Derives the set of TEST-fixture identity tokens — the deliberately-distinct customers, subscriptions, org,
    tenants, and environments the hermetic tests use — that must NEVER appear in a shipped config value
    (ADR-REPO-LANG, the reverse of Get-LiveIdentityTokens).
.DESCRIPTION
    Symmetric to Get-LiveIdentityTokens: the authoritative source is the config itself, here the FIXTURE
    configs under every `tests/assets/config/` (the `azure.yml` / `customer.yml` / `network.yml` a logic test
    redirects to). Reading them means the fixture set is always current — a fixture customer added to a test
    config is immediately banned from shipped config. A small set of neutral in-memory fixtures that never live
    in a config file (widget/gadget/faketool) is added explicitly.

    Backs Test-ConfigIdentityHygiene: a shipped `configs/*.yml` or `infrastructure/**` file whose parsed VALUES
    (or keys) contain one of these tokens has a test fixture where a live identity belongs. Parsing values is
    comment-blind, so a config comment illustrating `[acme, globex]` is fine — only real data is checked.
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

    # Every fixture config tree (tests/assets/config/) — the identity-bearing azure.yml and customer.yml a
    # logic test redirects Get-Config to. Enumerate all of them and union their identities.
    $automationRoot = Join-Path (Get-RepositoryRoot) 'automation'
    $fixtureConfigs = [System.IO.Directory]::EnumerateFiles($automationRoot, '*.yml', [System.IO.SearchOption]::AllDirectories) |
        Where-Object { $_ -match '[\\/]tests[\\/]assets[\\/]config[\\/](azure|customer)\.yml$' }

    foreach ($file in $fixtureConfigs) {
        $config = [System.IO.File]::ReadAllText($file) | ConvertFrom-Yaml -Ordered

        if ($config.Contains('org')) {
            & $add $config.org
        }
        foreach ($section in 'customers', 'subscriptions', 'tenants') {
            if ($config.Contains($section)) {
                foreach ($key in $config[$section].Keys) {
                    & $add $key
                    if ($config[$section][$key] -is [System.Collections.IDictionary] -and $config[$section][$key].Contains('shortcode')) {
                        & $add $config[$section][$key].shortcode
                    }
                }
            }
        }
        if ($config.Contains('environments')) {
            foreach ($key in $config.environments.Keys) {
                if ($config.environments[$key].per_subscription) {
                    continue
                }
                & $add $key
                & $add $config.environments[$key].shortcode
            }
        }
    }

    # Neutral in-memory fixtures that never live in a config file — the globset and tool fixtures logic tests
    # construct inline.
    foreach ($token in 'widget', 'gadget', 'faketool') {
        & $add $token
    }

    [string[]] @($ret)
}
