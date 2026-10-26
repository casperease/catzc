# pwsh/Base.ModuleSystem/Sync-GeneratedFile.ps1

The dev-box janitor: after an import, it commits the generated files the importer maintains (today the compiled type assembly under
`pwsh/.compiled/`) so they never sit uncommitted. It runs on every load and only ever skips, never breaks the load.

## help

### synopsis

Commits the importer-maintained generated files to git — the dev-box janitor.

### description

The dev-box janitor the importer runs on every load: in a person's session it commits what actually differs from HEAD under the
generated-file paths — pwsh/.compiled/ (the committed compiled type assembly) — via Invoke-GitCommit. Deriving the commit set from git
status rather than this run's reports also picks up a generated file an earlier import wrote but never committed (the .compiled DLL swap
happens during load, before any switch is consulted).

The commit stages and names only the generated paths that actually changed: a type rebuild commits 'pwsh/.compiled' as "chore(repo): sync
compiled types". The stamp commit's pathspec and message are the same fact — never a sibling path that happened to be clean.

Guards, in order — each skip is one explanatory message and leaves the working tree untouched:

- Skips in build mode (Get-CatzcRunMode,

[DDR-RUNMODE](../../../drs/design/run-modes.md)): the generated files belong to the source tree,

```text
and the session runs a built package. A skip, not a throw, because the importer's janitor tail calls
this on every load and a janitor never breaks the load.
```

- Skips, silently, in a test-run snapshot (Test-RepositorySnapshot): the disposable clone a test run executes in is never committed to.
- Who is running decides (Get-SessionActor,
  [ADR-BCL-TYPES-JANITORSBYCALLER](../../../drs/automation/BCL/native-csharp-types.md#rule-adr-bcl-types-janitorsbycaller)): a pipeline
  skips — the gates there must fail loudly, not be auto-repaired — and an agent never commits: it announces which generated paths changed
  and leaves the commit to the person, whose repository it is. Only a person's session commits.
- Skips on a detached HEAD: a commit there hangs off no branch and is one checkout away from lost.
- Skips on main/master when the repo's git_workspace variant is 'main-via-pr' (Test-GitWorkspace,
  [ADR-REPO-VARIANT-GITWORKSPACE](../../../drs/repository/repo-variants.md#rule-adr-repo-variant-gitworkspace)): in that mode work always
  happens on a branch, so standing on main locally is the one place a direct commit is forbidden. In 'main-direct' (the default, a
  solo-author trunk) any named branch commits — including main, which IS the integration path (one-living-version).
- Holds back pwsh/.compiled while it holds anything but the current build (Clear-ModuleTypeCache -DryRun lists the surplus): a superseded
  DLL a live session still locks would otherwise be committed next to the new one. One red line names the surplus; any other changed
  generated path still commits.
- Holds back pwsh/.compiled while any type source (`pwsh/*/types/*.cs`) differs from HEAD: the build is named for the hash of the sources in
  the working tree, so committing it ahead of them would leave HEAD with a build its own sources do not produce. One yellow line asks for
  the sources to be committed; the next import commits the build.

Past the guards it commits what changed under the generated paths — other uncommitted or staged work does not hold the stamp commit back.
Invoke-GitCommit stages and commits by PATHSPEC (`git add -A --`/`git commit --` limited to the changed generated paths), so exactly the
generated files land in the stamp commit whatever else is modified or staged: unrelated staged work stays staged, and a generated file
someone staged earlier is re-staged at its current content and carried along. CI verifies the pushed HEAD by recomputing the hashes.

### parameter `DryRun`

Propagated to Invoke-GitCommit: the changed generated paths are still probed (a read), but instead of committing, the planned git commands
for those paths are returned.

### outputs

`[string]` The new commit's SHA (or the planned commands with -DryRun); nothing when a guard skipped or no generated path changed.

### example 1

```powershell
Sync-GeneratedFile
```

### example 2

```powershell
Sync-GeneratedFile -DryRun
```

## Generated paths

The janitor owns a small table of generated paths, each with the commit-message subject that names it. The modules folder comes from its
resolver. Which of those paths actually changed decides both the commit's pathspec and its message, so the stamp commit stages and names
exactly what this sync did, never a sibling path that was clean.

## Why the compiled folder is held back

The compiled folder must hold exactly the current build
([ADR-AUTO-CACHE-COMPILEDTYPEPREBUILD](../../../drs/automation/caching.md#rule-adr-auto-cache-compiledtypeprebuild)). Two cases hold its
commit back until they clear, while any other changed generated path still commits:

- A superseded DLL that survived the janitor, because a session still holds it, would be committed next to the new one: the plus one without
  the minus one.
- The build is named for the hash of the working-tree type sources. While any of them differs from HEAD, often another session's in-flight
  edit, committing the build would leave HEAD carrying one its own sources do not produce.
