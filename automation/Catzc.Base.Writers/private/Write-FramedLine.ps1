<#
---
catzc:
  immutable:
    path: automation/Catzc.Base.Writers/private/Write-FramedLine.ps1
    folder: private
    name: write-framed-line
    filetype: ps1
    kind: function
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Base.Writers
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: private
  edges:
    page: docs/references/automation/catzc-base-writers/private/Write-FramedLine.ps1.md
  config:
    synopsis: |-
      Emits an ordered set of header/footer lines through the writer chokepoint, applying a colour plan — a
      solid colour, or a rainbow gradient on the rule (border) lines with the base colour on any titled line.
    description: |-
      The shared render step behind Write-Header and Write-Footer. Each segment is { Text; Rule }: a Rule line
      is a horizontal border (╭──╮, ╰──╯, a star row) that takes the per-character gradient of a rainbow plan;
      a non-Rule line (a titled message) takes the plan's base colour. A solid (non-rainbow) plan colours every
      line the one colour, and no colour renders the text as-is — both the pre-rainbow behaviour. The whole set
      is emitted as a single Write-InformationColored call, so it is one information record as before.
    parameters:
      Segment: 'Ordered line segments: @( @{ Text = ''...''; Rule = $true|$false }, ... ), in render order.'
      Color: 'The colour plan from Resolve-WriterColor: { HasColor; IsRainbow; Rainbow; Base }.'
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
