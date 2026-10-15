---
catzc:
  derived:
    path: docs/references/automation/catzc-tooling-provisioning/Initialize-GitClone.ps1.md
    kind: comment-page
    body_sha: "154374080727"
    adrs:
      - ADR-AUTO-DRYRUN#2
---

# automation/Catzc.Tooling.Provisioning/Initialize-GitClone.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:7

Above `function Initialize-GitClone {`.

```text
Uses -DryRun, not ShouldProcess/-WhatIf — see
[ADR-AUTO-DRYRUN#2](/docs/adr/automation/dry-run.md#rule-adr-auto-dryrun2).
```

## comment:8

Above `$settings = [ordered]@{ 'pull.rebase' = 'true' }`.

```text
The desired clone-local settings. pull.rebase keeps a plain `git pull` working when local
commits (the janitor's generated-file syncs) diverge from the remote; the WSL credential
helper reuses the Windows credential store for HTTPS pushes.
```

## comment:9

Above `$settings['credential.helper'] = $credentialManager -replace ' ', '\ '`.

```text
git runs the helper value through sh, so spaces in the /mnt/c path must be escaped
inside the value itself.
```

## comment:10

Above `foreach ($identityKey in @('user.name', 'user.email')) {`.

```text
An unset identity is not this function's to invent, but the very next commit (often the
janitor's) fails without one — so report the exact remediation instead of staying silent.
```
