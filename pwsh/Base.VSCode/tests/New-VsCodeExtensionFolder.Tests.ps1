<#
---
catzc:
  docs: "../../../docs/references/pwsh/catzc-base-vs-code/tests/New-VsCodeExtensionFolder.Tests.ps1.md"
  header: "generated"
---
#>

Describe 'New-VsCodeExtensionFolder' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:assets = Join-Path $TestDrive 'assets'
        $null = New-Item -ItemType Directory -Path $script:assets -Force
        $null = New-Item -ItemType Directory -Path (Join-Path $script:assets 'widget-ext') -Force
        Set-Content -LiteralPath (Join-Path $script:assets 'widget-ext/extension.js') -Value 'module.exports = { widget: true };'
        $script:entry = [Catzc.Base.VSCode.VscodeOwnExtension]::new('widget-ext', [ordered]@{
                displayName      = 'Widget'
                description      = 'A widget.'
                activationEvents = @('onStartupFinished')
                contributes      = [ordered]@{ colors = @([ordered]@{ id = 'widget.background' }) }
            })
        InModuleScope Catzc.Base.VSCode -Parameters @{ Entry = $script:entry; Out = (Join-Path $TestDrive 'out'); Assets = $script:assets } {
            param($Entry, $Out, $Assets)
            $script:folder = New-VsCodeExtensionFolder -Extension $Entry -OutputDirectory $Out -AssetDirectory $Assets
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

    It 'writes the source folder the installed shell loads, repository-relative under the js track' {
        $script:manifest.catzc.source | Should -BeExactly "$(Get-TrackPlace -Track js -TrackKind extensions)/widget-ext"
    }

    It 'reads a namespaced extension from its short folder, and installs it under its full name' -Tag 'DDR-TRACK-MODULENAMESPACE' {
        $null = New-Item -ItemType Directory -Path (Join-Path $script:assets 'gadget') -Force
        Set-Content -LiteralPath (Join-Path $script:assets 'gadget/extension.js') -Value 'module.exports = { gadget: true };'
        $gadget = [Catzc.Base.VSCode.VscodeOwnExtension]::new('catzc-gadget',
            [ordered]@{ displayName = 'Gadget'; description = 'A gadget.'; activationEvents = @('onStartupFinished') })
        $installed = InModuleScope Catzc.Base.VSCode -Parameters @{ Entry = $gadget; Out = (Join-Path $TestDrive 'out'); Assets = $script:assets } {
            param($Entry, $Out, $Assets)
            New-VsCodeExtensionFolder -Extension $Entry -OutputDirectory $Out -AssetDirectory $Assets
        }
        Split-Path $installed -Leaf | Should -BeExactly 'catzc-gadget'
        $manifest = Get-Content -LiteralPath (Join-Path $installed 'package.json') -Raw | ConvertFrom-Json
        $manifest.name | Should -BeExactly 'catzc-gadget'
        $manifest.catzc.source | Should -BeExactly "$(Get-TrackPlace -Track js -TrackKind extensions)/gadget"
        Get-Content -LiteralPath (Join-Path $installed 'extension.js') -Raw | Should -Match 'gadget: true'
    }

    It 'copies the script from the asset folder to extension.js' {
        Get-Content -LiteralPath (Join-Path $script:folder 'extension.js') -Raw |
            Should -Be (Get-Content -LiteralPath (Join-Path $script:assets 'widget-ext/extension.js') -Raw)
    }

    It 'ships the extension''s own folder as media, and no media when it has none' {
        Test-Path -LiteralPath (Join-Path $script:folder 'media') | Should -BeFalse
        $null = New-Item -ItemType File -Force -Path (Join-Path $script:assets 'widget-ext/assets/gadget.svg')
        InModuleScope Catzc.Base.VSCode -Parameters @{ Entry = $script:entry; Out = (Join-Path $TestDrive 'out'); Assets = $script:assets } {
            param($Entry, $Out, $Assets)
            $null = New-VsCodeExtensionFolder -Extension $Entry -OutputDirectory $Out -AssetDirectory $Assets
        }
        Test-Path -LiteralPath (Join-Path $script:folder 'media/gadget.svg') | Should -BeTrue
        Remove-Item -LiteralPath (Join-Path $script:assets 'widget-ext/assets') -Recurse
    }

    It 'replaces a folder rendered before, leaving no stale file' {
        Set-Content -LiteralPath (Join-Path $script:folder 'stale.js') -Value ''
        InModuleScope Catzc.Base.VSCode -Parameters @{ Entry = $script:entry; Out = (Join-Path $TestDrive 'out'); Assets = $script:assets } {
            param($Entry, $Out, $Assets)
            $null = New-VsCodeExtensionFolder -Extension $Entry -OutputDirectory $Out -AssetDirectory $Assets
        }
        Test-Path -LiteralPath (Join-Path $script:folder 'stale.js') | Should -BeFalse
    }

    It 'refuses an entry whose script is missing' {
        $missing = [Catzc.Base.VSCode.VscodeOwnExtension]::new('gadget-ext',
            [ordered]@{ displayName = 'Gadget'; description = 'A gadget.'; activationEvents = @('onStartupFinished') })
        {
            InModuleScope Catzc.Base.VSCode -Parameters @{ Entry = $missing; Out = (Join-Path $TestDrive 'out'); Assets = $script:assets } {
                param($Entry, $Out, $Assets)
                New-VsCodeExtensionFolder -Extension $Entry -OutputDirectory $Out -AssetDirectory $Assets
            }
        } | Should -Throw "*'gadget-ext' has no script*"
    }
}

Describe 'New-VsCodeExtensionFolder — real vscode-extensions.yml' -Tag 'L1', 'integrity', 'ADR-AUTO-ASSETDEP-COVEREDBYREALTEST' {
    It 'renders every registry entry from its shipped script to a manifest the packer accepts' {
        $entries = @((Get-Config -Config vscode-extensions).extensions)
        $entries.Count | Should -BeGreaterThan 0
        foreach ($entry in $entries) {
            $folder = InModuleScope Catzc.Base.VSCode -Parameters @{ Entry = $entry; Out = (Join-Path $TestDrive 'shipped') } {
                param($Entry, $Out)
                New-VsCodeExtensionFolder -Extension $Entry -OutputDirectory $Out
            }
            $manifest = Get-Content -LiteralPath (Join-Path $folder 'package.json') -Raw | ConvertFrom-Json
            $manifest.name | Should -Be $entry.name
            (Get-Item -LiteralPath (Join-Path $folder 'extension.js')).Length | Should -BeGreaterThan 0
            Build-VsCodeExtension -Path $folder -OutputDirectory (Join-Path $TestDrive 'vsix') | Should -Exist
            $commands = @(if ($manifest.PSObject.Properties['contributes'] -and
                    $manifest.contributes.PSObject.Properties['commands']) {
                    $manifest.contributes.commands
                })
            foreach ($command in $commands) {
                if (-not $command.PSObject.Properties['icon']) {
                    continue
                }
                foreach ($icon in @($command.icon.light, $command.icon.dark)) {
                    Join-Path $folder $icon |
                        Should -Exist -Because "$($entry.name) command '$($command.command)' names it"
                }
            }
        }
    }
}
