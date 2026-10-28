# cspell:ignore alweutstsmodst
Describe 'sample-with-module (reusable module consumer)' -Tag 'L0', 'logic' {
    # Mocks and the config-cache reset run once; only the build output folder is wiped per test, since the tests write into it.
    BeforeAll {
        # Redirects build output to this file's TestDrive, so it never shares out/template/<name> with another build test file.
        Mock Get-BicepTemplatesOutputRoot { Join-Path $TestDrive 'out' } -ModuleName Catzc.Azure.Templates
        $script:outputRoot = Join-Path $TestDrive 'out/template/sample-with-module'

        . (Join-Path $PSScriptRoot 'BicepParams.Fixture.ps1')
        Mock Invoke-ExecutableParallel {
            foreach ($line in $Command) {
                if (-not (& $script:compileBicepParams $line) -and $line -match ' build "' -and $line -match '--outdir "([^"]+)"') {
                    [System.IO.File]::WriteAllText((Join-Path $Matches[1] 'main.json'), '{}')
                }
                [Catzc.Base.Execution.CliResult]::new('', '', 0)
            }
        } -ModuleName Catzc.Azure.Templates
        # The bicep binary is resolved through the toolchain; mock the boundary so no version probe runs.
        Mock Resolve-ToolExecutable { [pscustomobject]@{ Found = $true; VersionOk = $true; Path = 'bicep' } } -ModuleName Catzc.Azure.Templates
        Mock Get-BicepTemplatesRoot {
            Join-Path (Get-CatzcModuleRoot -Module Catzc.Azure.Templates) 'tests/assets/templates'
        } -ModuleName Catzc.Azure.Templates
        Mock Resolve-ConfigEntry -ModuleName Catzc.Base.Config -ParameterFilter { $Config -in 'azure', 'network', 'customer' } -MockWith {
            @{ Name = $Config; Module = 'Catzc.Azure.Templates'
                Path = Join-Path (Get-CatzcModuleRoot -Module Catzc.Azure.Templates) "tests/assets/config/$Config.yml"
            }
        }
        InModuleScope Catzc.Base.Config { $script:configCache = $null }

        # Warms the discovery and config caches once, so no It pays the cold derive inside its own timing.
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

    It 'builds a self-contained output folder: every path a built .bicep or .bicepparam names resolves inside it' {
        Build-Bicep sample-with-module | Out-Null
        $root = [System.IO.Path]::GetFullPath($script:outputRoot) + [System.IO.Path]::DirectorySeparatorChar
        $reference = [regex]::new(
            "(?m)^\s*(?:module\s+\S+\s+|using\s+|extends\s+)'(?<path>[^']+)'|\bfrom\s+'(?<path>[^']+)'|\bload\w+\(\s*'(?<path>[^']+)'")
        $files = @(Get-ChildPath -Path $script:outputRoot -Depth 8 -Filter '*.bicep', '*.bicepparam' -File)
        $files | ForEach-Object { [System.IO.Path]::GetExtension($_) } | Sort-Object -Unique |
            Should -BeExactly @('.bicep', '.bicepparam') -Because 'the build copies main.bicep and its module beside the rendered slots'
        $leaving = [System.Collections.Generic.List[string]]::new()
        $resolved = 0
        foreach ($file in $files) {
            foreach ($match in $reference.Matches([System.IO.File]::ReadAllText($file))) {
                $target = [System.IO.Path]::GetFullPath((Join-Path ([System.IO.Path]::GetDirectoryName($file)) $match.Groups['path'].Value))
                if (-not $target.StartsWith($root, [System.StringComparison]::OrdinalIgnoreCase) -or -not [System.IO.File]::Exists($target)) {
                    $leaving.Add("$file -> $($match.Groups['path'].Value)")
                }
                $resolved++
            }
        }
        $resolved | Should -BeGreaterThan 1 -Because 'each slot''s using and the module reference are checked'
        $leaving | Should -BeNullOrEmpty -Because "a built template holds no reference to the source tree:`n$($leaving -join "`n")"
    }

    It 'compiles the copied main.bicep, never the source one' {
        Build-Bicep sample-with-module | Out-Null
        $script:copied = [regex]::Escape([System.IO.Path]::GetFullPath($script:outputRoot))
        Should -Invoke Invoke-ExecutableParallel -ModuleName Catzc.Azure.Templates -ParameterFilter {
            @($Command | Where-Object { $_ -match " build `"$script:copied" }).Count -eq 1
        }
    }
}
