---
catzc:
  derived:
    path: docs/references/automation/catzc-base-modulesystem/Sync-GeneratedFile.ps1.md
    kind: comment-page
    body_sha: fdfbb33dcfff
    adrs:
      - ADR-AUTO-CACHE#8
      - ADR-AUTO-TYPES#13
      - ADR-REPO-VARIANT#6
---

# automation/Catzc.Base.ModuleSystem/Sync-GeneratedFile.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
The dev-box janitor the importer runs on every load: in a person's session it commits what actually
differs from HEAD under the generated-file paths — automation/.compiled/ (the committed
compiled type assembly) — via Invoke-GitCommit. Deriving the commit set from git status rather than
this run's reports also picks up a generated file an earlier import wrote but never committed (the
.compiled DLL swap happens during load, before any switch is consulted).

The commit stages and names only the generated paths that actually changed: a type rebuild commits
'automation/.compiled' as "chore(repo): sync compiled types". The stamp commit's pathspec and message
are the same fact — never a sibling path that happened to be clean.

Guards, in order — each skip is one explanatory message and leaves the working tree untouched:
- Skips in build mode (Get-CatzcRunMode,
[ADR-DSGN-RUNMODE](/docs/adr/design/run-modes.md)): the generated files belong to the source tree,
  and the session runs a built package. A skip, not a throw, because the importer's janitor tail calls
  this on every load and a janitor never breaks the load.
- Skips, silently, in a test-run snapshot (Test-RepositorySnapshot): the disposable clone a test run
  executes in is never committed to.
- Who is running decides (Get-SessionActor,
  [ADR-AUTO-TYPES#13](/docs/adr/automation/BCL/native-csharp-types.md#rule-adr-auto-types13)): a pipeline skips —
  the gates there must fail loudly, not be auto-repaired — and an agent never commits: it announces which
  generated paths changed and leaves the commit to the person, whose repository it is. Only a person's
  session commits.
- Skips on a detached HEAD: a commit there hangs off no branch and is one checkout away from lost.
- Skips on main/master when the repo's git_workspace variant is 'main-via-pr' (Test-GitWorkspace,
  [ADR-REPO-VARIANT#6](/docs/adr/repository/repo-variants.md#rule-adr-repo-variant6)): in that mode work always
  happens on a branch, so standing on main locally is the
  one place a direct commit is forbidden. In 'main-direct' (the default, a solo-author trunk) any
  named branch commits — including main, which IS the integration path (one-living-version).
- Holds back automation/.compiled while it holds anything but the current build
  (Clear-ModuleTypeCache -DryRun lists the surplus): a superseded DLL a live session still locks
  would otherwise be committed next to the new one. One red line names the surplus; any other
  changed generated path still commits.
- Holds back automation/.compiled while any type source (automation/*/types/*.cs) differs from HEAD:
  the build is named for the hash of the sources in the working tree, so committing it ahead of them would
  leave HEAD with a build its own sources do not produce. One yellow line asks for the sources to be
  committed; the next import commits the build.

Past the guards it commits what changed under the generated paths — other uncommitted or staged work
does not hold the stamp commit back. Invoke-GitCommit stages and commits by PATHSPEC
(`git add -A --`/`git commit --` limited to the changed generated paths), so exactly the generated
files land in the stamp commit whatever else is modified or staged: unrelated staged work stays
staged, and a generated file someone staged earlier is re-staged at its current content and carried
along. CI verifies the pushed HEAD by recomputing the hashes.
```

## comment:2

Section `.PARAMETER DryRun` of the comment-based help.

```text
Propagated to Invoke-GitCommit: the changed generated paths are still probed (a read), but instead of
committing, the planned git commands for those paths are returned.
```

## comment:3

Above `$changed = @($generatedPaths.Keys | Where-Object { Test-GitPathChanged $_ })`.

```text
Which generated paths actually changed decides both the commit's pathspec and its message — the
stamp commit stages and names exactly what this sync did, never a sibling path that was clean.
```

## comment:4

Above `if ($changed -contains 'automation/.compiled') {`.

```text
.compiled must hold exactly the current build
([ADR-AUTO-CACHE#8](/docs/adr/automation/caching.md#rule-adr-auto-cache8)). A superseded DLL that
survived the
janitor (a session still holds it) would otherwise be committed next to the new one — the +1 without
the -1. Hold the .compiled commit back until it is tidy; any other changed generated path still commits.
```

## comment:5

Above `if ($changed -contains 'automation/.compiled' -and (Test-GitPathChanged...`.

```text
The build is named for the hash of the working-tree type sources. While any of them differs from HEAD — often
another session's in-flight edit — committing it would leave HEAD carrying a build its own sources do not
produce. Hold .compiled back until the sources are committed.
```

## comment:6

Above `$changed = @($generatedPaths.Keys | Where-Object { Test-GitPathChanged $_ })`.

```text
Which generated paths actually changed decides both the commit's pathspec and its message — the
stamp commit stages and names exactly what this sync did, never a sibling path that was clean.
```

## comment:7

Above `if ($changed -contains 'automation/.compiled') {`.

```text
.compiled must hold exactly the current build
([ADR-AUTO-CACHE#8](/docs/adr/automation/caching.md#rule-adr-auto-cache8)). A superseded DLL that
survived the
janitor (a session still holds it) would otherwise be committed next to the new one — the +1 without
the -1. Hold the .compiled commit back until it is tidy; any other changed generated path still commits.
```

## comment:8

Above `if ($changed -contains 'automation/.compiled' -and (Test-GitPathChanged...`.

```text
The build is named for the hash of the working-tree type sources. While any of them differs from HEAD — often
another session's in-flight edit — committing it would leave HEAD carrying a build its own sources do not
produce. Hold .compiled back until the sources are committed.
```
