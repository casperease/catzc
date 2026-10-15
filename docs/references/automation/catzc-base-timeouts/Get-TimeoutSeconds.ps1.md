---
catzc:
  derived:
    path: docs/references/automation/catzc-base-timeouts/Get-TimeoutSeconds.ps1.md
    kind: comment-page
    body_sha: "3dc14ef52f08"
    adrs:
      - ADR-PWSH-ASSERT#1
    links: []
---

# automation/Catzc.Base.Timeouts/Get-TimeoutSeconds.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
Resolves the limit from timeouts.yml for the run environment this session is in (Get-RunEnvironment: devbox or
pipeline). With -Executable it is the executable's own entry under `executables` when it has one, otherwise the
environment's pwsh limit. With -Shell it is that shell's limit: bash has a foreground and a -Background limit
(the ones the Claude Code hook enforces, since the hook governs the Bash tool), and every other engine has one.
With -Command it is a function's own limit, most specific
first: an exemption for its [TimeLimit] decoration's budget GUID, then its entry under `commands`, then the
decoration for this environment, then the environment's pwsh limit
([ADR-PWSH-ASSERT#1](/docs/adr/pwsh/assert-idioms.md#rule-adr-pwsh-assert1)). Every consumer of the safeguard (Invoke-Executable,
Invoke-WithTimeout, Assert-CompletesWithin, the hook's parity test) asks here, so tuning a limit is one edit to
the config.
```

## comment:2

Section `.PARAMETER Executable` of the comment-based help.

```text
The executable the call runs. A directory and an extension are ignored (`C:\tools\dotnet.exe` resolves as
`dotnet`).
```

## comment:3

Section `.PARAMETER Command` of the comment-based help.

```text
The function whose own limit to return — its [Catzc.Base.Timeouts.TimeLimit] decoration, unless config overrides it.
The function must be loaded.
```

## comment:4

Section `.PARAMETER Shell` of the comment-based help.

```text
The shell whose limit to return, one of the execution engines (pwsh, bash or zsh); pwsh is the default. Any other name
throws, naming the shells.
```

## comment:5

Section `.PARAMETER Budget` of the comment-based help.

```text
The work's immutable budget GUID. When timeout-exemptions.yml exempts it here, the limit is raised to the
exemption ceiling (never lowered). Omitted (the empty GUID) means no budget.
```

## comment:6

Section `.PARAMETER EnvironmentAssertIs` of the comment-based help.

```text
Pins the expected run environment (Pipeline or Devbox); a different one throws. The guard verifies, it never
selects.
```
