---
plan:
  status: active
  value: high
  reviewed: 2026-10-18
  targets:
    [
      docs/adr/index.md,
      docs/adr/repository,
      contracts,
      pwsh/Catzc.Base.Docs,
      pwsh/Catzc.Base.Docs/configs/adrs.yml,
      pwsh/Catzc.Base.QualityGates,
      .claude/drawio,
    ]
---

# One ADR code language: a path of segments, every string a fact, no numbers

The design questions were answered on 2026-10-18 (see Decisions).

An ADR reference is one string, `ADR` followed by zero or more `-SEGMENT`s, read from the most general part to the most specific: `ADR`,
then the domain, then the ADR, then the rule. Every string names a fact: the rule, ADR or domain it spells out. Every string is also a
selector: it selects itself and everything whose segments start with it. There are no rule numbers, no `#`, no `:`, no `{1,3-5}` groups and
no ranges. Citing several facts means writing several strings.

| String                             | Selects                                            |
| ---------------------------------- | -------------------------------------------------- |
| `ADR`                              | every ADR and every rule                           |
| `ADR-AUTO`                         | every ADR of the automation domain and their rules |
| `ADR-AUTO-FAILFAST`                | the fail-fast ADR and all its rules                |
| `ADR-AUTO-FAILFAST-BOUNDEVERYWAIT` | the one rule "Bound every wait" (today `#7`)       |

## Why its value is high

A number says nothing. `ADR-DSGN-TRACK#12` is cited 931 times and `ADR-DSGN-TRACK#1` 807 times, and a reader learns nothing from either
without opening the ADR. `ADR-AUTO-FAILFAST#7` gives no hint that the time safeguard rests on it. Groups such as `#{1-3}` or `#{1,5}` add a
second small language, with its own parser (`AdrCodeForm.Expand`/`Minimize`), its own range limit, and its own way to go wrong. A path of
names reads in prose, greps by prefix (`git grep ADR-AUTO-FAILFAST` finds the ADR and every rule in it), and has one grammar for every
level.

## Measured today (git grep over tracked files, 2026-10-18)

| What                                          | Count                                         |
| --------------------------------------------- | --------------------------------------------- |
| ADRs with a rule registry (`## Rules: ADR-…`) | 188                                           |
| rules (`### Rule ADR-…:<n>` headings)         | 1645                                          |
| `ADR-X#<n>` citations                         | 10901                                         |
| `ADR-X#{…}` group citations                   | 39                                            |
| `#rule-adr-…<n>` anchors in links             | 4482                                          |
| files carrying a `#` citation                 | 2234                                          |
| largest registry                              | 68 rules (`azure/caf/identity-and-access.md`) |

Citing files by area: `docs/references` 1015, `docs/explanation` 471, `pwsh/Catzc.Base.QualityGates` 141, `docs/adr` 127, `contracts/catzc`
77, `pwsh/Catzc.Base.Docs` 59, `pwsh/Catzc.Base.Contracts` 39, `.claude/plans` 29.

Code shapes in `docs/adr/index.md`: 183 codes have two segments, 4 have three, and 2 have one.

## The grammar

```text
code     = "ADR" *( "-" segment )
segment  = UPPER *( UPPER / DIGIT )        ; no lower case, no '#', ':', '{', ',' or '_'
```

1. **Level 1, `ADR`.** The literal prefix and the root of the tree. It stays the one searchable marker for an ADR reference anywhere
   (today's index rule).
2. **Level 2, the domain.** One segment per domain in `adrs.yml`, a closed set, one-to-one with the `docs/adr/<domain>/` folders.
3. **Level 3, the ADR.** One segment naming the decision record, unique within its parent (`FAILFAST`, `ONELIVE`, `TRACK`). A vendor
   reference adds one group level before it (`ADR-AZ-CAF-IAM`, `ADR-AZ-WAF-RELIABILITY`; Decision 4).
4. **Last level, the rule.** One segment naming what the rule says, spelled-out words joined with no length cap (`BOUNDEVERYWAIT`,
   `NOCOMPATIBILITYSHIMS`; Decision 2). It replaces the number. A vendor checklist ADR uses the vendor's item id as the segment.
5. **Prefix matching is whole-segment.** `ADR-AUTO-GO` selects `ADR-AUTO-GO-…` and never `ADR-AUTO-GOLD`. A matcher compares the string
   followed by `-`, or the whole string, never bare characters.
6. **Siblings share one namespace.** Under one parent, a child ADR and a rule never share a name, so every string resolves to exactly one
   node. `adrs.yml` plus the registries form the tree, and `Test-AdrRegistry` refuses a duplicate.
7. **A retired name is never reused.** This carries over today's rule that a retired number is never reused. A rule whose meaning changes
   gets a new name; the old string is left unresolvable rather than repointed.
8. **No subset spelling.** A citation is never `ADR-X-{A,B}` or a range. To cite a subset, write each string. To cite a whole ADR, write the
   ADR's string. Today's `Minimize` does not survive as "collapse to groups". It survives only as "a derived list that covers every rule of
   an ADR is written as the ADR"; hand-written prose never collapses (Decision 3).
9. **A registry keeps its authored order.** Numbers gave the order for free; without them the `### Rule` headings stay in the order the ADR
   writes them, never sorted by name (Decision 7).

### Heading, anchor, link

| Today                                                                  | Proposed                                                                                |
| ---------------------------------------------------------------------- | --------------------------------------------------------------------------------------- |
| `## Rules: ADR-AUTO-FAILFAST`                                          | `## Rules: ADR-AUTO-FAILFAST` (unchanged)                                               |
| `### Rule ADR-AUTO-FAILFAST:7`                                         | `### Rule ADR-AUTO-FAILFAST-BOUNDEVERYWAIT`                                             |
| anchor `#rule-adr-auto-failfast7`                                      | anchor `#rule-adr-auto-failfast-boundeverywait` (GitHub slug of the heading)            |
| cite `ADR-AUTO-FAILFAST#7`                                             | cite `ADR-AUTO-FAILFAST-BOUNDEVERYWAIT`                                                 |
| code link `[ADR-AUTO-FAILFAST#7](/docs/adr/…#rule-adr-auto-failfast7)` | `[ADR-AUTO-FAILFAST-BOUNDEVERYWAIT](/docs/adr/…#rule-adr-auto-failfast-boundeverywait)` |

With the new heading, the anchor is the lower-cased string itself. The index's warning that the anchor is `rule-adr-pwsh-error3`, not
`rule-adr-pwsh-error-3`, goes away, because the anchor and the citation are spelled the same.

## Checked against repository samples

Each sample is today's text with a slug proposed from the rule's first sentence. The slugs are illustrations, not decisions (step 2 names
them all).

| File (today)                                                                                    | Today                                                              | Proposed                                                                                                                                                                        |
| ----------------------------------------------------------------------------------------------- | ------------------------------------------------------------------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `docs/adr/automation/fail-fast-with-asserts.md` heading                                         | `### Rule ADR-AUTO-FAILFAST:1` "Assert inputs at function entry"   | `### Rule ADR-AUTO-FAILFAST-ASSERTINPUTSATENTRY`                                                                                                                                |
| same file                                                                                       | `:5` "Never catch assertion failures"                              | `ADR-AUTO-FAILFAST-NEVERCATCHASSERTIONS`                                                                                                                                        |
| same file                                                                                       | `:7` "Bound every wait"                                            | `ADR-AUTO-FAILFAST-BOUNDEVERYWAIT`                                                                                                                                              |
| `.claude/CLAUDE.md` time safeguard                                                              | `ADR-AUTO-FAILFAST#7` + `#rule-adr-auto-failfast7`                 | `ADR-AUTO-FAILFAST-BOUNDEVERYWAIT` + `#rule-adr-auto-failfast-boundeverywait`                                                                                                   |
| `docs/adr/principles/one-living-version.md`                                                     | `:1`…`:8`                                                          | `ONEVERSION`, `NOCOMPATIBILITYSHIMS`, `NODEADCODE`, `TRUNKBASED`, `HISTORYINGIT`, `PRESENTTENSEDOCS`, `PINNEDVERSIONNOTLEGACY`, `BRANCHBYABSTRACTION` under `ADR-PRIN-ONELIVE-` |
| drawio subtitle, `adr-prin-onelive--a-sibling-is-an-idea-never-a-reference--meta.drawio.png`    | `ADR-AUTO-GO#1 · ADR-PRIN-ONELIVE#{1,5} · meta`                    | `ADR-AUTO-GO-TESTARTIFACTSONLY · ADR-PRIN-ONELIVE-ONEVERSION · ADR-PRIN-ONELIVE-HISTORYINGIT · meta`                                                                            |
| drawio subtitle, `adr-dsgn-aspect--each-track-picks-its-catch-all--meta.drawio.png`             | `ADR-DSGN-ASPECT#{1-3} · meta`                                     | `ADR-DSGN-ASPECT · meta` when rules 1–3 are all of its rules (a subtitle is a derived list, Decision 3), otherwise the three strings                                            |
| `docs/adr/azure/caf/identity-and-access.md` heading                                             | `### Rule ADR-AZ-CAFIAM:1` (inventory of authentication providers) | `### Rule ADR-AZ-CAF-IAM-<vendor item id>` (Decision 4)                                                                                                                         |
| Pester tag, `pwsh/.internal/tests/Get-CombinedTypeHash.Tests.ps1:1`                             | `-Tag 'L0', 'logic', 'ADR-AUTO-TYPES#9'`                           | `-Tag 'L0', 'logic', 'ADR-AUTO-TYPES-<slug of rule 9>'`                                                                                                                         |
| throw text, `pwsh/Catzc.Base.Docs/private/Get-GlossaryAnchorViolations.ps1:22`                  | `… (ADR-REPO-VOCAB#1)`                                             | `… (ADR-REPO-VOCAB-<slug of rule 1>)`                                                                                                                                           |
| same module, `Get-GlossaryDefinitionViolations.ps1:27`                                          | `$ruleId.Replace(':', '#')`                                        | the replace goes: the heading key and the citation are one string                                                                                                               |
| comment, `docs/adr/automation/sensible-defaults.md` rule 6                                      | `[consumer-overlay](consumer-overlay.md#rule-adr-auto-overlay4)`   | `…#rule-adr-auto-overlay-<slug>`                                                                                                                                                |
| command contract head, `contracts/catzc/0.0.0/…/Register-AdoBuildValidation.command.yml:1`      | `(ADR-REPO-CMDCONTRACT#1)`                                         | `(ADR-REPO-CMDCONTRACT-<slug>)`; `0.0.0` is the draft folder, not frozen, so it is an ordinary rewrite                                                                          |
| released contract, `contracts/EXTERNAL-azure/0.1.0/.frozen:2` and its `main.json.schema.json:2` | `ADR-REPO-CONTRACT#5`, `#6`                                        | rewritten, and the `.frozen` SHA record refreshed in the same change (Decision 5)                                                                                               |
| type comment, `pwsh/Catzc.Base.Docs/types/AdrCodeForm.cs:9`                                     | `ADR-PWSH-TYPES#1`                                                 | `ADR-PWSH-TYPES-<slug>`                                                                                                                                                         |
| file head `adrs:` (derived), e.g. `pwsh/Catzc.Base.Config/configs/configs.yml:43`               | minimal-form list with `#{…}`                                      | a sorted list of plain strings, one per fact                                                                                                                                    |

### What the samples exposed

- **The two hand-picked subtitles** use a group (`#{1,5}`) and a range (`#{1-3}`). Rule 8 removes both spellings. The group becomes two
  strings, and the range becomes either the ADR string or three strings.
- **`ADR-FLOW-CD` already has children**: `ADR-FLOW-CD-RUNNER`, `-DETECT`, `-TYPE` and `-GLOBS` are separate ADRs. Under the new grammar,
  `ADR-FLOW-CD` selects all five ADRs and their rules. That fits the design, and it is the only place today where a code is a prefix of
  another. Rule 6 then requires that no rule of `ADR-FLOW-CD` is named `RUNNER`, `DETECT`, `TYPE` or `GLOBS`.
- **Level 2 is not the domain everywhere today.**

  | Code               | Lives in                          | Level 2 today      | Domain segment            |
  | ------------------ | --------------------------------- | ------------------ | ------------------------- |
  | `ADR-CATS`         | `principles/cats-and-catzc.md`    | `CATS` (no domain) | `PRIN`                    |
  | `ADR-AI`           | `repository/ai-agent-contract.md` | `AI` (no domain)   | `REPO`                    |
  | `ADR-PRIN-PROCESS` | `process/agile-principles.md`     | `PRIN`             | `PROC`                    |
  | `ADR-DORA-*` (34)  | `research/`                       | `DORA`             | `DORA` (kept, Decision 1) |

  Every other code already starts with its domain: `THES`, `PRIN`, `PROC`, `DSGN`, `FLOW`, `AUTO`, `PWSH`, `CONF`, `PIPE`, `GH`, `AZ`,
  `REPO`. So three codes move: `ADR-CATS` → `ADR-PRIN-CATS`, `ADR-AI` → `ADR-REPO-AI`, `ADR-PRIN-PROCESS` → `ADR-PROC-AGILE` (name to
  confirm in step 2).

- **Nested folders add a level only for vendor references.** `automation/BCL/native-csharp-types.md` stays `ADR-AUTO-TYPES`. The 12
  `azure/caf/*` and 5 `azure/waf/*` ADRs get a `CAF`/`WAF` group level: `ADR-AZ-CAFIAM` → `ADR-AZ-CAF-IAM` (Decision 4).
- **Very large registries take the vendor's ids.** `azure/caf/identity-and-access.md` holds 68 rules that answer a vendor checklist item by
  item; their slugs are the checklist's own item ids, normalised to the segment form (upper case, no `.` or `_`). Step 2 checks that every
  CAF/WAF rule can be traced to one vendor item id; one that cannot gets a spelled-out slug.
- **`ADR-AUTO-SPELL` asks for spelled-out names**, so slugs are spelled-out words joined (Decision 2). The vendor ids are external names
  that the vendor owns, which ADR-AUTO-SPELL rule 4 leaves alone.
- **The contract freeze is smaller than it looked.** `contracts/catzc/0.0.0/` (77 citing files) is the draft folder that
  `Publish-ContractRelease` freezes and is never itself frozen. The only released, frozen folder is `contracts/EXTERNAL-azure/0.1.0/`, with
  two citing files. Breaking the freeze (Decision 5) means rewriting those two and refreshing their `.frozen` SHA-256 record so that
  `Test-Contracts` stays green.

## Machinery that changes (one living version: every caller in the same change, no dual-read)

- `pwsh/Catzc.Base.Docs/types/AdrCodeForm.cs` and its tests: the `#`/group parser goes. What remains is a segment parser, a whole-segment
  prefix matcher, and (if kept) "covers every rule of the ADR, so write the ADR".
- `pwsh/Catzc.Base.Docs/Update-AdrCitation.ps1`: it already takes a `-CodeMap` and a `-RuleMap` and has `-DryRun`. It is the rewrite tool
  for the migration, fed a rule map from `ADR-X:<n>` to `ADR-X-<SLUG>` and a code map for the four domain moves. It works one file at a time
  (CLAUDE.md, Editing).
- `adrs.yml`, `Build-AdrIndex`, `Test-AdrRegistry`: the registry heading form, the uniqueness rule (6), and retired-name tracking (7).
- `Get-CatsAdrRuleIds`, `Get-CatsAdrRules`, and the `links.yml` exemptions that describe "rule ids in registry form".
- `Format-Links`, `Test-Links`: the anchor is computed from the heading, with no number concatenation.
- `.claude/drawio/drawio_forward.py`: `RULE_COLON` and `slide_facts` read plain strings. Diagram file names (`adr-dsgn-aspect--…`) are
  already lower-case code prefixes and stay valid.
- Glossary `defined_by`, the analyzer ADR map (`AnalyzerAdrMapConfig`), file heads `adrs:` (derived, so they regenerate), and Pester tags.
- `docs/adr/index.md` "Citing a rule" and ADR-REPO-LINK (`#` as the only spelling) are restated present-tense. The grammar becomes the rules
  of its own ADR, `docs/adr/repository/adr-code-language.md` with code `ADR-REPO-ADRCODE` (Decision 6). ADR-REPO-LINK keeps only the link
  forms and points to it.
- `contracts/EXTERNAL-azure/0.1.0/.frozen`: its SHA-256 lines for the two rewritten files are refreshed (Decision 5).

## Open steps

- [x] 1. Write `docs/adr/repository/adr-code-language.md` (`ADR-REPO-ADRCODE`) with the grammar as its 8 rules and register it in `adrs.yml`.
      Add the `code_language` check to `Test-AdrRegistry` (segment form, domain segment, numbered rule headings, sibling uniqueness), in
      `report` mode in `adr-checks.yml`, so today's tree reports and never fails. The index's "Citing a rule" and ADR-REPO-LINK keep the `#`
      form until step 6, because it is the live spelling until then. Check: the `Test-AdrRegistry` and `AdrChecksConfig` test files pass;
      `Test-AdrRegistry` and `Test-Links` on the new ADR clean.
- [x] 2. Write the slug map: one `ADR-X:<n> → ADR-X-<SLUG>` line for all 1645 rules, as a reviewable file in `out/`, written per domain and
      reviewed by the user one domain at a time before anything is rewritten. Spelled-out slugs, vendor item ids for CAF/WAF. Check: no
      duplicate under any parent, and no slug that equals a child ADR's name (`ADR-FLOW-CD`).
- [ ] 3. Rename the codes: the three domain moves (`ADR-CATS`, `ADR-AI`, `ADR-PRIN-PROCESS`) and the 17 CAF/WAF codes into their group
      level, through `Update-AdrCitation -CodeMap`; the flow domain's `code` in `adrs.yml` goes from `FLOW-CD` to `FLOW` (its ADR codes
      stay; `ADR-FLOW-CD` is then the ADR `CD` with its four sibling ADRs below it). Message the orchestrator first. Check: `Test-Links` and `Test-AdrRegistry` on the moved
      ADRs.
- [ ] 4. First, `Test-Spelling` takes the segments of every registered code and rule heading as known words, read from `adrs.yml` and the
      registries at run time, and the hand-written code-body entries leave `terminology.yml` in the same change (open question 1). Then
      rewrite the registries: each ADR's `### Rule` headings take their slugs, one ADR file at a time. Check: the `Test-Spelling` test file
      passes; `Test-Spelling` clean on `docs/adr`; `Test-AdrRegistry` on each rewritten file.
- [ ] 5. Rewrite the citations through `Update-AdrCitation -RuleMap`, one area at a time in the order `docs/adr`, `pwsh`,
      `docs/explanation`, `docs/references` (heads regenerate), `contracts`, `.claude`. Message the orchestrator first. In
      `contracts/EXTERNAL-azure/0.1.0/` the `.frozen` record is refreshed in the same change. Check: `Test-Links` per area, `Test-Contracts`
      clean, and `git grep -E 'ADR-[A-Z-]+[#:][0-9{]'` counts zero at the end.
- [ ] 6. Replace the parsers (`AdrCodeForm`, `RULE_COLON`, the `:`→`#` replaces) in the same change as their callers and remove the `#`
      form; restate the index's "Citing a rule" and trim ADR-REPO-LINK to the link forms; switch `code_language` to `gate`. Check:
      `AdrCodeForm.Tests.ps1`, `Update-AdrCitation.Tests.ps1`, the glossary and link test files pass; `Test-AdrRegistry` clean in gate mode.
- [ ] 7. Move this plan's decisions into the ADR and delete the plan. Check: `Test-AdrRegistry` and `Test-Links` clean on the ADR;
      `git grep plan-adr-code-language` finds no link left.

## Decisions

Recorded 2026-10-18 with the user:

1. **Research domain segment:** `DORA` is kept as level 2 for `research/`.
2. **Slug form:** one segment per rule, spelled-out words joined, no length cap (`BOUNDEVERYWAIT`), in line with ADR-AUTO-SPELL.
3. **Whole-ADR collapse:** a derived list (`adrs:` heads, diagram subtitles) that covers every rule of an ADR is written as the ADR string.
   Hand-written prose never collapses. Because of the collapse, adding a rule to an ADR widens what an existing derived `ADR-X` entry
   covers; the derived lists regenerate, so that is visible in the diff.
4. **Vendor checklist ADRs:** `azure/caf` and `azure/waf` get a `CAF`/`WAF` group level (`ADR-AZ-CAF-IAM`), and their rules take the
   vendor's item ids as slugs.
5. **Contract freeze:** the freeze is broken for this change. The two citing files in the released `contracts/EXTERNAL-azure/0.1.0/` are
   rewritten and their `.frozen` record refreshed. The 77 files in `contracts/catzc/0.0.0/` are a draft, not frozen, so they are an ordinary
   rewrite.
6. **Owning ADR:** the grammar gets its own ADR, `docs/adr/repository/adr-code-language.md` (`ADR-REPO-ADRCODE`).
7. **Rule order:** a registry keeps its authored order.

## Open questions

1. **Spelling of rule slugs** (found in step 1): `Test-Spelling` flags every joined slug (`BOUNDEVERYWAIT`, `NOCOMPATIBILITYSHIMS`) as an
   unknown word, and today each ADR code body is a hand-written `terminology.yml` entry (`onelive`, `failfast`). With 1645 rule slugs that
   is 1645 hand entries. Recommendation: `Test-Spelling` takes the segments of every registered code and rule heading as known words,
   derived from `adrs.yml` and the registries at run time, and the hand entries for code bodies go in the same change. Needed before step 2.
   Decided 2026-10-18 by the orchestrator on the user's delegation: the recommendation, as one mechanism read from the registry
   (ADR-PRIN-ONELIVE: the hand entries are deleted in the same change, no fallback).
2. **WAF and CAF rule names** (found in step 2): WAF rules carry Microsoft's ids (`RE:01`), CAF rules carry none in the tree. Decided by
   the orchestrator on the user's delegation, 2026-10-18: the WAF ADR segment is the short pillar code (`RE`, `SE`, `CO`, `OE`, `PE`) and a
   rule is the vendor id without the colon (`ADR-AZ-WAF-RE-RE01`); CAF rules take spelled-out names (the plan's fallback).
3. **CAF rule names** (found in step 2): decided by the orchestrator on the user's delegation, 2026-10-18: each CAF rule's name is derived
   mechanically from its vendor checklist title, upper-cased and joined with the English stop words of one list dropped; a collision
   under one ADR keeps the full title for both. No collision occurred. `ADR-PRIN-PROCESS` becomes `ADR-PROC-AGILEPRINCIPLES`, because
   `ADR-PROC-AGILE` exists.
