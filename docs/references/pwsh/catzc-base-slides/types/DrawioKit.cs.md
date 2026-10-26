# pwsh/Base.Slides/types/DrawioKit.cs

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its
comment sat above (Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `public string RendererModule() => ModuleOf(RendererFile);`, written with `//`.

```text
The renderer as the module `python -m` runs, read from the manifest when a caller runs it. A method, not a property: PowerShell
swallows a property getter's exception, so a missing manifest would reach the command line as an empty module name.
```
