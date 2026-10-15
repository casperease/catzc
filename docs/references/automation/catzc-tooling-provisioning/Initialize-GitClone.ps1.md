---
catzc:
  derived:
    path: docs/references/automation/catzc-tooling-provisioning/Initialize-GitClone.ps1.md
    kind: comment-page
    body_sha: "60aab09b65b9"
    adrs:
      - ADR-AUTO-DRYRUN#2
---

# automation/Catzc.Tooling.Provisioning/Initialize-GitClone.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
Hooks up the clone-local git configuration right after a `git clone`, so the trunk-based flow
works from the first pull and push:

- pull.rebase true — a plain `git pull` rebases local commits (e.g. the importer janitor's
  generated-file sync commits) onto the remote head instead of failing with "You have divergent
  branches and need to specify how to reconcile them".
- credential.helper — in a WSL session, points git at the Windows Git Credential Manager under
  /mnt/c, so an HTTPS push reuses the Windows-managed credentials instead of prompting for a
  username in the Linux shell.

Every setting is written to the clone's local config (--local), never the user's global config,
so nothing outside the named repository changes. Idempotent: a setting that already holds the
desired value is left untouched, and re-running is always safe. Also reports when the git
identity (user.name / user.email) resolves to nothing, with the exact commands to set it —
commits (including the janitor's automatic ones) fail without an identity.
```

## comment:2

Section `.PARAMETER Repository` of the comment-based help.

```text
Path to the cloned repository to configure. Defaults to this repository's root, so the
zero-argument call configures the clone the session runs from.
```

## comment:3

Above `function Initialize-GitClone {`.

```text
Uses -DryRun, not ShouldProcess/-WhatIf — see
[ADR-AUTO-DRYRUN#2](/docs/adr/automation/dry-run.md#rule-adr-auto-dryrun2).
```

## comment:4

Above `$settings = [ordered]@{ 'pull.rebase' = 'true' }`.

```text
The desired clone-local settings. pull.rebase keeps a plain `git pull` working when local
commits (the janitor's generated-file syncs) diverge from the remote; the WSL credential
helper reuses the Windows credential store for HTTPS pushes.
```

## comment:5

Above `$settings['credential.helper'] = $credentialManager -replace ' ', '\ '`.

```text
git runs the helper value through sh, so spaces in the /mnt/c path must be escaped
inside the value itself.
```

## comment:6

Above `foreach ($identityKey in @('user.name', 'user.email')) {`.

```text
An unset identity is not this function's to invent, but the very next commit (often the
janitor's) fails without one — so report the exact remediation instead of staying silent.
```
