# pwsh/Tooling.KeyHandler/configs/key-handler-bindings.yml

The Windows PSReadLine key bindings, captured by `Save-PsReadLineKeyHandlerSet` and replayed on Linux by `Import-PsReadLineKeyHandlerSet`.
It is a top-level sequence of `key` and `function` entries, and only those two keys are consumed.

## Reading it

`Get-Config -Config key-handler-bindings` returns the typed model, built by
[KeyHandlerBindingsConfig](../types/KeyHandlerBindingsConfig.cs.md). The import filters the entries against
[key-handler-supported.yml](key-handler-supported.yml.md), so a binding for a Windows-only function is skipped.
