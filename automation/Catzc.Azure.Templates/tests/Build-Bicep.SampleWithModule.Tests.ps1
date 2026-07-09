# cspell:ignore alweutstsmodst
Describe 'sample-with-module (reusable module consumer)' -Tag 'L0', 'logic' {
    # Boundary mocks + config-cache reset run ONCE (the mocked config is identical every test); only the
    # build output folder is wiped per test, since the build tests write into it (ADR-AUTO-TEST:19/ADR-AUTO-TEST:4).
    BeforeAll {
        # Isolate build output to this file's throwaway $TestDrive via the output-root seam (ADR-AUTO-PESTER:2), so
        # it never shares out/template/<name> with Build-Bicep.L2 or the other sample files — the sharing the
        # 'serial' tag used to work around (ADR-AUTO-TEST:26). Mocking the seam removes the sharing (so this runs in
        # parallel), and Pester auto-cleans $TestDrive, so no manual output teardown is needed.
        Mock Get-BicepTemplatesOutputRoot { Join-Path $TestDrive 'out' } -ModuleName Catzc.Azure.Templates
        $script:outputRoot = Join-Path $TestDrive 'out/template/sample-with-module'

        Mock Invoke-AzCli {
            if ($Arguments -match 'bicep version') {
                return [pscustomobject]@{ Output = 'Bicep CLI version 999.999.999'; ExitCode = 0 }
            }
            if ($Arguments -match 'bicep build' -and $Arguments -match '--outdir "([^"]+)"') {
                [System.IO.File]::WriteAllText((Join-Path $Matches[1] 'main.json'), '{}')
            }
        } -ModuleName Catzc.Azure.Templates
        Mock Assert-Tool { } -ModuleName Catzc.Azure.Templates
        # The Bicep CLI gate now lives in Catzc.Azure.Cli; mock the boundary so its internal az probe never runs.
        Mock Assert-AzCliBicep { } -ModuleName Catzc.Azure.Templates
        Mock Get-BicepTemplatesRoot {
            Join-Path (Get-RepositoryRoot) 'automation/Catzc.Azure.Templates/tests/assets/templates'
        } -ModuleName Catzc.Azure.Templates
        Mock Resolve-ConfigEntry -ModuleName Catzc.Base.Config -ParameterFilter { $Config -in 'azure', 'network', 'customer' } -MockWith {
            @{ Name = $Config; Module = 'Catzc.Azure.Templates'
                Path = Join-Path (Get-RepositoryRoot) "automation/Catzc.Azure.Templates/tests/assets/config/$Config.yml"
            }
        }
        InModuleScope Catzc.Base.Config { $script:configCache = $null }

        # Warm the discovery + config caches once so the first It doesn't pay the cold Get-BicepTemplate derive
        # inside its own timing now that this file runs in the (timed) parallel phase (ADR-AUTO-TEST:19).
        Get-BicepTemplate sample-with-module | Out-Null
    }

    BeforeEach {
        if ([System.IO.Directory]::Exists($script:outputRoot)) {
            [System.IO.Directory]::Delete($script:outputRoot, $true)
        }
    }

    It 'is discovered as a template under infrastructure/templates' {
        Get-BicepTemplateNames | Should -Contain 'sample-with-module'
    }

    It 'does not discover infrastructure/modules (or its files) as templates' {
        $names = Get-BicepTemplateNames
        $names | Should -Not -Contain 'modules'
        $names | Should -Not -Contain 'storage-account'
    }

    It 'uses a statically-configured name that matches Get-BicepResourceName' {
        $expected = Get-BicepResourceName -Template sample-with-module -Environment alpha -Type st
        $expected | Should -Be 'alweutstsmodst'
    }

    It 'renders the configured storageAccountName into parameters.alpha.json' {
        Build-Bicep sample-with-module -Environments alpha | Out-Null
        $json = Get-Content (Join-Path $script:outputRoot 'parameters.alpha.json') -Raw | ConvertFrom-Json
        $json.parameters.storageAccountName.value | Should -Be 'alweutstsmodst'
    }
}
