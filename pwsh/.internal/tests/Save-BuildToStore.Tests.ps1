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

    It 'lands the build on the second attempt when the first move is denied for a moment' -Tag 'ADR-AUTO-RETRY-LASTRESORT' {
        $case = & $newCase 'transient'
        $stampFolder = [System.IO.Path]::GetDirectoryName([System.IO.Path]::GetDirectoryName($case.Store))
        InModuleScope Catzc.Internal.Builder -Parameters @{ Case = $case; StampFolder = $stampFolder } {
            # A file where the stamp folder belongs denies the first move; the wait between attempts is where it goes away.
            Mock Get-ChildPath {
                [System.IO.File]::WriteAllText($StampFolder, 'not a folder yet')
                Join-Path $Case.Source 'build.json'
            }
            Mock Start-Sleep { [System.IO.File]::Delete($StampFolder) }
            Mock Write-Message { }
            Save-BuildToStore -BuildRoot $Case.Source -StoreBuildRoot $Case.Store
            Should -Invoke Start-Sleep -Times 1 -Exactly
            Should -Invoke Write-Message -Times 1 -Exactly -ParameterFilter {
                $Warning -and $Message -like "Save-BuildToStore: the move of the build into '$StampFolder' failed on attempt 1 of 8 (*); retrying in 250 ms."
            }
        }
        [System.IO.File]::Exists((Join-Path $case.Store 'build.json')) | Should -BeTrue
        @([System.IO.Directory]::GetDirectories($case.Bundle) | Where-Object { [System.IO.Path]::GetFileName($_) -like '.staging-*' }).Count | Should -Be 0
    }

    It 'throws naming the stamp folder when the move fails and no other build holds it' {
        $case = & $newCase 'blocked'
        $stampFolder = [System.IO.Path]::GetDirectoryName([System.IO.Path]::GetDirectoryName($case.Store))
        InModuleScope Catzc.Internal.Builder -Parameters @{ Case = $case; StampFolder = $stampFolder } {
            # A file where the stamp folder belongs fails the move without leaving a build record; the retries' waits are skipped.
            Mock Get-ChildPath {
                [System.IO.File]::WriteAllText($StampFolder, 'not a folder')
                Join-Path $Case.Source 'build.json'
            }
            Mock Start-Sleep { }
            Mock Write-Message { }
            { Save-BuildToStore -BuildRoot $Case.Source -StoreBuildRoot $Case.Store } | Should -Throw "*the store stamp folder '$StampFolder'*"
            Should -Invoke Start-Sleep -Times 7 -Exactly
            Should -Invoke Write-Message -Times 7 -Exactly
        }
        @([System.IO.Directory]::GetDirectories($case.Bundle) | Where-Object { [System.IO.Path]::GetFileName($_) -like '.staging-*' }).Count | Should -Be 0
    }
}
