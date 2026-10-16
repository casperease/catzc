---
catzc:
  derived:
    path: docs/references/automation/catzc-base-repository.md
    kind: reference
    language: markdown
    filetype: md
    track: docs
    body_sha: aa36a4ef1cbb
    links:
      - docs/adr/automation/never-depend-on-pwd.md
      - docs/adr/flow/pipeline-detection.md
      - docs/adr/repository/dedicated-output-directory.md
      - docs/references/automation/catzc-base-asserts.md
      - docs/references/automation/catzc-base-files.md
      - docs/references/automation/internal/catzc-internal-loader.md
---

# Catzc.Base.Repository

The path-anchor module. It is the **single source of truth for where files live** — locating the repository root, resolving repo-relative
and absolute paths, pointing to the dedicated output directory, and naming whether code runs in a pipeline or on a devbox. No other module
derives these answers independently; callers depend on `$PWD` nowhere (see
[never-depend-on-pwd](../../adr/automation/never-depend-on-pwd.md)). What this module deliberately does **not** own is general filesystem
work (copying trees, checking file locks, reading git facts) — those live in [Catzc.Base.Files](catzc-base-files.md). It is a member of the
`Base` group, depends on [Catzc.Base.Asserts](catzc-base-asserts.md), and is a dependency of everything above it.

## Responsibilities

| Responsibility   | Area     | Name                                                                                       |
| ---------------- | -------- | ------------------------------------------------------------------------------------------ |
| responsibility:1 | paths    | [Repository and output path anchors](#responsibility1--repository-and-output-path-anchors) |
| responsibility:2 | pipeline | [Pipeline context detection](#responsibility2--pipeline-context-detection)                 |

### responsibility:1 — Repository and output path anchors

Where files are. This responsibility answers "where is the repository root", "where does this repo-relative path resolve to an absolute
path", "what is this absolute path expressed relative to the root", and "where should generated output go". It is the single source of path
anchors, so no function anywhere in the platform depends on the current working directory (see
[never-depend-on-pwd](../../adr/automation/never-depend-on-pwd.md)) and all generated output lands in one dedicated, gitignored location
(see [dedicated-output-directory](../../adr/repository/dedicated-output-directory.md)).

### responsibility:2 — Pipeline context detection

Whether the code is executing inside a CI pipeline, named as a run environment (Pipeline or Devbox) that an `-EnvironmentAssertIs` guard can
pin. The answer keys environment-dependent settings such as the time-safeguard limits. It is read off the one detection seam, which lives in
the always-loaded [Catzc.Internal.Loader](internal/catzc-internal-loader.md) so the importer's pre-pass can ask it before any module loads
(see [pipeline-detection](../../adr/flow/pipeline-detection.md)). Callers never probe CI environment variables directly.

## What the module does

This module is the path layer the rest of the platform builds on. Its single most important guarantee is that no caller reads `$PWD`: they
call `Get-RepositoryRoot` instead, which finds the root by walking up from the script file's location rather than from wherever the shell
happened to be at invocation time. That guarantee propagates upward: `Get-RepositoryFile` and `Get-RepositoryFolder` both anchor to that
root by name; `Resolve-RepoPath` converts a repo-relative path to its absolute form; and `ConvertTo-RepoRelativePath` goes the other
direction. A caller using any of these functions is immune to working-directory drift.

The output location follows the same design. `Get-OutputRoot` returns the one path all generated files land in. That path is gitignored by
policy (see [dedicated-output-directory](../../adr/repository/dedicated-output-directory.md)); because every module writes there through
this function, the location is never duplicated or guessed.

Pipeline detection (responsibility 2) is a single boolean question with a single authoritative answer. Scattering the environment-variable
checks that answer it across modules would mean each could disagree; `Test-IsRunningInPipeline` in the loader holds the logic once, and
`Get-RunEnvironment` names its answer, so the detection heuristic can be improved in one place (see
[pipeline-detection](../../adr/flow/pipeline-detection.md)).

## Division

The module's public functions, sorted into the responsibilities above.

| Responsibility                                        | Function                     |
| ----------------------------------------------------- | ---------------------------- |
| responsibility:1 — Repository and output path anchors | `Get-RepositoryRoot`         |
|                                                       | `Get-RepositoryFile`         |
|                                                       | `Get-RepositoryFolder`       |
|                                                       | `Resolve-RepoPath`           |
|                                                       | `ConvertTo-RepoRelativePath` |
|                                                       | `Get-OutputRoot`             |
| responsibility:2 — Pipeline context detection         | `Get-RunEnvironment`         |
