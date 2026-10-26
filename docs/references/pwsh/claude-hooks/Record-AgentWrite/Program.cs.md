# .claude/hooks/Record-AgentWrite/Program.cs

The Claude Code hook that records, for every session, each file a tool writes (with its content hash) and the window of each Bash call, so
the listen mode can tell an agent's change from the editor's.

## Never in the way

It never blocks or fails a call: any error leaves the ledger without the line.
