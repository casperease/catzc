<#
.SYNOPSIS
    Derives the set of LIVE production identity tokens — the customers, subscriptions, org, deployable units,
    template names, and ADO project the shipped config maps to — that a hermetic LOGIC test must never name.
.DESCRIPTION
    The authoritative source of "what is a live identity" is the shipped config itself, not a hand-kept list:
    reading it here means the forbidden set is always current (add a customer to customer.yml and it is
    automatically banned from logic tests). Every value is read through Get-Config (the one global reader,
    ADR-MODCFG), so a test isolates this function by mocking Get-Config / Resolve-ConfigEntry to fixtures.

    This is PHASE 1 — the DISTINCTIVE identities only (customers, subscriptions, org, deployable units,
    template names, ADO project). Environment names (dev/test/preprod/prod) are deliberately excluded: they
    are ambiguous ('test' is pervasive in test code) and belong to a later, position-aware phase. Each record
    carries its Source and a Suggest string so a finding can name the fixture the test should have used.

    Backs Test-LogicTestIdentity (ADR-LANG): a logic test whose AST contains a string literal equal to one of
    these tokens (or a delimited segment of one) is using a live identity where a fixture belongs (ADR-TEST:3).
.OUTPUTS
    [object[]] One record per token: @{ Token; Kind; Source; Suggest }.
#>
function Get-LiveIdentityTokens {
    [CmdletBinding()]
    [OutputType([object[]])]
    param()

    $ret = [System.Collections.Generic.List[object]]::new()
    $seen = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::OrdinalIgnoreCase)
    # MatchMode governs HOW the finder matches a token: 'exact' — a distinctive identity flagged wherever it
    # appears as a literal; 'position' — an ambiguous identity (an environment name like 'test'/'dev') flagged
    # ONLY when bound to an identity parameter (-Environment/-Env/-Shortcode), never as bare prose.
    $add = {
        param($token, $kind, $source, $suggest, $matchMode = 'exact')
        $value = "$token"
        if (-not [string]::IsNullOrWhiteSpace($value) -and $seen.Add($value)) {
            $ret.Add([pscustomobject]@{ Token = $value; Kind = $kind; Source = $source; Suggest = $suggest; MatchMode = $matchMode })
        }
    }

    # Customers (customer.yml) — keys and 2-char shortcodes. The clearest live identity in a logic test.
    $customer = Get-Config -Config customer
    if ($customer.Contains('customers')) {
        foreach ($key in $customer.customers.Keys) {
            & $add $key 'customer-key' 'customer.yml' 'a fixture customer (acme / globex)'
            & $add $customer.customers[$key].shortcode 'customer-shortcode' 'customer.yml' 'a fixture shortcode (ac / gx)'
        }
    }

    # Azure identity (azure.yml) — the org component and the subscription names (distinctive → exact match).
    $azure = Get-Config -Config azure
    & $add $azure.org 'org' 'azure.yml' 'the fixture org (tst)'
    if ($azure.Contains('subscriptions')) {
        foreach ($subName in $azure.subscriptions.Keys) {
            & $add $subName 'subscription' 'azure.yml' 'a fixture subscription (core_lower / acme_lower)'
        }
    }

    # Environment names and shortcodes (azure.yml) — ambiguous words ('test'/'dev'), so 'position' match only
    # (a value bound to -Environment/-Env/-Shortcode). The per-subscription identity envs (nsub/psub) are
    # shared structural vocabulary, not a discriminating identity, and are skipped.
    if ($azure.Contains('environments')) {
        foreach ($envName in $azure.environments.Keys) {
            if ($azure.environments[$envName].per_subscription) {
                continue
            }
            & $add $envName 'environment' 'azure.yml' 'a fixture environment (alpha / beta / gamma / delta)' 'position'
            & $add $azure.environments[$envName].shortcode 'environment-shortcode' 'azure.yml' 'a fixture env shortcode (al / bt)' 'position'
        }
    }

    # NOTE: deployable-unit and pipeline names (globs.yml) are deliberately NOT included in Phase 1. The
    # generic ones (`automation`, `infrastructure`, `templates`, `shared`) are structural folder names that
    # appear as legitimate string literals throughout the tests, so matching them is pure false-positive; the
    # customer-named units (apex/nova/flux) are already covered by the customer keys above. A later phase may
    # add the DISTINCTIVE units with an explicit folder-collision exclusion.

    # ADO project (ado.yml).
    $ado = Get-Config -Config ado
    & $add $ado.project 'ado-project' 'ado.yml' 'a fixture project name'

    # Shipped template names (infrastructure/templates/<name>).
    $templatesRoot = Join-Path (Get-RepositoryRoot) 'infrastructure/templates'
    if ([System.IO.Directory]::Exists($templatesRoot)) {
        foreach ($dir in [System.IO.Directory]::EnumerateDirectories($templatesRoot)) {
            & $add ([System.IO.Path]::GetFileName($dir)) 'template' 'infrastructure/templates' 'a fixture template (sample)'
        }
    }

    , $ret.ToArray()
}
