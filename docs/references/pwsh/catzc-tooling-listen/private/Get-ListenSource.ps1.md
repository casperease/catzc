# pwsh/Tooling.Listen/private/Get-ListenSource.ps1

A private helper of the listen module that attributes a file's current bytes to an agent session, the editor or nobody known, by reading the
two write ledgers and ranking them as `WriteLedger.SourceOf` does.

## help

### synopsis

Says who made a file's current bytes: an agent session, the editor, or nobody the ledgers know.

### description

Reads the two write ledgers: the agent ledger the Record-AgentWrite hook appends for every Claude Code session, and the editor ledger the
catzc-save-ledger extension appends for every save, and ranks them as WriteLedger.SourceOf does: an agent's exact write, then the editor's
exact save, then a write inside an agent's Bash call (a formatter or generator an agent ran), else unknown, such as a git checkout, a script
outside Claude, another editor, or a ledger out/ lost. A Bash call whose end is not recorded stays open at most the Bash background limit of
the time safeguard.

### parameter `Path`

The repository-relative path.

### parameter `Hash`

The file's current content hash (DurableHash); none for a deleted file.

### parameter `WrittenAt`

The file's last write time; none for a deleted file.

### outputs

`[Catzc.Tooling.Listen.WriteSource]` with source (agent, editor or unknown) and agent (the agent's session id).
