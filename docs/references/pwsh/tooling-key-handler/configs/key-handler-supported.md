# pwsh/Tooling.KeyHandler/configs/key-handler-supported.yml

The allow-list of PSReadLine functions supported on Linux. `Import-PsReadLineKeyHandlerSet` filters the captured
[bindings](key-handler-bindings.yml.md) against it, so a Windows-only function is skipped rather than throwing.

## Keys

`functions` is the only key: a non-empty list of non-blank function names. The typed model is
[KeyHandlerSupportedConfig](../types/KeyHandlerSupportedConfig.cs.md), read through `Get-Config -Config key-handler-supported`.
