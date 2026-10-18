Describe 'Measure-NoTrackRootLiteral' -Tag 'L0', 'logic', 'ADR-AUTO-LAYERS#3' {
    BeforeAll {
        $script:modulesRoot = Get-CatzcModulesRoot
        $script:place = [System.IO.Path]::GetFileName($script:modulesRoot)
        Import-Module (Join-Path $script:modulesRoot '.scriptanalyzer/NoTrackRootLiteral.psm1') -Force
        if (-not (Get-Module PSScriptAnalyzer)) {
            Import-Module (Join-Path $script:modulesRoot '.vendor/PSScriptAnalyzer') -Force
        }

        function Test-TrackRootLiteralFile {
            param([string] $Code)
            $path = Join-Path $TestDrive 'Get-Widget.ps1'
            Set-Content -Path $path -Value $Code
            $ast = [System.Management.Automation.Language.Parser]::ParseFile($path, [ref] $null, [ref] $null)
            @(Measure-NoTrackRootLiteral -ScriptBlockAst $ast)
        }
    }

    It 'reports the bare place where a path is built, and a path under it, single-quoted or expandable' {
        $code = "function Get-Widget {`n    `$a = Join-Path `$root '$($script:place)'`n    `$b = '$($script:place)/Catzc.Widget'`n    `$c = `"$($script:place)/`$Name/widget.ps1`"`n}"
        $diagnostics = Test-TrackRootLiteralFile -Code $code
        $diagnostics | Should -HaveCount 3
        $diagnostics[0].RuleName | Should -Be 'Measure-NoTrackRootLiteral'
        $diagnostics[0].Severity | Should -Be 'Information'
        $diagnostics[0].Message | Should -BeLike "*Get-CatzcModulesRoot*ADR-AUTO-LAYERS*"
    }

    It 'leaves a comment, a word that only starts with the place, and another track alone' {
        $code = "function Get-Widget {`n    # '$($script:place)/Catzc.Widget' in a comment`n    `$a = '$($script:place)-gadget'`n    `$b = 'docs/widget.md'`n}"
        Test-TrackRootLiteralFile -Code $code | Should -HaveCount 0
    }

    It 'leaves the bare word alone where no path is built, as an ADR domain or a layer name, and reads Path.Combine as a path' {
        $code = "function Get-Widget {`n    `$domain = '$($script:place)'`n    @{ concern = @('$($script:place)') }`n    [System.IO.Path]::Combine(`$root, '$($script:place)')`n}"
        $diagnostics = Test-TrackRootLiteralFile -Code $code
        $diagnostics | Should -HaveCount 1
        $diagnostics[0].Extent.StartLineNumber | Should -Be 4
    }

    It 'reports a string nested in an expandable string once' {
        $code = "function Get-Widget {`n    `"`$(Join-Path `$root '$($script:place)/gadget')`"`n}"
        Test-TrackRootLiteralFile -Code $code | Should -HaveCount 1
    }

    It 'skips a file the config exempts' {
        InModuleScope NoTrackRootLiteral { $script:exempt = @('^.*Get-Widget\.ps1$') }
        try {
            Test-TrackRootLiteralFile -Code "function Get-Widget { '$($script:place)/Catzc.Widget' }" | Should -HaveCount 0
        }
        finally {
            InModuleScope NoTrackRootLiteral { $script:roots = $null }
        }
    }
}
