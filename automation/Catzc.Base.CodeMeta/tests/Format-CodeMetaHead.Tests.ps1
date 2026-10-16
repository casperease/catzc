<#
---
catzc:
  derived:
    path: automation/Catzc.Base.CodeMeta/tests/Format-CodeMetaHead.Tests.ps1
    kind: test
    language: powershell
    filetype: ps1
    track: automation
    module: Catzc.Base.CodeMeta
    moduletype: pwsh-folder-module
    bundle: azure
    adrs:
      - ADR-REPO-FILEMETA#3
---
#>

Describe 'Format-CodeMetaHead' -Tag 'L0', 'logic', 'ADR-REPO-FILEMETA#3' {
    BeforeAll {
        $script:form = [Catzc.Base.CodeMeta.HeadForm]::ForBlock('/*', '*/')
    }

    It 'imprints the facts above the text, and a second run changes nothing' {
        $facts = [ordered]@{ path = 'a/Get-Gadget.ps1'; module = 'Widget' }
        $once = Format-CodeMetaHead -Text "function Get-Gadget { }`n" -Form $script:form -Fact $facts
        $once | Should -BeExactly "/*`n---`ncatzc:`n  derived:`n    path: a/Get-Gadget.ps1`n    module: Widget`n---`n*/`n`nfunction Get-Gadget { }`n"
        Format-CodeMetaHead -Text $once -Form $script:form -Fact $facts | Should -BeExactly $once
    }

    It 'removes the head when no facts are given' {
        $text = "/*`n---`ncatzc:`n  derived:`n    path: a/b.ps1`n---`n*/`n`nfunction Get-Gadget { }`n"
        Format-CodeMetaHead -Text $text -Form $script:form | Should -BeExactly "function Get-Gadget { }`n"
    }

    It 'imprints into an empty text' {
        Format-CodeMetaHead -Text '' -Form $script:form -Fact ([ordered]@{ path = 'a/b.ps1' }) | Should -BeExactly "/*`n---`ncatzc:`n  derived:`n    path: a/b.ps1`n---`n*/`n"
    }
}
