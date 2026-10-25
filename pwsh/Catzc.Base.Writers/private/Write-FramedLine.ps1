<#
---
catzc:
  docs: "../../../docs/references/pwsh/catzc-base-writers/private/Write-FramedLine.ps1.md"
  header: "generated"
---
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
        # Coloured here: a rule takes the gradient, a titled line its base colour, so no colour is passed on.
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
