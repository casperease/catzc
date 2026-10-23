<div style="background:#c00;color:#fff;padding:6px 10px"><b>Experimental</b> &nbsp; A name is a promise so get never modifies test returns bool and assert throws (ADR-AUTO-ONEJOB-NAMEISCONTRACT + ADR-PWSH-VERBS-SEMANTICCONTRACT)</div>

> **Experimental.** This article is one rule: [ADR-AUTO-ONEJOB-NAMEISCONTRACT](../../drs/automation/single-responsibility-functions.md#rule-adr-auto-onejob-nameiscontract) and [ADR-PWSH-VERBS-SEMANTICCONTRACT](../../drs/automation/pwsh/respect-pwsh-verb-rules.md#rule-adr-pwsh-verbs-semanticcontract) merged into one. It holds nothing beyond what those two rules say.

The function name is the contract. `Get-Config` must not modify state and `Invoke-Poetry` must not install Poetry; if the name does not cover what the function does, rename it or remove the behavior. In PowerShell the verb is the promise: a `Get-` function must not modify state, a `Test-` function must return `[bool]`, and an `Assert-` function must throw on failure.
