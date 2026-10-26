# pwsh/Catzc.Base.Git/New-RepositorySnapshot.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Creates a verified, isolated snapshot of a repository's working tree as it is right now.

### description

Builds a throwaway copy of the source repository that is byte-identical to its working tree: HEAD plus every uncommitted change, staged and
unstaged, plus every untracked file git does not ignore. Ignored content (out/, build caches, tool folders) is not copied, so the snapshot
starts with a clean out/.

The build uses git for the history and plain file copies for the content:

1. `git clone --shared --no-checkout` — the snapshot borrows the source's object store through alternates, so no object is copied; staged
   blobs that exist only in the source's index are borrowed too.
2. The source index is copied over the snapshot's, so staged-versus-unstaged state matches exactly.
3. Every tracked and untracked-not-ignored file is copied from the source working tree, byte for byte. Copying the working-tree bytes
   (rather than `git checkout-index`) keeps the snapshot exact under line-ending conversion: a checkout re-applies core.autocrlf and can
   write different bytes than the working tree holds. A tracked file missing from the working tree is not copied — it stays deleted.
4. Verification: `git status --porcelain=v2` in the snapshot must equal the source's, line for line. On any difference the snapshot is
   removed — a run never proceeds on a snapshot that differs from its source. A difference usually means the source changed during the copy
   (a save, a stage or a commit by another session), so the whole build is retried, announced, up to -Attempts times; a difference that
   persists (a nested repository, a split index) then throws.

A marker file inside the snapshot's .git folder records its provenance; Remove-RepositorySnapshot refuses any folder without it. The
snapshot is announced once it is ready
([ADR-AUTO-CONSOLE-ANNOUNCEBEFOREBLOCKING](../../../drs/automation/console-output-matters.md#rule-adr-auto-console-announcebeforeblocking)).

### parameter `SourceRoot`

The repository to snapshot. Defaults to the repository root (Get-RepositoryRoot).

### parameter `Destination`

The folder to create the snapshot in; it must not exist yet. Defaults to a fresh `<temp>/catzc-snapshot-<guid>` folder.

### parameter `Attempts`

How many times to build the snapshot when verification finds it differs from its source. Default 3.

### parameter `Committed`

Builds the snapshot from HEAD alone: the clone checks the commit out, and no staged, unstaged or untracked change of the source reaches it.
It is the committed truth at one commit, for a reader that must not see the working tree, such as the listen mode's reference
([TDR-ONETRUTH](../../../drs/thesis/one-source-of-truth.md)). Modified, Untracked and Deleted are then 0, and no verification runs. Checking
out the whole tree takes longer than git's everyday limit, so the checkout is bounded by the command's own limit, its `TimeLimit` (120 s) or
its `commands` entry in timeouts.yml.

### outputs

`[pscustomobject]` with Path, SourceRoot, Commit, Modified, Untracked, Deleted (file counts relative to HEAD, from the verified status), and
DurationSeconds.

### example 1

```powershell
$snapshot = New-RepositorySnapshot
try {
    # ... work in $snapshot.Path ...
}
finally {
    Remove-RepositorySnapshot $snapshot.Path
}
```

### example 2

```powershell
New-RepositorySnapshot -SourceRoot C:\projects\other -Destination C:\tmp\other-snapshot
```

## comment:1

Above `$marker = [ordered]@{`, written with `#`.

```text
The provenance marker goes in first, so the cleanup below (and any later Remove-RepositorySnapshot)
recognises even a half-built snapshot as one it may delete.
```

## comment:2

Above `$statusCommand = 'git --no-optional-locks -C "{0}" -c core.quotepath=off...`, written with `#`.

```text
The gate: the snapshot's status must equal the source's. --no-optional-locks keeps the source's index
untouched (a plain status may rewrite it, racing other git commands on the source).
```

## comment:3

Above `$modified = 0`, written with `#`.

```text
Status counts relative to HEAD: '1'/'2'/'u' lines are changed entries (deleted when either side of
the XY code is D), '?' lines are untracked files.
```

## comment:4

Above `if ($Committed) {`, written with `#`.

```text
The committed form checks the commit out in the snapshot itself: nothing of the source's working tree reaches it, so it
cannot differ from its source and needs no verification.
```

## comment:5

Above `$diskFolders = @{}`, written with `#`.

```text
A folder renamed only in case keeps its old case in the index (core.ignorecase never records it), so each target folder takes
the name its source folder has on disk, resolved once per folder.
```

## comment:6

Above `$found =...`, written with `#`.

```text
The bounded walker, one level, nothing pruned: a tracked file under .vendor or out keeps its
folder's case too.
```

## comment:7

Above `try {` (occurrence 2), written with `#`.

```text
A cleanup that fails (a file another process holds) is announced, never thrown in place of the failure
that caused it.
```
