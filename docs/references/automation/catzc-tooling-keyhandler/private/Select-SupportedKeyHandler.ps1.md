# automation/Catzc.Tooling.KeyHandler/private/Select-SupportedKeyHandler.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Classifies captured key bindings by whether their function is supported on the target platform.

### description

The pure decision core of Import-PSReadLineKeyHandlerSet, separated so it is deterministic and testable without a real PSReadLine session
(see [ADR-AUTO-TEST](../../../../adr/automation/test-automation.md) push-left). Given the captured bindings and the allow-list of supported
function names, returns one record per binding carrying its Key, Function, and a Supported flag — the caller applies the supported ones and
logs the rest. Reads the inputs only; never mutates the cached config objects
([ADR-AUTO-CACHE#5](../../../../adr/automation/caching.md#rule-adr-auto-cache5)).

### parameter `Binding`

The captured bindings — a sequence of { key, function } mappings (from key-handler-bindings.yml).

### parameter `SupportedFunction`

The allow-list of supported function names (from key-handler-supported.yml `functions`).

### example 1

```powershell
Select-SupportedKeyHandler -Binding $bindings -SupportedFunction $supported | Where-Object Supported
```
