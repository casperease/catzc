# pwsh/Base.QualityGates/types/CommentEngine.cs

The engine that decides what moves from a source file's long comments to its comment page, and what the page then holds. It decides and
never writes: `Export` returns a `CommentFileResult` and the caller writes the files.

## Fresh page

`FreshPage` writes the opening of a page the exporter or the help move creates for the first time: its title and the line that says what it
holds, wrapped at the markdown width, so a new page is born formatted.
