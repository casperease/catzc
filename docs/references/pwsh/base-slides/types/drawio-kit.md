# pwsh/Base.Slides/types/DrawioKit.cs

The handle on the draw.io kit folder: it locates the kit's files and config and names its renderer.

## The renderer module

`RendererModule()` returns the renderer as the module `python -m` runs, read from the manifest when a caller runs it. It is a method, not a
property: PowerShell swallows a property getter's exception, so a missing manifest would reach the command line as an empty module name.
