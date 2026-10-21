# pwsh/Catzc.Base.CodeMeta/types/PropertyHead.cs

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `public string WithFacts(IDictionary immutable, IDictionary edges)`, written with `//`.

```text
The whole text again with the property written from the place facts and the edges in the order given and the authored config kept; nothing to write removes it
(ADR-REPO-FILEMETA-JSONCARRIER). A text that is no object, or whose property holds something foreign, comes back as it was.
```

## comment:2

Above `using System;`, written with `//`.

```text
Reads and writes a file's meta block, kept as the text of one property, as pure text work on strings. A JSON file keeps it as an ignored
top-level member. An XML file whose root is an MSBuild project keeps it as a CDATA property of a labelled first PropertyGroup, because
an XML comment cannot hold the `---` fence and a loader may refuse a processing instruction.
```
