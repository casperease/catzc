# ADR: DRS code language — a path of named segments, every string a fact

## Rules: ADR-REPO-DRSCODE

### Rule ADR-REPO-DRSCODE-DECISIONRECORDSSYSTEM

The **decision records system** (DRS) is the one system that holds every **decision record**: the domains of every record kind, their
records and rules, the index and the registry, under its one root, `docs/drs/`. Every record is of exactly one **record kind** registered in
`drs.yml` (`ADR`, `TDR`, `PDR`, `WDR`, `DDR`, `FDR`, `EDR`), and the kinds together are called "XDR". "ADR" names the `ADR` kind only, never
the system or a record of another kind.

- [One system holds every record](drs-code-language.md#one-system-holds-every-record)

### Rule ADR-REPO-DRSCODE-PATHOFSEGMENTS

A decision record code is a record kind followed by zero or more segments, each `-` plus an upper-case letter and then upper-case letters or
digits. It reads from the most general part to the most specific: the kind, then the domain where the kind is shared, then the record, then
the rule. The kind is always the first part and is one of the closed set of kinds registered in `drs.yml` (`ADR`, `TDR`, `PDR`, `WDR`,
`DDR`, `FDR`, `EDR`), so the registered kinds are the searchable markers for a decision record reference anywhere in the repository.

- [One path for every level](drs-code-language.md#one-path-for-every-level)

### Rule ADR-REPO-DRSCODE-CAPITALIZATION

Every segment is written in upper case. The setting is declared once, as `code_language.capitalization` in `drs-checks.yml`, and every tool
that writes or checks a code reads it from there.

- [One case, set once](drs-code-language.md#one-case-set-once)

### Rule ADR-REPO-DRSCODE-DOMAINSEGMENT

Every domain has a `kind` in `drs.yml`. A kind one domain owns stands for that domain, and its codes carry no domain segment
(`DDR-TRACK-UNORDEREDTRACK`). The shared kind `ADR` holds the implementation domains, and each of them adds its `code` as the second segment
(`ADR-AUTO-FAILFAST`), a closed set with one code per `docs/drs/<domain>/` folder. Every code in a domain starts with that domain's prefix:
its kind, then its code where it has one.

- [The domain comes first](drs-code-language.md#the-domain-comes-first)

### Rule ADR-REPO-DRSCODE-RECORDSEGMENT

The segment after the domain names the record, unique within its domain, and the segment after the record names the rule. The positions are
fixed: a record never nests in a record, so a record of a record is its own record. The one exception is the source path of an `EDR` record,
which ADR-REPO-DRSCODE-EXTERNALKIND gives.

```text
FDR-LIFE-DISCARDISTERMINAL, never FDR-CD-LIFE-DISCARDISTERMINAL
```

- [Positions are fixed](drs-code-language.md#positions-are-fixed)

### Rule ADR-REPO-DRSCODE-EXTERNALKIND

Every external source catzc reads, such as a vendor framework, a research program, a manifesto, a theory or a third-party tool, is an `EDR`
record of the external domain. Its code is `EDR` followed by the source's path in the source's own short names. An `EDR` rule states how
catzc reads the source and how it binds to the other records, with a `source:` line naming the page it reads; catzc's own decision stays in
the `ADR` or `PDR` that cites it. The `RDR` kind is retired, and the Azure DevOps records and the Azure CLI record stay `ADR`, because they
are catzc's own decisions about a vendor tool.

```text
EDR-AZ-CAF-GOV   EDR-DORA-CI   EDR-LEAN   EDR-PWSH-PESTER
```

- [External sources are their own kind](drs-code-language.md#external-sources-are-their-own-kind)

### Rule ADR-REPO-DRSCODE-NAMEDNOTNUMBERED

A rule of catzc's own is named, never numbered: its last segment says what the rule says, as spelled-out words joined (the rule "bound every
wait" of `ADR-AUTO-FAILFAST` is `ADR-AUTO-FAILFAST-` followed by those three words).

- [Names, not numbers](drs-code-language.md#names-not-numbers)

### Rule ADR-REPO-DRSCODE-NATIVEIDSOUTSIDE

An external item keeps the id its source gives it: a Well-Architected rule its item id, a Cloud Adoption Framework rule its checklist item
number within its record. The named form binds catzc's own rules only.

```text
EDR-AZ-WAF-RE-RE01   EDR-AZ-CAF-GOV-R01
```

- [Native ids outside](drs-code-language.md#native-ids-outside)

### Rule ADR-REPO-DRSCODE-RULENAMEBUDGET

A rule name, the last segment of a rule code, is at most `code_language.max_rule_chars` characters (24), set once in `drs-checks.yml` and
held by `Test-DrsCode -Rule`. A name that does not fit drops a word only where the spell checker's English dictionary proves the boundary,
or takes a hand name.

- [A budget for every name](drs-code-language.md#a-budget-for-every-name)

### Rule ADR-REPO-DRSCODE-UNIQUERULENAMES

Every rule name is unique in the repository. `Format-DrsCode` therefore compacts a code to record plus rule, kind plus rule, or the rule
alone without losing its identity, where space is short; prose keeps the full code.

- [Unique names compact](drs-code-language.md#unique-names-compact)

### Rule ADR-REPO-DRSCODE-SEGMENTSAREWORDS

Every segment of every registered code and rule heading is a known word to the spell checker, read from the registry and the ADR files by
`Build-DrsCodeDictionary`. No code body is registered by hand as a term.

- [Segments are known words](drs-code-language.md#segments-are-known-words)

### Rule ADR-REPO-DRSCODE-CODEISSELECTOR

Every code is also a selector: it selects itself and every code whose segments start with it. A kind selects its records and rules, so `ADR`
selects the implementation domains and every decision record is the list of all kinds; `ADR-AUTO` selects the automation domain, `DDR` the
design domain, and `ADR-AUTO-FAILFAST` that ADR and all its rules. A match compares whole segments, so a code never selects a longer one
that only starts with its last segment:

```text
ADR-AUTO-GO never selects ADR-AUTO-GOLD
```

A code in prose that selects nothing registered, no rule, record or domain, dangles like a broken link and is a finding of
`Test-DrsRegistry`; a fenced example, and a code followed by `#` or `:<n>`, is not a citation and is left alone.

- [Every string is a selector](drs-code-language.md#every-string-is-a-selector)

### Rule ADR-REPO-DRSCODE-ONESTRINGONEFACT

Under one parent, a child record and a rule never share a segment, so every code names exactly one record, rule, or domain. A retired name
is never reused; a rule whose meaning changes takes a new name.

- [One string, one fact](drs-code-language.md#one-string-one-fact)

### Rule ADR-REPO-DRSCODE-NOSUBSETSPELLING

A citation names a set only by a prefix. There is no group, list, or range syntax inside a code: several facts are several codes. A list
that a tool derives (a file head's `adrs:`) writes a code that covers every rule of an ADR as the ADR's code; hand-written prose never
collapses. In a diagram subtitle a record code names the ADR a slide supports, not every rule of it: the article's Supports line names the
rules.

- [No subset spelling](drs-code-language.md#no-subset-spelling)

### Rule ADR-REPO-DRSCODE-SLIDELOCALKEYS

A rule chip on a diagram carries a slide-local key (`1`, `2`, `3`, with no `#`), and the slide's legend maps each key to its full named
rule. A key numbers the slide's chips, never a rule.

- [Chips carry local keys](drs-code-language.md#chips-carry-local-keys)

### Rule ADR-REPO-DRSCODE-AUTHOREDORDER

A rule registry keeps the order its ADR writes the rules in. Rules are never sorted by name.

- [Authored order](drs-code-language.md#authored-order)

## Context

Every record, rule, and citation in this repository shares one grammar, and `docs/drs/index.md` lists every code. A rule is a fact the
codebase is held to, and code, tests, configuration, and prose cite it constantly: one design rule alone is cited more than nine hundred
times. The code a reader sees is the only hint, before opening the record, of what that citation asks for, so a code must be easy to see and
remember, unique in the repository, show its source, and stay compact without losing its identity.

### One system holds every record

The repository's decisions are of seven kinds, from the thesis to the architecture of one implementation domain and the external sources
they read, and one index, one registry and one grammar serve them all. Naming that whole after one of its kinds would make "ADR" mean both a
kind and everything, so the system has its own name, the DRS, and a record of any kind is a decision record. "XDR" is the family of kind
codes, X standing for the kind's letter.

### One path for every level

The repository's decisions form a tree: domains hold decision records, and decision records hold rules. One grammar with one separator
spells every level of that tree, so a domain, a record, and a rule are read, searched, and parsed the same way. A second spelling for one
level, such as a number after `#` or `:`, is a second small language with its own parser and its own way to go wrong.

### One case, set once

A code is matched by an ordinal comparison, so one case is the only way two spellings of one code stay one string. Upper case also marks a
code apart from the prose around it. Declaring the case once keeps the writers and the checks from each assuming their own.

### The domain comes first

The most general part comes first, so the codes of one domain sort together and one prefix search finds them. A code that leaves out its
domain's prefix, or names another domain than the folder it lives in, breaks both. The kind says before the record is opened whether it is a
thesis, an axiom, a way of working, a design, a flow, an external source, or an architecture decision; where one domain owns its kind, one
segment says both and the domain segment would only repeat it.

### Positions are fixed

A code whose segments mean different things at different depths has to be parsed against the registry before a reader knows which part is
the record. With fixed positions, the last segment is the rule and the one before it the record, everywhere, so a code is read the same way
whether it is short or long. A record that grew inside another is its own record, and its parent cites it.

### External sources are their own kind

Cloud Adoption Framework checklists, Well-Architected pillars, the DORA capabilities, the Agile Manifesto, lean theory and Pester are not
catzc's decisions; they are what catzc reads. Filed under catzc's own kinds, they looked like decisions catzc had made and could change. One
kind for every external source keeps that line visible in the code itself. The kind swap keeps the rest of each code, so a source keeps its
path, its vendor group (`CAF`, `WAF`) and its program (`DORA`) as segments. An `EDR` rule records the reading, never the decision: when
catzc decides something because of a source, the decision is an `ADR` or `PDR` rule that cites the `EDR` rule, so changing a decision never
means editing the record of the source. A research decision record was one source's kind; it is now one source among the external ones.

### Names, not numbers

A number says nothing about its rule: a reader learns nothing from `#7` without opening the record. A name tells the reader what the
citation asks for, so the citation itself carries the fact. Names follow the spell-out rule for identifiers
([spell-out-names](../automation/spell-out-names.md)), because a citation is read like one.

### Native ids outside

A source's own id for an item is the most precise name an external rule can have, and it is the one a reader finds in the source. A name
catzc gave an external item would be a translation that drifts from the source. A checklist that names its items without ids gets the item's
number within the record, which the source's order fixes.

### A budget for every name

Names were spelled out with no cap, and the longest ran to more than seventy characters, too long to read at a glance or keep in mind. A cap
of 24 keeps every name a few words. Dropping a word mechanically is only safe where the word boundary is certain, so a dictionary proves it;
otherwise a person chooses the shorter name.

### Unique names compact

A rule name that repeats across records needs its record to say which rule it is. A name that is unique in the repository says it alone, so
a diagram chip, a test tag or a narrow table cell can show the short form, and a search for the name finds the one rule. Prose keeps the
full code because prose is read without a tool at hand to expand the short form.

### Segments are known words

A named segment is a run of joined words (`BOUNDEVERYWAIT`) that no dictionary holds, and there are more than sixteen hundred of them. A
hand-written terminology entry per code body would copy a fact the registry already holds, once per rule, and drift from it on every rename.
The registry is the one source, so the spell checker reads it: `Build-DrsCodeDictionary` writes every segment, lower-cased, to the generated
word list `.cspell/drs-codes.txt`, which the root `cspell.yml` loads beside the terminology dictionaries.

### Every string is a selector

Because a prefix of a code is itself a code, a search, a filter, or a test-tag match needs no wildcard syntax: the shorter code is the wider
selection. Matching by whole segments keeps two decision records whose names merely start alike apart.

### One string, one fact

A selector is only safe when every string has one meaning. A rule named like a sibling record would make one string mean two things, and a
reused name would make an old citation silently point at a new fact. A rule whose meaning changes is a different fact, so it gets a
different name and its old citations fail the link check instead of drifting.

### No subset spelling

A group such as a list or a range of rules inside one code makes a citation a small expression that a reader and a tool must expand before
they know what it cites. Writing each fact as its own code keeps every citation a plain string. A tool-derived list may write a whole ADR as
its code when it covers every rule, because the list is regenerated: when a rule is added, the derived list shows it in its diff. Prose is
not regenerated, so prose cites exactly the rules it means.

### Chips carry local keys

A slide has room for a short mark beside each element, not for a full rule code. A chip that showed a rule's number would bring the numbered
spelling back in a place no text search reads, inside the embedded diagram model. A slide-local key is short and claims nothing: it is the
legend that turns each key into a full named code, so the citation on the slide is still the rule's name.

### Authored order

A record orders its rules to be read, general before specific. Numbers gave that order for free; without them the registry keeps it as
written.

## Decision

Decision record codes are paths of named segments in fixed positions: the record kind, the domain where the kind is shared, the record, and
the rule, in upper case, each rule name unique in the repository and at most 24 characters. External sources are `EDR` records that keep
their source's path and ids. Every code is a fact and a selector of everything under it, with no numbers for catzc's own rules and no group
syntax.

### How this is enforced

- **`Test-DrsRegistry`** (in `Catzc.Base.Docs`) runs the `code_language` check: a code outside the segment grammar, a code that does not
  start with its domain's prefix, a kind that is not registered, a numbered rule heading, and a rule that shares a segment with a sibling
  record are findings. The check's mode is configured in `drs-checks.yml`; in `report` mode its findings are printed in their own report and
  never fail the run.
- **`Test-DrsCode`** (in `Catzc.Base.Drs`) holds one code or rule name to the grammar, the capitalization setting and the length budget;
  `Assert-DrsCode` throws on the same findings.
- **`Test-Links`** (in `Catzc.Base.QualityGates`) reports a numbered citation in a markdown file or a code string as a finding; the test
  files whose fixtures carry one on purpose are named, each with its reason, in `links.yml` `string_citations.exempt`.
- **`Test-GeneratedFiles`** fails when `.cspell/drs-codes.txt` is stale against the registry.

## Consequences

- A citation reads as the fact it cites, and `git grep ADR-AUTO-FAILFAST` finds an ADR and every rule in it.
- A short form of a code is safe anywhere a tool or a reader can expand it, because every rule name is unique.
- `git grep EDR` finds every external source catzc reads, apart from the decisions catzc makes.
- Renaming a rule is a citation change across every file that cites it, made by `Update-DrsCitation` with a rule map, never by hand.
- A rule added to an ADR widens what every derived `ADR-<DOMAIN>-<NAME>` entry covers; the derived lists regenerate, so the change is
  visible in review.
