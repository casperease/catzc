---
catzc:
  derived:
    path: docs/references/automation/catzc-base-timeouts/Get-TimeoutExemption.ps1.md
    kind: reference
    body_sha: "9ee34125edb0"
    adrs: []
---

# automation/Catzc.Base.Timeouts/Get-TimeoutExemption.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
Looks the budget up in timeout-exemptions.yml for the run environment (Get-RunEnvironment) and shell. An
exemption raises the budget's limit to its scope's ceiling while the work is tuned; it never removes the limit.
The result is the normalized entry: kind (single | range), from, to, environments, shells, reason.
```

## comment:2

Section `.PARAMETER Shell` of the comment-based help.

```text
The shell the work runs in, one of the execution engines (pwsh, bash or zsh); pwsh is the default. Any other name
throws, naming the shells.
```

## comment:3

Section `.PARAMETER EnvironmentAssertIs` of the comment-based help.

```text
Pins the expected run environment (Pipeline or Devbox); a different one throws. The guard verifies, it never
selects.
```
