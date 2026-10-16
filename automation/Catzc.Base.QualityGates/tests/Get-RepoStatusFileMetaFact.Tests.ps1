<#
---
catzc:
  immutable:
    path: automation/Catzc.Base.QualityGates/tests/Get-RepoStatusFileMetaFact.Tests.ps1
    folder: tests
    name: get-repo-status-file-meta-fact-tests
    filetype: ps1
    kind: test
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Base.QualityGates
    moduletype: pwsh-folder
    catzc_bundle: azure
---
#>

Describe 'Get-RepoStatusFileMetaFact' -Tag 'L0', 'logic' {
    BeforeAll {
        function script:Get-Fact {
            param([string] $Class, [hashtable] $Raw)
            $kind = [Catzc.Base.QualityGates.FileMetaConfig]::new(@{ kinds = [ordered]@{ 'repo-status' = $Raw } }).kinds[0]
            InModuleScope Catzc.Base.QualityGates -Parameters @{ Kind = $kind; Class = $Class } {
                param($Kind, $Class)
                Mock Get-FileKind { [pscustomobject]@{ Class = $Class } }
                Get-RepoStatusFileMetaFact -State ([pscustomobject]@{}) -Path 'widget/file.md' -Kind $Kind
            }
        }
    }

    It 'is locked for a class the locked_classes setting lists' {
        $fact = Get-Fact -Class 'widget' -Raw @{ keys = @('repo_status'); settings = @{ locked_classes = @('widget') } }
        @($fact.Keys) | Should -Be @('repo_status')
        $fact['repo_status'] | Should -BeExactly 'locked'
    }

    It 'is clean for any other class' {
        $fact = Get-Fact -Class 'gadget' -Raw @{ keys = @('repo_status'); settings = @{ locked_classes = @('widget') } }
        $fact['repo_status'] | Should -BeExactly 'clean'
    }

    It 'is clean when the kind lists no locked class' {
        $fact = Get-Fact -Class 'widget' -Raw @{ keys = @('repo_status') }
        $fact['repo_status'] | Should -BeExactly 'clean'
    }
}
