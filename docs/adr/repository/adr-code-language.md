# ADR: ADR code language — a path of named segments, every string a fact

## Rules: ADR-REPO-ADRCODE

### Rule ADR-REPO-ADRCODE-PATHOFSEGMENTS

An ADR code is `ADR` followed by zero or more segments, each `-` plus an upper-case letter and then upper-case letters or digits. It reads
from the most general part to the most specific: `ADR`, then the domain, then the ADR, then the rule. `ADR` is always the first part, so it
stays the one searchable marker for an ADR reference anywhere in the repository.

- [One path for every level](#one-path-for-every-level)

### Rule ADR-REPO-ADRCODE-DOMAINSEGMENT

The second segment is the domain's `code` in `adrs.yml`, a closed set with one code per `docs/adr/<domain>/` folder. Every ADR code in a
domain starts with that domain's segment.

- [The domain comes first](#the-domain-comes-first)

### Rule ADR-REPO-ADRCODE-ADRSEGMENT

The segment after the domain names the ADR, unique within its parent. A vendor reference adds one group level before it, so the ADRs that
answer the Cloud Adoption Framework are `ADR-AZ-CAF-<NAME>` and those that answer the Well-Architected Framework are `ADR-AZ-WAF-<NAME>`.

- [Vendor references are a level](#vendor-references-are-a-level)

### Rule ADR-REPO-ADRCODE-NAMEDNOTNUMBERED

A rule is named, never numbered: its last segment says what the rule says, as spelled-out words joined with no length cap (the rule "bound
every wait" of `ADR-AUTO-FAILFAST` is `ADR-AUTO-FAILFAST-` followed by those three words). A rule that answers a vendor checklist item takes that item's id as its segment.

- [Names, not numbers](#names-not-numbers)

### Rule ADR-REPO-ADRCODE-CODEISSELECTOR

Every code is also a selector: it selects itself and every code whose segments start with it. `ADR` selects every ADR and rule, `ADR-AUTO`
the automation domain, and `ADR-AUTO-FAILFAST` that ADR and all its rules. A match compares whole segments, so `ADR-AUTO-GO` never selects
`ADR-AUTO-GOLD`.

- [Every string is a selector](#every-string-is-a-selector)

### Rule ADR-REPO-ADRCODE-ONESTRINGONEFACT

Under one parent, a child ADR and a rule never share a segment, so every code names exactly one ADR, rule, or domain. A retired name is never
reused; a rule whose meaning changes takes a new name.

- [One string, one fact](#one-string-one-fact)

### Rule ADR-REPO-ADRCODE-NOSUBSETSPELLING

A citation names a set only by a prefix. There is no group, list, or range syntax inside a code: several facts are several codes. A list
that a tool derives (a file head's `adrs:`, a diagram subtitle) writes a code that covers every rule of an ADR as the ADR's code;
hand-written prose never collapses.

- [No subset spelling](#no-subset-spelling)

### Rule ADR-REPO-ADRCODE-AUTHOREDORDER

A rule registry keeps the order its ADR writes the rules in. Rules are never sorted by name.

- [Authored order](#authored-order)

## Context

Every ADR, rule, and citation in this repository shares one marker, `ADR-`, and `docs/adr/index.md` lists every code. A rule is a fact the
codebase is held to, and code, tests, configuration, and prose cite it constantly: one design rule alone is cited more than nine hundred
times. The code a reader sees is the only hint, before opening the ADR, of what that citation asks for.

### One path for every level

The repository's decisions form a tree: domains hold ADRs, and ADRs hold rules. One grammar with one separator spells every level of that
tree, so a domain, an ADR, and a rule are read, searched, and parsed the same way. A second spelling for one level, such as a number after
`#` or `:`, is a second small language with its own parser and its own way to go wrong.

### The domain comes first

The most general part comes first, so the codes of one domain sort together and one prefix search finds them. A code that leaves out its
domain, or names another domain than the folder it lives in, breaks both.

### Vendor references are a level

The Cloud Adoption Framework and Well-Architected Framework ADRs answer a vendor's guidance item by item. They form a family inside the
azure domain, and a group segment makes that family one prefix (`ADR-AZ-CAF`). Their rules answer named vendor items, and the vendor's own
item id is the most precise name such a rule can have.

### Names, not numbers

A number says nothing about its rule: a reader learns nothing from `#7` without opening the ADR. A name tells the reader what the citation
asks for, so the citation itself carries the fact. Names follow the spell-out rule for identifiers ([spell-out-names](../automation/spell-out-names.md)),
because a citation is read like one; a vendor's item id is an external name, which that rule leaves as the vendor writes it.

### Every string is a selector

Because a prefix of a code is itself a code, a search, a filter, or a test-tag match needs no wildcard syntax: the shorter code is the
wider selection. Matching by whole segments keeps two ADRs whose names merely start alike apart.

### One string, one fact

A selector is only safe when every string has one meaning. A rule named like a sibling ADR would make one string mean two things, and a
reused name would make an old citation silently point at a new fact. A rule whose meaning changes is a different fact, so it gets a
different name and its old citations fail the link check instead of drifting.

### No subset spelling

A group such as a list or a range of rules inside one code makes a citation a small expression that a reader and a tool must expand before
they know what it cites. Writing each fact as its own code keeps every citation a plain string. A tool-derived list may write a whole ADR
as its code when it covers every rule, because the list is regenerated: when a rule is added, the derived list shows it in its diff. Prose
is not regenerated, so prose cites exactly the rules it means.

### Authored order

An ADR orders its rules to be read, general before specific. Numbers gave that order for free; without them the registry keeps it as
written.

## Decision

ADR codes are paths of named segments: `ADR`, the domain, the ADR (behind a vendor group where there is one), and the rule. Every code is a
fact and a selector of everything under it, with no numbers and no group syntax.

### How this is enforced

- **`Test-AdrRegistry`** (in `Catzc.Base.Docs`) runs the `code_language` check: a code outside the segment grammar, a code that does not
  start with its domain's segment, a numbered rule heading, and a rule that shares a segment with a sibling ADR are findings. The check's
  mode is configured in `adr-checks.yml`; in `report` mode its findings are printed in their own report and never fail the run.

## Consequences

- A citation reads as the fact it cites, and `git grep ADR-AUTO-FAILFAST` finds an ADR and every rule in it.
- Codes are longer than a code with a number, so more comment lines wrap.
- Renaming a rule is a citation change across every file that cites it, made by `Update-AdrCitation` with a rule map, never by hand.
- A rule added to an ADR widens what every derived `ADR-<DOMAIN>-<NAME>` entry covers; the derived lists regenerate, so the change is
  visible in review.
