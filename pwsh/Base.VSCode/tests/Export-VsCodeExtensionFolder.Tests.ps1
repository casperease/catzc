Describe 'Export-VsCodeExtensionFolder' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:config = [Catzc.Base.VSCode.VscodeExtensionsConfig]::new([ordered]@{
                recommendations = @('acme.tool')
                extensions      = [ordered]@{
                    'widget-ext' = [ordered]@{ displayName = 'Widget'; description = 'A widget.'; activationEvents = @('onStartupFinished') }
                    'gadget-ext' = [ordered]@{ displayName = 'Gadget'; description = 'A gadget.'; activationEvents = @('onStartupFinished') }
                }
            })
    }

    BeforeEach {
        Mock Get-Config -ModuleName Catzc.Base.VSCode { $script:config } -ParameterFilter { $Config -eq 'vscode-extensions' }
        Mock New-VsCodeExtensionFolder -ModuleName Catzc.Base.VSCode { Join-Path $OutputDirectory $Extension.name }
    }

    It 'renders the extension whose source folder the module names, into the output directory' {
        $folder = Export-VsCodeExtensionFolder -Module 'widget-ext' -OutputDirectory (Join-Path $TestDrive 'out')
        $folder | Should -Be (Join-Path (Join-Path $TestDrive 'out') 'widget-ext')
        Should -Invoke New-VsCodeExtensionFolder -ModuleName Catzc.Base.VSCode -Times 1 -Exactly -ParameterFilter { $Extension.name -eq 'widget-ext' }
    }

    It 'takes the last segment of a module path' {
        $folder = Export-VsCodeExtensionFolder -Module 'tracks/gadget-ext/' -OutputDirectory (Join-Path $TestDrive 'out')
        $folder | Should -Be (Join-Path (Join-Path $TestDrive 'out') 'gadget-ext')
    }

    It 'renders nothing for a module no extension is registered for' {
        Export-VsCodeExtensionFolder -Module 'sprocket-tool' -OutputDirectory (Join-Path $TestDrive 'out') | Should -BeNullOrEmpty
        Should -Invoke New-VsCodeExtensionFolder -ModuleName Catzc.Base.VSCode -Times 0 -Exactly
    }
}
