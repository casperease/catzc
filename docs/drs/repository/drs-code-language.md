# Repository: DRS code language — a path of named segments, every string a fact

## Rules: ADR-REPO-DRSCODE

### Rule ADR-REPO-DRSCODE-DECISIONRECORDSSYSTEM

The **decision records system** (DRS) is the one system that holds every **decision record**: the domains of every record kind, their
records and rules, the index and the registry, under its one root, `docs/drs/`. Every record is of exactly one **record kind** registered in
`drs.yml` (`ADR`, `TDR`, `PDR`, `WDR`, `DDR`, `FDR`, `EDR`), and the kinds together are called "XDR". "ADR" names the `ADR` kind only, an
**architecture decision record**: the system is the DRS, and a record of any kind is a decision record.

- [One system holds every record](drs-code-language.md#one-system-holds-every-record)

### Rule ADR-REPO-DRSCODE-PATHOFSEGMENTS

A decision record code is a record kind followed by zero or more segments, each `-` plus an upper-case letter and then upper-case letters or
digits. It reads from the most general part to the most specific: the kind, then the domain where the kind is shared, then the record, then
the rule. The kind is always the first part, so the registered kinds are the searchable markers for a decision record reference anywhere in
the repository.

- [One path for every level](drs-code-language.md#one-path-for-every-level)

### Rule ADR-REPO-DRSCODE-UPPERCASESEGMENTS

Every segment of a code is upper case, in a code and in a rule heading alike. The `code_language.capitalization` setting in `drs-checks.yml`
holds the casing, and `Test-DrsCode` judges a code against it.

- [Upper case everywhere](drs-code-language.md#upper-case-everywhere)

### Rule ADR-REPO-DRSCODE-DOMAINSEGMENT

Every domain has a `kind` in `drs.yml`. A kind one domain owns stands for that domain, and its codes carry no domain segment
(`DDR-TRACK-UNORDEREDTRACK`). The shared kind `ADR` holds the implementation domains, and each of them adds its `code` as the second segment
(`ADR-AUTO-FAILFAST`), a closed set with one code per `docs/drs/<domain>/` folder. Every code in a domain starts with that domain's prefix:
its kind, then its code where it has one.

- [The domain comes first](drs-code-language.md#the-domain-comes-first)

### Rule ADR-REPO-DRSCODE-FIXEDPOSITIONS

A code has fixed positions: the kind, the domain where the kind is shared, the record, the rule. No record nests in another record, so a
record is never a prefix of another record's code, and a family of records is a family of sibling records, each its own code. The one
exception is an external record, whose code keeps the path of its source
([ADR-REPO-DRSCODE-EXTERNALRECORDS](drs-code-language.md#rule-adr-repo-drscode-externalrecords)).

- [Fixed positions](drs-code-language.md#fixed-positions)

### Rule ADR-REPO-DRSCODE-RECORDSEGMENT

The segment after the domain names the record, unique within its parent. The record of outside guidance is the one record that carries more
than one segment there, its source path.

- [The record names the decision](drs-code-language.md#the-record-names-the-decision)

### Rule ADR-REPO-DRSCODE-EXTERNALRECORDS

Outside guidance is held as records of the `EDR` kind, which one domain owns, so an `EDR` code carries no domain segment. The code keeps the
path of its source as group segments after the kind: `EDR-DORA-CI` for a DORA capability, `EDR-AZ-WAF-RE` for a Well-Architected pillar,
`EDR-AZ-CAF-GOV` for a Cloud Adoption Framework design area, `EDR-PWSH-PESTER` for Pester. An external rule states how the repository reads
the source item, with a `Source:` line that names it; the repository's own decision stays in the `ADR` or `PDR` record that cites the rule.
No `RDR` kind is registered: the DORA research records are `EDR` records, as are the Well-Architected, Cloud Adoption Framework, Agile, lean
and Pester records.

- [Outside guidance is its own kind](drs-code-language.md#outside-guidance-is-its-own-kind)

### Rule ADR-REPO-DRSCODE-NAMEDNOTNUMBERED

A rule of the repository's own records is named, never numbered: its last segment says what the rule says, as spelled-out words joined with
no separator (the rule "bound every wait" of `ADR-AUTO-FAILFAST` is `ADR-AUTO-FAILFAST-` followed by those three words). A rule of an
external record answers a source item and takes the source's own id
([ADR-REPO-DRSCODE-NATIVEEXTERNALIDS](drs-code-language.md#rule-adr-repo-drscode-nativeexternalids)).

- [Names, not numbers](drs-code-language.md#names-not-numbers)

### Rule ADR-REPO-DRSCODE-NATIVEEXTERNALIDS

An external rule keeps the source's id for its item: a Well-Architected rule its item id (`EDR-AZ-WAF-RE-RE01`), a Cloud Adoption Framework
rule its item number in its record, in the record's authored order (`EDR-AZ-CAF-GOV-R01`). A source that names its items without ids is read
by name, as the repository's own rules are.

- [The source names its items](drs-code-language.md#the-source-names-its-items)

### Rule ADR-REPO-DRSCODE-RULENAMEBUDGET

A named rule's last segment is at most 24 characters. The `code_language.max_rule_chars` setting in `drs-checks.yml` holds the budget, and
`Test-DrsCode -Rule` judges a rule's code against it. A name that outgrows the budget says the same thing in fewer words, dropping a word
the record already says.

- [A rule name is short](drs-code-language.md#a-rule-name-is-short)

### Rule ADR-REPO-DRSCODE-RULENAMESUNIQUE

A named rule's last segment is unique in the repository, so the rule name alone names exactly one rule and a code can be written short
without losing its identity: the record and the rule, the kind and the rule, or the rule alone (`Format-DrsCode`). Prose keeps the full code
([ADR-REPO-LINK-ONECITATIONSPELLING](markdown-links.md#rule-adr-repo-link-onecitationspelling)). Where two rules would share a name, the
most general keeps the plain name and the other takes a word of its record.

- [A rule name is unique](drs-code-language.md#a-rule-name-is-unique)

### Rule ADR-REPO-DRSCODE-SEGMENTSAREWORDS

Every segment of every registered code and rule heading is a known word to the spell checker, read from the registry and the record files by
`Build-DrsCodeDictionary`. No code body is registered by hand as a term.

- [Segments are known words](drs-code-language.md#segments-are-known-words)

### Rule ADR-REPO-DRSCODE-CODEISSELECTOR

Every code is also a selector: it selects itself and every code whose segments start with it. A kind selects its records and rules, so `ADR`
selects the implementation domains and every decision record is the list of all kinds; `ADR-AUTO` selects the automation domain, `DDR` the
design domain, and `ADR-AUTO-FAILFAST` that record and all its rules. A match compares whole segments, so a code never selects a longer one
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
that a tool derives (a file head's `adrs:`) writes a code that covers every rule of a record as the record's code; hand-written prose never
collapses. In a diagram subtitle a record code names the record a slide supports, not every rule of it: the article's Supports line names
the rules.

- [No subset spelling](drs-code-language.md#no-subset-spelling)

### Rule ADR-REPO-DRSCODE-SLIDELOCALKEYS

A rule chip on a diagram carries a slide-local key (`1`, `2`, `3`, with no `#`), and the slide's legend maps each key to its full named
rule. A key numbers the slide's chips, never a rule.

- [Chips carry local keys](drs-code-language.md#chips-carry-local-keys)

### Rule ADR-REPO-DRSCODE-AUTHOREDORDER

A rule registry keeps the order its record writes the rules in. Rules are never sorted by name.

- [Authored order](drs-code-language.md#authored-order)

## Context

Every decision record, rule and citation starts with a registered kind, and `docs/drs/index.md` lists every code. A rule is a fact the
codebase is held to, and code, tests, configuration and prose cite it constantly, one design rule alone hundreds of times. The code a reader
sees is the only hint, before opening the record, of what that citation asks for.

### One system holds every record

The repository's decisions are of seven kinds, from the thesis to the architecture of one implementation domain, and one index, one registry
and one grammar serve them all. Naming that whole after one of its kinds would make "ADR" mean both a kind and everything, so the system has
its own name, the DRS, and a record of any kind is a decision record. "XDR" is the family of kind codes, X standing for the kind's letter.

### One path for every level

The repository's decisions form a tree: domains hold decision records, and decision records hold rules. One grammar with one separator
spells every level of that tree, so a domain, a record and a rule are read, searched and parsed the same way. A second spelling for one
level, such as a number after `#` or `:`, is a second small language with its own parser and its own way to go wrong.

### Upper case everywhere

A code is read, typed and searched all day, so it has one casing. Upper case makes a code stand out from the prose around it, and a search
for the kind marker finds a code and never a word.

### The domain comes first

The most general part comes first, so the codes of one domain sort together and one prefix search finds them. A code that leaves out its
domain's prefix, or names another domain than the folder it lives in, breaks both. The kind says before the record is opened whether it is a
thesis, an axiom, a way of working, a design, a flow, a piece of outside guidance, or an architecture decision; where one domain owns its
kind, one segment says both and the domain segment would only repeat it.

### Fixed positions

Each position of a code means one thing, so a reader and a parser both know what a segment is by where it stands. A record nested in a
record gives a segment two meanings, a record in one code and a part of a record in another, and makes a prefix select a record together
with its children. Flat sibling records keep every prefix to one meaning.

### The record names the decision

The segment after the domain names the record. Two records under one parent never share a name, so the code of a record is its identity.

### Outside guidance is its own kind

What a source says is not what the repository decides. A DORA capability, a vendor checklist or a testing framework is guidance the
repository reads, binds to its own rules, and answers. Holding the sources as one kind keeps them apart from the decisions that cite them,
so a search for `ADR`, `PDR` or `DDR` finds only the repository's own decisions, and a search for `EDR` finds every source. The source path
in the code (`EDR-AZ-CAF-GOV`) tells where a rule comes from without opening it, and the one `external` domain owns the kind, so the code
needs no domain segment.

### Names, not numbers

A number says nothing about its rule: a reader learns nothing from `#7` without opening the record. A name tells the reader what the
citation asks for, so the citation itself carries the fact. Names follow the spell-out rule for identifiers
([spell-out-names](../automation/spell-out-names.md)), because a citation is read like one.

### The source names its items

A source's own id for an item is the most precise name such a rule can have, and a reader who knows the source finds the item by it. The
repository does not rename another party's items.

### A rule name is short

A code is typed and read in a sentence, and a long rule name pushes the line past its width. A budget of 24 characters keeps a name to a few
words, and a name that needs more says too much for one rule.

### A rule name is unique

When a rule name is unique in the repository, the name alone selects one rule, so the shorter forms of a code are safe to write and no form
loses its identity. A rule name that two records share is a name that means two things the moment the record is dropped.

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
they know what it cites. Writing each fact as its own code keeps every citation a plain string. A tool-derived list may write a whole record
as its code when it covers every rule, because the list is regenerated: when a rule is added, the derived list shows it in its diff. Prose
is not regenerated, so prose cites exactly the rules it means.

### Chips carry local keys

A slide has room for a short mark beside each element, not for a full rule code. A chip that showed a rule's number would bring the numbered
spelling back in a place no text search reads, inside the embedded diagram model. A slide-local key is short and claims nothing: it is the
legend that turns each key into a full named code, so the citation on the slide is still the rule's name.

### Authored order

A record orders its rules to be read, general before specific. A name carries no order, so the registry keeps the order as written.

## Decision

Decision record codes are paths of upper-case named segments: the record kind, the domain where the kind is shared, the record, and the
rule, each in a fixed position. A rule name is short and unique in the repository, outside guidance keeps its path and its own item ids
under the `EDR` kind, and every code is a fact and a selector of everything under it, with no group syntax.

### How this is enforced

- **`Test-DrsRegistry`** (in `Catzc.Base.Docs`) runs the `code_language` check: a code outside the segment grammar, a code that does not
  start with its domain's prefix, a kind that is not registered, a numbered rule heading, a rule that shares a segment with a sibling
  record, a rule heading outside the casing and the name budget of `drs-checks.yml`, and a rule name that another rule shares are findings.
  The check's mode is configured in `drs-checks.yml`; in `report` mode its findings are printed in their own report and never fail the run.
- **`Test-DrsCode`** judges one code against the casing, and with `-Rule` against the name budget.
- **`Test-Links`** (in `Catzc.Base.QualityGates`) reports a numbered citation in a markdown file or a code string as a finding; the test
  files whose fixtures carry one on purpose are named, each with its reason, in `links.yml` `string_citations.exempt`.
- **`Test-GeneratedFiles`** fails when `.cspell/drs-codes.txt` is stale against the registry.

## Consequences

- A citation reads as the fact it cites, and `git grep ADR-AUTO-FAILFAST` finds a record and every rule in it.
- A rule name is short, so fewer comment lines wrap, and a code can be written as its record and rule, or its rule alone.
- Renaming a rule is a citation change across every file that cites it, made by `Update-DrsCitation` with a rule map, never by hand.
- A rule added to a record widens what every derived `ADR-<DOMAIN>-<NAME>` entry covers; the derived lists regenerate, so the change is
  visible in review.
- Outside guidance is read and bound in one place, so the repository's own records cite it and never copy it.
