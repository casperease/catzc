# pwsh/Tooling.Claude/types/EditorClaim.cs

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading. Prose written above the first section survives every
later export.

## comment:1

Above `public sealed class EditorClaim`, written with `//`.

```text
One session's claim to be the one editor of a shared config until it expires. The run lock is a mutex its process lets go on exit, so
it cannot span an edit across tool calls; the claim is a file instead, one per claimed path, beside the run lock's queue folder.
```

## comment:2

Above `public static EditorClaim Claim(string folder, string path, string session,...`, written with `//`.

```text
Claims the path for the session until expires, and returns the claim that holds the path afterwards: this session's, renewed when
it held it already, or another session's live claim, which is left alone.
```

## comment:3

Above `public static EditorClaim Release(string folder, string path, string session,...`, written with `//`.

```text
Releases the session's claim on the path and returns null, or returns another session's live claim, which is left alone. A path
with no live claim releases as nothing to do.
```
