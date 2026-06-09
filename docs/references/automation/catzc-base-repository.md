# Catzc.Base.Repository

The path-anchor module. It is the **single source of truth for where files live** — locating the repository root, resolving repo-relative
and absolute paths, pointing to the dedicated output directory, and detecting whether code is running inside a CI pipeline. No other module
derives these answers independently; callers depend on `$PWD` nowhere (see
[never-depend-on-pwd](../../adr/automation/never-depend-on-pwd.md)). What this module deliberately does **not** own is general filesystem
work (copying trees, checking file locks, reading git facts) — those live in [Catzc.Base.Files](catzc-base-files.md). It is a member of the
`Base` group, depends on [Catzc.Base.Asserts](catzc-base-asserts.md), and is a dependency of everything above it.

## Domains

| Domain   | Area     | Name                                                                               |
| -------- | -------- | ---------------------------------------------------------------------------------- |
| domain:1 | paths    | [Repository and output path anchors](#domain1--repository-and-output-path-anchors) |
| domain:2 | pipeline | [Pipeline context detection](#domain2--pipeline-context-detection)                 |

### domain:1 — Repository and output path anchors

Where files are. This domain answers "where is the repository root", "where does this repo-relative path resolve to an absolute path", "what
is this absolute path expressed relative to the root", and "where should generated output go". It is the single source of path anchors, so
no function anywhere in the platform depends on the current working directory (see
[never-depend-on-pwd](../../adr/automation/never-depend-on-pwd.md)) and all generated output lands in one dedicated, gitignored location
(see [dedicated-output-directory](../../adr/repository/dedicated-output-directory.md)).

### domain:2 — Pipeline context detection

Whether the code is executing inside a CI pipeline. This domain answers that one question — and it is the only sanctioned place the question
is answered (see [pipeline-detection](../../adr/pipelines/pipeline-detection.md)). Callers branch on its result to suppress interactive
prompts, skip steps that require a human, or adjust output verbosity; they never probe CI environment variables directly.

## What the module does

This module is the path layer the rest of the platform builds on. Its single most important guarantee is that no caller reads `$PWD`: they
call `Get-RepositoryRoot` instead, which finds the root by walking up from the script file's location rather than from wherever the shell
happened to be at invocation time. That guarantee propagates upward: `Get-RepositoryFile` and `Get-RepositoryFolder` both anchor to that
root by name; `Resolve-RepoPath` converts a repo-relative path to its absolute form; and `ConvertTo-RepoRelativePath` goes the other
direction. A caller using any of these functions is immune to working-directory drift.

The output location follows the same design. `Get-OutputRoot` returns the one path all generated files land in. That path is gitignored by
policy (see [dedicated-output-directory](../../adr/repository/dedicated-output-directory.md)); because every module writes there through
this function, the location is never duplicated or guessed.

Pipeline detection (domain 2) is a single boolean question with a single authoritative answer. Scattering the environment-variable checks
that answer it across modules would mean each could disagree; centralising the logic here means the answer is consistent and the detection
heuristic can be improved in one place (see [pipeline-detection](../../adr/pipelines/pipeline-detection.md)).

## Division

The module's public functions, sorted into the domains above.

| Domain                                        | Function                     |
| --------------------------------------------- | ---------------------------- |
| domain:1 — Repository and output path anchors | `Get-RepositoryRoot`         |
|                                               | `Get-RepositoryFile`         |
|                                               | `Get-RepositoryFolder`       |
|                                               | `Resolve-RepoPath`           |
|                                               | `ConvertTo-RepoRelativePath` |
|                                               | `Get-OutputRoot`             |
| domain:2 — Pipeline context detection         | `Test-IsRunningInPipeline`   |
