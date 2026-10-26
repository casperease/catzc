Describe 'Format-LongMarkdownLines' -Tag 'L0', 'logic' {
    BeforeAll {
        function script:Invoke-Wrap {
            param([string] $Text, [int] $Width)
            InModuleScope Catzc.Base.Docs -Parameters @{ Text = $Text; Width = $Width } {
                param($Text, $Width)
                Format-LongMarkdownLines -Text $Text -Width $Width
            }
        }
    }

    It 'leaves a text whose lines all fit exactly as it is' {
        $text = "# widget`n`nwidget gadget`nwidget gadget`n`n- widget`n  gadget`n"
        Invoke-Wrap $text 20 | Should -Be $text
    }

    It 're-wraps a paragraph that has a line past the width' {
        Invoke-Wrap "widget gadget widget`ngadget" 14 | Should -Be "widget gadget`nwidget gadget"
    }

    It 'wraps a list item under its marker and a quote under its quote mark' {
        Invoke-Wrap '- widget gadget widget gadget' 16 | Should -Be "- widget gadget`n  widget gadget"
        Invoke-Wrap '> widget gadget widget gadget' 16 | Should -Be "> widget gadget`n> widget gadget"
    }

    It 'never touches a fence, a table or a heading' {
        $text = "# widget gadget widget gadget`n`n| widget | gadget widget gadget |`n`n``````text`nwidget gadget widget gadget`n``````"
        Invoke-Wrap $text 10 | Should -Be $text
    }

    It 'keeps a paragraph with a hard line break as written' {
        $text = "widget gadget widget  `n" + 'gadget'
        Invoke-Wrap $text 10 | Should -Be $text
    }
}
