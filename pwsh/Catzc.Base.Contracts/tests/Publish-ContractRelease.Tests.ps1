<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Base.Contracts/tests/Publish-ContractRelease.Tests.ps1
    folder: tests
    name: publish-contract-release-tests
    filetype: ps1
    role: test
    language: powershell
    track: pwsh
    tracktype: modules
    module: Catzc.Base.Contracts
    moduletype: pwsh-folder
    catzc_bundle: azure
  edges:
    docs: "[Publish-ContractRelease.Tests.ps1.md](docs/references/pwsh/catzc-base-contracts/tests/Publish-ContractRelease.Tests.ps1.md)"
    cites:
      - ADR-AUTO-TEST-DISTINCTFIXTUREIDENTITIES
      - ADR-PWSH-ENUM-ALWAYSBOUNDED
      - ADR-REPO-CONTRACT-RELEASEDIMMUTABLE
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
        Mock Get-Config -ModuleName Catzc.Base.Contracts -ParameterFilter { $Config -eq 'contracts' } {
            [Catzc.Base.Contracts.ContractsConfig]::new(@{})
        }
        Mock Get-Config -ModuleName Catzc.Base.Contracts -ParameterFilter { $Config -eq 'exporter' } {
            [pscustomobject]@{ direct_install_version = '6.6.666' }
        }
        $script:root = Join-Path $TestDrive ([guid]::NewGuid().ToString('n'))
        Add-File 'contracts/widget/0.0.0/Catzc.Widget/docs/widget.md' "# Widget`r`n`r`nThe gadget line.`r`n"
        Add-File 'contracts/widget/0.0.0/Catzc.Widget/.widget/flows/build.yml'
        Add-File 'contracts/widget/0.0.0/Catzc.Gadget/rest/gadget.sample.json' '{ "gadget": 1 }'
        Add-File 'contracts/widget/0.0.0/contract.yml' "direction:`n  Catzc.Widget/docs/widget.md: provided`n"
    }

    It 'copies the draft exactly and writes the .frozen record of the copy' {
        $name = Publish-ContractRelease -Unit widget -Version 1.2.3 -RepositoryRoot $script:root
        $name | Should -Be 'contracts/widget/1.2.3'

        $draft = @(Get-Tree 'contracts/widget/0.0.0')
        @(Get-Tree 'contracts/widget/1.2.3') | Should -Be (@('.frozen') + $draft)
        foreach ($path in $draft) {
            $copy = [System.Convert]::ToBase64String([System.IO.File]::ReadAllBytes((Join-Path $script:root "contracts/widget/1.2.3/$path")))
            $copy | Should -BeExactly ([System.Convert]::ToBase64String([System.IO.File]::ReadAllBytes((Join-Path $script:root "contracts/widget/0.0.0/$path")))) -Because $path
        }

        $record = @([System.IO.File]::ReadAllLines((Join-Path $script:root 'contracts/widget/1.2.3/.frozen')) | Where-Object { -not $_.StartsWith('#') })
        $record.Count | Should -Be $draft.Count
        @($record | ForEach-Object { $_.Substring(66) }) | Should -Be $draft
        $findings = @(InModuleScope Catzc.Base.Contracts -Parameters @{ Folder = (Join-Path $script:root 'contracts/widget/1.2.3') } {
                param($Folder)
                Get-ContractFreezeFindings -Folder $Folder -Name contracts/widget/1.2.3
            })
        $findings.Count | Should -Be 0
    }

    It 'leaves the draft as it was' {
        $before = @(Get-Tree 'contracts/widget/0.0.0')
        $null = Publish-ContractRelease -Unit widget -Version 1.2.3 -RepositoryRoot $script:root
        @(Get-Tree 'contracts/widget/0.0.0') | Should -Be $before
    }

    It 'lists the frozen folder like any version folder, without the record' {
        $null = Publish-ContractRelease -Unit widget -Version 1.2.3 -RepositoryRoot $script:root
        (Get-Contract -Version 1.2.3 -RepositoryRoot $script:root).Path | Should -Be @(
            'rest/gadget.sample.json'
            '.widget/flows/build.yml'
            'docs/widget.md'
        )
    }

    It 'refuses a target folder that already exists, and leaves it untouched' {
        Add-File 'contracts/widget/1.2.3/Catzc.Widget/docs/widget.md' '# Released'
        { Publish-ContractRelease -Unit widget -Version 1.2.3 -RepositoryRoot $script:root } |
            Should -Throw '*contracts/widget/1.2.3/ already exists; a released version folder is immutable*'
        @(Get-Tree 'contracts/widget/1.2.3') | Should -Be @('Catzc.Widget/docs/widget.md')
        [System.IO.File]::ReadAllText((Join-Path $script:root 'contracts/widget/1.2.3/Catzc.Widget/docs/widget.md')) | Should -Be '# Released'
    }

    It 'refuses the draft version 0.0.0' {
        { Publish-ContractRelease -Unit widget -Version 0.0.0 -RepositoryRoot $script:root } |
            Should -Throw '*0.0.0 is the draft of ''widget''*'
    }

    It 'refuses the devbox build version 6.6.666 and writes nothing' {
        { Publish-ContractRelease -Unit widget -Version 6.6.666 -RepositoryRoot $script:root } |
            Should -Throw '*6.6.666 is the devbox build version*'
        [System.IO.Directory]::Exists((Join-Path $script:root 'contracts/widget/6.6.666')) | Should -BeFalse
    }

    It 'refuses a version that is not three numbers' {
        { Publish-ContractRelease -Unit widget -Version 1.2 -RepositoryRoot $script:root } | Should -Throw
    }

    It 'refuses a unit with no draft' {
        { Publish-ContractRelease -Unit gadget -Version 1.2.3 -RepositoryRoot $script:root } |
            Should -Throw '*contracts/gadget/0.0.0/ does not exist*'
    }

    It 'refuses a draft that does not list, and writes nothing' {
        Add-File 'contracts/widget/0.0.0/gadget.md' '# Gadget'
        { Publish-ContractRelease -Unit widget -Version 1.2.3 -RepositoryRoot $script:root } |
            Should -Throw '*sits outside a module folder*'
        [System.IO.Directory]::Exists((Join-Path $script:root 'contracts/widget/1.2.3')) | Should -BeFalse
    }

    It 'writes nothing under -WhatIf' {
        Publish-ContractRelease -Unit widget -Version 1.2.3 -RepositoryRoot $script:root -WhatIf | Should -BeNullOrEmpty
        [System.IO.Directory]::Exists((Join-Path $script:root 'contracts/widget/1.2.3')) | Should -BeFalse
    }

    It 'removes the target again when the freeze fails part-way' {
        Mock Get-ContractFileHashes -ModuleName Catzc.Base.Contracts { throw 'widget hash failed' }
        { Publish-ContractRelease -Unit widget -Version 1.2.3 -RepositoryRoot $script:root } | Should -Throw '*widget hash failed*'
        [System.IO.Directory]::Exists((Join-Path $script:root 'contracts/widget/1.2.3')) | Should -BeFalse
    }
}
