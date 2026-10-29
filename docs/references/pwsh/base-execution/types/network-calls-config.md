# pwsh/Base.Execution/types/NetworkCallsConfig.cs

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading. Prose written above the first section survives every
later export.

## comment:1

Above `public sealed class NetworkCallsConfig`, written with `//`.

```text
The registry of every call site that can reach the network, keyed '<file>#<function or step>' ([ADR-AUTO-NET-SITEREGISTRY](/docs/drs/automation/network-calls.md#rule-adr-auto-net-siteregistry)), so one
file can hold sites of different classes, and the network patterns Test-NetworkCalls searches the code for ([ADR-AUTO-NET-REGISTRYGATE](/docs/drs/automation/network-calls.md#rule-adr-auto-net-registrygate)).
```

## comment:2

Above `public IReadOnlyList<string> skip { get; } = new[]`, written with `//`.

```text
Repository-relative path patterns, as PowerShell -like reads them, whose files the gate never searches: the tests mock their calls,
and docs, configs and contracts name a call without making it.
```
