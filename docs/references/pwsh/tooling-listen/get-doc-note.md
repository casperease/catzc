# pwsh/Tooling.Listen/Get-DocNote.ps1

The reader of a listen session's notes: it lists the note files from their heads and marks each one processed or not by the processor's
ledger. It only reads.

## help

### synopsis

Lists a session's notes, from their heads, and whether the processor has processed each.

### description

A note is processed when processed.md, the processor's ledger (Complete-DocNote), holds a line for its id. The note files are read, never
written; a session with no notes folder yields nothing.

### parameter `Session`

The session folder. Default: the newest session.

### parameter `Unprocessed`

Only the notes the ledger has no line for.

### parameter `Source`

Only the notes whose change came from these writers: editor (the editor's own saves, the processor's input), agent (a Claude Code session)
or unknown (neither ledger knows it).

### outputs

`[pscustomobject]` per note, in id order: Id, File (the changed path), Change, From, Kind, Tier, Source, Agent (the agent's session id),
Rules, Commit, Note (the note file), Session (the session folder, which every later call about the note names, since a new session numbers
its notes from 0001 again), Processed.

### example 1

```powershell
Get-DocNote -Unprocessed -Source editor
```
