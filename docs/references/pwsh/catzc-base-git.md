# Catzc.Base.Git

The declarative git-configuration module. It owns the rule that **what git ignores is declared, explained, and generated**: the
repository-root `.gitignore` is rendered in full from a section registry (`gitignore.yml`) — every rule under a titled, explained comment
block — and never hand-maintained (see [generated-root-configs](../../drs/repository/generated-root-configs.md)). What it deliberately does
**not** own is the materialisation: `New-GitIgnore` is a pure renderer that returns content and writes nothing; the `.gitignore` target
itself is a managed, committed root file written by [Catzc.Base.RootConfig](catzc-base-root-config.md)'s `Build-RootConfig`, which names
`New-GitIgnore` as that entry's generator.

## Responsibilities

| Responsibility   | Area     | Name                                                                   |
| ---------------- | -------- | ---------------------------------------------------------------------- |
| responsibility:1 | render   | [Gitignore rendering](#responsibility1--gitignore-rendering)           |
| responsibility:2 | registry | [The section registry](#responsibility2--the-section-registry)         |
| responsibility:3 | snapshot | [Repository snapshots](#responsibility3--repository-snapshots)         |
| responsibility:4 | read     | [Reading git](#responsibility4--reading-git)                           |
| responsibility:5 | topic    | [The git topic flow](#responsibility5--the-git-topic-flow)             |
| responsibility:6 | import   | [Importing a repository](#responsibility6--importing-a-repository)     |
| responsibility:7 | clean    | [Cleaning generated files](#responsibility7--cleaning-generated-files) |

### responsibility:1 — Gitignore rendering

Turning the section registry into the full `.gitignore` text. This responsibility renders a generated-file header naming the sources of
truth, then each section in registry order: a rule line carrying the section's title, the wrapped `why` explanation as comment lines, and
the section's patterns verbatim — a `note` becomes an aligned trailing comment. A section declaring `inject: <provider>` takes its patterns
from the caller at render time; a provider the caller does not supply throws, so a silently incomplete `.gitignore` can never render.
Pattern text is never rewritten — what the registry says is what git gets.

### responsibility:2 — The section registry

Which paths are ignored, grouped and explained. The registry is `gitignore.yml`: an ordered list of **sections**, each with an `id`, a
`title`, a `why`, and either static `patterns` (bare strings or `{ pattern, note }`) or an `inject` provider name. The managed root-config
copies are the injected section — their list lives in [Catzc.Base.RootConfig](catzc-base-root-config.md)'s registry (the `committed: false`
targets) and is never restated here, which is also what keeps the dependency edge one-way: `Build-RootConfig` computes the injection and
calls the renderer; `New-GitIgnore` never reads `rootconfig.yml`. The registry is validated when it loads (`GitIgnoreConfig` — exactly one
of `patterns`/`inject` per section, unique ids), so a malformed section can never produce a run.

### responsibility:3 — Repository snapshots

A throwaway, verified copy of a working tree as it is right now. `New-RepositorySnapshot` borrows the history through a shared-object clone,
copies the source index so staged-versus-unstaged state matches, and copies the tracked and untracked-not-ignored files byte for byte —
never through a checkout, which re-applies line-ending conversion. It then requires the snapshot's `git status` to equal the source's line
for line, and throws (removing the half-built copy) on any difference. Ignored content is never copied. A provenance marker inside the
snapshot's `.git` folder answers whether a repository is a snapshot, and lets `Remove-RepositorySnapshot` refuse anything that is not one.
The test harness runs a concurrent run in one (see
[test-automation](../../drs/automation/test-automation.md#rule-adr-auto-test-runsneverwait)).

### responsibility:4 — Reading git

Answering questions about a repository without starting git where its format is small, and with a single git process where it is not
([tracked-files-from-the-index](../../drs/automation/tracked-files-from-the-index.md)). The index reader lists tracked files from
`.git/index`. The refs reader finds a checkout's git directory (a linked worktree included), resolves `HEAD`, branches and tags from the ref
files, and names the current branch. The history scan hunts a token through every commit message, path and distinct file content a ref
reaches, reading each object once from one `git cat-file` stream. These are types the rest of the platform reads through: the tracked-file
seam and the branch and commit getters in [Catzc.Base.Files](catzc-base-files.md), the snapshot above, and the token scan in
[Catzc.Tooling.Github](catzc-tooling-github.md). Writing git stays with the git CLI.

### responsibility:5 — The git topic flow

The steps that bring a topic branch to the server's main ([git-topic-flow](../../drs/flow/git-topic-flow.md)): reading the sync point, the
BVT-verified server head or, announced, the current server HEAD; saving the working tree as a commit; rebasing the topic onto the sync
point; and landing it as one commit by squash, rebase and squash, pushed by the workspace variant. Every step but the reading one changes
the repository, so it runs only at the user's hand ([FDR-GIT-USERRUNSGIT](../../drs/flow/git-topic-flow.md#rule-fdr-git-userrunsgit)); the
Bash hook denies those commands to an agent, reading their names from `git.yml`, and the VS Code tasks offer them to the user.

### responsibility:6 — Importing a repository

Bringing an outside repository in with its full history, at one landing address under the unordered track
([DDR-TRACK-UNORDEREDTRACK](../../drs/design/tracks.md#rule-ddr-track-unorderedtrack)): every commit of the source ref is kept, so the files
sorted out of the track later carry their history with them.

### responsibility:7 — Cleaning generated files

A `git clean -fxd` that deletes only what the automation generates and owns. It asks git what a clean would remove, deletes exactly the
candidates on the generated-file whitelist, and reports every candidate it refused, the untracked work that is not the automation's to
delete. Everything it deletes but `out/` comes back with the next import.

## What the module does

The module makes the repository's ignore rules a reviewed, explained artifact instead of an accreted one, and it holds the platform's git
readers. Every rule in the generated `.gitignore` sits under a heading and a rationale, so "why is this ignored?" is answered in the file
itself, and adding a rule means adding it to a section (or a new section) in `gitignore.yml` — the render carries the explanation along.

The split with [Catzc.Base.RootConfig](catzc-base-root-config.md) is the deliberate design: this module knows **what** is ignored and **how
to say it**; RootConfig knows **which root files are managed** and **owns every write**. The `.gitignore` file is `committed: true` in the
root-config registry — git must read it at checkout, before any import — so a fresh clone ignores correctly from the first second, the
importer merely keeps it current, and a source change surfaces as a normal reviewable diff. The injected section closes the loop: opting a
new root file into management (`committed: false`) puts its ignore line into the next rendered `.gitignore` automatically, with no second
list to maintain.

## Division

The module's public surface, sorted into the responsibilities above.

| Responsibility                              | Function                       |
| ------------------------------------------- | ------------------------------ |
| responsibility:1 — Gitignore rendering      | `New-GitIgnore`                |
| responsibility:2 — The section registry     | `gitignore.yml`                |
| responsibility:3 — Repository snapshots     | `New-RepositorySnapshot`       |
|                                             | `Remove-RepositorySnapshot`    |
|                                             | `Test-RepositorySnapshot`      |
| responsibility:5 — The git topic flow       | `Get-SyncPoint`                |
|                                             | `Save-Topic`                   |
|                                             | `Sync-Topic`                   |
|                                             | `Push-Topic`                   |
| config                                      | `git.yml`                      |
| responsibility:6 — Importing a repository   | `Import-RepositoryWithHistory` |
| responsibility:7 — Cleaning generated files | `Reset-GitCleanFxd`            |
