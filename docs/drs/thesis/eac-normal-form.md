# Thesis: Eac normal form — any code, verifiable within the repository's enabling constraints

## Rules: TDR-NORMALFORM

### Rule TDR-NORMALFORM-ANYCODEHASNORMALFORM

Everything inside a responsibility domain is code, managed through the one change process
([TDR-STORES-RESPONSIBILITYDOMAIN](truth-stores.md#rule-tdr-stores-responsibilitydomain),
[TDR-ONETRUTH-REPOSITORYISRECORD](one-source-of-truth.md#rule-tdr-onetruth-repositoryisrecord)). So any code can be brought into an **eac
normal form**: the shape in which the repository's automation can verify it. That holds for code written in the trunk and for an **unordered
code fragment**, code that comes from outside the trunk in whatever shape its origin left it.

- [Any code has a normal form](#any-code-has-a-normal-form)

### Rule TDR-NORMALFORM-ENABLINGCONSTRAINTS

Code is in eac normal form when it can be verified within the repository's **enabling constraints**, and nothing else: the sensible
defaults, the catzc bundle, and the local configs. Verifying it needs no undeclared tool, no machine state, and no person's knowledge.

- [The enabling constraints](#the-enabling-constraints)

### Rule TDR-NORMALFORM-UNCONTESTED

Code in eac normal form is **uncontested**: when the repository's formatters, tests, and asserts run over it, none of them changes it and
none fails. The form is the fixed point of the repository's own checks, so it is decided by running them, never by judgement.

- [Uncontested](#uncontested)

### Rule TDR-NORMALFORM-MIGRATIONREACHESTHEFORM

**Fragment migration** brings an unordered code fragment into eac normal form through the one change process. A fragment that is not yet in
the form decides nothing about the delivered system; the mechanics of moving it into the form belong to the implementation domains.

- [Migration reaches the form](#migration-reaches-the-form)

## Context

The one-source-of-truth thesis ([TDR-ONETRUTH](one-source-of-truth.md)) makes the repository the configuration record, and the truth stores
thesis ([TDR-STORES](truth-stores.md)) makes everything inside a responsibility domain code. Neither says when a piece of code is good
enough to be part of that record. Code arrives from many places: written in the trunk, imported with its history from another repository,
copied from a vendor sample, exported from a UI. Without a definition of the form the record accepts, every arrival is judged afresh, and
the record holds code that only its author can read or check.

## Decision

Define one target shape for all code, the eac normal form: verifiable within the enabling constraints, and uncontested by the repository's
own checks. Bring every unordered code fragment into it by migration.

### Any code has a normal form

When everything is code and everything is managed through one change process, nothing is too irregular to manage. A shell script pasted from
a wiki, a pipeline exported from a UI, and a module imported from a sibling repository are all code, so each of them has a form the
repository can verify. The thesis does not claim that every fragment is easy to bring into that form, only that the form exists and is the
same kind of target for all of them.

### The enabling constraints

The enabling constraints are what the repository declares about itself, and nothing more:

- **The sensible defaults.** Every setting has a default, declared once, so code that sets nothing still runs.
- **The catzc bundle.** The toolset, at the version the repository pins or as the clone it owns, supplies the commands that format and
  verify the code.
- **The local configs.** The repository's own config files override a default where the responsibility domain decides differently.

The constraints enable rather than restrict: they are what lets any engine, any devbox, and any pipeline verify the code the same way. A
check that depends on something outside them, such as a tool installed by hand or a value only one person knows, cannot be repeated, so code
that passes it is not in the form.

### Uncontested

The repository carries many formatters, tests, and asserts. Code is uncontested when all of them agree on it: no formatter rewrites it, no
test fails on it, and no assert stops on it. Running the checks again changes nothing, so the form is a fixed point and running the checks
both finds it and proves it. A file that a formatter still rewrites is not yet in the form, even when its tests pass.

### Migration reaches the form

An unordered code fragment is code the repository holds but does not yet decide by. Migration moves it into the eac normal form through the
same reviewed commits as any other change, one fragment at a time, until it is uncontested. A fragment can stay unordered while its
migration is under way, but nothing internally reads it as truth until it is in the form. How fragments land, how they are sorted, and how a
migration is tracked are technical decisions for the implementation domains, which specialise this thesis.

## Consequences

- Any code, whatever its origin, has one target shape, and the repository's own checks decide when it is reached.
- A check that needs something outside the enabling constraints is a defect in the check, or a constraint that must be declared.
- A file that a formatter still rewrites, or a test still fails on, is not in eac normal form.
- An unordered code fragment decides nothing about the delivered system until migration brings it into the form.
