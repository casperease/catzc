# cspell:ignore alweufxosbppst btweufxosbppst
Describe 'sample-bicepparam (a bicepparam slot beside a yml slot)' -Tag 'L0', 'logic' {
    BeforeAll {
        Mock Get-BicepTemplatesOutputRoot { Join-Path $TestDrive 'out' } -ModuleName Catzc.Azure.Templates
        $script:outputRoot = Join-Path $TestDrive 'out/template/sample-bicepparam'

        . (Join-Path $PSScriptRoot 'BicepParams.Fixture.ps1')
        Mock Invoke-ExecutableParallel {
            foreach ($line in $Command) {
                if (-not (& $script:compileBicepParams $line) -and $line -match ' build "' -and $line -match '--outdir "([^"]+)"') {
                    [System.IO.File]::WriteAllText((Join-Path $Matches[1] 'main.json'), '{}')
                }
                [Catzc.Base.Execution.CliResult]::new('', '', 0)
            }
        } -ModuleName Catzc.Azure.Templates
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
        InModuleScope Catzc.Azure.Templates { $script:bicepTemplatesCache = $null }
        Get-BicepTemplate sample-bicepparam | Out-Null
    }

    BeforeEach {
        if ([System.IO.Directory]::Exists($script:outputRoot)) {
            [System.IO.Directory]::Delete($script:outputRoot, $true)
        }
    }

    It 'compiles both slots to their parameters JSON, the bicepparam slot as written and the yml slot rendered' {
        Build-Bicep sample-bicepparam | Out-Null
        $alpha = Get-Content (Join-Path $script:outputRoot 'parameters.alpha.json') -Raw | ConvertFrom-Json
        $beta = Get-Content (Join-Path $script:outputRoot 'parameters.beta.json') -Raw | ConvertFrom-Json
        $alpha.parameters.storageAccountName.value | Should -BeExactly 'alweufxosbppst'
        $beta.parameters.storageAccountName.value | Should -BeExactly 'btweufxosbppst'
    }

    It 'writes each slot as a .bicepparam whose using names the copy of main.bicep inside the output folder' {
        Build-Bicep sample-bicepparam | Out-Null
        $source = Join-Path (Get-CatzcModuleRoot -Module Catzc.Azure.Templates) 'tests/assets/templates/sample-bicepparam/main.bicep'
        foreach ($config in 'alpha', 'beta') {
            $text = [System.IO.File]::ReadAllText((Join-Path $script:outputRoot "parameters.$config.bicepparam"))
            $using = [regex]::Match($text, "(?m)^using '(?<path>[^']+)'").Groups['path'].Value
            $target = [System.IO.Path]::GetFullPath((Join-Path $script:outputRoot $using))
            $target | Should -BeLike ([System.IO.Path]::GetFullPath($script:outputRoot) + [System.IO.Path]::DirectorySeparatorChar + '*')
            [System.IO.File]::ReadAllText($target) | Should -BeExactly ([System.IO.File]::ReadAllText($source))
        }
    }

    It 'compiles every slot through bicep build-params, once per slot' {
        Build-Bicep sample-bicepparam | Out-Null
        Should -Invoke Invoke-ExecutableParallel -ModuleName Catzc.Azure.Templates -Times 1 -Exactly -ParameterFilter {
            @($Command | Where-Object { $_ -like '* build-params *' }).Count -eq 2
        }
    }
}
