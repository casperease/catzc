# docs/references/automation/catzc-base-writers/private/Write-FramedLine.ps1.md

`automation/Catzc.Base.Writers/private/Write-FramedLine.ps1`

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
The shared render step behind Write-Header and Write-Footer. Each segment is { Text; Rule }: a Rule line
is a horizontal border (╭──╮, ╰──╯, a star row) that takes the per-character gradient of a rainbow plan;
a non-Rule line (a titled message) takes the plan's base colour. A solid (non-rainbow) plan colours every
line the one colour, and no colour renders the text as-is — both the pre-rainbow behaviour. The whole set
is emitted as a single Write-InformationColored call, so it is one information record as before.
```

## comment:2

Above `$rendered = foreach ($s in $Segment) {`.

```text
A rule line takes the per-character gradient; a titled line takes the base colour (the profile
side-grades to Base). The text is pre-coloured here, so it passes through the chokepoint with no
-ForegroundColor of its own.
```
