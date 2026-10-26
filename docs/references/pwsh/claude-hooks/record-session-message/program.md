# .claude/hooks/Record-SessionMessage/Program.cs

The Claude Code hook that logs, for every session, each cross-session message it sends and each it receives, so no session spends a tool
call on its log.

## What it logs

A sent message is read from the PostToolUse event on SendMessage; a received one from the UserPromptSubmit event on a prompt that is a
cross-session-message element. Each lands as one line of `out/orchestrator-<date>.log`.

## Never in the way

It never blocks or fails a call: any error leaves the log without the line.
