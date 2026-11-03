Describe 'New-BuiltCatzcRoot' -Tag 'L0', 'logic', 'ADR-AUTO-TEST-SAMETESTSBOTHRUNS' {
    BeforeAll {
        Import-InternalModule TestKit

        # Build-Modules (Catzc.Base.Exporter) is the boundary: mocked here, so no real build runs.
    }

    BeforeEach {
        Mock Build-Modules -ModuleName Catzc.Internal.TestKit -ParameterFilter { $DryRun } {
            [pscustomobject]@{ Modules = @('Catzc.Widget', 'Catzc.Gadget'); DryRun = $true }
        }
        Mock Build-Modules -ModuleName Catzc.Internal.TestKit -ParameterFilter { -not $DryRun } {
            $buildRoot = Join-Path $Destination 'Catzc/6.6.666'
            [void][System.IO.Directory]::CreateDirectory($buildRoot)
            [pscustomobject]@{ BuildRoot = $buildRoot; Version = '6.6.666'; Modules = @('Catzc.Widget',
                    'Catzc.Gadget')
            }
        }
    }

    It 'builds the selection plus the gates module into a fresh temp folder and returns the handle' {
        $handle = New-BuiltCatzcRoot -Module 'Catzc.Widget'
        try {
            Should -Invoke Build-Modules -ModuleName Catzc.Internal.TestKit -Times 1 -ParameterFilter {
                -not $DryRun -and ($Module -join ',') -eq 'Catzc.Widget,Catzc.Gadget,Catzc.Base.QualityGates' -and
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
        Mock Build-Modules -ModuleName Catzc.Internal.TestKit -ParameterFilter { -not $DryRun } {
            $seen.Add($Destination)
            [void][System.IO.Directory]::CreateDirectory((Join-Path $Destination 'Catzc'))
            throw 'presence check failed'
        }

        { New-BuiltCatzcRoot } | Should -Throw '*presence check failed*'
        $seen | Should -HaveCount 1
        $seen[0] | Should -Not -Exist
    }
}

Describe 'New-ConsumerRoot' -Tag 'L0', 'logic', 'ADR-AUTO-TEST-SAMETESTSBOTHRUNS' {
    BeforeAll {
        Import-InternalModule TestKit

        # Export-Catzc (Catzc.Base.Exporter) is the boundary: mocked here, so no real build runs.
    }

    BeforeEach {
        Mock Export-Catzc -ModuleName Catzc.Internal.TestKit {
            $modulePath = Join-Path $Root '.vendor/Catzc/6.6.666'
            [void][System.IO.Directory]::CreateDirectory($modulePath)
            [pscustomobject]@{ ModulePath = $modulePath; Importer = (Join-Path $Root 'widget-importer.ps1'); Version = '6.6.666' }
        }
    }

    It 'installs the selection into a fresh temp root and returns the handle the built-root helpers take' {
        $handle = New-ConsumerRoot -Module 'Catzc.Widget'
        try {
            Should -Invoke Export-Catzc -ModuleName Catzc.Internal.TestKit -Times 1 -ParameterFilter {
                ($Module -join ',') -eq 'Catzc.Widget' -and $Root -like "$([System.IO.Path]::GetTempPath())catzc-consumer-*"
            }
            $handle.Root | Should -Be $handle.WorkingRoot
            $handle.Root | Should -Be $handle.Destination
            $handle.BuildRoot | Should -Be (Join-Path $handle.Root '.vendor/Catzc/6.6.666')
            $handle.Importer | Should -Be (Join-Path $handle.Root 'widget-importer.ps1')
            $handle.Saved.RepositoryRoot | Should -Be $env:RepositoryRoot
        }
        finally {
            Remove-BuiltCatzcRoot $handle
        }
        $handle.Root | Should -Not -Exist
    }

    It 'writes the given file tree under the root, creating its folders' {
        $handle = New-ConsumerRoot -File @{
            '.catzc/configs/widget.yml'         = 'limit: 3'
            '.catzc/Base.Gadget/Get-Gadget.ps1' = 'function Get-Gadget { 1 }'
        }
        try {
            Get-Content (Join-Path $handle.Root '.catzc/configs/widget.yml') -Raw | Should -Be 'limit: 3'
            Join-Path $handle.Root '.catzc/Base.Gadget/Get-Gadget.ps1' | Should -Exist
        }
        finally {
            Remove-BuiltCatzcRoot $handle
        }
    }

    It 'installs from a build already on disk when -Source names one, and builds nothing' -Tag 'ADR-AUTO-TEST-SETUPONCE' {
        Mock Install-Catzc -ModuleName Catzc.Internal.TestKit {
            $modulePath = Join-Path $Root '.vendor/Catzc/6.6.666'
            [void][System.IO.Directory]::CreateDirectory($modulePath)
            [pscustomobject]@{ ModulePath = $modulePath; Importer = (Join-Path $Root 'widget-importer.ps1'); Version = '6.6.666' }
        }
        $handle = New-ConsumerRoot -Source 'C:\widget\built\Catzc\6.6.666'
        try {
            Should -Invoke Install-Catzc -ModuleName Catzc.Internal.TestKit -Times 1 -ParameterFilter { $Source -eq 'C:\widget\built\Catzc\6.6.666' }
            Should -Invoke Export-Catzc -ModuleName Catzc.Internal.TestKit -Times 0
            $handle.BuildRoot | Should -Be (Join-Path $handle.Root '.vendor/Catzc/6.6.666')
            $handle.Install.Version | Should -Be '6.6.666'
        }
        finally {
            Remove-BuiltCatzcRoot $handle
        }
    }

    It 'refuses a file path that leaves the root, before it installs anything' {
        { New-ConsumerRoot -File @{ '../widget.yml' = 'x' } } | Should -Throw '*not relative to the consumer root*'
        Should -Invoke Export-Catzc -ModuleName Catzc.Internal.TestKit -Times 0
    }

    It 'removes the root when the install throws' {
        $seen = [System.Collections.Generic.List[string]]::new()
        Mock Export-Catzc -ModuleName Catzc.Internal.TestKit {
            $seen.Add($Root)
            [void][System.IO.Directory]::CreateDirectory((Join-Path $Root '.vendor'))
            throw 'install failed'
        }

        { New-ConsumerRoot } | Should -Throw '*install failed*'
        $seen | Should -HaveCount 1
        $seen[0] | Should -Not -Exist
    }
}

Describe 'Invoke-InBuiltCatzc' -Tag 'L1', 'logic', 'ADR-AUTO-TEST-SAMETESTSBOTHRUNS' {
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
