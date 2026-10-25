# pwsh/Catzc.Base.Variants/types/GeneratedConfig.cs

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `public sealed class GeneratedConfig`, written with `//`.

```text
One module's declaration of what its generators write: each target a repository path or glob and the generator that writes it.
Every generating module keeps its own configs/generated.yml; Get-GeneratedTarget reads every owner beside rootconfig.yml.
```
