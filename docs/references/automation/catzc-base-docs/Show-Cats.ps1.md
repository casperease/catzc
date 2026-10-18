# automation/Catzc.Base.Docs/Show-Cats.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

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

Output is presentation only (the information stream, [ADR-AUTO-CONSOLE](../../../adr/automation/console-output-matters.md)); the function
returns nothing. Live bicep templates are out of scope here — use Get-BicepTemplates. The ADR reads are memoized for the session by the
private getters ([ADR-AUTO-CACHE](../../../adr/automation/caching.md)); the module and verb areas read the loaded modules' exports, so they
answer the same in source mode and build mode.

### parameter Area

What to ask about: adr, module, or verbs. Omitted (the default) prints the overview.

### parameter Query

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

## comment:1

Above `$entries = Get-CatsAdrIndex`, written with `#`.

```text
Plain assignment (not @(...)): the getter returns a comma-wrapped array
([ADR-AUTO-CACHE](/docs/adr/automation/caching.md) exemplar),
which assignment receives intact — wrapping it again in @() would nest it one level too deep.
```

## comment:2

Above `$entryEnforcers = $enforcers[($rule.Id -replace ':', '#')]`, written with `#`.

```text
Show what mechanically enforces this rule (tests + analyzer rules), if anything —
the citation is the '#' form of the registry id ([index](/docs/adr/index.md)).
```
