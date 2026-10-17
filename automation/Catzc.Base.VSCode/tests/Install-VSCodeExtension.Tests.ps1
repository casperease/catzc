<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Base.VSCode/tests/Install-VSCodeExtension.Tests.ps1
    folder: tests
    name: install-vs-code-extension-tests
    filetype: ps1
    kind: test
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Base.VSCode
    moduletype: pwsh-folder
    catzc_bundle: azure
  edges:
    cites:
      - ADR-PWSH-PESTER#2
---
#>

Describe 'Install-VSCodeExtension' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:root = Join-Path $TestDrive 'repo'
        foreach ($name in 'widget-ext', 'gadget-ext') {
            $null = New-Item -ItemType Directory -Path (Join-Path $script:root ".vscode/$name") -Force
            Set-Content -LiteralPath (Join-Path $script:root ".vscode/$name/package.json") -Value '{}'
        }
        $null = New-Item -ItemType Directory -Path (Join-Path $script:root '.vscode/plain') -Force
        Mock Get-RepositoryRoot -ModuleName Catzc.Base.VSCode { $script:root }
        Mock Test-Command -ModuleName Catzc.Base.VSCode { $true }
        Mock Build-VSCodeExtension -ModuleName Catzc.Base.VSCode { "$Path.vsix" }
        Mock Invoke-Executable -ModuleName Catzc.Base.VSCode { }
    }

    It 'installs every folder of .vscode that holds a package.json, and no other' {
        $installed = @(Install-VSCodeExtension)
        $installed.Count | Should -Be 2
        Should -Invoke Invoke-Executable -ModuleName Catzc.Base.VSCode -Times 2 -ParameterFilter { $Command -like 'code --install-extension "*" --force' }
    }

    It 'installs only the named extension' {
        $installed = @(Install-VSCodeExtension -Name widget-ext)
        $installed.Count | Should -Be 1
        $installed[0] | Should -BeLike '*widget-ext.vsix'
    }

    It 'refuses a name that holds no package.json' {
        { Install-VSCodeExtension -Name plain } | Should -Throw "*holds no package.json*"
    }

    It 'says so when the editor CLI is not on PATH' {
        Mock Test-Command -ModuleName Catzc.Base.VSCode { $false }
        { Install-VSCodeExtension } | Should -Throw "*'code' is not on PATH*"
    }
}
