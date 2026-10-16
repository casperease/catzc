---
catzc:
  derived:
    path: docs/references/automation/claude-hooks/Assert-BashTimeout/Program.cs.md
    folder: docs/references/automation/claude-hooks/Assert-BashTimeout
    name: program-cs
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: "2276d83149dc"
    adrs:
      - ADR-AUTO-FAILFAST#7
---

# .claude/hooks/Assert-BashTimeout/Program.cs

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `using System;`, written with `//`.

```text
Claude Code PreToolUse hook: denies a Bash call that does not run inside the time safeguard
([ADR-AUTO-FAILFAST#7](/docs/adr/automation/fail-fast-with-asserts.md#rule-adr-auto-failfast7)).

The decision is Catzc.Base.Timeouts.BashSafeguard and the limits are Catzc.Base.Timeouts.TimeoutsConfig — the
module's own source files, compiled into this program (see the .csproj), so the hook, Get-TimeoutSeconds and the
L0 tests share one parser, one set of defaults and one verdict. This file only does the I/O: read the payload
from stdin, load timeouts.yml, detect the run environment, print a denial, and append each denial to
out/time-safeguard.log — the list of blockers to tune.

A compiled program because it runs before every Bash call: it starts in about a third of the time a pwsh script
does. Build-BashTimeoutHook publishes it to .claude/hooks/bin/, from where the repository root is three folders up.
```

## comment:2

Above `private static IDictionary LoadYaml(string path)`, written with `//`.

```text
timeouts.yml as the nested IDictionary TimeoutsConfig takes, typed the way the module's YAML loader types it:
a plain integer is a number, a plain float a double, a quoted scalar stays a string.
```
