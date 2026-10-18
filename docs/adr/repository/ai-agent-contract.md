# ADR-REPO-AI: the agent contract

Every agent and every skill reads this first, at every start and after every clear. One line to act on per rule, then the why.

## Rules: ADR-REPO-AI

### Rule ADR-REPO-AI:1

**Read this contract first, every start.** Then the ADR index and only the rules your brief cites, by code. (ADR-REPO-LINK#5)

### Rule ADR-REPO-AI:2

**Trust the tree; verify cheaply.** A fact is checked by a read, a grep or a listing, never by a tool run. The tree is the truth.

### Rule ADR-REPO-AI:3

**Tests cost; postpone them to the end.** Run no test or gate while working; list the checks owed and report them as a warning.

### Rule ADR-REPO-AI:4

**A small test may run directly.** One Pester file or one gate on one file, in the background; Test-Automation is the user's.

### Rule ADR-REPO-AI:5

**Never mutate git.** No add, commit, mv, rm, reset, checkout, stash, rebase; the user commits. Query git only when a read cannot.

### Rule ADR-REPO-AI:6

**Working forward is safe.** Downstream is quality-controlled; do not re-verify what a gate will verify. (ADR-AUTO-TEST)

### Rule ADR-REPO-AI:7

**Foreground shell calls take at most 3 seconds.** Longer work runs in the background with a timeout prefix. (ADR-AUTO-FAILFAST#7)

### Rule ADR-REPO-AI:8

**One file at a time; read it back.** No script sweeps, no batch replace. (ADR-PRIN-ONELIVE)

### Rule ADR-REPO-AI:9

**Edit only what the brief names.** A shared file gets an entry request; a peer's dirty file is left alone. (ADR-REPO-AGENTS#4)

### Rule ADR-REPO-AI:10

**Never decide for the user.** An open question stays open and is reported; a recommendation is labelled as one.

### Rule ADR-REPO-AI:11

**End with the fixed report.** Files touched; checks owed and not run; checks run with output verbatim; what was left undone.

### Rule ADR-REPO-AI:12

**Use the domain's words.** Domain rules, never "house rules"; cats the product, catzc the inner namespace. (ADR-PRIN-CATS)

### Rule ADR-REPO-AI:13

**out/ is output, never input; render nothing unasked.** Plans live in .claude/plans; no diagram without an ask. (ADR-REPO-OUTDIR)

## Context

Agents start cold on small models. Test runs are the largest cost of a session, and a mutating git command by an agent cannot be undone by
the user. The time safeguard bounds every call; this contract bounds what a call is spent on.

A robot's front matter is a closed key set (ADR-REPO-AGENTS#6), and a value identical on every file is a constant, declared once
(ADR-PRIN-CONFIG, ADR-PRIN-REDUCEVAR). So the contract every robot and capability reads first is not a per-file key: it is named in the
`contracts` entry of agents.yml, which Test-AgentDefinitions reads, and in the CLAUDE.md session-start line.

## Decision

One short contract, named once: the top-level `contracts: [ADR-REPO-AI]` entry in agents.yml, which `Test-AgentDefinitions` reads, and the
CLAUDE.md session-start line. No per-file key. It says what to do and names the ADR that owns the why; under 100 lines with its head.

## Consequences

- A session's cost is bounded by reads, not runs; tests are reported as owed and run by the user.
- A fresh agent on the smallest model follows the contract without the corpus.
- Test-AgentDefinitions reads the required contracts from agents.yml; a front-matter key is not where a contract is named.
