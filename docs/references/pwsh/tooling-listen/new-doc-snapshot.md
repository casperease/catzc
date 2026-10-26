# pwsh/Tooling.Listen/New-DocSnapshot.ps1

The start of a listen session: it copies the watched folder twice, indexes both copies, pins the committed reference at HEAD and writes the
manifest. The index `seen.json` is written last, because it is what makes a folder a session; a start that fails half way leaves no session
behind.

## help

### synopsis

Starts a listen session: the frozen baseline, the rolling seen copy, their indexes, and the committed reference.

### description

Creates `<output>/<stamp>/` (listen.yml's output folder, the stamp yyyyMMdd-HHmmss) holding:

- baseline/ and seen/: two copies of the watched folder as it is on disk now. baseline/ never changes; seen/ moves forward as changes are
  noted (Update-DocSnapshot).
- baseline.json and seen.json: path to length, last-write ticks and content hash of the watched files, so a poll hashes only what changed.
- reference/: the repository at HEAD, committed files only (New-RepositorySnapshot -Committed), the one truth the scouts and the fact-checks
  read; never the live tree.
- manifest.json: the watched folder, the pinned commit and the start time.
- notes/: empty, for New-DocNote.

seen.json is what makes a folder a session, so it is written last: a start that fails half way leaves no session behind. Git state plays no
part in what counts as a change; it is read once, here, to pin the reference.

### parameter `Watch`

The repository-relative folder to watch. Default: listen.yml's watch.

### outputs

`[pscustomobject]` with Path (the session folder), Watch and Commit.

### example 1

```powershell
New-DocSnapshot -Watch docs
```
