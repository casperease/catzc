---
task:
  id: "006"
  status: done
  plans: [plan-adr-cats, plan-config-defaults, plan-layers-vocabulary-rename-contracts]
  value: high
  blocked_on: nothing
  targets:
    [docs/adr/principles, automation/Catzc.Base.Docs/configs/adrs.yml, automation/Catzc.Base.Docs/configs/glossary.yml, .claude/CLAUDE.md]
catzc:
  immutable:
    repo_status: clean
    path: ".claude/plans/task006.md"
    folder: plans
    name: task006
    filetype: md
    kind: other
    language: markdown
    track: ".claude"
    tracktype: vendor-settings
    vendor: claude
    module: ".claude"
    moduletype: settings
  edges:
    cites:
      - ADR-CATS#{1,2,5}
---

# task006: write ADR-CATS

Two plans wait on it: config defaults needs the overlay and fragment folder names, layers needs the glossary terms. Domain decided:
principles (B3). Scope decided (F1, S1): cats and catzc only; pwsh and automation belong to the layers ADRs. Material: the user's words in
plan-adr-cats.md. Present tense, no history, rules bolded, plain language (authoring conventions).

## Done (2026-10-17), with each check's verdict

- Correction found by a run: `GlossaryConcept.CitationRe` still required `ADR-<CODE>-<NAME>#<n>`, so the two glossary concepts made every
  import fail in the glossary janitor until the regex took one or more segments (D14's form); `GlossaryConfig.Tests.ps1` lost the
  `ADR-COG#3` malformed case and gained a one-segment acceptance test, `[Invoke-TestFile] Passed (in-place)`
  (`out/test-file/20261017-062339-67dffd`). It was the last two-segment validator; AgentEntry, CapabilityEntry, AgentsConfig and the link
  engine already took one segment. A `types/*.cs` edit means a new `automation/.compiled/Catzc.Types.<hash>.dll` for the user to stage.
- Step 1: the ADR written, 125 lines, five rules each bolding or naming its term and linking its prose. `Format-FileMeta` imprints only
  tracked files, so the head carries no `with_body_sha` until the user commits and formats; the `[Untracked]` link findings on
  dora-explains and CLAUDE.md clear at the same commit. `[Write-QualityGateReport] No links issues found.`
  (`out/test-links/20261017-062339-2`); `[Write-QualityGateReport] No markdownlint issues found.` (`out/test-markdownlint/20261017-062420`).
- Step 2: `cats-and-catzc: { external: ADR-CATS }` under principles, no `concern` (the domain default covers it); the domain description
  names the two names. `[Invoke-TestFile] Passed (snapshot)` for AdrsConfig.Tests.ps1 (`out/test-file/20261017-062339-469142`);
  `[Write-QualityGateReport] No adr-registry issues found.` (`out/test-adr-registry/20261017-062420`).
- Step 3: the principles dora-explains entry, code-maintainability and documentation-quality links. Test-Links: one `[Untracked]` finding,
  the new ADR, left as is (`out/test-links/20261017-062340`).
- Step 4: `Build-AdrIndex` run; the index lists `ADR-CATS` at line 73. `[Write-QualityGateReport] No generated-files issues found.`
  (`out/test-generated-files/20261017-062446`).
- Step 5: both concepts in glossary.yml with contrasts and the avoid row; `Build-Glossary` lists both. Test-Glossary: no G1, G2, G3 or G5
  finding; 238 pre-existing G4 and G6 findings (16 and 221, the latter mostly "assets-source" in generated tree pages) fail the gate as they
  did before this task (`out/test-glossary/20261017-062508`). Two of them were fixed on the way: "house rules" quoted in ADR-AI rule 12,
  "vocabulary gate" reworded in plan-adr-cats.
- Step 6: CLAUDE.md terminology bullets cite ADR-CATS#1 and ADR-CATS#2 with relative links. Test-Links: two `[Untracked]` findings, the new
  ADR, left as is (`out/test-links/20261017-062339`).
- Step 7: plan-config-defaults `waits_on` names only the module model; a Decided line for ADR-CATS#5. `[Write-QualityGateReport] No links
  issues found.` (`out/test-links/20261017-062350`).
- Step 8: the layers plan has its Decided line. `[Write-QualityGateReport] No links issues found.` (`out/test-links/20261017-062350-2`).
- Step 9: plan-adr-cats's three steps ticked; it has no open step and is deleted in T036.

## Steps, as planned

1. `docs/adr/principles/cats-and-catzc.md`, new. Head as the neighbours (Format-FileMeta writes it). `# ADR-CATS: cats and catzc` then
   `## Rules: ADR-CATS` with rules:
   - 1 **catzc** is the source-level name: the `Catzc.*` module prefix, the C# namespaces, the type-accelerator prefix, the product token in
     code and precise references.
   - 2 **cats** is the product's name to a person: the bash and zsh executor, prose and docs, the human form in conversation ("ask cats").
   - 3 cats names what comes from outside: new, other-sourced modules carry the cats form; catzc stays the inner namespace.
   - 4 either may stand in for the other where the audience is mixed (a pwsh entry point may say cats); neither replaces the other in its
     own home (no `Cats.*` module, no catzc in a user-facing sentence that has a cats form).
   - 5 the folder names that follow: the consumer overlay root and this repository's own config-fragment root are `.catzc/`; `.cats/` is
     never written and never read (one living version; the Q6 alias is withdrawn by this rule). Then Context (the two audiences), Decision,
     Consequences (CLAUDE.md terminology section cites this ADR). Check: Test-Markdownlint and Test-Links clean on the file; Format-FileMeta
     writes `defines: ADR-CATS#{1-5}`.
2. `automation/Catzc.Base.Docs/configs/adrs.yml`, principles `rulesets:`: add
   `cats-and-catzc: { external: ADR-CATS, concern: [automation] }`. Check: AdrsConfig test passes; Test-AdrRegistry clean (background).
3. `docs/adr/principles/dora-explains.md`: one entry `## cats and catzc` with the ADR link, two sentences (one name per audience removes a
   source of variability in how the product is spoken of and written), capability links `code-maintainability` and `documentation-quality`
   if that slug exists in docs/references/dora/capabilities.md (grep first), else `platform-engineering`. Check: Test-Links clean.
4. `Build-AdrIndex` (background). Check: the index lists ADR-CATS under principles; Test-GeneratedFiles clean.
5. `automation/Catzc.Base.Docs/configs/glossary.yml`, `concepts:`: add `cats` (key cats, domain principles, defined_by ADR-CATS#2, short:
   the product's name to a person; the executor and the prose form) and `catzc` (key catzc, defined_by ADR-CATS#1, short: the source-level
   name; module prefix, namespaces, accelerator prefix). Each with `realized_by: { kind: prose-only }` and one `avoid` row
   (`{ phrase: ".cats folder", say: ".catzc/" }` on catzc). Then `Build-Glossary` (background). Check: Test-Glossary clean; the glossary
   page lists both.
6. `.claude/CLAUDE.md`, Terminology section: the two bullets keep their text and gain a citation `(ADR-CATS#1)` and `(ADR-CATS#2)` with the
   relative link to the ADR. Check: Test-Links clean on CLAUDE.md.
7. `plan-config-defaults.md`, Decided: one line "ADR-CATS#5 rules the folder: .catzc/ only, no .cats alias (supersedes Q6's alias)"; remove
   "plan-adr-cats for the folder names" from the head's `waits_on`. Check: grep waits_on in the file names only the module model, or
   nothing.
8. `plan-layers-vocabulary-rename-contracts.md`, Decided: one line that cats and catzc are glossary terms from ADR-CATS and the layers
   glossary list excludes them. Check: Test-Links clean on the file.
9. `plan-adr-cats.md`: tick its three steps with the results. Check: grep `- [ ]` counts zero; the plan is deleted in T036.

## Report

As report-fixed.
