---
plan:
  status: active
  value: medium
  reviewed: 2026-10-22
  class: feature
  targets: [docs/how-to]
---

# Debt docs: two how-tos for facts only whoever knew them could find

Two facts live nowhere a session looks: which `command.yml` is the sample of a command contract, and how a hook is fed a payload. Each step
is one new how-to under `docs/how-to/` and its row in the how-to index; the chunk owns those files only.

## Open steps

1. [ ] Susan from HR: hindsight 031350, "If only a how-to had pointed at the shape": `command-contracts.md` declares the command contract,
       but no how-to names a `command.yml` (a grep of `docs/how-to` finds none). Cost: the sample is found only by whoever knows it. Change:
       a how-to that adds a command contract, pointing at one real `command.yml` and the rules of `command-contracts.md`. Check:
       `Test-Links` and `Test-Markdownlint` on the new page and the index.
2. [ ] Susan from HR: hindsight 031350, "If only someone had written down how to feed a hook": no how-to or capability says a hook payload
       is tested from a file redirected into the hook exe (a grep of `docs/how-to` for payload finds none), so Git Bash `echo` keeps eating
       the JSON backslashes. Cost: a failed hook test per attempt. Change: a how-to that writes the payload to a file and redirects it into
       the exe. Check: `Test-Links` and `Test-Markdownlint` on the new page and the index.

## Open questions

- Hindsight d7c207, "If only someone had told the parameters": no ADR, analyzer rule or capability says `ValidatePattern` ignores case
  unless it carries `Options = None`; the one precedent is `pwsh/Catzc.Base.Docs/Add-SessionLearning.ps1:57`. Should
  `docs/drs/automation/pwsh/parameter-design.md` gain a rule for it? Recommendation: yes, one rule citing the precedent, since a rule is
  doctrine and the user writes it.
- Hindsight d7c207, "If only the kit spoke thesis": `python/catzc_diagrams/assets/STYLE.md:121-123` declares flow, thick, ADR-only and
  failure edges, with no read or junction edge kind, so thesis drawings borrow flow edges. Should the kit gain a read edge kind?
  Recommendation: yes, one kind in STYLE.md and the template, since a vocabulary value is the user's to add.
