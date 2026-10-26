# pwsh/Tooling.KeyHandler/types/KeyHandlerBindingsConfig.cs

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `using System;`, written with `//`.

```text
The captured Windows PSReadLine key bindings, configs/key-handler-bindings.yml: a top-level SEQUENCE of
{ key, function } entries (KeyHandlerBinding), written by Save-PsReadLineKeyHandlerSet and replayed on Linux by
Import-PsReadLineKeyHandlerSet. The YAML has no top-level key, so the sequence is exposed as `bindings`.
Constructing an instance MAPS and VALIDATES the parsed YAML — a non-empty sequence of well-formed entries —
collecting every violation into one throw, so a malformed capture fails at read time rather than mid-import.
Registered in Catzc.Base.Config/configs/configs.yml (type: Catzc.Tooling.KeyHandler.KeyHandlerBindingsConfig), so
Get-Config -Config key-handler-bindings returns this typed model.
```

## comment:2

Above `public static string SourcePath(string moduleRoot)`, written with `//`.

```text
The committed source of the bindings, the file Save-PsReadLineKeyHandlerSet captures into: the module's own config under the module
root its caller passes, since the folder drops the namespace the name carries (DDR-TRACK-MODULENAMESPACE).
```
