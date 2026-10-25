# ADR: File limits — one declared length and width per file class, bounded, gated

## Rules: ADR-AUTO-LIMIT

### Rule ADR-AUTO-LIMIT-ONEDECLARATION

Every source file's limits — its longest allowed length in lines and its widest allowed line — are declared once, in one config, per file
class (code, config, prose), with a sensible default on the config's type. Every tool that holds a file to a width or a length reads that
one declaration; no formatter, linter, editor setting or generator carries its own number beside it.

- [Decision](#decision)

### Rule ADR-AUTO-LIMIT-LANGUAGEPUSHES

A language may set its own length or width, which replaces its class's default for that language's files only. The override is a config
entry, never code, and a language without one takes its class's default.

- [Decision](#decision)

### Rule ADR-AUTO-LIMIT-BOUNDSHOLD

Every limit stays inside declared bounds, a floor and a ceiling for length and for width. A default or a language override outside its
bounds fails the config load, so an out-of-range number never reaches a check. The length ceiling is the outer cap no language passes.

- [Decision](#decision)

### Rule ADR-AUTO-LIMIT-SPLITNOTEXEMPT

A file over its limit is split by responsibility, never raised past the cap. A config over its length splits into a folder of disjoint parts
that its reader merges, each key set by exactly one part. Only files outside the authored tracks (generated or vendored files) are out of
scope, by their track rather than by a list.

- [Decision](#decision)

### Rule ADR-AUTO-LIMIT-GENERATEDTOOLCONFIGS

The width settings of the formatter, the markdown linter, the editor and the Python linter are generated from the one declaration, so they
cannot drift from it or from each other.

- [Decision](#decision)

## Context

A long file is where a reader, human or agent, loses the thread: one responsibility hides inside another, a review covers less of it, and an
agent spends its context reading what it does not need. A wide line hides its end and fights every side-by-side view. Limits only hold when
they are checked, and they only stay coherent when they are stated once: a width written separately into the formatter, the linter and the
editor drifts, and a "keep these in sync" comment is a promise no tool keeps.

One global number fits no repository. Languages differ in density, so a language may set its own limit; but an unbounded override is no
limit at all, so every override stays within a declared floor and ceiling, and the ceiling is the cap for every language. This follows the
one resolution order of a setting ([sensible defaults](sensible-defaults.md#rule-adr-auto-default-oneresolutionorder)): the language's value
when set, else the class default declared on the type.

## Decision

Limits are configuration with a default, read by one resolver and enforced by one gate. A file over its limit is split, never exempted; the
folder-of-parts form lets a config grow past one file without growing past the cap.

## Consequences

- One edit to the declaration changes a width or length everywhere, and the generated tool settings follow.
- A language that needs more room says so in config, within the ceiling, and a wrong number fails at load, not in a later check.
- Every authored file stays small enough to read whole, and a split follows responsibility, so each part names one job.
- A config split into parts keeps one meaning: the reader merges the parts and refuses a key two parts both set.
