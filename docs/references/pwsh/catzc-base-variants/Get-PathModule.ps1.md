# pwsh/Catzc.Base.Variants/Get-PathModule.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Returns the module a repository-relative path is placed in, and its module type, when it is placed in one.

### description

The module types of the module-types registry say where modules are placed and how a path names its module
([DDR-TRACK-ONETECHSTACK](../../../adr/design/tracks.md#rule-ddr-track-onetechstack)): a PowerShell module is a folder under
automation or one psm1 file under pwsh/.internal, a settings module is a tool's dot-folder, a pipeline module is the folder that holds
pipelines, and a Python, Go or Bash module is its track folder. The first module type to place a path names its module, so
`pwsh/.internal/tests/Get-Foo.Tests.ps1` is in the module `Catzc.Internal.Tests`. A path no module type places, such as a file directly in
the root or a documentation page, is in no module: nothing is returned.

### parameter `Path`

A repository-relative path ('/' or '\' separated).

### outputs

`[Catzc.Base.Variants.PathModule]` The module (name) and its module type (type), or nothing.

### example 1

```powershell
(Get-PathModule 'pwsh/Catzc.Base.Variants/Get-Track.ps1').name   # -> Catzc.Base.Variants
```

### example 2

```powershell
(Get-PathModule '.claude/agents/x.md').type                           # -> settings
```
