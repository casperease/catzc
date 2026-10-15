Describe 'ConvertTo-HelpHeadConfig' -Tag 'L0', 'logic', 'ADR-REPO-HELP#1' {
    BeforeAll {
        $script:form = [Catzc.Base.CodeMeta.HeadForm]::ForBlock('<#', '#>')
        $script:head = "<#`n---`ncatzc:`n  derived:`n    path: automation/Catzc.Widget/Get-Gadget.ps1`n    kind: public-function`n---`n#>`n`n"
        $script:convert = {
            param([string] $Text)
            InModuleScope Catzc.Base.QualityGates -Parameters @{ Text = $Text; Form = $script:form } {
                param($Text, $Form)
                ConvertTo-HelpHeadConfig -Text $Text -Form $Form
            }
        }
        $script:function = "function Get-Gadget {`n    [CmdletBinding()]`n    param(`n        [string] `$Name`n    )`n}`n"
    }

    It 'moves every help section into the config part of the head and removes the help block' {
        $help = @(
            '<#'
            '.SYNOPSIS'
            '    Returns a gadget.'
            '.DESCRIPTION'
            '    A gadget is a widget: with a colon.'
            '    Second line.'
            '.PARAMETER Name'
            "    The gadget's name."
            '.OUTPUTS'
            '    [string] The name.'
            '.EXAMPLE'
            '    Get-Gadget -Name a'
            '#>'
        ) -join "`n"
        $result = & $script:convert ($script:head + $help + "`n" + $script:function)
        $result.Problems | Should -BeNullOrEmpty
        $expected = (@(
                '<#'
                '---'
                'catzc:'
                '  derived:'
                '    path: automation/Catzc.Widget/Get-Gadget.ps1'
                '    kind: public-function'
                '  config:'
                '    synopsis: Returns a gadget.'
                '    description: |-'
                '      A gadget is a widget: with a colon.'
                '      Second line.'
                '    parameters:'
                "      Name: The gadget's name."
                "    outputs: '[string] The name.'"
                '    examples:'
                '      - Get-Gadget -Name a'
                '---'
                '#>'
                ''
            ) -join "`n") + "`n" + $script:function
        $result.Text | Should -BeExactly $expected
    }

    It 'comes back as it was when the file has no help block, and a second run changes nothing' {
        $text = $script:head + $script:function
        (& $script:convert $text).Text | Should -BeExactly $text

        $once = (& $script:convert ($script:head + "<#`n.SYNOPSIS`n    Returns a gadget.`n.PARAMETER Name`n    The name.`n#>`n" + $script:function)).Text
        (& $script:convert $once).Text | Should -BeExactly $once
    }

    It 'reports a parameter with no section and a section for a parameter the function does not declare' {
        $result = & $script:convert ($script:head + "<#`n.SYNOPSIS`n    Returns a gadget.`n.PARAMETER Other`n    The other.`n#>`n" + $script:function)
        $result.Problems | Should -Contain 'the parameter Other is documented but the function declares no such parameter'
        $result.Problems | Should -Contain 'the parameter Name is declared but has no documentation'
    }

    It 'leaves a file with no head alone and says so' {
        $text = "<#`n.SYNOPSIS`n    Returns a gadget.`n#>`n" + $script:function
        $result = & $script:convert $text
        $result.Text | Should -BeExactly $text
        $result.Problems | Should -Be @('the file has no meta head to hold the help keys')
    }

    It 'keeps the config lines an author wrote and refuses a head that already holds help keys' {
        $authored = $script:head.Replace("---`n#>", "  config:`n    note: kept`n---`n#>")
        $result = & $script:convert ($authored + "<#`n.SYNOPSIS`n    Returns a gadget.`n.PARAMETER Name`n    The name.`n#>`n" + $script:function)
        $result.Text | Should -BeLike '*  config:*    note: kept*    synopsis: Returns a gadget.*'

        $twice = & $script:convert ($result.Text.Replace("function Get-Gadget", "<#`n.SYNOPSIS`n    Again.`n#>`nfunction Get-Gadget"))
        $twice.Problems | Should -Be @('the head already holds help keys, so the help block is a second copy')
    }
}
