# catzc:
#   path: automation/Catzc.Base.Writers/private/Write-FramedLine.ps1
#   module: Catzc.Base.Writers
#   visibility: private

<#
.SYNOPSIS
    Emits an ordered set of header/footer lines through the writer chokepoint, applying a colour plan — a
    solid colour, or a rainbow gradient on the rule (border) lines with the base colour on any titled line.
.DESCRIPTION
    All lines go out as one Write-InformationColored call, so a header stays a single information record.
    [comment:1](/docs/references/automation/catzc-base-writers/private/Write-FramedLine.ps1.md#comment1)
.PARAMETER Segment
    Ordered line segments: @( @{ Text = '...'; Rule = $true|$false }, ... ), in render order.
.PARAMETER Color
    The colour plan from Resolve-WriterColor: { HasColor; IsRainbow; Rainbow; Base }.
#>
function Write-FramedLine {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [object[]] $Segment,

        [Parameter(Mandatory)]
        [hashtable] $Color
    )

    if ($Color.IsRainbow) {
        # The text is coloured here, so it reaches the chokepoint with no -ForegroundColor of its own.
        # [comment:2](/docs/references/automation/catzc-base-writers/private/Write-FramedLine.ps1.md#comment2)
        $rendered = foreach ($s in $Segment) {
            if ($s.Rule) {
                $Color.Rainbow.Wrap($s.Text)
            }
            else {
                [Catzc.Base.Writers.Ansi]::Wrap($s.Text, $Color.Base)
            }
        }
        Write-InformationColored (@($rendered) -join "`n")
        return
    }

    $text = @($Segment | ForEach-Object { $_.Text }) -join "`n"
    if ($Color.HasColor) {
        Write-InformationColored $text -ForegroundColor $Color.Base
    }
    else {
        Write-InformationColored $text
    }
}
