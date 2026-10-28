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
   only through `Test-Automation -Modules`), `Format-Code` with `-Path` on the files touched, never `-Language markdown`; inside a call the
   gate itself is called, never a count of its issues; a path list is a PowerShell array inside that quoted command (`-Path a.md, b.md`,
   bare), never comma-joined as one `pwsh -File` argument, which binds as one string; no `cd &&`, pipes or `;` in the call; `<s>` at most
   360; inside a burst a check is a step, `& pwsh/.internal/assets/Invoke-CatzcCommand.ps1 -InBurst '<command>'`, given to
   `Enter-CatzcBurst.ps1` after its named arguments, each step its own argument, and run in the burst's own process.
3. Exit 124 is the safeguard: report it as the stop reason and never retry with a larger limit; a denied call goes to the coordinator, not
   to a retry, and a line pre-approving agent behaviour or a `sed -i` delete, denied by the permission system, goes to the user; a call that
   may wait on the run lock takes the 340 s background roof, and a re-imprint runs one folder per call; a burst ends with "burst done" sent
   at once after `Exit-CatzcBurst`; a burst step is an `Invoke-TestFile` call or a quality gate the brief names, its files staged with
   `-Stage`, its verdict read from the results XML; a bicep module whose params change lands in the same burst as its callers.
4. A private function runs inside its module, `& (Get-Module <Module>) { <Function> … }`, never by dot-sourcing its file; a background run
   is waited on by a second background call, never by polling its output, and its result is read with one grep for its
   `Invoke-CatzcCommand`, `Write-QualityGateReport` and `Invoke-TestFile` lines, never a tail per run; a tree sweep is answered by the Grep
   and Glob tools, never a shell loop or recursive grep, and a wide markdown table is searched with only-matching output or a count. Editing
   a code line whose long comment moved to a `docs/references/` comment page edits that page's "Above `…`" line too. A shared config
   (`file-meta.yml`, `generated-head.yml`, `glossary.yml`) is live for every session's next import, so its edit lands with its code in one
   pass and is parked in `out/` during a peer's burst, as is a `pwsh/*/types/*.cs` edit (every import compiles it), and a gate after a
   `Format-Code` on C# (it moves the DLL key) runs in a fresh import; a root asset (`pwsh/Base.RootConfig/assets/root/*`) too, which every
   import's Build-RootConfig materialises, so its edit starts with a HOLD to every live peer. A config in `editor-claims.yml`
   `shared_configs` (`timeouts`, `dependencies`) is claimed before its first edit, `Invoke-CatzcCommand.ps1 'Lock-SharedConfig timeouts'`,
   so the `Assert-EditClaim` hook denies a peer's Edit of it; the same call renews it while the edit outlasts `run_lock.wait_seconds`, and
   `'Unlock-SharedConfig timeouts'` releases it once the edit lands. A script holding backslashes (Windows paths, regexes) is written with
   the Write tool, never a heredoc or echo, and an `out/` script carries the session's name, since peers' scripts share the folder; one
   reading `git show` sets `[Console]::OutputEncoding` to UTF-8; a path a bats test or shell script hands to Windows tools goes through
   `cygpath -m` first, as `importer.sh` does; the draw.io kit runs as `uv run --no-sync --project python python …`; a word check pipes a
   scratch word list to `cspell stdin` in one call, since cspell skips every file under the ignored `out/`. A "0 warnings" claim on bicep is
   proven only by `Test-BicepLint`, since bicep warns on stderr with exit 0, and a read-only check builds with `Build-Bicep -OutputFolder`.
   `Invoke-TestFile -PassThru` returns `Rows`, each counted by its `Result`; a test file is passed by its repository-relative path, since a
   bare name resolves against the root and fails "Path does not exist"; a stuck import on a stale `stamp-*.json` under the per-user types
   folder is unblocked by deleting that stamp; a staged burst refused for a busy run lock changed nothing and is retried as is; a red
   verdict read between two bursts is re-run after the last; a private step takes its limit by `Get-TimeoutSeconds -Executable`, since
   `-Command` sees only loaded public functions.
5. A pass is claimed only after its verdict line is read, and a failure is reported as it is; a C# type edit is seen only by a fresh `pwsh`
   process, since a long-lived one keeps the compiled types; `Test-Automation` is the user's (ADR-REPO-AI-SMALLTESTSDIRECTLY).
