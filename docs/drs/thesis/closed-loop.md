# Thesis: Closed loop — deterministic AI for experimental DevOps on one trunk

## Rules: TDR-CLOSEDLOOP

### Rule TDR-CLOSEDLOOP-DETERMINISTICPLATFORM

Catzc is deterministic AI for closed-loop experimental DevOps: a digital twin platform builds quality in through checks, tests and gates,
while an orchestrated three-phase continuous flow carries changes authored by users alongside agentic actors into one trunk-based truth
store holding everything as code plus configuration (EaC), auditable, sustainable, mappable.

- [The platform](#the-platform)

### Rule TDR-CLOSEDLOOP-EXPERIMENTONTRUNK

Every experiment begins as a hypothesis committed to trunk. The twin replays production deterministically, so outcomes repeat exactly;
agents propose variations, humans approve intent, and gates reject whatever drifts from declared expectations. Evidence accumulates inside
version history, turning each failure into reusable knowledge rather than lost effort.

- [The experiment](#the-experiment)

### Rule TDR-CLOSEDLOOP-THREEPHASEFLOW

Three phases shape this flow. Authoring: people or models draft changes locally against fast checks. Integration: shared pipelines merge
work continuously, running tests where every result is reproducible. Promotion: staged environments receive identical artifacts, each
guarded by approvals that leave an audit trail nobody can quietly rewrite.

- [The flow](#the-flow)

### Rule TDR-CLOSEDLOOP-EVERYTHINGINONESTORE

One repository holds truth: infrastructure, policy, documentation, diagrams, decisions. Nothing lives only inside someone's head or an
unrecorded console click. Because configuration sits beside code under identical review, any state can be traced, diffed, rebuilt,
explained. Mapping follows naturally: every file knows its owner, purpose plus governing rule.

- [The truth store](#the-truth-store)

### Rule TDR-CLOSEDLOOP-AGENTSUNDERCONTRACT

Sustainable delivery means AI never improvises unchecked. Agents act within contracts, read rules first, cite them precisely, then hand
verdicts back for verification. Determinism makes their output comparable across runs; small batches keep risk low. Teams gain speed without
surrendering control, because machines enforce quality while humans decide it.

- [The discipline](#the-discipline)

## Context

The one-source-of-truth thesis ([TDR-ONETRUTH](one-source-of-truth.md)) puts delivery's truth in one repository, the truth stores thesis
([TDR-STORES](truth-stores.md)) names what lies outside it, and the eac normal form ([TDR-NORMALFORM](eac-normal-form.md)) decides when code
belongs to the record. None of them says who changes the record, how a change is tried before it is trusted, or how an AI actor takes part
without making delivery less predictable. A language model is not deterministic by itself, so an AI that changes the record directly makes
every outcome a one-off that nobody can repeat or audit.

## Current state

The tree holds part of this thesis and lacks the rest; each line names what exists or what is missing.

- **Truth store.** One trunk holds the modules, the configs, the decision records and the diagrams as code, read as a whole at one commit
  ([TDR-ONETRUTH-ONESTOREDECIDES](one-source-of-truth.md#rule-tdr-onetruth-onestoredecides)).
- **Mapping.** Every rule has a citation code, the index maps each code to its record, and code heads carry the codes that govern them
  ([index](../index.md)).
- **Checks, tests and gates.** Formatters, analyzers, tiered Pester tests and quality gates decide the eac normal form
  ([TDR-NORMALFORM-UNCONTESTED](eac-normal-form.md#rule-tdr-normalform-uncontested)), with a time roof on every run.
- **Three-phase flow.** The flow records define pipeline kinds, the promotion ladder and the release gates in the flow domain; the pipelines
  that run the promotion end to end are not yet built.
- **Agentic actors.** Robot definitions on named models load shared capabilities, are registered with the rules that support them, and read
  the AI agent contract first, as the repository domain decides.
- **Bounded actions.** A hook denies any shell call without a time limit, and heavy runs serialise on one run lock, so an agent's action
  ends or stops visibly.
- **Determinism.** Determinism comes from the gates, not from the model: a change is accepted only when the same checks give the same
  verdict on every run.
- **Experiments.** Imports land on the unordered track and migrate into the form one fragment at a time; a committed hypothesis record with
  declared expectations does not exist.
- **Digital twin.** No digital twin is in the tree: nothing replays production, so experiments run against the checks and the non-prod
  environments only.
- **Audit.** Git history is the audit trail of every change; platform approvals and runs are fact sources read, not copied
  ([TDR-STORES-FACTSOURCEREADONLY](truth-stores.md#rule-tdr-stores-factsourcereadonly)).

## Decision

Make catzc a closed loop: every change, by a person or an agent, is a committed experiment, tried against a deterministic twin and the
repository's own checks, carried through three phases, and kept in one trunk as the record of what was tried and what held.

### The platform

The platform is the loop itself: author, verify, promote, observe, and author again from what was observed. Determinism belongs to the
platform, not to its actors. Any actor, human or model, may propose anything; the twin and the gates decide, and they decide the same way
every time.

### The experiment

An experiment is a change with a declared expectation. Committing the hypothesis first makes the expectation reviewable before the result
exists, and replaying it on the twin makes the result repeatable. A rejected experiment is still history: the commit, the expectation, and
the verdict stay in the trunk as knowledge.

### The flow

The three phases follow the continuous-delivery records of the flow domain: authoring runs the fast checks on a devbox, integration runs the
full tests on every merge, and promotion moves one identical artifact through the environments. Each phase is a gate, so a change reaches
production only by passing all three in order.

### The truth store

Everything the loop reads or changes is code in the one repository ([TDR-ONETRUTH](one-source-of-truth.md)). Because every file carries the
rules that govern it, the repository can be mapped by its own tooling, and any state can be explained from the commit that produced it.

### The discipline

Agents work under the AI agent contract of the repository domain: they read the rules, act within the bounds of their brief, and return
verdicts that a gate can check. Small batches keep each verdict cheap to verify and each failure cheap to undo, and the decision to accept
stays with a person.

## Consequences

- An AI actor never changes the record directly; its change is accepted only by the same checks and gates as a person's.
- A change without a declared expectation is not an experiment, and its result teaches nothing the loop can reuse.
- A result that differs between two runs of the same commit is a defect in the platform, never an accepted outcome.
- Every phase leaves its verdict in the trunk or a fact source, so the whole loop is auditable from git history.
- The digital twin is the missing part of the loop; until it exists, experiments are verified against the checks and the non-prod
  environments.
