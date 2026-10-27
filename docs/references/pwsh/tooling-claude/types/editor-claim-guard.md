# pwsh/Tooling.Claude/types/EditorClaimGuard.cs

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading. Prose written above the first section survives every
later export.

## comment:1

Above `public static class EditorClaimGuard`, written with `//`.

```text
The decision of the Assert-EditClaim hook: a file-editing tool call on a path another session has claimed is denied, and every other
call goes on, the claimant's own included.
```
