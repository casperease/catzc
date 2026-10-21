---
plan:
  status: active
  value: high
  reviewed: 2026-10-21
  class: feature
  targets:
    [
      .claude/agents/fact-checker.md,
      pwsh/Catzc.Tooling.Listen/Get-DocChange.ps1,
      .claude/plans,
      pwsh/Catzc.Base.Docs/configs/agents.yml,
      docs/adr/repository/ai-agent-contract.md,
      docs/explanation/thesis/index.md,
      docs/references/pwsh/catzc-tooling-listen.md,
    ]
---

# The listen mode: register the processor, process the first notes, settle the seed

The listen mode is in the tree: the listener (`Start-DocListener`, `Catzc.Tooling.Listen`) that notes each change with its source (editor,
agent or unknown, from the `Record-AgentWrite` hook and the `catzc-save-ledger` extension), the processor robot
(`listen-very-carefully-to-doc-changes`), its scout (`doc-pattern-scout`) and their three capabilities. Left: the fact-checker's fit for the
mode, the first editor notes to process, one refinement of the notes, and the seed's decisions.

## Why its value is high

The editor's first three corrections are waiting as notes in `out/`, which can be wiped; until the processor runs, they exist only there and
in the Carried section below.

## Decided (2026-10-20 and 2026-10-21, from the user)

- In listen mode the editor's edit is fact (ADR-REPO-AI-EDITORISFACT); everywhere else the truth is the repository at one commit.
- The listener is a command with no model; the processor is the robot; the notes and the ledger are their contract, one writer each.
- Doc types are the file kinds of `file-kinds.yml`; `listen.yml` groups them into tiers, so no doc-type registry of its own.
- The processor plans from editor notes only; agent and unknown notes are context. The agent-write hook runs in every session.
- A fact-check verdict never stands alone: `Complete-DocNote` requires its reason, with the path:line it rests on.
- A stamped folder in `out/` is fine as input; it can be missing at start or vanish mid-run, and the tooling waits through both.
- The term stays **responsibility domain** (ADR-THES-STORES-RESPONSIBILITYDOMAIN).
- (decision round, 2026-10-21) The fact-checker already runs on haiku; its stale `model_reason` in `agents.yml` goes, since that key is only
  for a robot above the default.
- (decision round) The mode stays a rule of the AI agent contract, ADR-REPO-AI-EDITORISFACT, specialising the thesis; it cites
  ADR-THES-ONETRUTH-ONESTOREDECIDES in place of ADR-PRIN-ONELIVE, which governs versions, not truth.
- (decision round) The working tree is the proposal for the next commit and the committed tree at one commit is the truth;
  `ai-agent-contract.md:14` ("The tree is the truth") says so, and a local gate's verdict is a verdict on the proposal.
- (decision round) Both samples land: `where-truth-comes-from` beside the thesis explanation, `listen-mode-flow` beside the
  `Catzc.Tooling.Listen` reference, each moved from `out/` into its article's `.assets` folder.

## Open steps

- [ ] `.claude/plans/plan-listen-<pattern>.md`: the processor processes the three editor notes carried below (session
      `out/listen/20261021-005743`, reference pinned at `ed41b3e`), or the carried text when the session is gone (check: `Test-Plans`).
- [ ] `pwsh/Catzc.Tooling.Listen/Get-DocChange.ps1`: `Rules` lists only the ADR codes cited in the changed lines, not every code in the file
      (a whole-file list ran to 40 codes on `dora-explains.md`) (check: `Invoke-TestFile` on `Get-DocChange.Tests.ps1`).

- [ ] `pwsh/Catzc.Base.Docs/configs/agents.yml`: drop the fact-checker's `model_reason` (check: `Test-AgentDefinitions`).
- [ ] `docs/adr/repository/ai-agent-contract.md`: ADR-REPO-AI-EDITORISFACT cites ADR-THES-ONETRUTH-ONESTOREDECIDES in place of
      ADR-PRIN-ONELIVE (check: `Test-AdrCitations`, `Test-Links` on the page).
- [ ] `docs/adr/repository/ai-agent-contract.md`: ADR-REPO-AI-TRUSTTHETREE (line 14) says the committed tree at one commit is the truth and
      the working tree is the proposal for the next commit, in step with line 76 (check: `Test-AdrCodes`, `Test-Links` on the page).
- [ ] `out/diagrams/dark-sample/.assets/where-truth-comes-from/` to `docs/explanation/thesis/.assets/where-truth-comes-from/`, embedded in
      `docs/explanation/thesis/index.md`, put with `Build-Diagrams -Path` (check: `Test-Diagrams` on the folder, `Test-Links` on the page).
- [ ] `out/diagrams/dark-sample/.assets/listen-mode-flow/` to the `.assets` folder beside `docs/references/pwsh/catzc-tooling-listen.md`,
      embedded there (check: `Test-Diagrams` on the folder, `Test-Links` on the page).

The `Measure-NoCollapsingAssignment` finding in `Get-RelativeEdgesFileMetaFact.ps1` is plan-file-meta-cache's step 4.

## Carried

The editor's first three corrections (2026-10-21, notes 0001 to 0003, all `source: editor`, tier `rule`), verbatim from the notes:

1. `docs/adr/thesis/eac-normal-form.md`: "A fragment can stay unordered while its migration is under way, but nothing **internally** reads
   it as truth until it is in the form."
2. `docs/adr/thesis/one-source-of-truth.md`, ADR-THES-ONETRUTH-REPOSITORYISCONFIGURATIONRECORD: "nothing about delivery state lives outside
   it" became "nothing about delivery state **have source of truth (for BVT)** outside it".
3. Same rule: the adjacent store's examples became "such as a GitOps or configuration repository **or Azure Devops Services SaaS / GitHub
   SaaS**".

The user's seed for the first session (2026-10-20), the worked example of the mode:

> In any other context the AI must always use the current state of truth in a global, repository-wide context, with no preference for where
> truth comes from, looking only at committed files. This is fundamental to the single-source-of-truth ADR. Our single source of truth in
> all other modes is the system as a whole, immutable at a commit `xyz123`, as the single source of truth for our responsibility domain. A
> responsibility domain is that which a git repository is the responsibility boundary for, at org, team, product or person level: an
> org-mono-repo, a team-mono-repo, a personal repo. With git we are bound to each repository being the one responsibility domain that can be
> security-controlled; we cannot separate responsibilities by hard controls inside a repository unless we cross branch boundaries or
> client-to-server pushes. So a repository is one responsibility domain, e.g. a product repository holding its complete tooling, pipelines
> and configuration, including real prod, except secrets.
