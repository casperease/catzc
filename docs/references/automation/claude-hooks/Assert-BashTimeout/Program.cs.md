---
catzc:
  derived:
    path: docs/references/automation/claude-hooks/Assert-BashTimeout/Program.cs.md
    kind: comment-page
    body_sha: "605398973015"
    adrs:
      - ADR-AUTO-FAILFAST#7
    links: []
---

# .claude/hooks/Assert-BashTimeout/Program.cs

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `using System;`.

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

Above `private static IDictionary LoadYaml(string path)`.

```text
timeouts.yml as the nested IDictionary TimeoutsConfig takes, typed the way the module's YAML loader types it:
a plain integer is a number, a plain float a double, a quoted scalar stays a string.
```
