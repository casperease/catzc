# Repository: Links in repository — every link points a declared way

## Rules: ADR-REPO-LINKS

### Rule ADR-REPO-LINKS-EVERYLINKHASADIRECTION

Every **relation** between two files in the repository has a **link direction**: from the file that writes it to the file it names. A
relation a file writes is one of three: a markdown link (a link in a `.md` file), a code link (a link or a bare citation in a comment of any
other file), and a docs edge (a link to a comment page in a file's meta head, which a head carries only where it costs to derive; a file's
own page is found by its derived path, so no head is required to point to it). A string that names a path or a citation is data and no
relation; an image is an embed and no relation; a link to an in-file anchor, a URL, a folder or a missing target is no relation either.

- [Three relations](#three-relations)

### Rule ADR-REPO-LINKS-CONVENTIONSAREDERIVED

A **convention relation** is a relation no file writes: a declaration implies it. A test points at its subject by its stem under `tests/`, a
file at its comment page by the `pages` map, and a module at each module it declares as a dependency. A convention relation is derived from
its declaration on every run, never written into a file, and it is judged by the same rows as the relations a file writes.

- [Convention relations](#convention-relations)

### Rule ADR-REPO-LINKS-ENDPOINTSAREFACETS

Each end of a relation is an **endpoint**: a set of facets derived on demand from the declarations, never read from a head. The facets are
`class` (the file kind's role and subkind), `aspect` (`live`, `tests`, or the remainder name; none in a track without aspects), `track` and
`tracktype`, and `module`. A decision record's endpoint carries nothing more; the order of its domains is another gate's.

- [Endpoints are facets](#endpoints-are-facets)

### Rule ADR-REPO-LINKS-DIRECTIONSAREROWS

The directions are rows in one configuration, read top to bottom, the first matching row deciding. A row names the relations it covers, a
`from` selector, a `to` selector, a verdict (`allow` or `deny`) and `because`, a registered rule code, which is required. A selector lists
values of the facets and never holds a glob. A relation that no row allows is denied. A rule a decision record states in prose gets a deny
row of its own, so a finding names that rule.

- [Directions are rows](#directions-are-rows)

### Rule ADR-REPO-LINKS-DECLAREDGRAPHSSTAY

A direction that another record declares is read there, never copied into the rows: module to module stays the modules' declared
dependencies, a decision record's domain order stays the DRS registry's `depends_on`, and the aspect partition stays the aspect model's. A
row selects an aspect; it never recomputes one, and a row that allows record to record says in `because` where the order is held.

- [Declared graphs stay where they are declared](#declared-graphs-stay-where-they-are-declared)

### Rule ADR-REPO-LINKS-RECORDSLINKGROUNDINGONLY

A decision record links other records, the DRS index and the glossary, and the references it is grounded in: the DORA, CAF and WAF
references. It never links code, a how-to, an explanation or any other reference.

- [A record links only its grounding](#a-record-links-only-its-grounding)

### Rule ADR-REPO-LINKS-EXCEPTIONSAREENTRIES

An exception is a configuration entry with its reason: `exempt:` maps a file to why it may break the rows. There is no report mode and no
warning level; the gate fails or passes.

- [Exceptions are entries](#exceptions-are-entries)

### Rule ADR-REPO-LINKS-CHECKEDBYONEGATE

One gate, `Test-LinkDirections`, judges every relation in the tree against the rows. It reads the relations from the same walk of the same
files that `Test-Links` and `Format-Links` use, so the aligner and the gate cannot disagree on what a link is.

- [How this is enforced](#how-this-is-enforced)

## Context

The repository's files point at each other: a function's comment cites the rule it implements, a reference page links the code it describes,
a file's head names its comment page. Which way such a pointer may go is a design decision in several records:
[markdown-links](markdown-links.md) says code links go out of code into a decision record and a record never links into code;
[file-meta](file-meta.md) says a comment page sits in the file's own docs section and modules relate by name, never by path;
[aspects](../design/module-aspects.md) splits a unit into `live` and `tests`. Stated only as prose, a direction holds until the first file
that breaks it, and nothing reports that file.

### Three relations

A relation is what a reader follows from one file to another. The markdown link and the code link are the two link kinds of
[markdown-links](markdown-links.md); the docs edge is the head's way to the comment page ([comments-in-docs](comments-in-docs.md)). Each is
written by an author and resolves to one tracked file. A string literal is consumed by code, not followed by a reader; an image is shown in
place, not read as another document; an anchor, a URL and a folder name no file of the tree. None of them has a direction to check, and a
missing target is the form check's finding, not this one's.

### Convention relations

Some of the strongest ties between files are written nowhere: a test belongs to the file it tests, a file to its comment page, a module to
the modules it builds on. Each is implied by a declaration the repository holds, the test layout, the `pages` map and the module
dependencies, so writing it into a file as well would be a second version of the same fact
([one-living-version](../principles/one-living-version.md)). Derived on every run, a convention relation follows its declaration the moment
the declaration changes, and judging it by the same rows lets one query answer what a file touches, written or implied.

### Endpoints are facets

A rule about directions speaks about kinds of file — a decision record, a test, a file of a vendor track — never about one path. The facets
name those kinds from what the repository declares: the file kinds, the tracks and their types, the aspect sets and the module of a path.
They are derived from the declarations on every run and never read from a file's head ([file-meta](file-meta.md)), so a moved or
reclassified file is judged by what it is now. Each distinct file is resolved once per run, not once per link.

### Directions are rows

A list of rows, first match deciding and the rest denied, is the same shape as the aspect order, where a track's last aspect catches what
the earlier ones leave ([aspects](../design/module-aspects.md)). It makes every new file role or document type one more row instead of one
more unchecked convention, and it keeps the decision in configuration and the mechanism in one engine
([configuration-is-data](../principles/configure-not-program.md)). The `because` of a row is what a finding prints, so a reader of the
finding reads the rule that denies the link, not the name of a row. A selector speaks in facets and never in globs, because a glob names
paths and paths are what the facets abstract away.

### Declared graphs stay where they are declared

Three directions have a declaration and a gate of their own: the dependencies between modules, the order of the domains in `drs.yml` and the
partition of a unit into aspects. A copy of any of them in the rows is a second version of the same fact that drifts from the first
([one-living-version](../principles/one-living-version.md)). The rows allow what those records govern and name the record in `because`.

### A record links only its grounding

A decision record holds durable rationale; code, how-tos and explanations churn with the implementation, so a link from a record into them
couples the decision to that churn. The references a record is grounded in are the exception: DORA grounds the repository's own decisions,
and the Azure Cloud Adoption and Well-Architected records answer their vendor's reference item by item
([index](../index.md#authoring-conventions)). Any other reference is written for readers and is linked from them, not from the decision.

### Exceptions are entries

A file that must break a row is named in configuration with its reason, as every exception in the repository is
([configuration-is-data](../principles/configure-not-program.md)). A report mode that lists findings and passes would let the tree drift
behind a gate that stays green, so the gate runs as a gate from its first commit, and what it finds is fixed, re-rowed or exempted before it
lands.

## Decision

Every relation between two tracked files, written or implied, has a direction, judged on the facets of its endpoints against rows in one
configuration and checked by one gate from the same walk as the link check.

### How this is enforced

- **`Test-LinkDirections`** (in `Catzc.Base.QualityGates`) — the gate. It reads every relation through the link engine's walk, builds the
  endpoint of each distinct file once, judges each relation against the rows, and fails with every relation the first matching row denies or
  no row allows, each finding naming its file, line, relation, the classes of both ends and the `because` of the deciding row.
- **`link-directions.yml`** — the rows and the `exempt:` entries, read by the `LinkDirectionsConfig` type, which declares every default once
  and refuses an unknown key; `Assert-LinkDirectionsConfig` checks that every class, track type, aspect and module a row names is declared
  and that every `because` is a registered rule code.
- **One engine** — `LinkEngine` records the relations into a sink only when the gate asks for them, so `Test-Links`, `Format-Links` and
  `Test-LinkDirections` read one extraction.

## Consequences

- A link that points the wrong way fails a gate instead of waiting for a reviewer to notice it.
- A new file role or document type needs a row before its files may link or be linked; until then the default denies, which is loud but
  safe.
- Every exception is visible in one file, with its reason next to it.
- The rows depend on the file kinds, the tracks and the aspect model; a change to any of them can turn a row's verdict, and the gate shows
  it in the same run.
