---
catzc:
  edges:
    cites:
      - ADR-AUTO-DEFAULT-ONERESOLUTIONORDER
      - ADR-AUTO-FAILFAST-BOUNDEVERYWAIT
---

# A run past its limit stops with a message that names the limit and where to change it

```text
A run past its limit stops with a message that names the limit and where to change it; no call runs without one.

1  agent               a coding agent whose every Bash call passes the hook
2  developer           a person running pwsh work on a devbox, or a pipeline running it unattended
3  Assert-BashTimeout  the hook: a call without a limit within the bash limits is denied
4  Invoke-Executable   a native tool, killed with its process tree past its executable's limit
5  Invoke-WithTimeout  a script block, stopped past the pwsh limit or a budget's ceiling
6  Bash call denied    the denial: the limit, how to re-issue the call, who to tell
7  TimeoutException    the throw: how long it ran, the limit, which file or parameter to tune

Supports ADR-AUTO-FAILFAST-BOUNDEVERYWAIT and ADR-AUTO-DEFAULT-ONERESOLUTIONORDER (operations lens).
```

Nobody in cats waits forever. A person's pwsh work runs through `Invoke-Executable` or `Invoke-WithTimeout`, and a coding agent's shell call
runs through the Bash hook; each is the same wait with a different caller, and each stops at a known limit with an ordinary failure that
says how long it ran, what the limit was, and where to change it. The limits are tight on purpose on a devbox, 3 seconds for pwsh work and
for a foreground bash call, so that a call which legitimately needs longer shows up as a blocker to tune rather than a limit raised quietly
in code.

```yml drawio
description:
  "Every call runs inside a limit: an agent's Bash call meets the hook, a developer's or pipeline's pwsh work runs through the two bounded
  runners, and a run past its limit stops with a message naming the limit and where to change it."
about:
  adrs: [ADR-AUTO-FAILFAST-BOUNDEVERYWAIT, ADR-AUTO-DEFAULT-ONERESOLUTIONORDER]
  lens: operations
content:
  title: A run past its limit stops with a message that names the limit and where to change it
  kind: explanation
  flow: left-to-right
  relation: runs
  theme: dark
  bands:
    - { id: band-caller, label: CALLER }
    - { id: band-call, label: CALL }
    - { id: band-stop, label: STOP }
  groups:
    - { id: grp-runners, label: bounded runners, in: band-call }
  glyphs:
    - { id: g-agent, kind: actor, label: agent, in: band-caller }
    - { id: g-developer, kind: actor, label: developer, in: band-caller }
    - { id: g-hook, kind: gate, label: Assert-BashTimeout, in: band-call }
    - { id: g-executable, kind: code, label: Invoke-Executable, in: grp-runners }
    - { id: g-with-timeout, kind: code, label: Invoke-WithTimeout, in: grp-runners }
    - { id: f-denied, kind: failure, label: Bash call denied, in: band-stop }
    - { id: f-timeout, kind: failure, label: TimeoutException, in: band-stop }
  edges:
    - { from: g-agent, to: g-hook, kind: flow, label: "" }
    - { from: g-developer, to: grp-runners, kind: flow, label: "" }
    - { from: g-hook, to: f-denied, kind: fail, label: "" }
    - { from: grp-runners, to: f-timeout, kind: fail, label: "" }
  markers:
    - { at: g-agent, number: 1 }
    - { at: g-developer, number: 2 }
    - { at: g-hook, number: 3 }
    - { at: g-executable, number: 4 }
    - { at: g-with-timeout, number: 5 }
    - { at: f-denied, number: 6 }
    - { at: f-timeout, number: 7 }
  legend: auto
  minimaps:
    code-locations:
      - cell: .claude/.claude/.
        by: [.claude/CLAUDE.md, ADR-AUTO-DEFAULT-ONERESOLUTIONORDER, ADR-AUTO-FAILFAST-BOUNDEVERYWAIT]
      - cell: .claude/.claude/hooks/Assert-BashTimeout
        by: [.claude/hooks/Assert-BashTimeout/Program.cs, ADR-AUTO-DEFAULT-ONERESOLUTIONORDER, ADR-AUTO-FAILFAST-BOUNDEVERYWAIT]
      - cell: .claude/.claude/skills/catzc-module
        by: [.claude/skills/catzc-module/SKILL.md, ADR-AUTO-DEFAULT-ONERESOLUTIONORDER]
      - cell: docs/-/.
        by:
          - docs/drs/automation/dora-explains.md
          - docs/drs/automation/fail-fast-with-asserts.md
          - docs/drs/automation/sensible-defaults.md
          - docs/drs/glossary.md
          - docs/drs/index.md
          - docs/how-to/pwsh/manual-test-plan/configs.md
          - docs/how-to/pwsh/manual-test-plan/repository-conventions.md
          - docs/references/pwsh/catzc-azure-cli/Assert-AzCliSubscriptionAccessible.ps1.md
          - docs/references/pwsh/catzc-azure/types/AzureConfig.cs.md
          - docs/references/pwsh/catzc-base-contracts/configs/contracts.yml.md
          - docs/references/pwsh/catzc-base-contracts/tests/types/ContractsConfig.Tests.ps1.md
          - docs/references/pwsh/catzc-base-contracts/types/ContractsConfig.cs.md
          - docs/references/pwsh/catzc-base-docs/Test-Glossary.ps1.md
          - docs/references/pwsh/catzc-base-docs/tests/Test-Glossary.Tests.ps1.md
          - docs/references/pwsh/catzc-base-drs/configs/drs-checks.yml.md
          - docs/references/pwsh/catzc-base-drs/private/Import-DrsCitationMapFile.ps1.md
          - docs/references/pwsh/catzc-base-drs/types/DrsChecksConfig.cs.md
          - docs/references/pwsh/catzc-base-drs/types/DrsConfig.cs.md
          - docs/references/pwsh/catzc-base-engines/types/ExecutionEngine.cs.md
          - docs/references/pwsh/catzc-base-folders/tests/types/FolderWalkConfig.Tests.ps1.md
          - docs/references/pwsh/catzc-base-git/Import-RepositoryWithHistory.ps1.md
          - docs/references/pwsh/catzc-base-globs/Test-GlobSetAffected.ps1.md
          - docs/references/pwsh/catzc-base-languages.md
          - docs/references/pwsh/catzc-base-languages/configs/file-carriers.yml.md
          - docs/references/pwsh/catzc-base-languages/configs/go.yml.md
          - docs/references/pwsh/catzc-base-languages/configs/languages.yml.md
          - docs/references/pwsh/catzc-base-languages/configs/python.yml.md
          - docs/references/pwsh/catzc-base-languages/types/FileCarrier.cs.md
          - docs/references/pwsh/catzc-base-languages/types/FileCarriersConfig.cs.md
          - docs/references/pwsh/catzc-base-languages/types/GoConfig.cs.md
          - docs/references/pwsh/catzc-base-languages/types/LanguagesConfig.cs.md
          - docs/references/pwsh/catzc-base-maps/configs/maps.yml.md
          - docs/references/pwsh/catzc-base-maps/types/MapsConfig.cs.md
          - docs/references/pwsh/catzc-base-maps/types/MapsHighlight.cs.md
          - docs/references/pwsh/catzc-base-maps/types/MapsLabels.cs.md
          - docs/references/pwsh/catzc-base-maps/types/MapsLimits.cs.md
          - docs/references/pwsh/catzc-base-maps/types/MapsPalette.cs.md
          - docs/references/pwsh/catzc-base-quality-gates/Test-ShippedConfigs.ps1.md
          - docs/references/pwsh/catzc-base-quality-gates/configs/comments.yml.md
          - docs/references/pwsh/catzc-base-quality-gates/configs/file-meta.yml.md
          - docs/references/pwsh/catzc-base-quality-gates/configs/links.yml.md
          - docs/references/pwsh/catzc-base-quality-gates/configs/parameter-consistency.yml.md
          - docs/references/pwsh/catzc-base-quality-gates/configs/source-conventions.yml.md
          - docs/references/pwsh/catzc-base-quality-gates/configs/test-policy.yml.md
          - docs/references/pwsh/catzc-base-quality-gates/private/Get-LinkLineLimit.ps1.md
          - docs/references/pwsh/catzc-base-quality-gates/private/Test-TestRunOverBudget.ps1.md
          - docs/references/pwsh/catzc-base-quality-gates/private/Write-TestAutomationVerdict.ps1.md
          - docs/references/pwsh/catzc-base-quality-gates/tests/types/CommentsConfig.Tests.ps1.md
          - docs/references/pwsh/catzc-base-quality-gates/tests/types/FileMetaConfig.Tests.ps1.md
          - docs/references/pwsh/catzc-base-quality-gates/tests/types/LinksConfig.Tests.ps1.md
          - docs/references/pwsh/catzc-base-quality-gates/tests/types/SourceCheck.Tests.ps1.md
          - docs/references/pwsh/catzc-base-quality-gates/tests/types/SourceConventionsConfig.Tests.ps1.md
          - docs/references/pwsh/catzc-base-quality-gates/types/CommentsConfig.cs.md
          - docs/references/pwsh/catzc-base-quality-gates/types/EngineSetCheck.cs.md
          - docs/references/pwsh/catzc-base-quality-gates/types/FileMetaKind.cs.md
          - docs/references/pwsh/catzc-base-quality-gates/types/GeneratedWriter.cs.md
          - docs/references/pwsh/catzc-base-quality-gates/types/LinksConfig.cs.md
          - docs/references/pwsh/catzc-base-quality-gates/types/ParameterConsistencyConfig.cs.md
          - docs/references/pwsh/catzc-base-quality-gates/types/SourceCheck.cs.md
          - docs/references/pwsh/catzc-base-quality-gates/types/SourceConventionsConfig.cs.md
          - docs/references/pwsh/catzc-base-quality-gates/types/TestPolicyConfig.cs.md
          - docs/references/pwsh/catzc-base-reports/types/CheckMode.cs.md
          - docs/references/pwsh/catzc-base-reports/types/CheckModes.cs.md
          - docs/references/pwsh/catzc-base-timeouts/Get-TestTimeLimits.ps1.md
          - docs/references/pwsh/catzc-base-timeouts/Watch-Blocking.ps1.md
          - docs/references/pwsh/catzc-base-timeouts/types/BashSafeguard.cs.md
          - docs/references/pwsh/catzc-base-timeouts/types/TimeoutExemptionsConfig.cs.md
          - docs/references/pwsh/catzc-base-timeouts/types/TimeoutsConfig.cs.md
          - docs/references/pwsh/catzc-base-types-system.md
          - docs/references/pwsh/catzc-base-types-system/Build-AgentHook.ps1.md
          - docs/references/pwsh/catzc-base-variants/private/Get-Variant.ps1.md
          - docs/references/pwsh/catzc-base-variants/types/VariantsConfig.cs.md
          - docs/references/pwsh/catzc-tooling-inspiration/Get-Inspiration.ps1.md
          - docs/references/pwsh/catzc-tooling-inspiration/configs/inspiration.yml.md
          - docs/references/pwsh/catzc-tooling-inspiration/tests/types/InspirationConfig.Tests.ps1.md
          - docs/references/pwsh/catzc-tooling-inspiration/types/InspirationConfig.cs.md
          - docs/references/pwsh/catzc-tooling-listen/Wait-DocChange.ps1.md
          - docs/references/pwsh/catzc-tooling-listen/Wait-DocNote.ps1.md
          - docs/references/pwsh/claude-hooks/Assert-BashTimeout/Program.cs.md
          - ADR-AUTO-DEFAULT-ONERESOLUTIONORDER
          - ADR-AUTO-FAILFAST-BOUNDEVERYWAIT
      - cell: pwsh/-/.
        by: [pwsh/.scriptanalyzer/tests/NoLiteralDefault.Tests.ps1, ADR-AUTO-DEFAULT-ONERESOLUTIONORDER]
      - cell: pwsh/Catzc.Azure/types
        by: [pwsh/Catzc.Azure/types/AzureConfig.cs, ADR-AUTO-DEFAULT-ONERESOLUTIONORDER]
      - cell: pwsh/Catzc.Azure.Cli/.
        by: [pwsh/Catzc.Azure.Cli/Assert-AzCliSubscriptionAccessible.ps1, ADR-AUTO-FAILFAST-BOUNDEVERYWAIT]
      - cell: pwsh/Catzc.Base.CodeMeta/tests/types
        by: [pwsh/Catzc.Base.CodeMeta/tests/types/CommentPagesConfig.Tests.ps1, ADR-AUTO-DEFAULT-ONERESOLUTIONORDER]
      - cell: pwsh/Catzc.Base.Config/configs
        by: [pwsh/Catzc.Base.Config/configs/glossary.yml, ADR-AUTO-DEFAULT-ONERESOLUTIONORDER]
      - cell: pwsh/Catzc.Base.Config/tests
        by: [pwsh/Catzc.Base.Config/tests/Get-Config.Tests.ps1, ADR-AUTO-DEFAULT-ONERESOLUTIONORDER]
      - cell: pwsh/Catzc.Base.Config/types
        by: [pwsh/Catzc.Base.Config/types/ConfigDefaultDifference.cs, ADR-AUTO-DEFAULT-ONERESOLUTIONORDER]
      - cell: pwsh/Catzc.Base.Contracts/configs
        by: [pwsh/Catzc.Base.Contracts/configs/contracts.yml, ADR-AUTO-DEFAULT-ONERESOLUTIONORDER]
      - cell: pwsh/Catzc.Base.Contracts/tests
        by: [pwsh/Catzc.Base.Contracts/tests/Get-Contract.Tests.ps1, ADR-AUTO-DEFAULT-ONERESOLUTIONORDER]
      - cell: pwsh/Catzc.Base.Contracts/tests/types
        by:
          - pwsh/Catzc.Base.Contracts/tests/types/AccostedConfig.Tests.ps1
          - pwsh/Catzc.Base.Contracts/tests/types/ContractCommand.Tests.ps1
          - pwsh/Catzc.Base.Contracts/tests/types/ContractsConfig.Tests.ps1
          - ADR-AUTO-DEFAULT-ONERESOLUTIONORDER
      - cell: pwsh/Catzc.Base.Contracts/types
        by:
          - pwsh/Catzc.Base.Contracts/types/ContractCommand.cs
          - pwsh/Catzc.Base.Contracts/types/ContractParameter.cs
          - pwsh/Catzc.Base.Contracts/types/ContractsConfig.cs
          - ADR-AUTO-DEFAULT-ONERESOLUTIONORDER
      - cell: pwsh/Catzc.Base.Docs/.
        by: [pwsh/Catzc.Base.Docs/Test-Glossary.ps1, ADR-AUTO-FAILFAST-BOUNDEVERYWAIT]
      - cell: pwsh/Catzc.Base.Docs/configs
        by:
          - pwsh/Catzc.Base.Docs/configs/agents.yml
          - pwsh/Catzc.Base.Docs/configs/capabilities.yml
          - ADR-AUTO-DEFAULT-ONERESOLUTIONORDER
          - ADR-AUTO-FAILFAST-BOUNDEVERYWAIT
      - cell: pwsh/Catzc.Base.Docs/tests
        by: [pwsh/Catzc.Base.Docs/tests/Test-Glossary.Tests.ps1, ADR-AUTO-FAILFAST-BOUNDEVERYWAIT]
      - cell: pwsh/Catzc.Base.Docs/tests/types
        by: [pwsh/Catzc.Base.Docs/tests/types/LearningsConfig.Tests.ps1, ADR-AUTO-DEFAULT-ONERESOLUTIONORDER]
      - cell: pwsh/Catzc.Base.Drs/configs
        by:
          - pwsh/Catzc.Base.Drs/configs/drs-checks.yml
          - pwsh/Catzc.Base.Drs/configs/drs.yml
          - ADR-AUTO-DEFAULT-ONERESOLUTIONORDER
          - ADR-AUTO-FAILFAST-BOUNDEVERYWAIT
      - cell: pwsh/Catzc.Base.Drs/private
        by: [pwsh/Catzc.Base.Drs/private/Import-DrsCitationMapFile.ps1, ADR-AUTO-FAILFAST-BOUNDEVERYWAIT]
      - cell: pwsh/Catzc.Base.Drs/tests/types
        by: [pwsh/Catzc.Base.Drs/tests/types/DrsChecksConfig.Tests.ps1, ADR-AUTO-DEFAULT-ONERESOLUTIONORDER]
      - cell: pwsh/Catzc.Base.Drs/types
        by: [pwsh/Catzc.Base.Drs/types/DrsChecksConfig.cs, pwsh/Catzc.Base.Drs/types/DrsConfig.cs, ADR-AUTO-DEFAULT-ONERESOLUTIONORDER]
      - cell: pwsh/Catzc.Base.Engines/types
        by: [pwsh/Catzc.Base.Engines/types/ExecutionEngine.cs, ADR-AUTO-FAILFAST-BOUNDEVERYWAIT]
      - cell: pwsh/Catzc.Base.Flow/tests/types
        by: [pwsh/Catzc.Base.Flow/tests/types/RungsConfig.Tests.ps1, ADR-AUTO-DEFAULT-ONERESOLUTIONORDER]
      - cell: pwsh/Catzc.Base.Folders/tests
        by: [pwsh/Catzc.Base.Folders/tests/Get-ChildPath.Tests.ps1, ADR-AUTO-DEFAULT-ONERESOLUTIONORDER]
      - cell: pwsh/Catzc.Base.Folders/tests/types
        by:
          - pwsh/Catzc.Base.Folders/tests/types/FolderWalkConfig.Tests.ps1
          - pwsh/Catzc.Base.Folders/tests/types/FolderWalker.Tests.ps1
          - ADR-AUTO-DEFAULT-ONERESOLUTIONORDER
      - cell: pwsh/Catzc.Base.Git/.
        by: [pwsh/Catzc.Base.Git/Import-RepositoryWithHistory.ps1, ADR-AUTO-DEFAULT-ONERESOLUTIONORDER]
      - cell: pwsh/Catzc.Base.Globs/.
        by: [pwsh/Catzc.Base.Globs/Test-GlobSetAffected.ps1, ADR-AUTO-FAILFAST-BOUNDEVERYWAIT]
      - cell: pwsh/Catzc.Base.Languages/configs
        by:
          - pwsh/Catzc.Base.Languages/configs/file-carriers.yml
          - pwsh/Catzc.Base.Languages/configs/go.yml
          - pwsh/Catzc.Base.Languages/configs/languages.yml
          - pwsh/Catzc.Base.Languages/configs/python.yml
          - ADR-AUTO-DEFAULT-ONERESOLUTIONORDER
      - cell: pwsh/Catzc.Base.Languages/tests
        by: [pwsh/Catzc.Base.Languages/tests/Get-EngineContract.Tests.ps1, ADR-AUTO-FAILFAST-BOUNDEVERYWAIT]
      - cell: pwsh/Catzc.Base.Languages/tests/types
        by:
          - pwsh/Catzc.Base.Languages/tests/types/FileCarriersConfig.Tests.ps1
          - pwsh/Catzc.Base.Languages/tests/types/LanguagesConfig.Tests.ps1
          - ADR-AUTO-DEFAULT-ONERESOLUTIONORDER
      - cell: pwsh/Catzc.Base.Languages/types
        by:
          - pwsh/Catzc.Base.Languages/types/FileCarrier.cs
          - pwsh/Catzc.Base.Languages/types/FileCarriersConfig.cs
          - pwsh/Catzc.Base.Languages/types/GoConfig.cs
          - pwsh/Catzc.Base.Languages/types/LanguagesConfig.cs
          - pwsh/Catzc.Base.Languages/types/LayoutRow.cs
          - ADR-AUTO-DEFAULT-ONERESOLUTIONORDER
      - cell: pwsh/Catzc.Base.Maps/configs
        by: [pwsh/Catzc.Base.Maps/configs/maps.yml, ADR-AUTO-DEFAULT-ONERESOLUTIONORDER]
      - cell: pwsh/Catzc.Base.Maps/tests/types
        by: [pwsh/Catzc.Base.Maps/tests/types/MapsConfig.Tests.ps1, ADR-AUTO-DEFAULT-ONERESOLUTIONORDER]
      - cell: pwsh/Catzc.Base.Maps/types
        by:
          - pwsh/Catzc.Base.Maps/types/MapsConfig.cs
          - pwsh/Catzc.Base.Maps/types/MapsHighlight.cs
          - pwsh/Catzc.Base.Maps/types/MapsLabels.cs
          - pwsh/Catzc.Base.Maps/types/MapsLimits.cs
          - pwsh/Catzc.Base.Maps/types/MapsPalette.cs
          - ADR-AUTO-DEFAULT-ONERESOLUTIONORDER
      - cell: pwsh/Catzc.Base.ModuleSystem/tests
        by:
          - pwsh/Catzc.Base.ModuleSystem/tests/Resolve-ImportMix.Tests.ps1
          - pwsh/Catzc.Base.ModuleSystem/tests/Set-ImportMix.Tests.ps1
          - ADR-AUTO-DEFAULT-ONERESOLUTIONORDER
      - cell: pwsh/Catzc.Base.ModuleSystem/tests/types
        by:
          - pwsh/Catzc.Base.ModuleSystem/tests/types/ImportMix.Tests.ps1
          - pwsh/Catzc.Base.ModuleSystem/tests/types/ImporterConfig.Tests.ps1
          - ADR-AUTO-DEFAULT-ONERESOLUTIONORDER
      - cell: pwsh/Catzc.Base.QualityGates/.
        by: [pwsh/Catzc.Base.QualityGates/Test-ShippedConfigs.ps1, ADR-AUTO-DEFAULT-ONERESOLUTIONORDER]
      - cell: pwsh/Catzc.Base.QualityGates/configs
        by:
          - pwsh/Catzc.Base.QualityGates/configs/analyzer-drs-map.yml
          - pwsh/Catzc.Base.QualityGates/configs/comments.yml
          - pwsh/Catzc.Base.QualityGates/configs/file-meta.yml
          - pwsh/Catzc.Base.QualityGates/configs/links.yml
          - pwsh/Catzc.Base.QualityGates/configs/parameter-consistency.yml
          - pwsh/Catzc.Base.QualityGates/configs/source-conventions.yml
          - pwsh/Catzc.Base.QualityGates/configs/test-policy.yml
          - ADR-AUTO-DEFAULT-ONERESOLUTIONORDER
      - cell: pwsh/Catzc.Base.QualityGates/private
        by:
          - pwsh/Catzc.Base.QualityGates/private/Get-LinkLineLimit.ps1
          - pwsh/Catzc.Base.QualityGates/private/Test-TestRunOverBudget.ps1
          - pwsh/Catzc.Base.QualityGates/private/Write-TestAutomationVerdict.ps1
          - ADR-AUTO-DEFAULT-ONERESOLUTIONORDER
          - ADR-AUTO-FAILFAST-BOUNDEVERYWAIT
      - cell: pwsh/Catzc.Base.QualityGates/tests
        by:
          - pwsh/Catzc.Base.QualityGates/tests/Get-DrsCodesFileMetaFact.Tests.ps1
          - pwsh/Catzc.Base.QualityGates/tests/Test-ShippedConfigs.Tests.ps1
          - ADR-AUTO-DEFAULT-ONERESOLUTIONORDER
      - cell: pwsh/Catzc.Base.QualityGates/tests/types
        by:
          - pwsh/Catzc.Base.QualityGates/tests/types/CommentsConfig.Tests.ps1
          - pwsh/Catzc.Base.QualityGates/tests/types/EngineSetCheck.Tests.ps1
          - pwsh/Catzc.Base.QualityGates/tests/types/FileHeadPolicy.Tests.ps1
          - pwsh/Catzc.Base.QualityGates/tests/types/FileMetaConfig.Tests.ps1
          - pwsh/Catzc.Base.QualityGates/tests/types/LinksConfig.Tests.ps1
          - pwsh/Catzc.Base.QualityGates/tests/types/PlansConfig.Tests.ps1
          - pwsh/Catzc.Base.QualityGates/tests/types/SourceCheck.Tests.ps1
          - pwsh/Catzc.Base.QualityGates/tests/types/SourceConventionsConfig.Tests.ps1
          - ADR-AUTO-DEFAULT-ONERESOLUTIONORDER
      - cell: pwsh/Catzc.Base.QualityGates/types
        by:
          - pwsh/Catzc.Base.QualityGates/types/CommentsConfig.cs
          - pwsh/Catzc.Base.QualityGates/types/EngineSetCheck.cs
          - pwsh/Catzc.Base.QualityGates/types/FileMetaKind.cs
          - pwsh/Catzc.Base.QualityGates/types/GeneratedWriter.cs
          - pwsh/Catzc.Base.QualityGates/types/LinksConfig.cs
          - pwsh/Catzc.Base.QualityGates/types/ParameterConsistencyConfig.cs
          - pwsh/Catzc.Base.QualityGates/types/PlansConfig.cs
          - pwsh/Catzc.Base.QualityGates/types/SourceCheck.cs
          - pwsh/Catzc.Base.QualityGates/types/SourceConventionsConfig.cs
          - pwsh/Catzc.Base.QualityGates/types/TestPolicyConfig.cs
          - ADR-AUTO-DEFAULT-ONERESOLUTIONORDER
      - cell: pwsh/Catzc.Base.Reports/tests/types
        by:
          - pwsh/Catzc.Base.Reports/tests/types/CheckModes.Tests.ps1
          - pwsh/Catzc.Base.Reports/tests/types/IsolationRunResult.Tests.ps1
          - pwsh/Catzc.Base.Reports/tests/types/OutputFormatsConfig.Tests.ps1
          - pwsh/Catzc.Base.Reports/tests/types/QualityGateResult.Tests.ps1
          - pwsh/Catzc.Base.Reports/tests/types/TestRunResult.Tests.ps1
          - ADR-AUTO-DEFAULT-ONERESOLUTIONORDER
      - cell: pwsh/Catzc.Base.Reports/types
        by:
          - pwsh/Catzc.Base.Reports/types/CheckMode.cs
          - pwsh/Catzc.Base.Reports/types/CheckModes.cs
          - pwsh/Catzc.Base.Reports/types/IsolationRunResult.cs
          - pwsh/Catzc.Base.Reports/types/QualityGateResult.cs
          - pwsh/Catzc.Base.Reports/types/TestRunResult.cs
          - ADR-AUTO-DEFAULT-ONERESOLUTIONORDER
      - cell: pwsh/Catzc.Base.Slides/tests/types
        by:
          - pwsh/Catzc.Base.Slides/tests/types/SlidesConfig.Tests.ps1
          - pwsh/Catzc.Base.Slides/tests/types/SlidesKit.Tests.ps1
          - ADR-AUTO-DEFAULT-ONERESOLUTIONORDER
      - cell: pwsh/Catzc.Base.Timeouts/.
        by: [pwsh/Catzc.Base.Timeouts/Get-TestTimeLimits.ps1, pwsh/Catzc.Base.Timeouts/Watch-Blocking.ps1, ADR-AUTO-FAILFAST-BOUNDEVERYWAIT]
      - cell: pwsh/Catzc.Base.Timeouts/tests/types
        by:
          - pwsh/Catzc.Base.Timeouts/tests/types/TimeoutsConfig.Tests.ps1
          - ADR-AUTO-DEFAULT-ONERESOLUTIONORDER
          - ADR-AUTO-FAILFAST-BOUNDEVERYWAIT
      - cell: pwsh/Catzc.Base.Timeouts/types
        by:
          - pwsh/Catzc.Base.Timeouts/types/BashSafeguard.cs
          - pwsh/Catzc.Base.Timeouts/types/TimeoutExemptionsConfig.cs
          - pwsh/Catzc.Base.Timeouts/types/TimeoutsConfig.cs
          - ADR-AUTO-DEFAULT-ONERESOLUTIONORDER
          - ADR-AUTO-FAILFAST-BOUNDEVERYWAIT
      - cell: pwsh/Catzc.Base.TypesSystem/.
        by: [pwsh/Catzc.Base.TypesSystem/Build-AgentHook.ps1, ADR-AUTO-FAILFAST-BOUNDEVERYWAIT]
      - cell: pwsh/Catzc.Base.Variants/private
        by: [pwsh/Catzc.Base.Variants/private/Get-Variant.ps1, ADR-AUTO-DEFAULT-ONERESOLUTIONORDER]
      - cell: pwsh/Catzc.Base.Variants/tests
        by: [pwsh/Catzc.Base.Variants/tests/Get-Track.Tests.ps1, ADR-AUTO-DEFAULT-ONERESOLUTIONORDER]
      - cell: pwsh/Catzc.Base.Variants/tests/types
        by: [pwsh/Catzc.Base.Variants/tests/types/VariantsConfig.Tests.ps1, ADR-AUTO-DEFAULT-ONERESOLUTIONORDER]
      - cell: pwsh/Catzc.Base.Variants/types
        by: [pwsh/Catzc.Base.Variants/types/VariantsConfig.cs, ADR-AUTO-DEFAULT-ONERESOLUTIONORDER]
      - cell: pwsh/Catzc.Base.VSCode/types
        by: [pwsh/Catzc.Base.VSCode/types/VscodeOwnExtension.cs, ADR-AUTO-DEFAULT-ONERESOLUTIONORDER]
      - cell: pwsh/Catzc.Internal.Assets/.
        by: [pwsh/.internal/assets/Enter-CatzcBurst.ps1, pwsh/.internal/assets/Invoke-CatzcCommand.ps1, ADR-AUTO-FAILFAST-BOUNDEVERYWAIT]
      - cell: pwsh/Catzc.Internal.Tests/.
        by:
          - pwsh/.internal/tests/Enter-CatzcBurst.Tests.ps1
          - pwsh/.internal/tests/Invoke-CatzcCommand.Tests.ps1
          - pwsh/.internal/tests/Wait-CatzcRunLock.Tests.ps1
          - ADR-AUTO-FAILFAST-BOUNDEVERYWAIT
      - cell: pwsh/Catzc.Tooling.Claude/tests/types
        by: [pwsh/Catzc.Tooling.Claude/tests/types/ClaudeWorkerConfig.Tests.ps1, ADR-AUTO-DEFAULT-ONERESOLUTIONORDER]
      - cell: pwsh/Catzc.Tooling.Inspiration/.
        by: [pwsh/Catzc.Tooling.Inspiration/Get-Inspiration.ps1, ADR-AUTO-DEFAULT-ONERESOLUTIONORDER]
      - cell: pwsh/Catzc.Tooling.Inspiration/configs
        by: [pwsh/Catzc.Tooling.Inspiration/configs/inspiration.yml, ADR-AUTO-DEFAULT-ONERESOLUTIONORDER]
      - cell: pwsh/Catzc.Tooling.Inspiration/tests/types
        by: [pwsh/Catzc.Tooling.Inspiration/tests/types/InspirationConfig.Tests.ps1, ADR-AUTO-DEFAULT-ONERESOLUTIONORDER]
      - cell: pwsh/Catzc.Tooling.Inspiration/types
        by: [pwsh/Catzc.Tooling.Inspiration/types/InspirationConfig.cs, ADR-AUTO-DEFAULT-ONERESOLUTIONORDER]
      - cell: pwsh/Catzc.Tooling.Listen/.
        by: [pwsh/Catzc.Tooling.Listen/Wait-DocChange.ps1, pwsh/Catzc.Tooling.Listen/Wait-DocNote.ps1, ADR-AUTO-FAILFAST-BOUNDEVERYWAIT]
      - cell: pwsh/Catzc.Tooling.Listen/tests
        by:
          - pwsh/Catzc.Tooling.Listen/tests/Wait-DocChange.Tests.ps1
          - pwsh/Catzc.Tooling.Listen/tests/Wait-DocNote.Tests.ps1
          - ADR-AUTO-FAILFAST-BOUNDEVERYWAIT
      - cell: pwsh/Catzc.Tooling.Listen/tests/types
        by: [pwsh/Catzc.Tooling.Listen/tests/types/ListenConfig.Tests.ps1, ADR-AUTO-DEFAULT-ONERESOLUTIONORDER]
    module-neighbourhood:
      - cell: subject/.claude
        by:
          - .claude/CLAUDE.md
          - .claude/hooks/Assert-BashTimeout/Program.cs
          - .claude/skills/catzc-module/SKILL.md
          - ADR-AUTO-DEFAULT-ONERESOLUTIONORDER
          - ADR-AUTO-FAILFAST-BOUNDEVERYWAIT
      - cell: subject/Catzc.Azure
        by: [pwsh/Catzc.Azure/types/AzureConfig.cs, ADR-AUTO-DEFAULT-ONERESOLUTIONORDER]
      - cell: subject/Catzc.Azure.Cli
        by: [pwsh/Catzc.Azure.Cli/Assert-AzCliSubscriptionAccessible.ps1, ADR-AUTO-FAILFAST-BOUNDEVERYWAIT]
      - cell: subject/Catzc.Base.CodeMeta
        by: [pwsh/Catzc.Base.CodeMeta/tests/types/CommentPagesConfig.Tests.ps1, ADR-AUTO-DEFAULT-ONERESOLUTIONORDER]
      - cell: subject/Catzc.Base.Config
        by:
          - pwsh/Catzc.Base.Config/configs/glossary.yml
          - pwsh/Catzc.Base.Config/tests/Get-Config.Tests.ps1
          - pwsh/Catzc.Base.Config/types/ConfigDefaultDifference.cs
          - ADR-AUTO-DEFAULT-ONERESOLUTIONORDER
      - cell: subject/Catzc.Base.Contracts
        by:
          - pwsh/Catzc.Base.Contracts/configs/contracts.yml
          - pwsh/Catzc.Base.Contracts/tests/Get-Contract.Tests.ps1
          - pwsh/Catzc.Base.Contracts/tests/types/AccostedConfig.Tests.ps1
          - pwsh/Catzc.Base.Contracts/tests/types/ContractCommand.Tests.ps1
          - pwsh/Catzc.Base.Contracts/tests/types/ContractsConfig.Tests.ps1
          - pwsh/Catzc.Base.Contracts/types/ContractCommand.cs
          - pwsh/Catzc.Base.Contracts/types/ContractParameter.cs
          - pwsh/Catzc.Base.Contracts/types/ContractsConfig.cs
          - ADR-AUTO-DEFAULT-ONERESOLUTIONORDER
      - cell: subject/Catzc.Base.Docs
        by:
          - pwsh/Catzc.Base.Docs/Test-Glossary.ps1
          - pwsh/Catzc.Base.Docs/configs/agents.yml
          - pwsh/Catzc.Base.Docs/configs/capabilities.yml
          - pwsh/Catzc.Base.Docs/tests/Test-Glossary.Tests.ps1
          - pwsh/Catzc.Base.Docs/tests/types/LearningsConfig.Tests.ps1
          - ADR-AUTO-DEFAULT-ONERESOLUTIONORDER
          - ADR-AUTO-FAILFAST-BOUNDEVERYWAIT
      - cell: subject/Catzc.Base.Drs
        by:
          - pwsh/Catzc.Base.Drs/configs/drs-checks.yml
          - pwsh/Catzc.Base.Drs/configs/drs.yml
          - pwsh/Catzc.Base.Drs/private/Import-DrsCitationMapFile.ps1
          - pwsh/Catzc.Base.Drs/tests/types/DrsChecksConfig.Tests.ps1
          - pwsh/Catzc.Base.Drs/types/DrsChecksConfig.cs
          - pwsh/Catzc.Base.Drs/types/DrsConfig.cs
          - ADR-AUTO-DEFAULT-ONERESOLUTIONORDER
          - ADR-AUTO-FAILFAST-BOUNDEVERYWAIT
      - cell: subject/Catzc.Base.Engines
        by: [pwsh/Catzc.Base.Engines/types/ExecutionEngine.cs, ADR-AUTO-FAILFAST-BOUNDEVERYWAIT]
      - cell: subject/Catzc.Base.Flow
        by: [pwsh/Catzc.Base.Flow/tests/types/RungsConfig.Tests.ps1, ADR-AUTO-DEFAULT-ONERESOLUTIONORDER]
      - cell: subject/Catzc.Base.Folders
        by:
          - pwsh/Catzc.Base.Folders/tests/Get-ChildPath.Tests.ps1
          - pwsh/Catzc.Base.Folders/tests/types/FolderWalkConfig.Tests.ps1
          - pwsh/Catzc.Base.Folders/tests/types/FolderWalker.Tests.ps1
          - ADR-AUTO-DEFAULT-ONERESOLUTIONORDER
      - cell: subject/Catzc.Base.Git
        by: [pwsh/Catzc.Base.Git/Import-RepositoryWithHistory.ps1, ADR-AUTO-DEFAULT-ONERESOLUTIONORDER]
      - cell: subject/Catzc.Base.Globs
        by: [pwsh/Catzc.Base.Globs/Test-GlobSetAffected.ps1, ADR-AUTO-FAILFAST-BOUNDEVERYWAIT]
      - cell: subject/Catzc.Base.Languages
        by:
          - pwsh/Catzc.Base.Languages/configs/file-carriers.yml
          - pwsh/Catzc.Base.Languages/configs/go.yml
          - pwsh/Catzc.Base.Languages/configs/languages.yml
          - pwsh/Catzc.Base.Languages/configs/python.yml
          - pwsh/Catzc.Base.Languages/tests/Get-EngineContract.Tests.ps1
          - pwsh/Catzc.Base.Languages/tests/types/FileCarriersConfig.Tests.ps1
          - pwsh/Catzc.Base.Languages/tests/types/LanguagesConfig.Tests.ps1
          - pwsh/Catzc.Base.Languages/types/FileCarrier.cs
          - pwsh/Catzc.Base.Languages/types/FileCarriersConfig.cs
          - pwsh/Catzc.Base.Languages/types/GoConfig.cs
          - pwsh/Catzc.Base.Languages/types/LanguagesConfig.cs
          - pwsh/Catzc.Base.Languages/types/LayoutRow.cs
          - ADR-AUTO-DEFAULT-ONERESOLUTIONORDER
          - ADR-AUTO-FAILFAST-BOUNDEVERYWAIT
      - cell: subject/Catzc.Base.Maps
        by:
          - pwsh/Catzc.Base.Maps/configs/maps.yml
          - pwsh/Catzc.Base.Maps/tests/types/MapsConfig.Tests.ps1
          - pwsh/Catzc.Base.Maps/types/MapsConfig.cs
          - pwsh/Catzc.Base.Maps/types/MapsHighlight.cs
          - pwsh/Catzc.Base.Maps/types/MapsLabels.cs
          - pwsh/Catzc.Base.Maps/types/MapsLimits.cs
          - pwsh/Catzc.Base.Maps/types/MapsPalette.cs
          - ADR-AUTO-DEFAULT-ONERESOLUTIONORDER
      - cell: subject/Catzc.Base.ModuleSystem
        by:
          - pwsh/Catzc.Base.ModuleSystem/tests/Resolve-ImportMix.Tests.ps1
          - pwsh/Catzc.Base.ModuleSystem/tests/Set-ImportMix.Tests.ps1
          - pwsh/Catzc.Base.ModuleSystem/tests/types/ImportMix.Tests.ps1
          - pwsh/Catzc.Base.ModuleSystem/tests/types/ImporterConfig.Tests.ps1
          - ADR-AUTO-DEFAULT-ONERESOLUTIONORDER
      - cell: subject/Catzc.Base.QualityGates
        by:
          - pwsh/Catzc.Base.QualityGates/Test-ShippedConfigs.ps1
          - pwsh/Catzc.Base.QualityGates/configs/analyzer-drs-map.yml
          - pwsh/Catzc.Base.QualityGates/configs/comments.yml
          - pwsh/Catzc.Base.QualityGates/configs/file-meta.yml
          - pwsh/Catzc.Base.QualityGates/configs/links.yml
          - pwsh/Catzc.Base.QualityGates/configs/parameter-consistency.yml
          - pwsh/Catzc.Base.QualityGates/configs/source-conventions.yml
          - pwsh/Catzc.Base.QualityGates/configs/test-policy.yml
          - pwsh/Catzc.Base.QualityGates/private/Get-LinkLineLimit.ps1
          - pwsh/Catzc.Base.QualityGates/private/Test-TestRunOverBudget.ps1
          - pwsh/Catzc.Base.QualityGates/private/Write-TestAutomationVerdict.ps1
          - pwsh/Catzc.Base.QualityGates/tests/Get-DrsCodesFileMetaFact.Tests.ps1
          - pwsh/Catzc.Base.QualityGates/tests/Test-ShippedConfigs.Tests.ps1
          - pwsh/Catzc.Base.QualityGates/tests/types/CommentsConfig.Tests.ps1
          - pwsh/Catzc.Base.QualityGates/tests/types/EngineSetCheck.Tests.ps1
          - pwsh/Catzc.Base.QualityGates/tests/types/FileHeadPolicy.Tests.ps1
          - pwsh/Catzc.Base.QualityGates/tests/types/FileMetaConfig.Tests.ps1
          - pwsh/Catzc.Base.QualityGates/tests/types/LinksConfig.Tests.ps1
          - pwsh/Catzc.Base.QualityGates/tests/types/PlansConfig.Tests.ps1
          - pwsh/Catzc.Base.QualityGates/tests/types/SourceCheck.Tests.ps1
          - pwsh/Catzc.Base.QualityGates/tests/types/SourceConventionsConfig.Tests.ps1
          - pwsh/Catzc.Base.QualityGates/types/CommentsConfig.cs
          - pwsh/Catzc.Base.QualityGates/types/EngineSetCheck.cs
          - pwsh/Catzc.Base.QualityGates/types/FileMetaKind.cs
          - pwsh/Catzc.Base.QualityGates/types/GeneratedWriter.cs
          - pwsh/Catzc.Base.QualityGates/types/LinksConfig.cs
          - pwsh/Catzc.Base.QualityGates/types/ParameterConsistencyConfig.cs
          - pwsh/Catzc.Base.QualityGates/types/PlansConfig.cs
          - pwsh/Catzc.Base.QualityGates/types/SourceCheck.cs
          - pwsh/Catzc.Base.QualityGates/types/SourceConventionsConfig.cs
          - pwsh/Catzc.Base.QualityGates/types/TestPolicyConfig.cs
          - ADR-AUTO-DEFAULT-ONERESOLUTIONORDER
          - ADR-AUTO-FAILFAST-BOUNDEVERYWAIT
      - cell: subject/Catzc.Base.Reports
        by:
          - pwsh/Catzc.Base.Reports/tests/types/CheckModes.Tests.ps1
          - pwsh/Catzc.Base.Reports/tests/types/IsolationRunResult.Tests.ps1
          - pwsh/Catzc.Base.Reports/tests/types/OutputFormatsConfig.Tests.ps1
          - pwsh/Catzc.Base.Reports/tests/types/QualityGateResult.Tests.ps1
          - pwsh/Catzc.Base.Reports/tests/types/TestRunResult.Tests.ps1
          - pwsh/Catzc.Base.Reports/types/CheckMode.cs
          - pwsh/Catzc.Base.Reports/types/CheckModes.cs
          - pwsh/Catzc.Base.Reports/types/IsolationRunResult.cs
          - pwsh/Catzc.Base.Reports/types/QualityGateResult.cs
          - pwsh/Catzc.Base.Reports/types/TestRunResult.cs
          - ADR-AUTO-DEFAULT-ONERESOLUTIONORDER
      - cell: subject/Catzc.Base.Slides
        by:
          - pwsh/Catzc.Base.Slides/tests/types/SlidesConfig.Tests.ps1
          - pwsh/Catzc.Base.Slides/tests/types/SlidesKit.Tests.ps1
          - ADR-AUTO-DEFAULT-ONERESOLUTIONORDER
      - cell: subject/Catzc.Base.Timeouts
        by:
          - pwsh/Catzc.Base.Timeouts/Get-TestTimeLimits.ps1
          - pwsh/Catzc.Base.Timeouts/Watch-Blocking.ps1
          - pwsh/Catzc.Base.Timeouts/tests/types/TimeoutsConfig.Tests.ps1
          - pwsh/Catzc.Base.Timeouts/types/BashSafeguard.cs
          - pwsh/Catzc.Base.Timeouts/types/TimeoutExemptionsConfig.cs
          - pwsh/Catzc.Base.Timeouts/types/TimeoutsConfig.cs
          - ADR-AUTO-DEFAULT-ONERESOLUTIONORDER
          - ADR-AUTO-FAILFAST-BOUNDEVERYWAIT
      - cell: subject/Catzc.Base.TypesSystem
        by: [pwsh/Catzc.Base.TypesSystem/Build-AgentHook.ps1, ADR-AUTO-FAILFAST-BOUNDEVERYWAIT]
      - cell: subject/Catzc.Base.VSCode
        by: [pwsh/Catzc.Base.VSCode/types/VscodeOwnExtension.cs, ADR-AUTO-DEFAULT-ONERESOLUTIONORDER]
      - cell: subject/Catzc.Base.Variants
        by:
          - pwsh/Catzc.Base.Variants/private/Get-Variant.ps1
          - pwsh/Catzc.Base.Variants/tests/Get-Track.Tests.ps1
          - pwsh/Catzc.Base.Variants/tests/types/VariantsConfig.Tests.ps1
          - pwsh/Catzc.Base.Variants/types/VariantsConfig.cs
          - ADR-AUTO-DEFAULT-ONERESOLUTIONORDER
      - cell: subject/Catzc.Internal.Assets
        by: [pwsh/.internal/assets/Enter-CatzcBurst.ps1, pwsh/.internal/assets/Invoke-CatzcCommand.ps1, ADR-AUTO-FAILFAST-BOUNDEVERYWAIT]
      - cell: subject/Catzc.Internal.Tests
        by:
          - pwsh/.internal/tests/Enter-CatzcBurst.Tests.ps1
          - pwsh/.internal/tests/Invoke-CatzcCommand.Tests.ps1
          - pwsh/.internal/tests/Wait-CatzcRunLock.Tests.ps1
          - ADR-AUTO-FAILFAST-BOUNDEVERYWAIT
      - cell: subject/Catzc.Tooling.Claude
        by: [pwsh/Catzc.Tooling.Claude/tests/types/ClaudeWorkerConfig.Tests.ps1, ADR-AUTO-DEFAULT-ONERESOLUTIONORDER]
      - cell: subject/Catzc.Tooling.Inspiration
        by:
          - pwsh/Catzc.Tooling.Inspiration/Get-Inspiration.ps1
          - pwsh/Catzc.Tooling.Inspiration/configs/inspiration.yml
          - pwsh/Catzc.Tooling.Inspiration/tests/types/InspirationConfig.Tests.ps1
          - pwsh/Catzc.Tooling.Inspiration/types/InspirationConfig.cs
          - ADR-AUTO-DEFAULT-ONERESOLUTIONORDER
      - cell: subject/Catzc.Tooling.Listen
        by:
          - pwsh/Catzc.Tooling.Listen/Wait-DocChange.ps1
          - pwsh/Catzc.Tooling.Listen/Wait-DocNote.ps1
          - pwsh/Catzc.Tooling.Listen/tests/Wait-DocChange.Tests.ps1
          - pwsh/Catzc.Tooling.Listen/tests/Wait-DocNote.Tests.ps1
          - pwsh/Catzc.Tooling.Listen/tests/types/ListenConfig.Tests.ps1
          - ADR-AUTO-DEFAULT-ONERESOLUTIONORDER
          - ADR-AUTO-FAILFAST-BOUNDEVERYWAIT
    axis:
      - cell: AUTO/*
        by: [ADR-AUTO-DEFAULT-ONERESOLUTIONORDER, ADR-AUTO-FAILFAST-BOUNDEVERYWAIT]
layout:
  band-caller: { x: 20, y: 84, w: 240, h: 320 }
  band-call: { x: 280, y: 84, w: 480, h: 320 }
  band-stop: { x: 780, y: 84, w: 500, h: 320 }
  g-agent: { x: 80, y: 124, w: 100, h: 64 }
  g-developer: { x: 80, y: 262, w: 100, h: 64 }
  g-hook: { x: 560, y: 120, w: 180, h: 72 }
  grp-runners: { x: 320, y: 214, w: 210, h: 170 }
  g-executable: { x: 340, y: 254, w: 170, h: 44 }
  g-with-timeout: { x: 340, y: 322, w: 170, h: 44 }
  f-denied: { x: 950, y: 134, w: 180, h: 44 }
  f-timeout: { x: 950, y: 276, w: 180, h: 44 }
```

![A run past its limit stops with a message that names the limit](.assets/a-stopped-run-names-its-limit.drawio.png)

## Walkthrough

1. **Agent.** Every Bash call a coding agent makes is judged by the hook before it runs. A foreground call passes a `timeout` of at most the
   foreground limit, 3000 milliseconds on a devbox. A background call, whose `timeout` the Bash tool ignores, starts with a GNU
   `timeout <duration>` of at most the background limit, 360 seconds on a devbox, around one command; exit 124 means the safeguard stopped
   it.
2. **Developer.** A person on a devbox, or a pipeline with nobody watching, runs the pwsh wrappers. A pipeline gets looser limits, 600
   seconds for pwsh work and for a foreground bash call and 3600 for a background one, but never none.
3. **Assert-BashTimeout.** The hook denies and never rewrites a call, because an approval would skip the permission prompt and a wrapped
   command no longer matches the deny rules written for it. Denial leaves every other safeguard in place.
4. **Invoke-Executable.** The default mode runs the tool under its executable's entry in `timeouts.yml`, or the environment's pwsh limit
   when it has none, and kills the whole process tree past it.
5. **Invoke-WithTimeout.** A script block runs under the environment's pwsh limit, or the exemption ceiling while its budget is exempt, and
   is stopped past it. `Assert-CompletesWithin` and `Test-CompletesWithin` are its assertion and boolean forms.
6. **Bash call denied.** The reason names the environment, foreground or background, what the call carried and the limit, then the fix:
   `Re-issue it with timeout: <ms>`, or run longer work in the background behind `timeout <s> <one command>`. Who asked changes only the
   last line: the main session raises the blocker with the user, a subagent reports it to its coordinator, and a pipeline fixes the call or
   its limit. Each denial is appended to `out/time-safeguard.log`, the list of blockers to tune.
7. **TimeoutException.** A killed tool reports `Killed '<command>' after <n>s: it did not finish within its time limit`, then says to make
   it faster or pass `-TimeoutSeconds` or tune the executable's entry in `timeouts.yml`. A stopped script block reports
   `Stopped after <n>s: '<activity>' did not finish within its <n>-second limit`, then names `-Seconds`, the environment's pwsh limit in
   `timeouts.yml`, and a `-Budget` to exempt in `timeout-exemptions.yml` while the work is tuned.

## Why it holds

- A hang fails fast with a message naming the limit instead of waiting forever; the bash limits bound every shell call an agent makes,
  foreground and background, and a hook denies a call outside them; work that legitimately runs longer while it is tuned carries a budget
  GUID and is exempted, which raises its limit to a ceiling but never lifts it (ADR-AUTO-FAILFAST-BOUNDEVERYWAIT).
- The limit a wrapper applies is the caller's explicit value, else the config, else the declared default, so a person tunes one entry in one
  file and never a number in code (ADR-AUTO-DEFAULT-ONERESOLUTIONORDER).

## See also

- [Fail fast with inline assertions](../../drs/automation/fail-fast-with-asserts.md) and
  [Sensible defaults for all parameters](../../drs/automation/sensible-defaults.md) — the decisions this article explains.
- The other lenses on the same resolution: [meta](callers-value-else-config-else-default.md),
  [architecture](one-resolver-every-consumer-but-the-hook.md), [implementation](resolve-one-limit-in-code-order.md) and
  [governance](one-rule-per-stage-and-two-gaps.md).
- [The automation explanations](index.md) · [How to read the diagrams](../index.md#how-to-read-the-diagrams)
