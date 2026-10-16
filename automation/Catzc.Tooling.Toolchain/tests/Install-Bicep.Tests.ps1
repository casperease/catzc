<#
---
catzc:
  immutable:
    path: automation/Catzc.Tooling.Toolchain/tests/Install-Bicep.Tests.ps1
    folder: tests
    name: install-bicep-tests
    filetype: ps1
    kind: test
    language: powershell
    track: automation
    module: Catzc.Tooling.Toolchain
    moduletype: pwsh-folder
    catzc_bundle: azure
  edges:
    page: docs/references/automation/catzc-tooling-toolchain/tests/Install-Bicep.Tests.ps1.md
---
#>

Describe 'Install-Bicep' -Tag 'L0', 'logic' {
    BeforeEach {
        Mock Install-Tool -ModuleName Catzc.Tooling.Toolchain { }
        Mock Uninstall-Tool -ModuleName Catzc.Tooling.Toolchain { }
    }

    It 'delegates to Install-Tool with the tools.yml pin' -Skip:$IsLinux {
        Install-Bicep
        Should -Invoke Install-Tool -ModuleName Catzc.Tooling.Toolchain -Times 1 -Exactly -ParameterFilter {
            $Tool -eq 'bicep' -and $Version -eq (Get-ToolConfig -Tool 'bicep').version -and -not $Force
        }
    }

    It 'passes -Force and an explicit version through' -Skip:$IsLinux {
        Install-Bicep -Version '0.48.1' -Force
        Should -Invoke Install-Tool -ModuleName Catzc.Tooling.Toolchain -Times 1 -Exactly -ParameterFilter {
            $Tool -eq 'bicep' -and $Version -eq '0.48.1' -and $Force
        }
    }

    It 'installs the verified release binary on Linux, then puts ~/.local/bin on PATH' -Skip:(-not $IsLinux) {
        $script:probes = 0
        Mock Test-Tool -ModuleName Catzc.Tooling.Toolchain {
            $script:probes++
            if ($script:probes -eq 1) {
                [pscustomobject]@{ Version = $null; Path = $null }
            }
            else {
                [pscustomobject]@{ Version = '0.48.1'; Path = '/home/widget/.local/bin/bicep' }
            }
        }
        Mock Install-BicepStandalone -ModuleName Catzc.Tooling.Toolchain { }
        Mock Add-PermanentPath -ModuleName Catzc.Tooling.Toolchain { }
        Install-Bicep
        Should -Invoke Install-BicepStandalone -ModuleName Catzc.Tooling.Toolchain -Times 1 -Exactly -ParameterFilter { $Version -eq (Get-ToolConfig -Tool 'bicep').version }
        Should -Invoke Add-PermanentPath -ModuleName Catzc.Tooling.Toolchain -Times 1 -Exactly
        Should -Invoke Install-Tool -ModuleName Catzc.Tooling.Toolchain -Times 0
    }

    It 'uninstalls through Uninstall-Tool' -Skip:$IsLinux {
        Uninstall-Bicep
        Should -Invoke Uninstall-Tool -ModuleName Catzc.Tooling.Toolchain -Times 1 -Exactly -ParameterFilter { $Tool -eq 'bicep' }
    }

    It 'removes the ~/.local/bin binary on Linux' -Skip:(-not $IsLinux) {
        $savedHome = $env:HOME
        $env:HOME = Join-Path $TestDrive 'home'
        try {
            $binary = Join-Path $env:HOME '.local/bin/bicep'
            $null = New-Item -ItemType File -Path $binary -Force
            Mock Write-Message -ModuleName Catzc.Tooling.Toolchain { }
            Uninstall-Bicep
            $binary | Should -Not -Exist
            Should -Invoke Uninstall-Tool -ModuleName Catzc.Tooling.Toolchain -Times 0
        }
        finally {
            $env:HOME = $savedHome
        }
    }
}
