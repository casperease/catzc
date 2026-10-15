Describe 'Get-CodeMetaState' -Tag 'L0', 'logic', 'ADR-REPO-CODEMETA#1' {
    BeforeAll {
        $script:form = [Catzc.Base.CodeMeta.HeadForm]::ForLine('//')
    }

    It 'reports the head''s keys and facts in the order written, with what stands around it' {
        $state = Get-CodeMetaState -Text "// catzc:`n//   path: a/b.cs`n//   module: Widget`n`n// The insight.`nclass Gadget { }`n" -Form $script:form
        $state.HasHead | Should -BeTrue
        $state.Keys | Should -Be @('path', 'module')
        $state.Facts['path'] | Should -Be 'a/b.cs'
        $state.Facts['module'] | Should -Be 'Widget'
        $state.Before | Should -BeExactly ''
        $state.Rest | Should -BeExactly "// The insight.`nclass Gadget { }`n"
        $state.NewLine | Should -BeExactly "`n"
    }

    It 'reports a text without a head as having none, leaving the whole text as the rest' {
        $text = "class Gadget { }`r`n"
        $state = Get-CodeMetaState -Text $text -Form $script:form
        $state.HasHead | Should -BeFalse
        @($state.Keys).Count | Should -Be 0
        $state.Rest | Should -BeExactly $text
        $state.NewLine | Should -BeExactly "`r`n"
    }

    It 'reports an empty text' {
        (Get-CodeMetaState -Text '' -Form $script:form).HasHead | Should -BeFalse
    }
}
