---
catzc:
  derived:
    path: docs/references/automation/catzc-base-typessystem/private/Test-ConsoleReadyType.ps1.md
    kind: comment-page
    body_sha: "8f9dac776fd2"
    adrs: []
    links: []
---

# automation/Catzc.Base.TypesSystem/private/Test-ConsoleReadyType.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
PowerShell's "$x" and [string]$x call the type's own .NET ToString() and ignore an ETS ToString, so a type
reads well in pwsh only when it overrides ToString() — normally by delegating to
Catzc.Base.Objects.ConsoleText (`public override string ToString() => this.ToConsoleString();`), which every
DictionaryRecord inherits. A type that is never held as a value needs no override and passes: an enum (it
renders its name), an interface, a delegate, an abstract or static class, an Attribute, and an Exception (it
renders its message).
```
