Describe 'Get-CodeMetaState' -Tag 'L0', 'logic', 'ADR-REPO-CODEMETA#1' {
    BeforeAll {
        $script:form = [Catzc.Base.CodeMeta.HeadForm]::ForBlock('/*', '*/')
    }

    It 'reports the head''s sections and keys in the order written, with what stands around it' {
        $state = Get-CodeMetaState -Text "/*`n---`ncatzc:`n  derived:`n    path: a/b.cs`n    module: Widget`n  config:`n    colour: red`n---`n*/`n`n// The insight.`nclass Gadget { }`n" -Form $script:form
        $state.HasHead | Should -BeTrue
        $state.Sections | Should -Be @('derived', 'config')
        $state.DerivedKeys | Should -Be @('path', 'module')
        $state.ConfigLines | Should -Be @('    colour: red')
        $state.Before | Should -BeExactly ''
        $state.Rest | Should -BeExactly "// The insight.`nclass Gadget { }`n"
        $state.NewLine | Should -BeExactly "`n"
    }

    It 'reports a text without a head as having none, leaving the whole text as the rest' {
        $text = "class Gadget { }`r`n"
        $state = Get-CodeMetaState -Text $text -Form $script:form
        $state.HasHead | Should -BeFalse
        @($state.DerivedKeys).Count | Should -Be 0
        $state.Rest | Should -BeExactly $text
        $state.NewLine | Should -BeExactly "`r`n"
    }

    It 'reports an empty text' {
        (Get-CodeMetaState -Text '' -Form $script:form).HasHead | Should -BeFalse
    }
}
