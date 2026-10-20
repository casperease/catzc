<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Base.Contracts/tests/Get-ContractFreezeFindings.Tests.ps1
    folder: tests
    name: get-contract-freeze-findings-tests
    filetype: ps1
    role: test
    language: powershell
    track: pwsh
    tracktype: modules
    module: Catzc.Base.Contracts
    moduletype: pwsh-folder
    catzc_bundle: azure
  edges:
    docs: "[Get-ContractFreezeFindings.Tests.ps1.md](docs/references/pwsh/catzc-base-contracts/tests/Get-ContractFreezeFindings.Tests.ps1.md)"
    cites:
      - ADR-AUTO-TEST-DISTINCTFIXTUREIDENTITIES
      - ADR-REPO-CONTRACT-RELEASEDIMMUTABLE
---
#>

Describe 'Get-ContractFreezeFindings' -Tag 'L0', 'logic', 'ADR-REPO-CONTRACT-RELEASEDIMMUTABLE' {
    BeforeAll {
        function Add-File {
            param([string] $Relative, [string] $Content = 'widget: gadget')
            $file = Join-Path $script:folder $Relative
            $null = [System.IO.Directory]::CreateDirectory([System.IO.Path]::GetDirectoryName($file))
            [System.IO.File]::WriteAllText($file, $Content)
        }

        function Save-Record {
            $hashes = InModuleScope Catzc.Base.Contracts -Parameters @{ Folder = $script:folder } {
                param($Folder)
                Get-ContractFileHashes -Folder $Folder
            }
            $lines = [System.Collections.Generic.List[string]]::new()
            $lines.Add('# widget record')
            foreach ($path in $hashes.Keys) {
                $lines.Add("$($hashes[$path])  $path")
            }
            [System.IO.File]::WriteAllText((Join-Path $script:folder '.frozen'), (($lines -join "`n") + "`n"))
        }

        function Get-Finding {
            InModuleScope Catzc.Base.Contracts -Parameters @{ Folder = $script:folder } {
                param($Folder)
                @(Get-ContractFreezeFindings -Folder $Folder -Name contracts/widget/1.0.0)
            }
        }

        $script:fix = 'a released version folder is immutable, so a change lands in the draft, contracts/widget/0.0.0/ (ADR-REPO-CONTRACT-RELEASEDIMMUTABLE).'
    }

    BeforeEach {
        $script:folder = Join-Path $TestDrive ([guid]::NewGuid().ToString('n'))
        Add-File 'Catzc.Widget/docs/widget.md' "# Widget`n`nThe gadget line.`n"
        Add-File 'Catzc.Widget/.widget/flows/build.yml'
        Add-File 'contract.yml' "direction:`n  Catzc.Widget/docs/widget.md: provided`n"
        Save-Record
    }

    It 'finds nothing in a folder unchanged since its freeze' {
        @(Get-Finding).Count | Should -Be 0
    }

    It 'records every file, contract.yml included, and not the record itself' {
        $keys = InModuleScope Catzc.Base.Contracts -Parameters @{ Folder = $script:folder } {
            param($Folder)
            @((Get-ContractFileHashes -Folder $Folder).Keys)
        }
        $keys | Should -Be @('Catzc.Widget/.widget/flows/build.yml', 'Catzc.Widget/docs/widget.md', 'contract.yml')
    }

    It 'finds nothing when only the line endings differ, as between two checkouts' {
        Add-File 'Catzc.Widget/docs/widget.md' "# Widget`r`n`r`nThe gadget line.`r`n"
        @(Get-Finding).Count | Should -Be 0
    }

    It 'finds a changed file' {
        Add-File 'Catzc.Widget/docs/widget.md' "# Widget`n`nThe sprocket line.`n"
        Get-Finding | Should -Be @("contracts/widget/1.0.0/Catzc.Widget/docs/widget.md: changed since the release froze it; $script:fix")
    }

    It 'finds a changed contract.yml' {
        Add-File 'contract.yml' "direction:`n  Catzc.Widget/docs/widget.md: depended-on`n"
        Get-Finding | Should -Be @("contracts/widget/1.0.0/contract.yml: changed since the release froze it; $script:fix")
    }

    It 'finds an added file' {
        Add-File 'Catzc.Gadget/gadget.md' '# Gadget'
        Get-Finding | Should -Be @("contracts/widget/1.0.0/Catzc.Gadget/gadget.md: added since the release froze it; $script:fix")
    }

    It 'finds a removed file' {
        [System.IO.File]::Delete((Join-Path $script:folder 'Catzc.Widget/.widget/flows/build.yml'))
        Get-Finding | Should -Be @("contracts/widget/1.0.0/Catzc.Widget/.widget/flows/build.yml: removed since the release froze it; $script:fix")
    }

    It 'finds a file whose name changed only in case' {
        [System.IO.File]::Move((Join-Path $script:folder 'Catzc.Widget/docs/widget.md'), (Join-Path $script:folder 'Catzc.Widget/docs/Widget.md'))
        Get-Finding | Should -Be @(
            "contracts/widget/1.0.0/Catzc.Widget/docs/widget.md: removed since the release froze it; $script:fix"
            "contracts/widget/1.0.0/Catzc.Widget/docs/Widget.md: added since the release froze it; $script:fix"
        )
    }

    It 'finds a folder with no record' {
        [System.IO.File]::Delete((Join-Path $script:folder '.frozen'))
        Get-Finding | Should -Be @('contracts/widget/1.0.0: holds no .frozen record, so nothing proves it unchanged; a release freezes the draft with Publish-ContractRelease, which writes it (ADR-REPO-CONTRACT-RELEASEDIMMUTABLE).')
    }

    It 'finds a malformed and a repeated record line' {
        $record = Join-Path $script:folder '.frozen'
        $first = @([System.IO.File]::ReadAllLines($record))[1]
        [System.IO.File]::AppendAllText($record, "widget gadget`n$first`n")
        Get-Finding | Should -Be @(
            'contracts/widget/1.0.0/.frozen: line 5 is not ''<sha256>  <path>''.'
            "contracts/widget/1.0.0/.frozen: line 6 records '$($first.Substring(66))' a second time."
        )
    }
}

BeforeDiscovery {
    $contractsRoot = Join-Path (Get-RepositoryRoot) 'contracts'
    $script:releasedCases = @(if ([System.IO.Directory]::Exists($contractsRoot)) {
            foreach ($unitFolder in [System.IO.Directory]::GetDirectories($contractsRoot)) {
                foreach ($versionFolder in [System.IO.Directory]::GetDirectories($unitFolder)) {
                    $version = [System.IO.Path]::GetFileName($versionFolder)
                    if ($version -match '^[0-9]+\.[0-9]+\.[0-9]+$' -and $version -cne '0.0.0') {
                        @{
                            Folder = $versionFolder
                            Name   = "contracts/$([System.IO.Path]::GetFileName($unitFolder))/$version"
                        }
                    }
                }
            }
        })
}

Describe 'Released contract version folders' -Tag 'L1', 'integrity', 'source-only', 'ADR-REPO-CONTRACT-RELEASEDIMMUTABLE' {
    It '<Name> is unchanged since its release' -ForEach $script:releasedCases {
        $findings = @(InModuleScope Catzc.Base.Contracts -Parameters @{ Folder = $Folder; Name = $Name } {
                param($Folder, $Name)
                Get-ContractFreezeFindings -Folder $Folder -Name $Name
            })
        $findings.Count | Should -Be 0 -Because ($findings -join "`n")
    }
}
