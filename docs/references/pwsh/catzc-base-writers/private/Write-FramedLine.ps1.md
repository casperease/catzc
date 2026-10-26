# pwsh/Base.Writers/private/Write-FramedLine.ps1

The private render step shared by the header and footer writers: it colours their lines by a colour plan and emits them as one record.

## help

### synopsis

Emits an ordered set of header/footer lines through the writer chokepoint, applying a colour plan — a solid colour, or a rainbow gradient on
the rule (border) lines with the base colour on any titled line.

### description

The shared render step behind Write-Header and Write-Footer. Each segment is { Text; Rule }: a Rule line is a horizontal border (╭──╮, ╰──╯,
a star row) that takes the per-character gradient of a rainbow plan; a non-Rule line (a titled message) takes the plan's base colour. A
solid (non-rainbow) plan colours every line the one colour, and no colour renders the text as-is — both the pre-rainbow behaviour. The whole
set is emitted as a single Write-InformationColored call, so it is one information record as before.

### parameter `Segment`

Ordered line segments: @( @{ Text = '...'; Rule = $true|$false }, ... ), in render order.

### parameter `Color`

The colour plan from Resolve-WriterColor: { HasColor; IsRainbow; Rainbow; Base }.

## Pre-coloured text

A rule line takes the per-character gradient and a titled line takes the base colour, the profile side-grading to its base. The text is
coloured here, so it passes through the chokepoint with no `-ForegroundColor` of its own.
