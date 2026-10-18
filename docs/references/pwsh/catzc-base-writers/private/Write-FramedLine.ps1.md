# automation/Catzc.Base.Writers/private/Write-FramedLine.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

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

## comment:1

Above `$rendered = foreach ($s in $Segment) {`, written with `#`.

```text
A rule line takes the per-character gradient; a titled line takes the base colour (the profile
side-grades to Base). The text is pre-coloured here, so it passes through the chokepoint with no
-ForegroundColor of its own.
```
