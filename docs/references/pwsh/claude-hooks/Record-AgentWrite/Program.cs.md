# .claude/hooks/Record-AgentWrite/Program.cs

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its
comment sat above (Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `public static class RecordAgentWrite`, written with `//`.

```text
Records, for every Claude Code session, each file a tool writes (with its content hash) and the window of each Bash call, so the
listen mode can tell an agent's change from the editor's. It never blocks or fails a call: any error leaves the ledger without the line.
```
