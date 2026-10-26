# Rests on
# [ADR-PWSH-PESTER-ISOLATETHROUGHSEAMS](/docs/drs/automation/pwsh/pester-testing.md#rule-adr-pwsh-pester-isolatethroughseams).
Describe 'Install-VsCodeExtension' -Tag 'L0', 'logic' {
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
        Mock New-VsCodeExtensionFolder -ModuleName Catzc.Base.VSCode {
            $folder = Join-Path $OutputDirectory $Extension.name
            $null = New-Item -ItemType Directory -Path $folder -Force
            Set-Content -LiteralPath (Join-Path $folder 'package.json') -Value "{ `"name`": `"$($Extension.name)`", `"version`": `"1.0.0`", `"publisher`": `"acme`" }"
            Set-Content -LiteralPath (Join-Path $folder 'extension.js') -Value 'module.exports = {};'
            $folder
        }
        Mock Test-Command -ModuleName Catzc.Base.VSCode { $true }
        Mock Build-VsCodeExtension -ModuleName Catzc.Base.VSCode { "$Path.vsix" }
        Mock Invoke-Executable -ModuleName Catzc.Base.VSCode { }
        # The folder writer's stamp is the generated-writer memo's; each case says whether it reads current.
        Mock Get-GeneratedWriterDue -ModuleName Catzc.Base.VSCode { [Catzc.Base.GeneratedFiles.GeneratedWriterDue]::new('New-VsCodeExtensionFolder', -not $script:current, $true) }
        Mock Save-GeneratedWriterStamp -ModuleName Catzc.Base.VSCode { }
    }

    BeforeEach {
        Remove-Item -LiteralPath $script:installs -Recurse -Force -ErrorAction Ignore
        $script:current = $false
    }

    It 'skips the render while the folder writer is current, and still renders a folder that is missing' {
        Install-VsCodeExtension @script:install | Out-Null
        Remove-Item -LiteralPath (Join-Path $script:root 'gadget-ext') -Recurse -Force
        $script:current = $true
        Install-VsCodeExtension @script:install | Out-Null
        Should -Invoke New-VsCodeExtensionFolder -ModuleName Catzc.Base.VSCode -Times 3 -Exactly
        Should -Invoke New-VsCodeExtensionFolder -ModuleName Catzc.Base.VSCode -Times 2 -Exactly -ParameterFilter { $Extension.name -eq 'gadget-ext' }
    }

    It 'trusts a current stamp: an unchanged folder whose installed copy is present is not compared or reinstalled' {
        Install-VsCodeExtension @script:install | Out-Null
        $copy = Join-Path $script:installs 'acme.widget-ext-1.0.0'
        $null = New-Item -ItemType Directory -Path $copy -Force
        Set-Content -LiteralPath (Join-Path $copy 'extension.js') -Value 'module.exports = { old: true };'
        $script:current = $true
        @(Install-VsCodeExtension @script:install -Name widget-ext).Count | Should -Be 0
    }

    It 'stores the folder stamp after a render of every extension, never after a named one' {
        Install-VsCodeExtension @script:install -Name widget-ext | Out-Null
        Should -Invoke Save-GeneratedWriterStamp -ModuleName Catzc.Base.VSCode -Times 0 -Exactly
        Install-VsCodeExtension @script:install | Out-Null
        Should -Invoke Save-GeneratedWriterStamp -ModuleName Catzc.Base.VSCode -Times 1 -Exactly -ParameterFilter { $Name -eq 'New-VsCodeExtensionFolder' }
    }

    It 'renders and installs every registry entry' {
        $installed = @(Install-VsCodeExtension @script:install)
        $installed.Count | Should -Be 2
        Should -Invoke Invoke-Executable -ModuleName Catzc.Base.VSCode -Times 2 -ParameterFilter { $Command -like 'code --install-extension "*" --force' }
    }

    It 'installs only the named extension' {
        $installed = @(Install-VsCodeExtension @script:install -Name widget-ext)
        $installed.Count | Should -Be 1
        $installed[0] | Should -BeLike '*widget-ext.vsix'
    }

    It 'skips an extension whose installed copy holds every rendered file, its manifest apart from the editor metadata' {
        $copy = Join-Path $script:installs 'acme.widget-ext-1.0.0'
        $null = New-Item -ItemType Directory -Path $copy -Force
        Set-Content -LiteralPath (Join-Path $copy 'extension.js') -Value 'module.exports = {};'
        Set-Content -LiteralPath (Join-Path $copy 'package.json') -Value '{ "name": "widget-ext", "version": "1.0.0", "publisher": "acme", "__metadata": { "size": 1 } }'
        $installed = @(Install-VsCodeExtension @script:install)
        $installed.Count | Should -Be 1
        $installed[0] | Should -BeLike '*gadget-ext.vsix'
        @(Install-VsCodeExtension @script:install -Force).Count | Should -Be 2
    }

    It 'reinstalls an extension whose installed copy differs from the rendered folder' {
        $copy = Join-Path $script:installs 'acme.widget-ext-1.0.0'
        $null = New-Item -ItemType Directory -Path $copy -Force
        Set-Content -LiteralPath (Join-Path $copy 'extension.js') -Value 'module.exports = { old: true };'
        Set-Content -LiteralPath (Join-Path $copy 'package.json') -Value '{ "name": "widget-ext", "version": "1.0.0", "publisher": "acme" }'
        @(Install-VsCodeExtension @script:install -Name widget-ext).Count | Should -Be 1
    }

    It 'refuses a name that is not a registry entry' {
        { Install-VsCodeExtension @script:install -Name plain } |
            Should -Throw "*'plain' is not an entry under extensions*"
    }

    It 'says so when the editor CLI is not on PATH' {
        Mock Test-Command -ModuleName Catzc.Base.VSCode { $false }
        { Install-VsCodeExtension @script:install } | Should -Throw "*'code' is not on PATH*"
    }
}
