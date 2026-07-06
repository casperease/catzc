# Walking-skeleton L2 coverage for Build-Bicep: the few real `az bicep build` threads that exercise something
# the mocked-az L0 logic tests cannot. The per-template RULE checks — parameter-file names, customer prefixes,
# indexed slots, merged vnet ranges, injected Key Vault references, resource-group/deployment names — are
# pushed left to the fast L0 logic blocks in Build-Bicep.Sample*.Tests.ps1 (which mock Invoke-AzCli so no real
# build runs). This file keeps only the end-to-end COMPILE wiring (Build-Bicep -> Invoke-AzCli -> real az),
# proven once on the broadest single thread, plus the two real-compiler capabilities the mock fakes away:
# a subscription-scoped template compiling, and a local reusable module being inlined into main.json.
# Each build asserts main.json (the compiled artifact — the integration concern) and, where the real
# compiler does something the mock cannot, that specific output. It does NOT re-assert the rendered
# parameter FILES: those are pure PowerShell covered at L0 (Sample*.Tests.ps1), `az` is invoked once
# regardless of how many slots render, and binding L2 to files on the shared out/template/ path is the
# reused-sandbox race the test-automation Gotchas warn about (main.json is the last, stable write).
#
# Three builds, not one per sample: each adds a DISTINCT real-compiler concern. sample-indexed and
# sample-with-prepost are deliberately absent — their behaviour (indexed slots, the PrePost merge seam) is pure
# PowerShell fully covered at L0, and their compile is a flat resource-group build identical to the skeleton.
# Each It self-skips when `az` is absent (ADR-TEST:8); the skip key is the constrained `tool_az_missing` grammar.
#
# Isolation is the standard seam swap (ADR-TEST:2): redirect the template tree to tests/assets/templates and the
# azure/network configs to the fixtures, so these bind to the sample-* assets, never to shipped templates.
# serial: builds sample-customer / sample-subscription / sample-with-module into the shared out/template/<name>
# folders that Build-Bicep.Sample*.Tests.ps1 also write — a parallel worker building the same template races
# the output folder (see the test-automation ADR's serial tag).
Describe 'Build-Bicep (walking skeleton — real az)' -Tag 'L2', 'logic', 'serial' {
    BeforeAll {
        Mock Get-BicepTemplatesRoot {
            Join-Path (Get-RepositoryRoot) 'automation/Catzc.Azure.Templates/tests/assets/templates'
        } -ModuleName Catzc.Azure.Templates
        Mock Resolve-ConfigEntry -ModuleName Catzc.Base.Config -ParameterFilter { $Config -in 'azure', 'network' } -MockWith {
            @{ Name = $Config; Module = 'Catzc.Azure.Templates'
                Path = Join-Path (Get-RepositoryRoot) "automation/Catzc.Azure.Templates/tests/assets/config/$Config.yml"
            }
        }
        InModuleScope Catzc.Base.Config { $script:configCache = $null }
    }

    AfterEach {
        if ($script:outputRoot -and (Test-Path $script:outputRoot)) {
            Remove-Item $script:outputRoot -Recurse -Force
        }
    }

    It 'real az bicep build compiles a multi-slot template to main.json (sample-customer)' {
        $script:outputRoot = Join-Path (Get-RepositoryRoot) 'out/template/sample-customer'
        if (-not (Get-Command az -ErrorAction Ignore)) {
            Set-ItResult -Skipped -Because 'tool_az_missing'
            return
        }
        if (Test-Path $script:outputRoot) {
            Remove-Item $script:outputRoot -Recurse -Force
        }
        Build-Bicep sample-customer | Out-Null
        # main.json is the integration concern: the real compiler ran and Build-Bicep wired --outdir. The
        # per-(customer,slot) parameter files it also renders are pure PowerShell, asserted at L0
        # (Build-Bicep.SampleCustomer.Tests.ps1) — re-checking them here adds no real-compile coverage.
        Join-Path $script:outputRoot 'main.json' | Should -Exist
    }

    It 'a subscription-scoped template compiles end-to-end (targetScope = subscription) (sample-subscription)' {
        $script:outputRoot = Join-Path (Get-RepositoryRoot) 'out/template/sample-subscription'
        if (-not (Get-Command az -ErrorAction Ignore)) {
            Set-ItResult -Skipped -Because 'tool_az_missing'
            return
        }
        if (Test-Path $script:outputRoot) {
            Remove-Item $script:outputRoot -Recurse -Force
        }
        Build-Bicep sample-subscription -Environments alpha | Out-Null
        # The subscription-scope compile is the concern; main.json proves it compiled. Parameter rendering is L0.
        Join-Path $script:outputRoot 'main.json' | Should -Exist
    }

    It 'real az inlines a local reusable module into main.json (sample-with-module)' {
        $script:outputRoot = Join-Path (Get-RepositoryRoot) 'out/template/sample-with-module'
        if (-not (Get-Command az -ErrorAction Ignore)) {
            Set-ItResult -Skipped -Because 'tool_az_missing'
            return
        }
        if (Test-Path $script:outputRoot) {
            Remove-Item $script:outputRoot -Recurse -Force
        }
        Build-Bicep sample-with-module -Environments alpha | Out-Null
        $mainJson = Join-Path $script:outputRoot 'main.json'
        $mainJson | Should -Exist
        # Only the real compiler resolves + inlines the reusable module's storage resource into the template.
        (Get-Content $mainJson -Raw) | Should -Match 'Microsoft.Storage/storageAccounts'
    }
}
