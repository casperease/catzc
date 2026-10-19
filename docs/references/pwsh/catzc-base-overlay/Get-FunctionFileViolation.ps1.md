# automation/pwsh/Catzc.Base.Overlay/Get-FunctionFileViolation.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Returns every reason a .ps1 file is not one function, named for the file, that can be loaded anywhere.

### description

The one check of a function file's shape, read from its syntax tree, shared by the two places that load a function file away from the folder
it was written in: the build, which merges a module's function files into one file (the merge preconditions,
[ADR-PWSH-MANIFEST-BUNDLECARRIESMANIFESTS](../../../adr/automation/pwsh/dynamic-module-manifests.md#rule-adr-pwsh-manifest-bundlecarriesmanifests)),
and a consumer overlay, whose override file is loaded into a built module ([ADR-AUTO-OVERLAY](../../../adr/automation/consumer-overlay.md)).
A file passes when it parses; it defines exactly one function, named for the file, and nothing else at the top level (no param block, no
begin/process blocks, no other statement); it carries no `using` statement and no `#requires`; and it never reads $PSScriptRoot, which names
another folder once the file is loaded elsewhere
([ADR-AUTO-ASSETDEP-INTERNALASSETDEPENDENCY](../../../adr/automation/internal-asset-dependencies.md#rule-adr-auto-assetdep-internalassetdependency)).

### parameter `Path`

The file to check.

### parameter `RelativePath`

The file's name as the messages should show it (a repository- or overlay-relative path).

### parameter `ParsedScripts`

The call's shared parse of each script; a caller checking many files passes one so a file is parsed once.

### outputs

`[string]` One message per violation; nothing when the file passes.

### example 1

```powershell
Get-FunctionFileViolation -Path ./pwsh/Catzc.Base.Widget/Get-Widget.ps1 -RelativePath automation/pwsh/Catzc.Base.Widget/Get-Widget.ps1
```
