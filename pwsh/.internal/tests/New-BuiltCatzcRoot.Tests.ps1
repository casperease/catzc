Describe 'New-BuiltCatzcRoot' -Tag 'L0', 'logic', 'ADR-AUTO-TEST#30' {
    BeforeAll {
        Import-InternalModule TestKit

        # Build-Modules (Catzc.Base.Exporter) is the boundary: mocked here, so no real build runs.
    }

    BeforeEach {
        Mock Build-Modules -ModuleName Catzc.Internal.TestKit {
            $buildRoot = Join-Path $Destination 'Catzc/6.6.666'
            [void][System.IO.Directory]::CreateDirectory($buildRoot)
            [pscustomobject]@{ BuildRoot = $buildRoot; Version = '6.6.666'; Modules = @('Catzc.Widget', 'Catzc.Gadget') }
        }
    }

    It 'builds the selection with the full vendor policy into a fresh temp folder and returns the handle' {
        $handle = New-BuiltCatzcRoot -Module 'Catzc.Widget' -ModuleProfile 'gadgets'
        try {
            Should -Invoke Build-Modules -ModuleName Catzc.Internal.TestKit -Times 1 -ParameterFilter {
                $VendorPolicy -eq 'full' -and $Module -contains 'Catzc.Widget' -and $ModuleProfile -eq 'gadgets' -and
                $Destination -like "$([System.IO.Path]::GetTempPath())catzc-built-*"
            }
            $handle.BuildRoot | Should -Be (Join-Path $handle.Destination 'Catzc/6.6.666')
            $handle.WorkingRoot | Should -Be $env:RepositoryRoot
            @($handle.Modules) | Should -Be @('Catzc.Widget', 'Catzc.Gadget')
            $handle.Saved.RepositoryRoot | Should -Be $env:RepositoryRoot
            $handle.Saved.CatzcModulesRoot | Should -Be $env:CatzcModulesRoot
        }
        finally {
            Remove-BuiltCatzcRoot $handle
        }
    }

    It 'leaves the selection to Build-Modules when none is given' {
        $handle = New-BuiltCatzcRoot
        try {
            Should -Invoke Build-Modules -ModuleName Catzc.Internal.TestKit -Times 1 -ParameterFilter {
                -not $PSBoundParameters.ContainsKey('Module') -and -not $PSBoundParameters.ContainsKey('ModuleProfile')
            }
        }
        finally {
            Remove-BuiltCatzcRoot $handle
        }
    }

    It 'removes the build and restores both roots on removal' {
        $before = @{ RepositoryRoot = $env:RepositoryRoot; CatzcModulesRoot = $env:CatzcModulesRoot }
        $handle = New-BuiltCatzcRoot
        try {
            $env:CatzcModulesRoot = $handle.BuildRoot
            Remove-BuiltCatzcRoot $handle

            $handle.Destination | Should -Not -Exist
            $env:RepositoryRoot | Should -Be $before.RepositoryRoot
            $env:CatzcModulesRoot | Should -Be $before.CatzcModulesRoot
        }
        finally {
            $env:RepositoryRoot = $before.RepositoryRoot
            $env:CatzcModulesRoot = $before.CatzcModulesRoot
        }
    }

    It 'removes a half-written build when Build-Modules throws' {
        $seen = [System.Collections.Generic.List[string]]::new()
        Mock Build-Modules -ModuleName Catzc.Internal.TestKit {
            $seen.Add($Destination)
            [void][System.IO.Directory]::CreateDirectory((Join-Path $Destination 'Catzc'))
            throw 'presence check failed'
        }

        { New-BuiltCatzcRoot } | Should -Throw '*presence check failed*'
        $seen | Should -HaveCount 1
        $seen[0] | Should -Not -Exist
    }
}

Describe 'Invoke-InBuiltCatzc' -Tag 'L1', 'logic', 'ADR-AUTO-TEST#30' {
    BeforeAll {
        Import-InternalModule TestKit

        $buildRoot = Join-Path $TestDrive 'Catzc/6.6.666'
        [void][System.IO.Directory]::CreateDirectory($buildRoot)
        $entry = @'
param([string] $RepositoryRoot)
Write-Output '[Importer.ps1] Loaded widget'
Write-Host '[Importer.ps1] Loaded gadget'
$env:CatzcModulesRoot = $PSScriptRoot
$env:RepositoryRoot = $RepositoryRoot
'@
        [System.IO.File]::WriteAllText((Join-Path $buildRoot 'Import-Catzc.ps1'), $entry)
        $script:workingRoot = Join-Path $TestDrive 'working'
        [void][System.IO.Directory]::CreateDirectory($script:workingRoot)
        $script:handle = @{ BuildRoot = $buildRoot; WorkingRoot = $script:workingRoot }
    }

    It 'runs the block after the entry script, with both roots set, and returns only the block''s output' {
        $result = @(Invoke-InBuiltCatzc -Handle $script:handle -ScriptBlock {
                $env:CatzcModulesRoot
                $env:RepositoryRoot
            })

        $result | Should -HaveCount 2
        $result[0] | Should -Be $script:handle.BuildRoot
        $result[1] | Should -Be $script:workingRoot
    }

    It 'passes -ArgumentList through to the block' {
        $result = Invoke-InBuiltCatzc -Handle $script:handle -ArgumentList 'widget', 3 -ScriptBlock {
            param($Name, $Count)
            "$Name x$Count"
        }

        $result | Should -Be 'widget x3'
    }

    It 'throws with the child''s error when the block throws' {
        { Invoke-InBuiltCatzc -Handle $script:handle -ScriptBlock { throw 'gadget broke' } } |
            Should -Throw '*block failed in the built session: gadget broke*'
    }

    It 'throws when the handle has no entry script' {
        $empty = @{ BuildRoot = (Join-Path $TestDrive 'nothing'); WorkingRoot = $script:workingRoot }

        { Invoke-InBuiltCatzc -Handle $empty -ScriptBlock { 1 } } | Should -Throw '*no Import-Catzc.ps1*'
    }
}
