# pwsh/Base.QualityGates/types/FunctionHelp.cs

Turns the plain help text of a function, written inside YAML, into Markdown that means the same, so a formatter or a linter reads what the
author wrote.

## Markdown

`Markdown` keeps lists at the margin, fences aligned layouts verbatim, and puts a placeholder, glob or bracket token in a code span.
