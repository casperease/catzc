# Repository: DRS value chain — where each decision record sits along delivery

## Rules: ADR-REPO-VALUECHAIN

### Rule ADR-REPO-VALUECHAIN-STACK

The **value-chain stack** is the ordered set of rows a decision sits on, from the axioms down to the vendor: `PRIN` (what catzc is for, its
principles, its process, and the research they rest on), `DSGN` (how the platform and its delivery flow are shaped), `AUTO` (the tooling
that enacts them), `PIPE` (the pipelines that run the tooling), and `CLOUD` (the substrate it deploys onto). Every decision-record domain
declares exactly one row (`stack:` in `drs.yml`), and every decision record it holds sits on that row. The value-chain stack orders
decisions; it is not a track's tech-stack ([DDR-TRACK-ONETECHSTACK](../design/tracks.md#rule-ddr-track-onetechstack)), which is a set of
file languages.

- [Two maps, two questions](#two-maps-two-questions)

### Rule ADR-REPO-VALUECHAIN-CONCERN

A **value-chain concern** is one of the six columns that say where along delivery a decision record acts, in value-chain order: `automation`
(loading the modules, reading their configuration, and selecting files through globsets), `build` (turning the tracked files into an
artifact), `quality-control` (verifying a change — tests, checks, and quality gates), `release` (making a build a versioned, promotable
release candidate), `deploy` (putting a release onto its target), and `access` (reaching and operating what runs — identities, credentials,
and monitoring). Every decision-record domain declares a default (`concern:` in `drs.yml`), and a decision record declares its own only when
it differs, so every decision record resolves to one or more value-chain concerns, never to none and never to an unknown one. A value-chain
concern is not a track's root concern ([DDR-TRACK-ISPLACEDCLUSTER](../design/tracks.md#rule-ddr-track-isplacedcluster)): a track is where
files live, and a value-chain concern is where a decision acts.

- [A declared place](#a-declared-place)

### Rule ADR-REPO-VALUECHAIN-MAP

The **value-chain map** is the decision records drawn as the value-chain stack crossed with the value-chain concerns: one row per row of the
stack (ADR-REPO-VALUECHAIN-STACK) and one column per value-chain concern (ADR-REPO-VALUECHAIN-CONCERN), and a decision record lights the
places where the row of the decision-record domain that holds it meets each of its value-chain concerns. A cell of the map
([DDR-TRACK-CELL](../design/tracks.md#rule-ddr-track-cell)) holds the decision records whose decision-record domain declares its row and
whose value-chain concerns include its column, and a record code, or one of its rules, lights
([DDR-TRACK-LITCELL](../design/tracks.md#rule-ddr-track-litcell)) every cell its decision record sits in. The map is computed from
`drs.yml`, never drawn by hand, and every label it prints names a defined term in its head, as the world map's labels do
([DDR-TRACK-LABELSNAMEDEFINEDTERMS](../design/tracks.md#rule-ddr-track-labelsnamedefinedterms)); its row names are the rows of the
value-chain stack, and its column names are the value-chain concerns.

- [Two maps, two questions](#two-maps-two-questions)

## Context

### Two maps, two questions

The world map ([DDR-TRACK-WORLDMAP](../design/tracks.md#rule-ddr-track-worldmap)) says where a decision's files sit; it cannot say where
along delivery the decision acts. A rule about formatting and a rule about release tags can govern the same PowerShell files in the same
track, and the world map lights the same cells for both. The value-chain map answers the other question. Its rows are the value-chain stack,
ordered from the axioms every decision specialises down to the vendor every deployment lands on, so the row says how general a decision is.
Its columns are the value-chain concerns, ordered the way a change travels — the tooling it runs on, its build, its verification, its
release, its deployment, and the access to what runs — so the columns read left to right like the value-chain diagrams
([visual-design](../design/visual-design.md)). The two maps sit side by side because each answers what the other cannot.

### A declared place

The place is declared, never guessed, with the same resolution every setting follows: a declared default, overridden only where it differs.
Both words are qualified on purpose: "concern" names a track, the repository's root concern, and "stack" names a track's tech-stack, so the
value-chain forms keep each word to one meaning.

## Decision

Place every decision record on the value-chain map, beside the world map of the tracks: its decision-record domain declares its row and a
default value-chain concern, and the record declares its own value-chain concerns only where they differ.

### How this is enforced

- **`Catzc.Base.Drs.DrsConfig`**, the type of `drs.yml`, declares the rows of the value-chain stack and the value-chain concerns once, in
  order, and fails the load on a decision-record domain without a row or a default, on a row or a value-chain concern outside them, and on
  an unknown key, so every decision record resolves to its row and one or more value-chain concerns (ADR-REPO-VALUECHAIN-STACK,
  ADR-REPO-VALUECHAIN-CONCERN).
- **The `Test-ValueChainMap` quality gate** reads the value-chain map and fails on axes that differ from the declared rows and value-chain
  concerns, a decision record that sits in no cell, and a printed label that names no defined term (ADR-REPO-VALUECHAIN-MAP).

## Consequences

- "Where along delivery does this decision act?" has a declared answer: the value-chain map reads it from `drs.yml`, and a new decision
  record inherits its decision-record domain's default until it declares otherwise.
- The value-chain words and the track words never share a meaning, so "stack" and "concern" each say which map they belong to.
