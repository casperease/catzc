---
plan:
  status: active
  value: high
  reviewed: 2026-10-16
  targets:
    [
      docs/adr/thesis,
      docs/adr/principles,
      automation/Catzc.Base.Docs/configs/glossary.yml,
      automation/Catzc.Base.Docs/configs/adrs.yml,
      .claude/CLAUDE.md,
    ]
catzc:
  immutable:
    repo_status: clean
    path: ".claude/plans/plan-adr-cats.md"
    folder: plans
    name: plan-adr-cats
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
      - ADR-CATS#{1,2}
---

# ADR-CATS: cats and catzc, two names, two audiences, used across each other on purpose

Opened by the user in the questionnaire round of 2026-10-16 (decisions-2026-10-16.md, Q18 and Q18b). The question was the overlay folder
name, .catzc or .cats; the answer was that the question is bigger than a folder.

## Why its value is high

The names reach every surface: the module prefix, the C# namespaces, the type accelerators, the bash and zsh executor, the overlay and
fragment folders, the glossary, this file's own CLAUDE.md terminology section. Two plans wait on it: config defaults (the folder names) and
layers (the glossary terms for cats, catzc, pwsh and automation).

## The user's words (2026-10-16), the material for the rules

- cats is used primarily for new, other-sourced modules.
- catzc is an internal moniker for the inner repository namespace.
- cats is the more friendly, cute form of the product where we need it. We use it as the root executor for bash and zsh, and can likewise
  use cats in some contexts for pwsh. It is cute. It is us.
- cats and catzc, their distinction and their ability to be used cross-purpose with each other, is a core high-level product principle and
  should be controlled by ADR-CATS.

## Needed docs

- ADR-CATS, new, in the thesis or principles domain (the user called it a core high-level product principle; the domain is open). Rules to
  write: what catzc names (the inner namespace: module prefix, C# namespaces, accelerator prefix, the product token in code); what cats
  names (the product to a person: the executor, prose, other-sourced modules, consumer-facing folders); when one may stand in for the other
  and when it may not; the folder names that follow for the consumer overlay and this repo's own fragments.
- Glossary: cats, catzc (and their contrast), with avoid-phrasings; adrs.yml and index entries; the CLAUDE.md terminology section re-cited
  to the ADR.

## Needed tests

- Test-Glossary and Test-Terminology on the new terms; Test-AdrRegistry; Test-Links.
- Once the folder names are ruled: the overlay root tests in plan-config-defaults read the names from the rule.

## Open steps

- [x] Write ADR-CATS from the material above. Done 2026-10-17 (task006): docs/adr/principles/cats-and-catzc.md, five rules, registered as
      `cats-and-catzc: { external: ADR-CATS }`, a principles dora-explains entry, the index regenerated (line 73). Check: Test-AdrRegistry
      "No adr-registry issues found." (`out/test-adr-registry/20261017-062420`); Test-Links "No links issues found." on the ADR
      (`out/test-links/20261017-062339-2`); Test-Markdownlint clean (`out/test-markdownlint/20261017-062420`). The links to the ADR from
      dora-explains and CLAUDE.md report `[Untracked]` until the file is committed.
- [x] Glossary terms and avoid-phrasings. Done 2026-10-17: cats (ADR-CATS#2) and catzc (ADR-CATS#1) in glossary.yml with contrasts and the
      `.cats folder` avoid row; Build-Glossary lists both. Check: Test-Glossary reports no G1, G2, G3 or G5 finding, so both terms are
      anchored; its 238 G4 and G6 findings are the pre-existing ones plan-clear-actions lists per file
      (`out/test-glossary/20261017-062508`).
- [x] Tell plan-config-defaults and plan-layers-vocabulary-rename-contracts the folder and term decisions. Done 2026-10-17: a Decided line
      in each; plan-config-defaults `waits_on` names only the module model. Check: Test-Links clean on both
      (`out/test-links/20261017-062350`, `-2`).

## Decided (F1, S1, 2026-10-16)

- ADR-CATS rules cats and catzc only. pwsh and automation are kept strictly separate from it: the automation to pwsh folder rename is
  technical, and automation is a subject, the big cross-cutter together with design principles and pipelines; those names belong to the
  layers ADRs. Test-Glossary covers every file, plans and prompts included.

## Decided (B3, 2026-10-16)

- Domain: principles. The ADR lives beside everything-as-code, configure-not-program and one-living-version.

## Decided (D14, 2026-10-17)

- The code is `ADR-CATS`, one segment, no domain segment. The registry accepts the form since task005 (`AdrsConfig.ExternalRe` takes one or
  more uppercase segments; a one-segment external skips the domain-segment match); register it as
  `cats: { external: ADR-CATS }` under principles, the way `ai-agent-contract: { external: ADR-AI }` sits under repository.
