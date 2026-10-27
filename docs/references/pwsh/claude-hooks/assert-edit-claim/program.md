# .claude/hooks/Assert-EditClaim/Program.cs

The Claude Code hook that keeps one editor on a shared config: before an Edit, Write, MultiEdit or NotebookEdit it reads the claim record of
the file (`Lock-SharedConfig`) and denies the call when another session holds a live claim. The claimant's own edits, and every file no one
claims, go on.

## Never in the way

A check that fails lets the call go on and says why on stderr: a broken claim check never stops every edit of every session.
