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

# Rests on [ADR-PWSH-PESTER#2](/docs/adr/pwsh/pester-testing.md#rule-adr-pwsh-pester2).
Describe 'Install-VSCodeExtension' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:root = Join-Path $TestDrive 'extensions'
        $script:installs = Join-Path $TestDrive 'installed'
        $script:config = [Catzc.Base.VSCode.VscodeExtensionsConfig]::new([ordered]@{
                recommendations = @('acme.tool')
                extensions      = [ordered]@{
                    'widget-ext' = [ordered]@{ displayName = 'Widget'; description = 'A widget.'; version = '1.0.0'; publisher = 'acme'; activationEvents = @('onStartupFinished') }
                    'gadget-ext' = [ordered]@{ displayName = 'Gadget'; description = 'A gadget.'; version = '1.0.0'; publisher = 'acme'; activationEvents = @('onStartupFinished') }
                }
            })
        $script:install = @{ Root = $script:root; ExtensionsDirectory = $script:installs }
        Mock Get-Config -ModuleName Catzc.Base.VSCode { $script:config } -ParameterFilter { $Config -eq 'vscode-extensions' }
        Mock New-VSCodeExtensionFolder -ModuleName Catzc.Base.VSCode {
            $folder = Join-Path $OutputDirectory $Extension.name
            $null = New-Item -ItemType Directory -Path $folder -Force
            Set-Content -LiteralPath (Join-Path $folder 'package.json') -Value "{ `"name`": `"$($Extension.name)`", `"version`": `"1.0.0`", `"publisher`": `"acme`" }"
            Set-Content -LiteralPath (Join-Path $folder 'extension.js') -Value 'module.exports = {};'
            $folder
        }
        Mock Test-Command -ModuleName Catzc.Base.VSCode { $true }
        Mock Build-VSCodeExtension -ModuleName Catzc.Base.VSCode { "$Path.vsix" }
        Mock Invoke-Executable -ModuleName Catzc.Base.VSCode { }
    }

    BeforeEach {
        Remove-Item -LiteralPath $script:installs -Recurse -Force -ErrorAction Ignore
    }

    It 'renders and installs every registry entry' {
        $installed = @(Install-VSCodeExtension @script:install)
        $installed.Count | Should -Be 2
        Should -Invoke Invoke-Executable -ModuleName Catzc.Base.VSCode -Times 2 -ParameterFilter { $Command -like 'code --install-extension "*" --force' }
    }

    It 'installs only the named extension' {
        $installed = @(Install-VSCodeExtension @script:install -Name widget-ext)
        $installed.Count | Should -Be 1
        $installed[0] | Should -BeLike '*widget-ext.vsix'
    }

    It 'skips an extension whose installed copy holds every rendered file, its manifest apart from the editor metadata' {
        $copy = Join-Path $script:installs 'acme.widget-ext-1.0.0'
        $null = New-Item -ItemType Directory -Path $copy -Force
        Set-Content -LiteralPath (Join-Path $copy 'extension.js') -Value 'module.exports = {};'
        Set-Content -LiteralPath (Join-Path $copy 'package.json') -Value '{ "name": "widget-ext", "version": "1.0.0", "publisher": "acme", "__metadata": { "size": 1 } }'
        $installed = @(Install-VSCodeExtension @script:install)
        $installed.Count | Should -Be 1
        $installed[0] | Should -BeLike '*gadget-ext.vsix'
        @(Install-VSCodeExtension @script:install -Force).Count | Should -Be 2
    }

    It 'reinstalls an extension whose installed copy differs from the rendered folder' {
        $copy = Join-Path $script:installs 'acme.widget-ext-1.0.0'
        $null = New-Item -ItemType Directory -Path $copy -Force
        Set-Content -LiteralPath (Join-Path $copy 'extension.js') -Value 'module.exports = { old: true };'
        Set-Content -LiteralPath (Join-Path $copy 'package.json') -Value '{ "name": "widget-ext", "version": "1.0.0", "publisher": "acme" }'
        @(Install-VSCodeExtension @script:install -Name widget-ext).Count | Should -Be 1
    }

    It 'refuses a name that is not a registry entry' {
        { Install-VSCodeExtension @script:install -Name plain } | Should -Throw "*'plain' is not an entry under extensions*"
    }

    It 'says so when the editor CLI is not on PATH' {
        Mock Test-Command -ModuleName Catzc.Base.VSCode { $false }
        { Install-VSCodeExtension @script:install } | Should -Throw "*'code' is not on PATH*"
    }
}
