# docs/references/automation/catzc-base-globs/Get-GlobSetHash.ps1.md

`automation/Catzc.Base.Globs/Get-GlobSetHash.ps1`

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
The recipe: per member file, SHA-256 over the on-disk bytes with every CR (0x0D) stripped (a CRLF vs LF
working tree yields the same identity on every machine); the per-file digests folded as
<repo-relative-path>|<digest> lines in ordinal path order; one combined SHA-256 over the fold, returned
as 64 lowercase hex chars — exactly the marker file's sha256 value
([ADR-FLOW-CD-GLOBS#9](/docs/adr/flow/durable-sha-globs.md#rule-adr-flow-cd-globs9)). A
tracked-but-missing-on-disk member (an unstaged deletion) folds the distinct marker <path>|missing
instead of throwing, so a deletion re-keys the set. Because the path is part of the fold, a rename
re-keys even on byte-identical content. When the working tree is clean in-scope, this equals the
committed marker identity.
```

## comment:2

Section `.PARAMETER GlobSet` of the comment-based help.

```text
A [Catzc.Base.Globs.GlobSet] instance to compute the identity for instead — the path a DERIVED set
(Get-ModuleGlobSet) takes, since derived sets are not in the declared registry.
```

## comment:3

Section `.PARAMETER TrackedFile` of the comment-based help.

```text
The tracked-file universe (Get-TrackedFile), fetched once by a caller hashing many sets and passed in.
Omitted, it is fetched for this call.
```
