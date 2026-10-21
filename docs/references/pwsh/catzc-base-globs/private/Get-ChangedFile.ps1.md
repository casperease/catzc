# pwsh/Catzc.Base.Globs/private/Get-ChangedFile.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

The repo-relative paths changed across a git diff range — the diff counterpart to the tracked-file universe.

### description

The diff sibling of Get-TrackedFile
([FDR-CD-GLOBS-TRACKEDFILESONLY](../../../../drs/flow/durable-sha-globs.md#rule-fdr-cd-globs-trackedfilesonly)):
`git diff --name-only` over the range, with renames split into a delete + an add (--no-renames) so BOTH the old and the new path count as
changed — a file moving INTO or OUT OF a globset must re-trigger it (rename correctness, the property vendor content-blind filters miss).
`core.quotepath=off` keeps non-ASCII paths literal; paths come back '/'-separated and repo-relative, the same universe globsets match
against. Unlike a tracked-file member, a changed path may be a deletion; it is still returned, matched on its path.

A range that spans a commit absent from a shallow CI clone fails in git — a caller in a pipeline must ensure sufficient fetch depth
(fetchDepth: 0); the reference-commit resolver owns that contract.

### parameter `Range`

The git diff range: a merge-base range 'origin/main...HEAD' (a PR's net change since it diverged) or a commit range 'HEAD^1..HEAD' (what a
post-commit push added to main, first-parent of the squash commit).

### example 1

```powershell
Get-ChangedFile -Range 'HEAD^1..HEAD'
```
