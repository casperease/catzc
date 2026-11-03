BeforeAll {
    Import-InternalModule Builder

    $script:root = Join-Path $TestDrive 'modules'
    [void] [System.IO.Directory]::CreateDirectory((Join-Path $script:root 'Widget'))
    Set-Content -LiteralPath (Join-Path $script:root 'Widget/Get-Widget.ps1') -NoNewline -Value "function Get-Widget {`n    Invoke-Runner 'widgets/Widget'`n}`n"
    $script:index = [System.Collections.Generic.Dictionary[string, bool]]::new()
    $script:index['Widget/Get-Widget.ps1'] = $true

    Mock Get-ModuleNamespace -ModuleName Catzc.Internal.Builder { '' }
    Mock Get-FunctionDependency -ModuleName Catzc.Internal.Builder { @() }
    Mock Get-Track -ModuleName Catzc.Internal.Builder {
        [pscustomobject]@{ name = 'widgets'; type = 'modules'; languages = @('bash'); places = @('widgets') }
    }
    Mock Get-CatzcModule -ModuleName Catzc.Internal.Builder {
        [pscustomobject]@{ name = 'catzc-widget'; shape = 'folder'; root = 'widgets/Widget' }
    }

    Mock Get-Config -ModuleName Catzc.Internal.Builder -ParameterFilter { $Config -eq 'dependencies' } {
        @{ modules = [ordered]@{ Widget = $script:declared } }
    }

    function script:Get-Violation {
        param([string[]] $Declares = @(), [string[]] $Ships = @())
        $script:declared = $Declares
        $rows = @($Ships | ForEach-Object { [pscustomobject]@{ Source = $_ } })
        InModuleScope Catzc.Internal.Builder -Parameters @{ Root = $script:root; Index = $script:index; Rows = $rows } -ScriptBlock {
            @(Get-BuildClosureViolation -SourceRoot $Root -Module 'Widget' -Index $Index -Language $Rows)
        }
    }
}

Describe 'Get-BuildClosureViolation' -Tag 'L0', 'logic' {
    It 'reports a literal language module path the module row does not declare' {
        $found = @(Get-Violation)
        $found.Count | Should -Be 1
        $found[0] | Should -BeLike '*Widget/Get-Widget.ps1:2:*widgets/Widget*does not declare*add*'
    }

    It 'reports a declared language module the build does not ship' {
        $found = @(Get-Violation -Declares 'widgets/Widget')
        $found.Count | Should -Be 1
        $found[0] | Should -BeLike '*Widget/Get-Widget.ps1:2:*widgets/Widget*does not ship*'
    }

    It 'reports nothing for a declared and shipped language module' {
        Get-Violation -Declares 'widgets/Widget' -Ships 'widgets/Widget' | Should -BeNullOrEmpty
    }

    It 'reports nothing for a string that names no language module' {
        Set-Content -LiteralPath (Join-Path $script:root 'Widget/Get-Widget.ps1') -NoNewline -Value "function Get-Widget {`n    Invoke-Runner 'gadgets/Gadget'`n}`n"
        Get-Violation | Should -BeNullOrEmpty
    }
}
