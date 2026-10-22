# .claude/hooks/Record-SessionMessage/Program.cs

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `public static class RecordSessionMessage`, written with `//`.

```text
Logs, for every Claude Code session, each cross-session message it sends (PostToolUse on SendMessage) and each it receives
(UserPromptSubmit on a prompt that is a cross-session-message element) as one line of out/orchestrator-<date>.log, so no session spends a
tool call on its log. It never blocks or fails a call: any error leaves the log without the line.
```
