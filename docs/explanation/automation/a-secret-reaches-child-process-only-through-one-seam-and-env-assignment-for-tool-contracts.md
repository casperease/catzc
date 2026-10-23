---
catzc:
  warning: "Experimental: this article merges two rules into one and holds nothing beyond what they say"
  edges:
    cites:
      - ADR-AUTO-ENVVAR-SECRETTOCHILDPROCESS
      - ADR-PWSH-ENV-ASSIGNMENTFORTOOLCONTRACT
---

# A secret reaches child process only through one seam and env assignment for tool contracts

This article is one rule:
[ADR-AUTO-ENVVAR-SECRETTOCHILDPROCESS](../../drs/automation/environment-variables.md#rule-adr-auto-envvar-secrettochildprocess) and
[ADR-PWSH-ENV-ASSIGNMENTFORTOOLCONTRACT](../../drs/automation/pwsh/environment-variable-mechanics.md#rule-adr-pwsh-env-assignmentfortoolcontract)
merged into one. It holds nothing beyond what those two rules say.

A `$env:` assignment in our code sets an external tool's contract variable, `$env:GIT_TERMINAL_PROMPT = '0'`,
`$env:DOTNET_CLI_TELEMETRY_OPTOUT = '1'` or `$env:PSModulePath`, and nothing else. Handing a secret to a child or external process through
the environment is the legitimate external-boundary use, permitted only through `Write-EnvironmentSet`, which takes the secret as a
protected value and never logs or returns the plaintext.
