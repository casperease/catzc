# pwsh/Catzc.Base.Objects/types/NameCase.cs

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `public static string ToNormal(string caseName, string name, string normalForm)`, written with `//`.

```text
A name in a case as its normal form: each namespace segment joined in the normal form's case, the segments by '.'; snake's
leading and trailing underscores stay outside the case, around the normal form.
```
