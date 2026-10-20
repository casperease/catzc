# pwsh/Catzc.Base.Flow/types/RungsConfig.cs

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `public static readonly IReadOnlyList<Rung> DefaultRungs = Array.AsReadOnly(new[]`, written with `//`.

```text
The ladder when the file names none: main-uat, release-uat behind RC, pre-prod behind RBC, prod behind the prod approval gate.
This is the one place a rung's environment is mapped, so remapping one (main-uat from dev to its own) is a one-line edit here.
```
