<#
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/tests/Get-FixtureIdentityTokens.Tests.ps1
    kind: pester-test
    relatives:
      page: docs/references/automation/catzc-base-qualitygates/tests/Get-FixtureIdentityTokens.Tests.ps1.md
      source: automation/Catzc.Base.QualityGates/private/Get-FixtureIdentityTokens.ps1
    adrs:
      - ADR-AUTO-TEST#3
---
#>

Describe 'Get-FixtureIdentityTokens' -Tag 'L1', 'logic' {
    BeforeAll {
        $script:config = Join-Path $TestDrive 'repo/automation/Catzc.Widget/tests/assets/config'
        [void][System.IO.Directory]::CreateDirectory($script:config)
        [void][System.IO.Directory]::CreateDirectory((Join-Path $TestDrive 'repo/automation/Catzc.Widget/configs'))
        $script:azure = @'
org: wdg
bicep_min_version: "0.30.0"
tenants:
  gizmo_tenant:
    id: TENANT_GUID
environments:
  sprocket:
    shortcode: sp
    region: westeurope
    region_code: weu
  pooled:
    shortcode: po
    region: westeurope
    region_code: weu
    per_subscription: true
subscriptions:
  gizmo_lower:
    id: SUBSCRIPTION_GUID
    tenant: gizmo_tenant
    environments:
      - sprocket
      - pooled
'@
        # The guids are built at runtime, so the repository guid scan never reads them as unregistered guids.
        $prefix = 'a100a000-7e57-7e0a-0700-00000000000'
        $script:azure = $script:azure.Replace('TENANT_GUID', $prefix + '1').Replace('SUBSCRIPTION_GUID', $prefix + '2')
        $script:customer = @'
customers:
  gizmo:
    shortcode: gz
    details: Gizmo Fixture Co
'@
        # A shipped config of the same name is not a fixture: only tests/assets/config/ is read.
        [System.IO.File]::WriteAllText((Join-Path $TestDrive 'repo/automation/Catzc.Widget/configs/customer.yml'), "customers: {}`n")
    }

    BeforeEach {
        [System.IO.File]::WriteAllText((Join-Path $script:config 'azure.yml'), $script:azure)
        [System.IO.File]::WriteAllText((Join-Path $script:config 'customer.yml'), $script:customer)
        Mock Assert-SourceTree -ModuleName Catzc.Base.QualityGates { }
        Mock Get-RepositoryRoot -ModuleName Catzc.Base.QualityGates { Join-Path $TestDrive 'repo' }
    }

    It 'derives the org, tenants, subscriptions, environments, and customers from the fixture configs' {
        $tokens = InModuleScope Catzc.Base.QualityGates { Get-FixtureIdentityTokens }
        foreach ($token in 'wdg', 'gizmo_tenant', 'gizmo_lower', 'sprocket', 'sp', 'gizmo', 'gz') {
            $tokens | Should -Contain $token
        }
    }

    It 'includes the neutral in-memory fixtures (globset / tool)' {
        $tokens = InModuleScope Catzc.Base.QualityGates { Get-FixtureIdentityTokens }
        $tokens | Should -Contain 'widget'
        $tokens | Should -Contain 'gadget'
        $tokens | Should -Contain 'faketool'
    }

    It 'excludes a per_subscription identity environment' {
        $tokens = InModuleScope Catzc.Base.QualityGates { Get-FixtureIdentityTokens }
        $tokens | Should -Not -Contain 'pooled'
        $tokens | Should -Not -Contain 'po'
    }

    It 'fails on a malformed fixture config, as its registered type does for a shipped one' {
        [System.IO.File]::WriteAllText((Join-Path $script:config 'customer.yml'), ("customers: {}`n" + "sprocket: 1`n"))
        { InModuleScope Catzc.Base.QualityGates { Get-FixtureIdentityTokens } } | Should -Throw "*unknown top-level key 'sprocket'*"
    }
}
