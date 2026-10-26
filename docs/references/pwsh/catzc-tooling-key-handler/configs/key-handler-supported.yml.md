# pwsh/Tooling.KeyHandler/configs/key-handler-supported.yml

<!-- cspell:ignore begining -->

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `functions:`, written with `#`.

```text
PSReadLine functions supported on Linux — the allow-list Import-PsReadLineKeyHandlerSet filters
key-handler-bindings against, so a Windows-only function is skipped rather than throwing.
```
