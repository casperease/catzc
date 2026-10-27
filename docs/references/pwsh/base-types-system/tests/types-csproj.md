# pwsh/Base.TypesSystem/tests/Types.Csproj.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading. Prose written above the first section survives every
later export.

## comment:1

Above `Describe 'Catzc.Types.csproj — editor build stamps, never warns on loaded types'`, written with `#`.

```text
L1: runs dotnet msbuild over the template's own stamp target, so the cases follow the one living version of the check. The loader
answers from the real tree; only its shadow root moves, through the environment Get-TypesShadowRoot reads.
```
