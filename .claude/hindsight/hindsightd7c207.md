# Hindsight d7c207

Started 2026-10-21T05:24:52.8629145+02:00.

- 2026-10-21 Jack: If only the article had said relative to what: pwsh/Catzc.Base.QualityGates/Test-Plans.ps1:47 resolves -Path with
  GetFullPath against the process directory, while docs/references/pwsh/catzc-base-qualitygates/Test-Plans.ps1.md:37 says only the plans
  folder to check, so every relative caller is checked against the wrong folder, politely.
- 2026-10-21 Jack: If only the gate looked for what is missing: docs/drs/repository/plans.md:31 (ADR-REPO-PLANS-OPENSTEP) defines an open
  step as a checkbox line and Test-Plans.ps1.md:24 checks only - [ ] items, but nothing in the tree flags a numbered step without a
  checkbox, so it passes the gate and escapes the closing sweep alike.
- 2026-10-21 Jack: If only the learning had waited a commit: .claude/agents/fact-checker.md:11 runs on haiku and its registry entry at
  pwsh/Catzc.Base.Docs/configs/agents.yml:132 carries no model_reason at all, so the stale reason it mourns is already gone.
- 2026-10-21 Jack: If only CLAUDE.md agreed with its own capability: .claude/CLAUDE.md:158 still offers pwsh -NoProfile -Command with the
  importer, a semicolon and the command as its example, while .claude/skills/catzc-run/SKILL.md:19 forbids the semicolon in the call and the
  entry script makes the example unnecessary, a second contradiction beside the out/ script line already logged.
- 2026-10-21 Jack: If only one capability pointed at the index: docs/references/pwsh/index.md lists every module foundation-first with its
  Division of commands, yet no SKILL.md, robot body or .claude/CLAUDE.md line names docs/references/pwsh/, so the cheapest design round is
  the one nobody is told to start with.
- 2026-10-21 Jack: If only the session had counted rather than recalled: git grep finds language: csharp in the head of 270 tracked .cs
  files today, and .claude/plans/plan-minimal-heads.md:28 already lists language among the head keys it reworks, so the cost was one grep
  and the decision belongs to that plan.
- 2026-10-21 Jack: If only the ceiling were written where fan-outs are planned: .claude/skills/drawio-waves/SKILL.md:18 bounds its own waves
  to a few scouts, but no capability, robot or CLAUDE.md line states the 20-subagent limit, so a 41-agent fan-out discovers it at agent 21.
- 2026-10-21 Jack: If only the brief file were a capability: .claude/skills/drawio-waves/SKILL.md:4 knows fixed maker briefs for diagram
  waves alone, and nothing in the tree tells a general fan-out to write its brief once in a file and send each agent one line naming it.
- 2026-10-21 Jack: If only the session had read the contract checker:
  docs/references/pwsh/catzc-base-contracts/Get-ContractCheckResults.ps1.md:24-26 already lists the bounded subset (type, required,
  properties, additionalProperties as a boolean, enum, items, const) and calls any other keyword a finding.
- 2026-10-21 Jack: If only someone had warned the tests: no ADR, capability or analyzer rule in the tree says that Should -BeLike and Should
  -Throw match a -like pattern where [ ] is a character class, so every bracketed fragment in an expected string fails until a session
  learns it, twice in one session as the learnings show.
- 2026-10-21 Jack: If only the kit spoke thesis: python/catzc_diagrams/assets/STYLE.md:121-123 declares flow, thick, ADR-only and failure
  edges and python/catzc_diagrams/assets/template-slide.xml:148 fixes the thick legend to to a named set, with no read or junction edge kind
  anywhere, so thesis drawings borrow flow edges.
- 2026-10-21 Jack: If only the article admitted the side effect: pwsh/Catzc.Base.QualityGates/Format-Code.ps1:168 runs a file-meta imprint
  step (Invoke-ImprintStep at :177) over the files in scope, while docs/references/pwsh/catzc-base-qualitygates/Format-Code.ps1.md:19 speaks
  only of formatting, so a folder run writes heads into neighbours nobody asked about.
- 2026-10-21 Jack: If only the one place had a page: pwsh/Catzc.Base.Languages/types/LanguagesConfig.cs:150 renders every test folder name
  through TestFolderOf, called by Invoke-PythonTest.ps1:54 and Invoke-GoTest.ps1:52, but no article under docs/references/ names it, so a
  session finds the single source only by grep.
- 2026-10-21 Jack: If only the lock had a janitor: docs/drs/automation/python/python-test-artifacts.md:43 and .gitignore:120 declare uv.lock
  a gitignored product of uv sync, but nothing in the tree deletes it or warns that it pins member paths, so every member move ends in a red
  uv sync and a manual delete.
- 2026-10-21 Jack: If only one living version applied to slugs: the module-to-kebab rule, ToLowerInvariant then dot to hyphen, is spelled
  out separately in pwsh/Catzc.Base.QualityGates/types/CommentPageMap.cs, Catzc.Base.Docs/private/Get-ReadmeMappings.ps1,
  Catzc.Base.Globs/Get-ModuleGlobSet.ps1, Catzc.Base.Languages/New-PythonProject.ps1 and
  Catzc.Base.QualityGates/private/Get-ModuleProtectionIdentity.ps1, with no shared method or config key, so a snake folder surprises five
  copies at once.
- 2026-10-21 Jack: If only someone had parsed it once: no ADR, capability or shared helper in the tree says that FunctionDefinitionAst.Name
  keeps a scope qualifier such as script:, so each name check strips it by hand or not at all.
- 2026-10-21 Jack: If only scripts were not needed: pwsh/.internal/assets/Invoke-CatzcCommand.ps1:29 takes [string[]] Command as separate
  quoted arguments, as .claude/skills/catzc-run/SKILL.md:18 prescribes, so a cats call never needs a comma list, but nothing in the tree
  warns a script of one's own that pwsh -File hands it one string.
- 2026-10-21 Jack: If only the tip had read the rules before proposing to break them: .claude/CLAUDE.md:124 forbids batch-editing many files
  with scripts and docs/drs/repository/ai-agent-contract.md:40 says one file at a time, read back, so a burst of apply and rollback scripts
  is the very sweep the tree bans, rollback included.
- 2026-10-21 Jack: If only the session had read the config article:
  docs/references/pwsh/catzc-base-qualitygates/configs/file-meta.yml.md:30-31 already says a meta kind with no select applies to every file
  that carries a head, so a select-less body-sha was always going to meet every carrier, BodyHash or not.
- 2026-10-21 Jack: If only the session had read the config ADR: docs/drs/configuration/module-config-loading.md:22 already says Get-Config
  caches by resolved file path and invalidates only by re-import, so a peer sees the edit at its next fresh import and not a moment sooner.
