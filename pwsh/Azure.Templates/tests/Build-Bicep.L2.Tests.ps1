Describe 'Build-Bicep (walking skeleton — real bicep)' -Tag 'L2', 'logic', 'greedy' {
    BeforeAll {
        # Redirects build output to this file's TestDrive, so the real builds never share out/template/<name> with the L0 sample files.
        Mock Get-BicepTemplatesOutputRoot { Join-Path $TestDrive 'out' } -ModuleName Catzc.Azure.Templates
        Mock Get-BicepTemplatesRoot {
            Join-Path (Get-CatzcModuleRoot -Module Catzc.Azure.Templates) 'tests/assets/templates'
        } -ModuleName Catzc.Azure.Templates
        Mock Resolve-ConfigEntry -ModuleName Catzc.Base.Config -ParameterFilter { $Config -in 'azure', 'network', 'customer' } -MockWith {
            @{ Name = $Config; Module = 'Catzc.Azure.Templates'
                Path = Join-Path (Get-CatzcModuleRoot -Module Catzc.Azure.Templates) "tests/assets/config/$Config.yml"
            }
        }
        InModuleScope Catzc.Base.Config { $script:configCache = $null }

        # The bicep binary is resolved once for the file, not inside every build.
        $bicep = Resolve-ToolExecutable -Tool bicep
        $script:bicepReady = $bicep.Found -and $bicep.VersionOk
        if ($script:bicepReady) {
            Mock Resolve-ToolExecutable { $bicep }.GetNewClosure() -ModuleName Catzc.Azure.Templates
        }
    }

    AfterEach {
        if ($script:outputRoot -and (Test-Path $script:outputRoot)) {
            Remove-Item $script:outputRoot -Recurse -Force
        }
    }

    It 'real bicep build compiles a multi-slot template to main.json (sample-customer)' {
        $script:outputRoot = Join-Path $TestDrive 'out/template/sample-customer'
        if (-not $script:bicepReady) {
            Set-ItResult -Skipped -Because 'tool_bicep_missing'
            return
        }
        if (Test-Path $script:outputRoot) {
            Remove-Item $script:outputRoot -Recurse -Force
        }
        Build-Bicep sample-customer | Out-Null
        # main.json proves the real compiler ran and --outdir was wired; the rendered parameter files are pure PowerShell, asserted at L0.
        Join-Path $script:outputRoot 'main.json' | Should -Exist
    }

    It 'a subscription-scoped template compiles end-to-end (targetScope = subscription) (sample-subscription)' {
        $script:outputRoot = Join-Path $TestDrive 'out/template/sample-subscription'
        if (-not $script:bicepReady) {
            Set-ItResult -Skipped -Because 'tool_bicep_missing'
            return
        }
        if (Test-Path $script:outputRoot) {
            Remove-Item $script:outputRoot -Recurse -Force
        }
        Build-Bicep sample-subscription -Environments alpha | Out-Null
        # The subscription-scope compile is the concern; main.json proves it compiled. Parameter rendering is L0.
        Join-Path $script:outputRoot 'main.json' | Should -Exist
    }

    It 'real bicep inlines a local reusable module into main.json (sample-with-module)' {
        $script:outputRoot = Join-Path $TestDrive 'out/template/sample-with-module'
        if (-not $script:bicepReady) {
            Set-ItResult -Skipped -Because 'tool_bicep_missing'
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
