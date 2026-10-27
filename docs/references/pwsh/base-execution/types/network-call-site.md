# pwsh/Base.Execution/types/NetworkCallSite.cs

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading. Prose written above the first section survives every
later export.

## comment:1

Above `public sealed class NetworkCallSite`, written with `//`.

```text
One function or pipeline step that can reach the network, keyed '<file>#<function or step>', with its class, its trigger and what keeps
it off a default path (ADR-AUTO-NET-SITEREGISTRY).
```
