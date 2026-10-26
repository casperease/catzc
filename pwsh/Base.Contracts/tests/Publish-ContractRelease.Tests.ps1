<#
---
catzc:
  docs: "../../../docs/references/pwsh/catzc-base-contracts/tests/Publish-ContractRelease.Tests.ps1.md"
  header: "generated"
---
#>

Describe 'Publish-ContractRelease' -Tag 'L0', 'logic', 'ADR-REPO-CONTRACT-RELEASEDIMMUTABLE' {
    BeforeAll {
        function Add-File {
            param([string] $Relative, [string] $Content = 'widget: gadget')
            $file = Join-Path $script:root $Relative
            $null = [System.IO.Directory]::CreateDirectory([System.IO.Path]::GetDirectoryName($file))
            [System.IO.File]::WriteAllText($file, $Content)
        }

        function Get-Tree {
            param([string] $Relative)
            $folder = Join-Path $script:root $Relative
            if (-not [System.IO.Directory]::Exists($folder)) {
                return @()
            }
            $paths = [string[]] @(Get-ChildPath $folder -File -Depth 64 -Exclude @() -PruneVendor $false |
                    ForEach-Object { [System.IO.Path]::GetRelativePath($folder, $_) -replace '\\', '/' })
            [System.Array]::Sort($paths, [System.StringComparer]::Ordinal)
            $paths
        }
    }

    BeforeEach {
        Mock Get-Config -ModuleName Catzc.Base.Contracts -ParameterFilter { $Config -eq 'exporter' } {
            [pscustomobject]@{ direct_install_version = '6.6.666' }
        }
        Mock Get-GitTrackedPath { 'widget.yml' } -ModuleName Catzc.Base.Contracts
        $script:root = Join-Path $TestDrive ([guid]::NewGuid().ToString('n'))
        Add-File 'contracts/catzc/0.1.0/widgets/widget.yml' "# Widget`r`n`r`nThe gadget line.`r`n"
        Add-File 'contracts/catzc/0.1.0/widgets/widget.sample.json' '{ "widget": 1 }'
        Add-File 'contracts/catzc/0.1.0/gadgets/gadget.sample.json' '{ "gadget": 1 }'
        Add-File 'contracts/catzc/0.1.0/contract.yml' "applies_to:`n  widgets/widget.yml: ['widget.yml']`n"
    }

    It 'copies the current version exactly and writes the .frozen record of the copy' {
        $name = Publish-ContractRelease -Root catzc -Version 1.2.3 -RepositoryRoot $script:root
        $name | Should -Be 'contracts/catzc/1.2.3'

        $current = @(Get-Tree 'contracts/catzc/0.1.0')
        @(Get-Tree 'contracts/catzc/1.2.3') | Should -Be (@('.frozen') + $current)
        foreach ($path in $current) {
            $copy = [System.Convert]::ToBase64String([System.IO.File]::ReadAllBytes((Join-Path $script:root "contracts/catzc/1.2.3/$path")))
            $copy |
                Should -BeExactly ([System.Convert]::ToBase64String([System.IO.File]::ReadAllBytes((Join-Path $script:root "contracts/catzc/0.1.0/$path")))) -Because $path
        }

        $record = @([System.IO.File]::ReadAllLines((Join-Path $script:root 'contracts/catzc/1.2.3/.frozen')) | Where-Object { -not $_.StartsWith('#') })
        $record.Count | Should -Be $current.Count
        @($record | ForEach-Object { $_.Substring(66) }) | Should -Be $current
        $findings = @(InModuleScope Catzc.Base.Contracts -Parameters @{ Folder = (Join-Path $script:root 'contracts/catzc/1.2.3') } {
                param($Folder)
                Get-ContractFreezeFindings -Folder $Folder -Name contracts/catzc/1.2.3
            })
        $findings.Count | Should -Be 0
    }

    It 'leaves the current version as it was' {
        $before = @(Get-Tree 'contracts/catzc/0.1.0')
        $null = Publish-ContractRelease -Root catzc -Version 1.2.3 -RepositoryRoot $script:root
        @(Get-Tree 'contracts/catzc/0.1.0') | Should -Be $before
    }

    It 'lists the frozen folder like any version folder, without the record' {
        $null = Publish-ContractRelease -Root catzc -Version 1.2.3 -RepositoryRoot $script:root
        (Get-Contract -Version 1.2.3 -RepositoryRoot $script:root).Path | Should -Be @(
            'gadget.sample.json'
            'widget.sample.json'
            'widget.yml'
        )
    }

    It 'refuses a target folder that already exists, and leaves it untouched' {
        Add-File 'contracts/catzc/1.2.3/widgets/widget.sample.json' '# Released'
        { Publish-ContractRelease -Root catzc -Version 1.2.3 -RepositoryRoot $script:root } |
            Should -Throw '*contracts/catzc/1.2.3/ already exists; a released version folder is immutable*'
        @(Get-Tree 'contracts/catzc/1.2.3') | Should -Be @('widgets/widget.sample.json')
    }

    It 'refuses a vendor root, which never releases' -Tag 'ADR-REPO-CONTRACT-KEPTWHILEPINNED' {
        Add-File 'contracts/widget/0.1.0/gadgets/gadget.sample.json' '{}'
        { Publish-ContractRelease -Root widget -Version 1.2.3 -RepositoryRoot $script:root } |
            Should -Throw '*''widget'' is a vendor root, which never releases*'
        [System.IO.Directory]::Exists((Join-Path $script:root 'contracts/widget/1.2.3')) | Should -BeFalse
    }

    It 'refuses the version <Version>, which is not a release' -ForEach @(
        @{ Version = '0.0.0' }
        @{ Version = '0.1.0' }
        @{ Version = '0.9.9' }
    ) {
        { Publish-ContractRelease -Root catzc -Version $Version -RepositoryRoot $script:root } |
            Should -Throw "*$Version is not a release of 'catzc'*"
    }

    It 'refuses the devbox build version 6.6.666 and writes nothing' {
        { Publish-ContractRelease -Root catzc -Version 6.6.666 -RepositoryRoot $script:root } |
            Should -Throw '*6.6.666 is the devbox build version*'
        [System.IO.Directory]::Exists((Join-Path $script:root 'contracts/catzc/6.6.666')) | Should -BeFalse
    }

    It 'refuses a version that is not three numbers' {
        { Publish-ContractRelease -Root catzc -Version 1.2 -RepositoryRoot $script:root } | Should -Throw
    }

    It 'refuses a root with no current version' {
        $null = New-Item -ItemType Directory -Path (Join-Path $script:root 'contracts/catzc/0.1.0') -Force
        [System.IO.Directory]::Delete((Join-Path $script:root 'contracts/catzc/0.1.0'), $true)
        { Publish-ContractRelease -Root catzc -Version 1.2.3 -RepositoryRoot $script:root } |
            Should -Throw '*contracts/catzc/0.1.0/ does not exist*'
    }

    It 'refuses a current version that does not list, and writes nothing' {
        Add-File 'contracts/catzc/0.1.0/gadgets/flows/deep/gadget.sample.json' '{}'
        { Publish-ContractRelease -Root catzc -Version 1.2.3 -RepositoryRoot $script:root } |
            Should -Throw '*is a second folder below a group*'
        [System.IO.Directory]::Exists((Join-Path $script:root 'contracts/catzc/1.2.3')) | Should -BeFalse
    }

    It 'writes nothing under -WhatIf' {
        Publish-ContractRelease -Root catzc -Version 1.2.3 -RepositoryRoot $script:root -WhatIf | Should -BeNullOrEmpty
        [System.IO.Directory]::Exists((Join-Path $script:root 'contracts/catzc/1.2.3')) | Should -BeFalse
    }

    It 'removes the target again when the freeze fails part-way' {
        Mock Get-ContractFileHashes -ModuleName Catzc.Base.Contracts { throw 'widget hash failed' }
        { Publish-ContractRelease -Root catzc -Version 1.2.3 -RepositoryRoot $script:root } |
            Should -Throw '*widget hash failed*'
        [System.IO.Directory]::Exists((Join-Path $script:root 'contracts/catzc/1.2.3')) | Should -BeFalse
    }
}
