BeforeAll {
    Import-InternalModule TestKit
    Import-InternalModule Builder

    # A widget build folder with its record, and the store root of a gadget bundle at a fixed stamp.
    $script:newCase = {
        param([string] $Name)
        $source = Join-Path $TestDrive "$Name/source"
        [System.IO.Directory]::CreateDirectory($source) | Out-Null
        [System.IO.File]::WriteAllText((Join-Path $source 'build.json'), '{"bundle":"gadgets","version":"6.6.666","modules":["widget"]}')
        [pscustomobject] @{
            Source = $source
            Bundle = Join-Path $TestDrive "$Name/gadgets"
            Store  = Join-Path $TestDrive "$Name/gadgets/$('a' * 12)/Catzc/6.6.666"
        }
    }
}

Describe 'Save-BuildToStore' -Tag 'L0', 'logic' {
    It 'moves the copied build into the stamp folder' {
        $case = & $newCase 'plain'
        InModuleScope Catzc.Internal.Builder -Parameters @{ Case = $case } {
            Save-BuildToStore -BuildRoot $Case.Source -StoreBuildRoot $Case.Store
        }
        [System.IO.File]::Exists((Join-Path $case.Store 'build.json')) | Should -BeTrue
        @([System.IO.Directory]::GetDirectories($case.Bundle) | Where-Object { [System.IO.Path]::GetFileName($_) -like '.staging-*' }).Count | Should -Be 0
    }

    It 'returns quietly and leaves the other build when another build filled the stamp folder during the copy' {
        $case = & $newCase 'filled'
        InModuleScope Catzc.Internal.Builder -Parameters @{ Case = $case } {
            Mock Get-ChildPath {
                [System.IO.Directory]::CreateDirectory($Case.Store) | Out-Null
                [System.IO.File]::WriteAllText((Join-Path $Case.Store 'build.json'), 'other writer')
                Join-Path $Case.Source 'build.json'
            }
            { Save-BuildToStore -BuildRoot $Case.Source -StoreBuildRoot $Case.Store } | Should -Not -Throw
        }
        [System.IO.File]::ReadAllText((Join-Path $case.Store 'build.json')) | Should -Be 'other writer'
        @([System.IO.Directory]::GetDirectories($case.Bundle) | Where-Object { [System.IO.Path]::GetFileName($_) -like '.staging-*' }).Count | Should -Be 0
    }

    It 'throws naming the stamp folder when the move fails and no other build holds it' {
        $case = & $newCase 'blocked'
        $stampFolder = [System.IO.Path]::GetDirectoryName([System.IO.Path]::GetDirectoryName($case.Store))
        InModuleScope Catzc.Internal.Builder -Parameters @{ Case = $case; StampFolder = $stampFolder } {
            # A file where the stamp folder belongs fails the move without leaving a build record.
            Mock Get-ChildPath {
                [System.IO.File]::WriteAllText($StampFolder, 'not a folder')
                Join-Path $Case.Source 'build.json'
            }
            { Save-BuildToStore -BuildRoot $Case.Source -StoreBuildRoot $Case.Store } | Should -Throw "*the store stamp folder '$StampFolder'*"
        }
        @([System.IO.Directory]::GetDirectories($case.Bundle) | Where-Object { [System.IO.Path]::GetFileName($_) -like '.staging-*' }).Count | Should -Be 0
    }
}
