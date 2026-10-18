# pwsh/Catzc.Base.Git/private/Format-GitIgnoreSection.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Renders one gitignore section — its titled, explained comment block followed by its pattern lines.

### description

The per-section pretty-printer behind New-GitIgnore: a rule line carrying the section's title, the wrapped `why` explanation as comment
lines, then each pattern verbatim — with any `note` rendered as its own comment line directly above its pattern. git has no trailing
comments: a '#' after a pattern becomes part of the pattern, so a noted pattern written on one line would match nothing. Pure formatting;
the pattern text is never rewritten.

### parameter `Title`

The section's heading.

### parameter `Why`

The section's explanation (wrapped to the comment width).

### parameter `Pattern`

The section's resolved pattern entries ({ pattern; note } objects, in order).

### outputs

`[string[]]` The section's rendered lines (no trailing blank — the caller owns section separation).
