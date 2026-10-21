# Test an agent hook from a payload file

An agent hook under `.claude/hooks/<Name>/` reads one JSON payload from standard input and writes its decision to standard output.
`Build-AgentHook` publishes it to `.claude/hooks/bin/<Name>.exe` on import, and `.claude/settings.json` runs that exe. This guide feeds the
exe a payload by hand, the way the agent does.

## Write the payload to a file

Write the JSON to a file under `out/`, never through `echo` or `printf` in Git Bash: the shell eats the backslashes in the JSON, so the exe
reads a payload the agent never sends. Write it with the editor's write tool or from PowerShell:

```powershell
Set-Content -LiteralPath out/hook-payload.json -NoNewline -Value '{"tool_name":"Bash","tool_input":{"command":"git status","timeout":3000}}'
```

The fields are the ones the hook reads: `Assert-BashTimeout` reads `tool_input.command`, `tool_input.timeout` and
`tool_input.run_in_background`.

## Redirect it into the exe

Redirect the file into the published exe, from the repository root:

```bash
.claude/hooks/bin/Assert-BashTimeout.exe < out/hook-payload.json
```

No output means the hook allows the call. A deny is one JSON object whose `hookSpecificOutput` carries `permissionDecision: "deny"` and the
reason. Change one field of the payload per run, so each run proves one rule.

## Make it a test

A payload worth keeping becomes a case in the hook's Pester test,
[`Build-AgentHook.Tests.ps1`](../../../pwsh/Catzc.Base.TypesSystem/tests/Build-AgentHook.Tests.ps1), which pipes the payload string into the
published exe from PowerShell (`$Payload | & $program`), so no POSIX shell stands between the test and the JSON.
