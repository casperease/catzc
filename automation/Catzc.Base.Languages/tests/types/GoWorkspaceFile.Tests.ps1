<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Languages/tests/types/GoWorkspaceFile.Tests.ps1
    kind: test
    language: powershell
    filekind: ps1
    track: automation
    module: Catzc.Base.Languages
    relatives:
      source: automation/Catzc.Base.Languages/types/GoWorkspaceFile.cs
---
#>

Describe 'GoWorkspaceFile' -Tag 'L0', 'logic' {
    It 'carries its target and content' {
        $file = [Catzc.Base.Languages.GoWorkspaceFile]::new('go/tests/catzc-widget/go.mod', "module widget`n")
        $file.Target | Should -Be 'go/tests/catzc-widget/go.mod'
        $file.Content | Should -Be "module widget`n"
    }

    It 'throws on a target that is not repository-relative and forward-slashed' -ForEach @('go\tests\go.mod', '/go.work', '') {
        { [Catzc.Base.Languages.GoWorkspaceFile]::new($_, "go 1.24`n") } | Should -Throw '*repository-relative, forward-slashed*'
    }

    It 'throws on content that is not LF with a trailing newline' -ForEach @("go 1.24`r`n", 'go 1.24') {
        { [Catzc.Base.Languages.GoWorkspaceFile]::new('go.work', $_) } | Should -Throw '*LF line endings*'
    }
}
