<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Base.VSCode/tests/New-VSCodeExtensionFolder.Tests.ps1
    folder: tests
    name: new-vs-code-extension-folder-tests
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
      - ADR-AUTO-ASSETDEP#3
      - ADR-PWSH-PESTER#2
---
#>

Describe 'New-VSCodeExtensionFolder' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:assets = Join-Path $TestDrive 'assets'
        $null = New-Item -ItemType Directory -Path $script:assets -Force
        Set-Content -LiteralPath (Join-Path $script:assets 'widget-ext.js') -Value 'module.exports = { widget: true };'
        $script:entry = [Catzc.Base.VSCode.VscodeOwnExtension]::new('widget-ext', [ordered]@{
                displayName      = 'Widget'
                description      = 'A widget.'
                activationEvents = @('onStartupFinished')
                contributes      = [ordered]@{ colors = @([ordered]@{ id = 'widget.background' }) }
            })
        InModuleScope Catzc.Base.VSCode -Parameters @{ Entry = $script:entry; Out = (Join-Path $TestDrive 'out'); Assets = $script:assets } {
            param($Entry, $Out, $Assets)
            $script:folder = New-VSCodeExtensionFolder -Extension $Entry -OutputDirectory $Out -AssetDirectory $Assets
        }
        $script:folder = InModuleScope Catzc.Base.VSCode { $script:folder }
        $script:manifest = Get-Content -LiteralPath (Join-Path $script:folder 'package.json') -Raw | ConvertFrom-Json
    }

    It 'writes the folder under the output directory, named for the extension' {
        $script:folder | Should -Be (Join-Path (Resolve-Path (Join-Path $TestDrive 'out')).Path 'widget-ext')
    }

    It 'renders package.json from the entry, with the defaults the type declares' {
        $script:manifest.name | Should -Be 'widget-ext'
        $script:manifest.displayName | Should -Be 'Widget'
        $script:manifest.version | Should -Be ([Catzc.Base.VSCode.VscodeOwnExtension]::DefaultVersion)
        $script:manifest.publisher | Should -Be ([Catzc.Base.VSCode.VscodeOwnExtension]::DefaultPublisher)
        $script:manifest.engines.vscode | Should -Be ([Catzc.Base.VSCode.VscodeOwnExtension]::DefaultEngine)
        $script:manifest.main | Should -Be './extension.js'
        @($script:manifest.activationEvents) | Should -Be @('onStartupFinished')
        $script:manifest.contributes.colors[0].id | Should -Be 'widget.background'
    }

    It 'copies the script from the asset folder to extension.js' {
        Get-Content -LiteralPath (Join-Path $script:folder 'extension.js') -Raw | Should -Be (Get-Content -LiteralPath (Join-Path $script:assets 'widget-ext.js') -Raw)
    }

    It 'replaces a folder rendered before, leaving no stale file' {
        Set-Content -LiteralPath (Join-Path $script:folder 'stale.js') -Value ''
        InModuleScope Catzc.Base.VSCode -Parameters @{ Entry = $script:entry; Out = (Join-Path $TestDrive 'out'); Assets = $script:assets } {
            param($Entry, $Out, $Assets)
            $null = New-VSCodeExtensionFolder -Extension $Entry -OutputDirectory $Out -AssetDirectory $Assets
        }
        Test-Path -LiteralPath (Join-Path $script:folder 'stale.js') | Should -BeFalse
    }

    It 'refuses an entry whose script is missing' {
        $missing = [Catzc.Base.VSCode.VscodeOwnExtension]::new('gadget-ext', [ordered]@{ displayName = 'Gadget'; description = 'A gadget.'; activationEvents = @('onStartupFinished') })
        {
            InModuleScope Catzc.Base.VSCode -Parameters @{ Entry = $missing; Out = (Join-Path $TestDrive 'out'); Assets = $script:assets } {
                param($Entry, $Out, $Assets)
                New-VSCodeExtensionFolder -Extension $Entry -OutputDirectory $Out -AssetDirectory $Assets
            }
        } | Should -Throw "*'gadget-ext' has no script*"
    }
}

Describe 'New-VSCodeExtensionFolder — real vscode-extensions.yml' -Tag 'L1', 'integrity', 'ADR-AUTO-ASSETDEP#3' {
    It 'renders every registry entry from its shipped script to a manifest the packer accepts' {
        $entries = @((Get-Config -Config vscode-extensions).extensions)
        $entries.Count | Should -BeGreaterThan 0
        foreach ($entry in $entries) {
            $folder = InModuleScope Catzc.Base.VSCode -Parameters @{ Entry = $entry; Out = (Join-Path $TestDrive 'shipped') } {
                param($Entry, $Out)
                New-VSCodeExtensionFolder -Extension $Entry -OutputDirectory $Out
            }
            $manifest = Get-Content -LiteralPath (Join-Path $folder 'package.json') -Raw | ConvertFrom-Json
            $manifest.name | Should -Be $entry.name
            (Get-Item -LiteralPath (Join-Path $folder 'extension.js')).Length | Should -BeGreaterThan 0
            Build-VSCodeExtension -Path $folder -OutputDirectory (Join-Path $TestDrive 'vsix') | Should -Exist
        }
    }
}
