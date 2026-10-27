# Check the name, pick the range per context, then diff git and match the paths

```text
Test-GlobSetAffected checks the name, picks a git range per context, then diffs and matches; doubt returns true.

1  Test-GlobSetAffected     the entry: a globset name, one boolean out
2  globs.yml                the registry the name must be in, read through Get-Config
3  not a declared globset   the throw on an undeclared name
4  Get-GlobSetChangeRange   the reference-commit resolver, no parameters
5  the three ranges         HEAD locally, HEAD^1..HEAD post-commit, origin/<target>...HEAD in a pull request
6  $null                    a pull request with no resolvable target: the resolver's fail-open signal
7  Get-ChangedGlobSet       git diff over the range, then every globset that matches a changed path
8  $false                   the named set is not among the touched sets
9  $true                    the named set is touched, or the diff threw and was caught

Supports FDR-GLOBS-CHANGECOMPUTEDFROMGIT and ADR-PWSH-DETECT-NODIRECTVARIABLECHECK (implementation lens).
```

`Test-GlobSetAffected` is a short function with a strict order. It refuses a name it does not know, asks the resolver for the git range the
current context measures a change against, diffs that range, matches the changed paths against the registry, and reports whether the named
globset is among the matches. Two places in that order can be in doubt, the range and the diff, and both resolve to true.

```yml drawio
description:
  Test-GlobSetAffected checks the globset name against the registry, asks the resolver for the git range of the current context, diffs that
  range and matches the paths; an unresolved range or a failed diff answers true.
about:
  adrs: [FDR-GLOBS-CHANGECOMPUTEDFROMGIT, ADR-PWSH-DETECT-NODIRECTVARIABLECHECK]
  lens: implementation
content:
  title: Check the name, pick the range per context, then diff git and match the paths
  kind: explanation
  flow: top-to-bottom
  theme: dark
  bands:
    - { id: band-entry, label: ENTRY }
    - { id: band-range, label: RANGE PER CONTEXT }
    - { id: band-diff, label: DIFF AND MATCH }
    - { id: band-answer, label: ANSWER }
  groups:
    - { id: grp-ranges, label: the three ranges, in: band-range }
  glyphs:
    - { id: g-affected, kind: code, label: Test-GlobSetAffected, in: band-entry }
    - { id: g-globs, kind: file, label: globs.yml, in: band-entry }
    - { id: f-undeclared, kind: failure, label: not a declared globset, in: band-entry }
    - { id: g-range, kind: code, label: Get-GlobSetChangeRange, in: band-range }
    - { id: r-head, kind: result, label: HEAD, in: grp-ranges }
    - { id: r-push, kind: result, label: HEAD^1..HEAD, in: grp-ranges }
    - { id: r-pull-request, kind: result, label: origin/<target>...HEAD, in: grp-ranges }
    - { id: g-changed, kind: code, label: Get-ChangedGlobSet, in: band-diff }
    - { id: r-false, kind: result, label: "$false, confirmed untouched", in: band-answer }
    - { id: r-true, kind: result, label: "$true, touched or doubt", in: band-answer }
  edges:
    - { from: g-affected, to: g-globs, kind: flow, label: "" }
    - { from: g-affected, to: f-undeclared, kind: fail, label: undeclared }
    - { from: g-affected, to: g-range, kind: flow, label: calls }
    - { from: g-range, to: grp-ranges, kind: flow, label: "" }
    - { from: grp-ranges, to: g-changed, kind: flow, label: feeds }
    - { from: g-changed, to: r-false, kind: flow, label: untouched }
    - { from: g-changed, to: r-true, kind: flow, label: "touched, or git throws" }
    - from: g-range
      to: r-true
      kind: flow
      label: $null
      via:
        - [920, 272]
        - [920, 656]
  markers:
    - { at: g-affected, number: 1 }
    - { at: g-globs, number: 2 }
    - { at: f-undeclared, number: 3 }
    - { at: g-range, number: 4 }
    - { at: grp-ranges, number: 5, corner: top-right }
    - { at: g-range, number: 6, corner: bottom-right }
    - { at: g-changed, number: 7 }
    - { at: r-false, number: 8 }
    - { at: r-true, number: 9 }
  legend: auto
  minimaps: [code-locations, module-neighbourhood, axis]
layout:
  band-entry: { x: 20, y: 84, w: 1260, h: 110 }
  band-range: { x: 20, y: 214, w: 1260, h: 230 }
  band-diff: { x: 20, y: 464, w: 1260, h: 110 }
  band-answer: { x: 20, y: 594, w: 1260, h: 110 }
  g-affected: { x: 320, y: 130, w: 300, h: 44 }
  g-globs: { x: 60, y: 126, w: 150, h: 52 }
  f-undeclared: { x: 800, y: 130, w: 220, h: 44 }
  g-range: { x: 320, y: 250, w: 300, h: 44 }
  grp-ranges: { x: 60, y: 316, w: 820, h: 110 }
  r-head: { x: 90, y: 362, w: 210, h: 44 }
  r-push: { x: 350, y: 362, w: 220, h: 44 }
  r-pull-request: { x: 620, y: 362, w: 230, h: 44 }
  g-changed: { x: 320, y: 504, w: 300, h: 44 }
  r-false: { x: 215, y: 634, w: 230, h: 44 }
  r-true: { x: 485, y: 634, w: 230, h: 44 }
```

![Check the name, pick the range per context, then diff git and match the paths](.assets/range-per-context-then-diff-and-match.drawio.png)

## Walkthrough

1. **Test-GlobSetAffected.** The entry takes one mandatory, positional `-Name`, tab-completed from the registry's names, and returns a
   boolean.
2. **globs.yml.** The function reads the registry with `Get-Config -Config globs` and asks whether it contains the name. This happens before
   any git work.
3. **Not a declared globset.** An unknown name throws `Test-GlobSetAffected: '<Name>' is not a declared globset (globs.yml).` A typo is a
   programming error, so it never becomes a silent skip.
4. **Get-GlobSetChangeRange.** The resolver takes no parameters. It asks `Test-IsRunningInPipeline`, which reads `TF_BUILD` and
   `GITHUB_ACTIONS` and nothing else, and then reads the pull-request variables.
5. **The three ranges.** Outside a pipeline the range is `HEAD`, the working tree against the last commit. In a pipeline that is not a pull
   request it is `HEAD^1..HEAD`: main advances only by squash merge, so the first parent is the prior mainline and the diff is exactly the
   push. In a pull request, detected by `SYSTEM_PULLREQUEST_PULLREQUESTID` or a `GITHUB_EVENT_NAME` of `pull_request`, it is
   `origin/<target>...HEAD`, the merge-base range, with the target from `SYSTEM_PULLREQUEST_TARGETBRANCH` (its `refs/heads/` prefix
   stripped) or `GITHUB_BASE_REF`.
6. **$null.** A pull request that names no target yields `$null`, and the function returns true at once: the range is unknown, so the unit
   is treated as affected.
7. **Get-ChangedGlobSet.** With a range, the function calls `Get-ChangedGlobSet -Range`, which resolves the changed paths through
   `Get-ChangedFile`, that is `git -c core.quotepath=off diff --name-only --no-renames <range>`, and returns every declared globset whose
   scan program selects at least one of them. `-IncludeModules` also matches the derived module sets, but the check does not pass it.
8. **$false.** The named set is not among the touched sets. This is the only false the function returns, and it is reached only after git
   answered.
9. **$true.** The named set is among the touched sets. The same answer is returned when git throws, for example on a shallow clone that
   cannot reach `HEAD^1`: `Invoke-Executable` asserts git's exit code, the function catches the error, writes one message naming the range
   and the reason, and proceeds.

## Why it holds

- The change is computed from git at real refs: `Get-ChangedGlobSet` diffs a commit range with `git diff --name-only --no-renames` and
  matches the paths against the registry; `Test-GlobSetAffected` resolves the reference commit per context and fails open on any doubt
  (FDR-GLOBS-CHANGECOMPUTEDFROMGIT).
- The context is read through `Test-IsRunningInPipeline`, never from the detection variables directly (ADR-PWSH-DETECT-NODIRECTVARIABLECHECK).

## See also

- [Globset triggers](../../drs/flow/durable-sha-globs.md) — the decision this article explains.
- [Pipeline detection](../../drs/automation/pwsh/pipeline-detection.md) — the one detection function the resolver asks.
- The other lenses on the same check: [meta](every-doubt-fails-open-to-proceed.md),
  [architecture](globs-asks-loader-for-context-and-git-for-diff.md), [operations](stop-only-on-false-everything-else-proceeds.md) and
  [governance](tests-pin-the-throw-and-fail-open-cd-calls-it.md).
- [The flow explanations](index.md) · [How to read the diagrams](../index.md#how-to-read-the-diagrams)
