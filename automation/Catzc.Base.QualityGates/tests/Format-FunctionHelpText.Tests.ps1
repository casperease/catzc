Describe 'Format-FunctionHelpText' -Tag 'L0', 'logic', 'ADR-REPO-HELP#1', 'ADR-REPO-HELP#2', 'ADR-REPO-HELP#3', 'ADR-REPO-HELP#4' {
    BeforeAll {
        $script:format = {
            param([string] $Text)
            Format-FunctionHelpText -Text $Text
        }
        $script:conforming = @'
<#
.SYNOPSIS
    Turns a widget into a gadget.
.DESCRIPTION
    The gadget keeps the widget's colour.
    [ADR-WIDGET-COG#1](/docs/adr/widget/cog.md#rule-adr-widget-cog1),
    [ADR-WIDGET-GADGET#2](/docs/adr/widget/gadget.md#rule-adr-widget-gadget2)
.PARAMETER Widget
    The widget to turn.
.OUTPUTS
    [string] The gadget.
.EXAMPLE
    ConvertTo-Gadget -Widget 'cog'
#>
function ConvertTo-Gadget {
    [OutputType([string])]
    param(
        [string] $Widget
    )
    $Widget
}
'@
        $script:run = {
            param([string] $Text)
            InModuleScope Catzc.Base.QualityGates -Parameters @{ Text = $Text } {
                param($Text)
                Format-FunctionHelpText -Text $Text
            }
        }
    }

    It 'leaves a help block that is already in the normal form exactly as it is' {
        $result = & $script:run $script:conforming
        $result.Text | Should -BeExactly $script:conforming
        $result.Problems | Should -BeNullOrEmpty
    }

    It 'restores the section order and keeps each section text' {
        $text = $script:conforming.Replace(".OUTPUTS`n    [string] The gadget.`n", '').Replace(".PARAMETER Widget`n    The widget to turn.`n", ".OUTPUTS`n    [string] The gadget.`n.PARAMETER Widget`n    The widget to turn.`n")
        $text | Should -Not -BeExactly $script:conforming
        (& $script:run $text).Text | Should -BeExactly $script:conforming
    }

    It 'moves a parenthesised synopsis citation to the sorted, de-duplicated tail of the description' {
        $text = @'
<#
.SYNOPSIS
    Turns a widget into a gadget
    ([ADR-WIDGET-GADGET#2](/docs/adr/widget/gadget.md#rule-adr-widget-gadget2)).
.DESCRIPTION
    The gadget keeps the widget's colour.
    [ADR-WIDGET-GADGET#2](/docs/adr/widget/gadget.md#rule-adr-widget-gadget2),
    [ADR-WIDGET-COG#1](/docs/adr/widget/cog.md#rule-adr-widget-cog1)
    [comment:1](/docs/references/widget.md#comment1)
#>
function ConvertTo-Gadget {
    param()
}
'@
        $result = & $script:run $text
        $result.Text | Should -BeExactly @'
<#
.SYNOPSIS
    Turns a widget into a gadget.
.DESCRIPTION
    The gadget keeps the widget's colour.
    [ADR-WIDGET-COG#1](/docs/adr/widget/cog.md#rule-adr-widget-cog1),
    [ADR-WIDGET-GADGET#2](/docs/adr/widget/gadget.md#rule-adr-widget-gadget2)
    [comment:1](/docs/references/widget.md#comment1)
#>
function ConvertTo-Gadget {
    param()
}
'@
        $result.Problems | Should -BeNullOrEmpty
    }

    It 'drops an inline comment equal to its section and turns one with no section into the section' {
        $text = @'
<#
.SYNOPSIS
    Turns a widget into a gadget.
.PARAMETER Widget
    The widget to turn.
#>
function ConvertTo-Gadget {
    param(
        # The widget to turn.
        [string] $Widget,

        # The colour the gadget takes.
        [string] $Colour
    )
}
'@
        $result = & $script:run $text
        $result.Text | Should -BeExactly @'
<#
.SYNOPSIS
    Turns a widget into a gadget.
.PARAMETER Widget
    The widget to turn.
.PARAMETER Colour
    The colour the gadget takes.
#>
function ConvertTo-Gadget {
    param(
        [string] $Widget,

        [string] $Colour
    )
}
'@
        $result.Problems | Should -BeNullOrEmpty
    }

    It 'reports, and leaves alone, an inline comment that differs from its section' {
        $text = @'
<#
.SYNOPSIS
    Turns a widget into a gadget.
.PARAMETER Widget
    The widget to turn.
#>
function ConvertTo-Gadget {
    param(
        # Something else entirely.
        [string] $Widget
    )
}
'@
        $result = & $script:run $text
        $result.Text | Should -BeExactly $text
        $result.Problems | Should -HaveCount 1
        $result.Problems[0] | Should -BeLike 'parameter Widget: the inline comment and the .PARAMETER section differ*'
    }

    It 'reports a parameter with no section, a section with no parameter and a type that disagrees with OutputType' {
        $text = @'
<#
.SYNOPSIS
    Turns a widget into a gadget.
.PARAMETER Cog
    A cog the function does not take.
.OUTPUTS
    [int] The gadget.
#>
function ConvertTo-Gadget {
    [OutputType([string])]
    param(
        [string] $Widget
    )
}
'@
        $result = & $script:run $text
        $result.Text | Should -BeExactly $text
        $result.Problems | Should -HaveCount 3
        ($result.Problems -join '|') | Should -BeLike '*names no parameter*'
        ($result.Problems -join '|') | Should -BeLike '*parameter Widget has no .PARAMETER section*'
        ($result.Problems -join '|') | Should -BeLike '*.OUTPUTS documents [[]int[]] but [[]OutputType[]] declares*'
    }

    It 'reads a generic type in .OUTPUTS as the same type as the one OutputType declares, namespaces aside' {
        $text = @'
<#
.SYNOPSIS
    Lists the widgets.
.OUTPUTS
    [System.Collections.Generic.List[object]] The widgets.
#>
function Get-Gadget {
    [OutputType([System.Collections.Generic.List[object]])]
    param()
}
'@
        $result = & $script:run $text
        $result.Text | Should -BeExactly $text
        $result.Problems | Should -BeNullOrEmpty
    }

    It 'does not read a rule id in registry form, quoted as an example, as a citation' {
        # Built from parts, so no tool that rewrites citation spellings in text touches the example.
        $registryId = 'ADR-WIDGET-GADGET' + ':3'
        $text = (@('<#', '.SYNOPSIS', "    Lists every rule id (registry form, e.g. '$registryId').", '.DESCRIPTION', '    The ids come back in colon form.', '#>', 'function Get-Gadget {', '    param()', '}') -join "`n") + "`n"
        $result = & $script:run $text
        $result.Text | Should -BeExactly $text
        $result.Problems | Should -BeNullOrEmpty
    }

    It 'leaves a file with no help block, and a file that does not parse, untouched' {
        foreach ($text in @("function ConvertTo-Gadget {`n    param()`n}`n", "function ConvertTo-Gadget {`n")) {
            $result = & $script:run $text
            $result.Text | Should -BeExactly $text
            $result.Problems | Should -BeNullOrEmpty
        }
    }

    It 'keeps the line endings of the file it was given' {
        $crlf = $script:conforming.Replace("`n", "`r`n").Replace(".PARAMETER Widget`r`n    The widget to turn.`r`n.OUTPUTS`r`n    [string] The gadget.`r`n", ".OUTPUTS`r`n    [string] The gadget.`r`n.PARAMETER Widget`r`n    The widget to turn.`r`n")
        $result = & $script:run $crlf
        $result.Text | Should -Not -Match '(?<!\r)\n'
        $result.Text.IndexOf('.PARAMETER') | Should -BeLessThan $result.Text.IndexOf('.OUTPUTS')
    }
}
