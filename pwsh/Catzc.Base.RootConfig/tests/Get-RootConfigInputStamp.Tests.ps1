Describe 'Get-RootConfigInputStamp' -Tag 'L0', 'logic', 'ADR-AUTO-CACHE-CHECKEDFILESACROSSSESSIONS' {
    BeforeAll {
        Import-InternalModule TestKit

        $script:fake = New-FakeRepositoryRoot -Files @{
            'sources/widget.yml'       = "alpha: 1`n"
            'widgets/alpha/gadget.txt' = "alpha`n"
            'gadget.txt'               = "rendered`n"
        }
        $script:entries = @(
            [pscustomobject]@{ target = 'gadget.txt'; source = $null; sources = @('sources/widget.yml'); generator = 'New-Widget'; copyAsLink = $false }
            [pscustomobject]@{ target = 'widgets/*/gadget.txt'; source = $null; sources = @('sources/widget.yml'); generator = 'New-Widget'; copyAsLink = $false }
            [pscustomobject]@{ target = 'linked.yml'; source = 'sources/widget.yml'; sources = @(); generator = $null; copyAsLink = $true }
        )

        function script:Get-Stamp {
            InModuleScope Catzc.Base.RootConfig -Parameters @{ Entries = $script:entries } {
                param($Entries)
                Get-RootConfigInputStamp -Entries $Entries
            }
        }
    }

    AfterAll {
        Remove-FakeRepositoryRoot $script:fake
    }

    It 'is the same hash twice over an unchanged tree' {
        $first = Get-Stamp
        $first | Should -Match '^[0-9a-f]{64}$'
        Get-Stamp | Should -Be $first
    }

    It 'changes when a declared source changes' {
        $before = Get-Stamp
        [System.IO.File]::WriteAllText((Join-Path $script:fake.Root 'sources/widget.yml'), "alpha: 2`n")
        Get-Stamp | Should -Not -Be $before
    }

    It 'changes when a rendered target is edited, and when it goes missing' {
        $before = Get-Stamp
        [System.IO.File]::AppendAllText((Join-Path $script:fake.Root 'gadget.txt'), "edited`n")
        $edited = Get-Stamp
        $edited | Should -Not -Be $before
        [System.IO.File]::Delete((Join-Path $script:fake.Root 'gadget.txt'))
        Get-Stamp | Should -Not -Be $edited
    }

    It 'changes when a folder appears that a wildcard entry would render into' {
        $before = Get-Stamp
        [System.IO.Directory]::CreateDirectory((Join-Path $script:fake.Root 'widgets/beta')) | Out-Null
        Get-Stamp | Should -Not -Be $before
    }

    It 'changes when a link entry gains or loses its link' {
        $before = Get-Stamp
        $link = Join-Path $script:fake.Root 'linked.yml'
        [System.IO.File]::WriteAllText($link, "a plain file where a link belongs`n")
        Get-Stamp | Should -Be $before
        [System.IO.File]::Delete($link)
        New-Item -ItemType SymbolicLink -Path $link -Target (Join-Path $script:fake.Root 'sources/widget.yml') -ErrorAction SilentlyContinue | Out-Null
        if (Test-Path -LiteralPath $link) {
            Get-Stamp | Should -Not -Be $before
        }
    }
}
