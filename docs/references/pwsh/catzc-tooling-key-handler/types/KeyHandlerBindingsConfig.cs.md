# pwsh/Tooling.KeyHandler/types/KeyHandlerBindingsConfig.cs

The typed model of `configs/key-handler-bindings.yml`: the captured Windows PSReadLine bindings, a top-level sequence of
[KeyHandlerBinding](KeyHandlerBinding.cs.md) entries. The YAML has no top-level key, so the sequence is exposed as `bindings`.

## Validation

Constructing an instance maps and validates the parsed YAML, a non-empty sequence of well-formed entries, and collects every violation into
one throw, so a malformed capture fails at read time rather than mid-import.

## Registration

The type is registered in `pwsh/Base.Config/configs/configs.yml`, so `Get-Config -Config key-handler-bindings` returns this model.

## Source path

`SourcePath` returns the committed file `Save-PsReadLineKeyHandlerSet` captures into: the module's own config under the module root its
caller passes, since the folder drops the namespace the name carries
([DDR-TRACK-MODULENAMESPACE](../../../../drs/design/tracks.md#rule-ddr-track-modulenamespace)).
