# pwsh/Catzc.Base.Variants/types/TrackTypeEntry.cs

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `public IReadOnlyList<string> gitAttributes { get; }`, written with `//`.

```text
The git attributes every file under a place of a track of this type gets in the generated .gitattributes, and why;
empty and null when the type gives none.
```
