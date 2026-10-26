Describe 'Format-MarkdownTablePadding' -Tag 'L0', 'logic' {
    It 'pads every cell of a table to its column width, the separator row in dashes' {
        InModuleScope Catzc.Base.Docs {
            $text = "A widget.`n`n| Widget | Gadget |`n| --- | --- |`n| [spin](../../widgets/spin.md) | rests |`n`nAfter."
            $expected = "A widget.`n`n| Widget                        | Gadget |`n| ----------------------------- | ------ |`n" +
            "| [spin](../../widgets/spin.md) | rests  |`n`nAfter."
            Format-MarkdownTablePadding -Text $text | Should -BeExactly $expected
        }
    }

    It 'keeps an escaped pipe inside its cell and leaves a fenced pipe line alone' {
        InModuleScope Catzc.Base.Docs {
            $text = "| a \| b | c |`n| - | - |`n`n``````text`n|x|`n``````"
            $result = Format-MarkdownTablePadding -Text $text
            $result | Should -Match '(?m)^\| a \\\| b \| c   \|$'
            $result | Should -Match '(?m)^\|x\|$'
        }
    }
}
