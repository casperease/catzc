# pwsh/Catzc.Base.QualityGates/types/FileHeadPolicy.cs

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `public sealed class FileHeadPolicy`, written with `//`.

```text
The head policy of the meta-kind registry: whether a file of a class must, may or must not carry a meta block
([ADR-REPO-FILEMETA-HEADPOLICY](/docs/drs/repository/file-meta.md#rule-adr-repo-filemeta-headpolicy)).
```

## comment:2

Above `public HeadPolicy For(string fileClass, bool codeCarrier = false, bool...`, written with `//`.

```text
A class entry decides first; an authored file in a code carrier takes the file-heads variant
([ADR-REPO-VARIANT-FILEHEADS](/docs/drs/repository/repo-variants.md#rule-adr-repo-variant-fileheads)), else the default.
```
