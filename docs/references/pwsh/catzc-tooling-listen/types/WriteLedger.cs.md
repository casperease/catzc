# pwsh/Catzc.Tooling.Listen/types/WriteLedger.cs

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its
comment sat above (Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `public static WriteSource SourceOf(IReadOnlyList<WriteLedgerEntry> agent,...`, written with `//`.

```text
Who made a file's current bytes, in rank order: an agent's exact write, the editor's exact save, a write inside an agent's Bash
window (open windows close after openWindowSeconds), else unknown. A deleted file has no hash and no write time.
```
