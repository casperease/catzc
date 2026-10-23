---
name: catzc-run
description:
  How to run a cats command or any shell call under the time safeguard; for every robot that runs pwsh; input is the command to run.
user-invocable: false
allowed-tools: Bash
metadata:
  catzc:
    config:
      model_floor: haiku
      needs: [pwsh]
---

# catzc-run

1. A foreground Bash call carries `timeout: 3000` and only reads or probes (cat, ls, grep, git status, log, diff); it never imports cats.
2. A cats command runs in the background as one command through the entry script, never an `out/*.ps1` of its own:
   `timeout <s> pwsh -NoProfile -File pwsh/.internal/assets/Invoke-CatzcCommand.ps1 '<command with args>' …`, one quoted argument per
   command, in single quotes so bash leaves `$_` alone, `Invoke-TestFile` with `-PassThru` on test files only (a language test folder runs
   only through `Test-Automation -Modules`), `Format-Code` with `-Path` on the files touched, never `-Language markdown`; a path list is a
   PowerShell array inside that quoted command (`-Path a.md, b.md`, bare), never comma-joined as one `pwsh -File` argument, which binds as
   one string; no `cd &&`, pipes or `;` in the call; `<s>` at most 360.
3. Exit 124 is the safeguard: report it as the stop reason and never retry with a larger limit; a denied call goes to the coordinator, not
   to a retry; a burst ends with "burst done" sent at once after `Exit-CatzcBurst`.
4. A private function runs inside its module, `& (Get-Module <Module>) { <Function> … }`, never by dot-sourcing its file; a background run
   is waited on by a second background call, never by polling its output, and its result is read with one grep for its
   `Invoke-CatzcCommand`, `Write-QualityGateReport` and `Invoke-TestFile` lines, never a tail per run; a tree sweep is answered by the Grep
   and Glob tools, never a shell loop or recursive grep, and a wide markdown table is searched with only-matching output or a count.
   Editing a code line whose long comment moved to a `docs/references/` comment page edits that page's "Above `…`" line too. A shared
   config (`file-meta.yml`, `generated-head.yml`, `glossary.yml`) is live for every session's next import, so its edit lands with its code
   in one pass and is parked in `out/` during a peer's burst, as is a `pwsh/*/types/*.cs` edit (every import compiles it), and a gate
   after a `Format-Code` on C# (it moves the DLL key) runs in a fresh import; a root asset (`pwsh/Catzc.Base.RootConfig/assets/root/*`)
   too, which every import's Build-RootConfig materialises, so its edit starts with a HOLD to every live peer. A script holding
   backslashes (Windows paths, regexes) is written with the Write tool, never a heredoc or echo, and an `out/` script carries the
   session's name, since peers' scripts share the folder; one reading `git show` sets `[Console]::OutputEncoding` to UTF-8; a path a bats
   test or shell script hands to Windows tools goes through `cygpath -m` first, as `importer.sh` does.
