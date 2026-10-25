Describe 'Format-CodeMetaHead' -Tag 'L0', 'logic', 'ADR-REPO-FILEMETA-IMPRINTEDPARTS' {
    BeforeAll {
        $script:form = [Catzc.Base.CodeMeta.HeadForm]::ForBlock('/*', '*/')
    }

    It 'imprints the facts above the text, and a second run changes nothing' {
        $facts = [ordered]@{ path = 'a/Get-Gadget.ps1'; module = 'Widget' }
        $once = Format-CodeMetaHead -Text "function Get-Gadget { }`n" -Form $script:form -Immutable $facts -Edges ([ordered]@{ test = 'a/Get-Gadget.Tests.ps1' })
        $once | Should -BeExactly "/*`n---`ncatzc:`n  test: a/Get-Gadget.Tests.ps1`n  immutable:`n    path: a/Get-Gadget.ps1`n    module: Widget`n---`n*/`n`nfunction Get-Gadget { }`n"
        Format-CodeMetaHead -Text $once -Form $script:form -Immutable $facts -Edges ([ordered]@{ test = 'a/Get-Gadget.Tests.ps1' }) | Should -BeExactly $once
    }

    It 'removes the head when no facts are given' {
        $text = "/*`n---`ncatzc:`n  immutable:`n    path: a/b.ps1`n---`n*/`n`nfunction Get-Gadget { }`n"
        Format-CodeMetaHead -Text $text -Form $script:form | Should -BeExactly "function Get-Gadget { }`n"
    }

    It 'imprints into an empty text' {
        Format-CodeMetaHead -Text '' -Form $script:form -Immutable ([ordered]@{ path = 'a/b.ps1' }) | Should -BeExactly "/*`n---`ncatzc:`n  immutable:`n    path: a/b.ps1`n---`n*/`n"
    }
}
