# pwsh/Base.Docs/Show-Cats.ps1

The offline browser behind "ask cats": it prints the ADR index, the loaded modules and the approved verbs from what the repository already
knows.

## The ADR area

The ADR index getter returns a comma-wrapped array
([ADR-AUTO-CACHE](../../../drs/automation/caching.md) exemplar), so the entries are taken by plain assignment: wrapping them again in `@()`
would nest the array one level too deep.

For each rule it also shows what mechanically enforces it, the tests and the analyzer rules, keyed by the rule's code, which both sides use
(see the [index](../../../drs/index.md)).

## help

### synopsis

Ask the catzc docs — a deterministic browser over the ADRs, modules, and approved verbs.

### description

"Ask cats": surfaces what the catzc system can do from what the repository already knows, offline and deterministically (no network, no
LLM). With no argument it prints the overview of what you can ask; an area narrows it:

```text
Show-Cats adr [query]     the ADR codes and titles; with a query, the matching ADRs and their rules
Show-Cats module [name]   the modules; with a name substring, the public functions they export
Show-Cats verbs           the approved verbs in use across the tree
```

Output is presentation only (the information stream, [ADR-AUTO-CONSOLE](../../../drs/automation/console-output-matters.md)); the function
returns nothing. Live bicep templates are out of scope here — use Get-BicepTemplates. The ADR reads are memoized for the session by the
private getters ([ADR-AUTO-CACHE](../../../drs/automation/caching.md)); the module and verb areas read the loaded modules' exports, so they
answer the same in source mode and build mode.

### parameter `Area`

What to ask about: adr, module, or verbs. Omitted (the default) prints the overview.

### parameter `Query`

Narrows the area: an ADR code/title substring for 'adr', a module-name substring for 'module'. Ignored by 'verbs' and the overview.

### example 1

```powershell
Show-Cats
Prints the overview of what you can ask.
```

### example 2

```powershell
Show-Cats adr naming
Summarizes the ADRs whose code or title contains 'naming', with each rule's one-line summary.
```

### example 3

```powershell
Show-Cats module azure
Lists the public functions of every module whose name contains 'azure'.
```
