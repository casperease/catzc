# pwsh/Tooling.Listen/types/WriteLedger.cs

The write ledgers of the listen mode and the rule that reads them. The agent ledger (`out/agent-writes.jsonl`) and the editor ledger
(`out/editor-saves.jsonl`) each hold one entry per write or save; `WriteLedger` reads both and answers who made a file's current bytes.

## Who wrote it

`WriteLedger.SourceOf` ranks the evidence:

1. an agent's exact write of the same hash;
2. the editor's exact save of the same hash;
3. a write inside an agent's Bash window, such as a formatter or generator an agent ran; a window whose end is not recorded closes after
   `openWindowSeconds`;
4. otherwise unknown.

A deleted file has no hash and no write time, so only the matching on the path remains for it.
