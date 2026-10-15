# docs/references/automation/catzc-base-globs/Get-TrackedFile.ps1.md

`automation/Catzc.Base.Globs/Get-TrackedFile.ps1`

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
`git ls-files` defines "files under version control"
([ADR-FLOW-CD-GLOBS#4](/docs/adr/flow/durable-sha-globs.md#rule-adr-flow-cd-globs4)): deterministic on every
checkout, independent of build residue, blind to untracked and
ignored files. Read through Get-GitTrackedPath, the one place that answers it (from the index, in-process —
[ADR-AUTO-TRACKED#1](/docs/adr/automation/tracked-files-from-the-index.md#rule-adr-auto-tracked1)).
A tracked file may be missing on disk (an unstaged deletion) — it is still listed here; the hashing code
folds a distinct marker for it.
```
