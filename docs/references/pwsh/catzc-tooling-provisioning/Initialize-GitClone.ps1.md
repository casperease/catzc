# pwsh/Catzc.Tooling.Provisioning/Initialize-GitClone.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Configures a fresh git clone with the local git settings this repository's workflow needs.

### description

Hooks up the clone-local git configuration right after a `git clone`, so the trunk-based flow works from the first pull and push:

- pull.rebase true — a plain `git pull` rebases local commits (e.g. the importer janitor's generated-file sync commits) onto the remote head
  instead of failing with "You have divergent branches and need to specify how to reconcile them".
- credential.helper — in a WSL session, points git at the Windows Git Credential Manager under /mnt/c, so an HTTPS push reuses the
  Windows-managed credentials instead of prompting for a username in the Linux shell.

Every setting is written to the clone's local config (--local), never the user's global config, so nothing outside the named repository
changes. Idempotent: a setting that already holds the desired value is left untouched, and re-running is always safe. Also reports when the
git identity (user.name / user.email) resolves to nothing, with the exact commands to set it — commits (including the janitor's automatic
ones) fail without an identity.

### parameter `Repository`

Path to the cloned repository to configure. Defaults to this repository's root, so the zero-argument call configures the clone the session
runs from.

### parameter `DryRun`

Return the `git config` commands that would run, without executing them.

### outputs

`[string[]]` Under -DryRun, the planned `git config` commands; otherwise nothing.

### example 1

```powershell
Initialize-GitClone
```

### example 2

```powershell
Initialize-GitClone ~/catzc -DryRun
```

## comment:1

Above `function Initialize-GitClone {`, written with `#`.

```text
Uses -DryRun, not ShouldProcess/-WhatIf — see
[ADR-AUTO-DRYRUN#2](/docs/adr/automation/dry-run.md#rule-adr-auto-dryrun2).
```

## comment:2

Above `$settings = [ordered]@{ 'pull.rebase' = 'true' }`, written with `#`.

```text
The desired clone-local settings. pull.rebase keeps a plain `git pull` working when local
commits (the janitor's generated-file syncs) diverge from the remote; the WSL credential
helper reuses the Windows credential store for HTTPS pushes.
```

## comment:3

Above `$settings['credential.helper'] = $credentialManager -replace ' ', '\ '`, written with `#`.

```text
git runs the helper value through sh, so spaces in the /mnt/c path must be escaped
inside the value itself.
```

## comment:4

Above `foreach ($identityKey in @('user.name', 'user.email')) {`, written with `#`.

```text
An unset identity is not this function's to invent, but the very next commit (often the
janitor's) fails without one — so report the exact remediation instead of staying silent.
```
