# Add an ADR

From a decision to a landed ADR: the page, its registration, the generated files that follow from it, and the checks that prove it. The
rules for what an ADR says and how it is shaped are the [authoring conventions](../../../drs/index.md#authoring-conventions) and the code
grammar of [adr-code-language](../../../drs/repository/drs-code-language.md) (ADR-REPO-DRSCODE); this guide only orders the work.

## Steps

1. **Pick the domain and the code.** The domain is the folder whose decisions this one belongs to, as `pwsh/Catzc.Base.Drs/configs/drs.yml`
   lists them; the code is the domain's prefix plus a segment that names the decision (`TDR-NORMALFORM`), each rule's code that plus one
   more segment.
2. **Write the page** at `docs/drs/<domain-folder>/<kebab-title>.md`: the rule registry first, one normative summary per rule, then the
   prose that justifies each rule. Copy the shape of a neighbouring ADR in the same folder.
3. **Register it** under its domain's `rulesets:` in `drs.yml`, keyed by the page's file name: `<kebab-title>: { external: <code> }`.
4. **Add its DORA entry** to the domain's `dora-explains.md`, one section per ADR, as the conventions describe. A vendor-checklist folder
   (`azure/caf/`, `azure/waf/`) takes none.
5. **Add its terms.** A term the rule bolds gets an entry in the owning module's `configs/glossary.yml`, its contrast with a similar term
   declared once on either term ([controlled-vocabulary](../../../drs/repository/controlled-vocabulary.md)).
6. **Regenerate** the index and the glossary, then format the files you touched.
7. **Check** the registry, the glossary and the links.

## Running it

Steps 6 and 7 run through the gate runner, `pwsh/.internal/assets/Invoke-CatzcCommand.ps1`, one quoted command per argument, so no throwaway
script is needed:

```powershell
pwsh -NoProfile -File pwsh/.internal/assets/Invoke-CatzcCommand.ps1 "Build-DrsIndex" "Build-Glossary"
pwsh -NoProfile -File pwsh/.internal/assets/Invoke-CatzcCommand.ps1 "Format-Code -Path docs/drs/<domain-folder>/<kebab-title>.md"
pwsh -NoProfile -File pwsh/.internal/assets/Invoke-CatzcCommand.ps1 "Test-DrsRegistry" "Test-Glossary" "Test-Links -Path docs/drs/<domain-folder>"
```

`Test-DrsRegistry` holds the page against `drs.yml`, the code grammar and the domain's `dora-explains.md`; `Test-Glossary` holds the terms
against the rules that bold them; `Test-Links` checks every link the page and its DORA entry carry. An ADR in `automation/` also passes
`Test-DrsEngineNeutrality`.

## Verify

The ADR is landed when the three checks pass, `docs/drs/index.md` lists the code, and `docs/drs/glossary.md` carries each new term.
