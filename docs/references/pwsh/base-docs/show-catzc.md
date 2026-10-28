# pwsh/Base.Docs/Show-Catzc.ps1

The offline browser behind "ask cats": it prints the decision record index, the loaded modules and the approved verbs from what the
repository already knows.

## The drs area

The decision record index getter returns a comma-wrapped array ([ADR-AUTO-CACHE](../../../drs/automation/caching.md) exemplar), so the
entries are taken by plain assignment: wrapping them again in `@()` would nest the array one level too deep.

For each rule it also shows what mechanically enforces it, the tests and the analyzer rules, keyed by the rule's code, which both sides use
(see the [index](../../../drs/index.md)).

## help

### synopsis

Ask the catzc docs — a deterministic browser over the decision records, modules, and approved verbs.

### description

"Ask cats": surfaces what the catzc system can do from what the repository already knows, offline and deterministically (no network, no
LLM). With no argument it prints the overview of what you can ask; an area narrows it:

```text
Show-Catzc drs [query]     the decision record codes and titles; with a query, the matching records and their rules
Show-Catzc module [name]   the modules; with a name substring, the public functions they export
Show-Catzc verbs           the approved verbs in use across the tree
```

Output is presentation only (the information stream, [ADR-AUTO-CONSOLE](../../../drs/automation/console-output-matters.md)); the function
returns nothing. Live bicep templates are out of scope here — use Get-BicepTemplates. The decision record reads are memoized for the session
by the private getters ([ADR-AUTO-CACHE](../../../drs/automation/caching.md)); the module and verb areas read the loaded modules' exports,
so they answer the same in source mode and build mode.

### parameter `Area`

What to ask about: drs, module, or verbs. Omitted (the default) prints the overview.

### parameter `Query`

Narrows the area: a decision record code/title substring for 'drs', a module-name substring for 'module'. Ignored by 'verbs' and the
overview.

### example 1

```powershell
Show-Catzc
Prints the overview of what you can ask.
```

### example 2

```powershell
Show-Catzc drs naming
Summarizes the decision records whose code or title contains 'naming', with each rule's one-line summary.
```

### example 3

```powershell
Show-Catzc module azure
Lists the public functions of every module whose name contains 'azure'.
```
