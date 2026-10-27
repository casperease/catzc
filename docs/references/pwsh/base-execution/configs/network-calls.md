# pwsh/Base.Execution/configs/network-calls.yml

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading. Prose written above the first section survives every
later export.

## comment:1

Above `patterns:`, written with `#`.

```text
Every call site that can reach the network, keyed '<file>#<function or pipeline job>' (ADR-AUTO-NET-SITEREGISTRY); a default-path site is an open violation.
The network-call shapes Test-NetworkCalls searches the tracked code for, one regular expression per line of code (ADR-AUTO-NET-REGISTRYGATE).
```
