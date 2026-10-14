Describe 'Get-LinkScope' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:diskRoot = [System.IO.Path]::GetPathRoot($TestDrive)
        $script:widgetRoot = Join-Path $TestDrive 'widget-repository'
        [System.IO.Directory]::CreateDirectory((Join-Path $script:widgetRoot 'docs')) | Out-Null
        [System.IO.File]::WriteAllText((Join-Path $script:widgetRoot 'docs/widget.md'), '# widget')
    }

    It 'refuses a repository root that is a disk root' {
        {
            InModuleScope Catzc.Base.QualityGates -Parameters @{ Root = $script:diskRoot } {
                param($Root)
                Get-LinkScope -RepositoryRoot $Root -Path @()
            }
        } | Should -Throw '*is a disk root*'
    }

    It 'refuses a -Path that resolves to a disk root' {
        {
            InModuleScope Catzc.Base.QualityGates -Parameters @{ Root = $script:widgetRoot; Item = $script:diskRoot } {
                param($Root, $Item)
                Get-LinkScope -RepositoryRoot $Root -Path $Item
            }
        } | Should -Throw '*resolves to the disk root*'
    }

    It 'lists the files under an ordinary -Path, repository-relative' {
        $scope = InModuleScope Catzc.Base.QualityGates -Parameters @{ Root = $script:widgetRoot; Item = (Join-Path $script:widgetRoot 'docs') } {
            param($Root, $Item)
            Get-LinkScope -RepositoryRoot $Root -Path $Item
        }
        $scope | Should -Be @('docs/widget.md')
    }

    It 'leaves out a file .gitattributes marks a contract asset' -Tag 'ADR-REPO-CONTRACT#6' {
        $contractFolder = Join-Path $script:widgetRoot 'contracts/widget/0.0.0/Gadget'
        [System.IO.Directory]::CreateDirectory($contractFolder) | Out-Null
        [System.IO.File]::WriteAllText((Join-Path $contractFolder 'gadget.md'), '')
        Mock Get-GitAttributeValue {
            @{ 'contracts/widget/0.0.0/Gadget/gadget.md' = @{ 'catzc-contract' = 'set' } }
        } -ModuleName Catzc.Base.QualityGates
        $scope = InModuleScope Catzc.Base.QualityGates -Parameters @{ Root = $script:widgetRoot; Items = @((Join-Path $script:widgetRoot 'docs'), (Join-Path $script:widgetRoot 'contracts')) } {
            param($Root, $Items)
            Get-LinkScope -RepositoryRoot $Root -Path $Items
        }
        $scope | Should -Be @('docs/widget.md')
    }
}
