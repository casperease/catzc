# The analyzer checks rule 1, a test checks rule 4, and rules 2, 3 and 5 have no gate

```text
The analyzer checks rule 1, a test checks rule 4, and rules 2, 3 and 5 have no gate.

1  Test-IsRunningInPipeline            the detector: rule 4 tested (D4), rule 5 unchecked (D5)
2  Assert-BashTimeout                  the C# hook: rule 1 unchecked there (dashed D1)
3  consumers                           24 call sites: rule 1 checked (D1); rules 2, 3 and P3 unchecked
4  Test-IsRunningInPipeline.Tests.ps1  the L0 test that proves the boolean's three cases
5  Measure-NoRawPipelineDetection      the analyzer rule, mapped to rule 1 in analyzer-drs-map.yml

Supports FDR-CD-DETECT-NODIRECTVARIABLECHECK, FDR-CD-DETECT-VISIBLECONTEXTBEHAVIOUR, FDR-CD-DETECT-PARAMETERSOVERDETECTION, FDR-CD-DETECT-BOOLEANNOTMODAL, FDR-CD-DETECT-FASTDETECTION and ADR-AUTO-PARITY-ONESEAM (governance lens).
```

Five rules govern pipeline detection in cats, and one gate carries most of the weight. The analyzer rule enforces the first, never read the
variables directly, on every PowerShell file; an L0 test pins the fourth, that the answer is a plain boolean. The other three rules, and the
one reader outside PowerShell, rest on the FDR alone.

```yml drawio
description:
  "Five rules govern pipeline detection: the analyzer rule checks the raw-read rule over every PowerShell file, a test pins that the answer
  is a plain boolean, and the other rules, and the one reader outside PowerShell, rest on the ADR alone, drawn dashed."
about:
  adrs:
    - FDR-CD-DETECT-NODIRECTVARIABLECHECK
    - FDR-CD-DETECT-VISIBLECONTEXTBEHAVIOUR
    - FDR-CD-DETECT-PARAMETERSOVERDETECTION
    - FDR-CD-DETECT-BOOLEANNOTMODAL
    - FDR-CD-DETECT-FASTDETECTION
    - ADR-AUTO-PARITY-ONESEAM
  lens: governance
content:
  title: The analyzer checks rule 1, a test checks rule 4, and rules 2, 3 and 5 have no gate
  kind: explanation
  flow: top-to-bottom
  relation: feeds the next step
  theme: dark
  bands:
    - { id: band-detection, label: DETECTION }
    - { id: band-consumers, label: CONSUMERS }
    - { id: band-enforcement, label: ENFORCEMENT }
  glyphs:
    - { id: g-detector, kind: code, label: Test-IsRunningInPipeline, in: band-detection }
    - { id: g-hook, kind: code, label: Assert-BashTimeout, in: band-detection }
    - { id: s-consumers, kind: set, label: consumers, in: band-consumers }
    - { id: g-test, kind: gate, label: Test-IsRunningInPipeline.Tests.ps1, in: band-enforcement }
    - { id: g-analyzer, kind: gate, label: Measure-NoRawPipelineDetection, in: band-enforcement }
  edges:
    - { from: g-detector, to: s-consumers, kind: thick, label: "" }
    - { from: g-detector, to: g-test, kind: flow, label: "" }
    - { from: s-consumers, to: g-analyzer, kind: flow, label: "" }
  markers:
    - { at: g-detector, number: 1 }
    - { at: g-hook, number: 2 }
    - { at: s-consumers, number: 3 }
    - { at: g-test, number: 4 }
    - { at: g-analyzer, number: 5 }
  chips:
    - { at: g-detector, kind: rule, rule: FDR-CD-DETECT-BOOLEANNOTMODAL }
    - { at: g-detector, kind: rule, rule: FDR-CD-DETECT-FASTDETECTION, gated: false }
    - { at: g-hook, kind: rule, rule: FDR-CD-DETECT-NODIRECTVARIABLECHECK, gated: false }
    - { at: s-consumers, kind: rule, rule: FDR-CD-DETECT-NODIRECTVARIABLECHECK }
    - { at: s-consumers, kind: rule, rule: FDR-CD-DETECT-VISIBLECONTEXTBEHAVIOUR, gated: false }
    - { at: s-consumers, kind: rule, rule: FDR-CD-DETECT-PARAMETERSOVERDETECTION, gated: false }
    - { at: s-consumers, kind: rule, rule: ADR-AUTO-PARITY-ONESEAM, gated: false }
  legend: auto
  minimaps:
    code-locations:
      - cell: .claude/.claude/.
        by:
          - .claude/CLAUDE.md
          - FDR-CD-DETECT-BOOLEANNOTMODAL
          - FDR-CD-DETECT-FASTDETECTION
          - FDR-CD-DETECT-NODIRECTVARIABLECHECK
          - FDR-CD-DETECT-PARAMETERSOVERDETECTION
          - FDR-CD-DETECT-VISIBLECONTEXTBEHAVIOUR
      - cell: docs/-/.
        by:
          - docs/drs/automation/devbox-pipeline-parity.md
          - docs/drs/automation/dora-explains.md
          - docs/drs/flow/dora-explains.md
          - docs/drs/flow/pipeline-detection.md
          - docs/drs/index.md
          - docs/how-to/automation/apply-environment-approvals.md
          - docs/references/pwsh/catzc-azure-dev-ops/Sync-AdoEnvironmentApprovals.ps1.md
          - docs/references/pwsh/catzc-azure-templates/Get-BicepDeploymentName.ps1.md
          - docs/references/pwsh/catzc-base-drs/types/DrsConfig.cs.md
          - docs/references/pwsh/catzc-base-globs/Get-GlobSetChangeRange.ps1.md
          - docs/references/pwsh/catzc-base-globs/tests/Get-GlobSetChangeRange.Tests.ps1.md
          - docs/references/pwsh/catzc-base-maps/Get-LifecyclePositionMinimapData.ps1.md
          - docs/references/pwsh/catzc-base-maps/Get-ValueChainHighlight.ps1.md
          - docs/references/pwsh/catzc-base-maps/Get-WorldMapHighlight.ps1.md
          - docs/references/pwsh/catzc-base-repository/Get-RunEnvironment.ps1.md
          - ADR-AUTO-PARITY-ONESEAM
          - FDR-CD-DETECT-BOOLEANNOTMODAL
          - FDR-CD-DETECT-FASTDETECTION
          - FDR-CD-DETECT-NODIRECTVARIABLECHECK
          - FDR-CD-DETECT-PARAMETERSOVERDETECTION
          - FDR-CD-DETECT-VISIBLECONTEXTBEHAVIOUR
      - cell: pwsh/Catzc.Azure.DevOps/.
        by:
          - pwsh/Catzc.Azure.DevOps/Sync-AdoEnvironmentApprovals.ps1
          - FDR-CD-DETECT-BOOLEANNOTMODAL
          - FDR-CD-DETECT-FASTDETECTION
          - FDR-CD-DETECT-NODIRECTVARIABLECHECK
          - FDR-CD-DETECT-PARAMETERSOVERDETECTION
          - FDR-CD-DETECT-VISIBLECONTEXTBEHAVIOUR
      - cell: pwsh/Catzc.Azure.Templates/.
        by: [pwsh/Catzc.Azure.Templates/Get-BicepDeploymentName.ps1, FDR-CD-DETECT-NODIRECTVARIABLECHECK]
      - cell: pwsh/Catzc.Base.Drs/configs
        by:
          - pwsh/Catzc.Base.Drs/configs/drs.yml
          - ADR-AUTO-PARITY-ONESEAM
          - FDR-CD-DETECT-BOOLEANNOTMODAL
          - FDR-CD-DETECT-FASTDETECTION
          - FDR-CD-DETECT-NODIRECTVARIABLECHECK
          - FDR-CD-DETECT-PARAMETERSOVERDETECTION
          - FDR-CD-DETECT-VISIBLECONTEXTBEHAVIOUR
      - cell: pwsh/Catzc.Base.Drs/types
        by:
          - pwsh/Catzc.Base.Drs/types/DrsConfig.cs
          - FDR-CD-DETECT-BOOLEANNOTMODAL
          - FDR-CD-DETECT-FASTDETECTION
          - FDR-CD-DETECT-NODIRECTVARIABLECHECK
          - FDR-CD-DETECT-PARAMETERSOVERDETECTION
          - FDR-CD-DETECT-VISIBLECONTEXTBEHAVIOUR
      - cell: pwsh/Catzc.Base.Globs/.
        by:
          - pwsh/Catzc.Base.Globs/Get-GlobSetChangeRange.ps1
          - FDR-CD-DETECT-BOOLEANNOTMODAL
          - FDR-CD-DETECT-FASTDETECTION
          - FDR-CD-DETECT-NODIRECTVARIABLECHECK
          - FDR-CD-DETECT-PARAMETERSOVERDETECTION
          - FDR-CD-DETECT-VISIBLECONTEXTBEHAVIOUR
      - cell: pwsh/Catzc.Base.Globs/tests
        by:
          - pwsh/Catzc.Base.Globs/tests/Get-GlobSetChangeRange.Tests.ps1
          - FDR-CD-DETECT-BOOLEANNOTMODAL
          - FDR-CD-DETECT-FASTDETECTION
          - FDR-CD-DETECT-NODIRECTVARIABLECHECK
          - FDR-CD-DETECT-PARAMETERSOVERDETECTION
          - FDR-CD-DETECT-VISIBLECONTEXTBEHAVIOUR
      - cell: pwsh/Catzc.Base.Maps/.
        by:
          - pwsh/Catzc.Base.Maps/Get-LifecyclePositionMinimapData.ps1
          - pwsh/Catzc.Base.Maps/Get-ValueChainHighlight.ps1
          - pwsh/Catzc.Base.Maps/Get-WorldMapHighlight.ps1
          - FDR-CD-DETECT-BOOLEANNOTMODAL
          - FDR-CD-DETECT-FASTDETECTION
          - FDR-CD-DETECT-NODIRECTVARIABLECHECK
          - FDR-CD-DETECT-PARAMETERSOVERDETECTION
          - FDR-CD-DETECT-VISIBLECONTEXTBEHAVIOUR
      - cell: pwsh/Catzc.Base.Maps/tests
        by:
          - pwsh/Catzc.Base.Maps/tests/Get-WorldMapHighlight.Tests.ps1
          - FDR-CD-DETECT-BOOLEANNOTMODAL
          - FDR-CD-DETECT-FASTDETECTION
          - FDR-CD-DETECT-NODIRECTVARIABLECHECK
          - FDR-CD-DETECT-PARAMETERSOVERDETECTION
          - FDR-CD-DETECT-VISIBLECONTEXTBEHAVIOUR
      - cell: pwsh/Catzc.Base.QualityGates/configs
        by: [pwsh/Catzc.Base.QualityGates/configs/analyzer-drs-map.yml, FDR-CD-DETECT-NODIRECTVARIABLECHECK]
      - cell: pwsh/Catzc.Base.Repository/.
        by: [pwsh/Catzc.Base.Repository/Get-RunEnvironment.ps1, ADR-AUTO-PARITY-ONESEAM]
    grid:
      - cell: .claude/markdown
        by:
          - .claude/CLAUDE.md
          - FDR-CD-DETECT-BOOLEANNOTMODAL
          - FDR-CD-DETECT-FASTDETECTION
          - FDR-CD-DETECT-NODIRECTVARIABLECHECK
          - FDR-CD-DETECT-PARAMETERSOVERDETECTION
          - FDR-CD-DETECT-VISIBLECONTEXTBEHAVIOUR
      - cell: docs/markdown
        by:
          - docs/drs/automation/devbox-pipeline-parity.md
          - docs/drs/automation/dora-explains.md
          - docs/drs/flow/dora-explains.md
          - docs/drs/flow/pipeline-detection.md
          - docs/drs/index.md
          - docs/how-to/automation/apply-environment-approvals.md
          - docs/references/pwsh/catzc-azure-dev-ops/Sync-AdoEnvironmentApprovals.ps1.md
          - docs/references/pwsh/catzc-azure-templates/Get-BicepDeploymentName.ps1.md
          - docs/references/pwsh/catzc-base-drs/types/DrsConfig.cs.md
          - docs/references/pwsh/catzc-base-globs/Get-GlobSetChangeRange.ps1.md
          - docs/references/pwsh/catzc-base-globs/tests/Get-GlobSetChangeRange.Tests.ps1.md
          - docs/references/pwsh/catzc-base-maps/Get-LifecyclePositionMinimapData.ps1.md
          - docs/references/pwsh/catzc-base-maps/Get-ValueChainHighlight.ps1.md
          - docs/references/pwsh/catzc-base-maps/Get-WorldMapHighlight.ps1.md
          - docs/references/pwsh/catzc-base-repository/Get-RunEnvironment.ps1.md
          - ADR-AUTO-PARITY-ONESEAM
          - FDR-CD-DETECT-BOOLEANNOTMODAL
          - FDR-CD-DETECT-FASTDETECTION
          - FDR-CD-DETECT-NODIRECTVARIABLECHECK
          - FDR-CD-DETECT-PARAMETERSOVERDETECTION
          - FDR-CD-DETECT-VISIBLECONTEXTBEHAVIOUR
      - cell: pwsh/bcl
        by:
          - pwsh/Catzc.Base.Drs/types/DrsConfig.cs
          - FDR-CD-DETECT-BOOLEANNOTMODAL
          - FDR-CD-DETECT-FASTDETECTION
          - FDR-CD-DETECT-NODIRECTVARIABLECHECK
          - FDR-CD-DETECT-PARAMETERSOVERDETECTION
          - FDR-CD-DETECT-VISIBLECONTEXTBEHAVIOUR
      - cell: pwsh/powershell
        by:
          - pwsh/Catzc.Azure.DevOps/Sync-AdoEnvironmentApprovals.ps1
          - pwsh/Catzc.Azure.Templates/Get-BicepDeploymentName.ps1
          - pwsh/Catzc.Base.Globs/Get-GlobSetChangeRange.ps1
          - pwsh/Catzc.Base.Globs/tests/Get-GlobSetChangeRange.Tests.ps1
          - pwsh/Catzc.Base.Maps/Get-LifecyclePositionMinimapData.ps1
          - pwsh/Catzc.Base.Maps/Get-ValueChainHighlight.ps1
          - pwsh/Catzc.Base.Maps/Get-WorldMapHighlight.ps1
          - pwsh/Catzc.Base.Maps/tests/Get-WorldMapHighlight.Tests.ps1
          - pwsh/Catzc.Base.Repository/Get-RunEnvironment.ps1
          - ADR-AUTO-PARITY-ONESEAM
          - FDR-CD-DETECT-BOOLEANNOTMODAL
          - FDR-CD-DETECT-FASTDETECTION
          - FDR-CD-DETECT-NODIRECTVARIABLECHECK
          - FDR-CD-DETECT-PARAMETERSOVERDETECTION
          - FDR-CD-DETECT-VISIBLECONTEXTBEHAVIOUR
      - cell: pwsh/yaml
        by:
          - pwsh/Catzc.Base.Drs/configs/drs.yml
          - pwsh/Catzc.Base.QualityGates/configs/analyzer-drs-map.yml
          - ADR-AUTO-PARITY-ONESEAM
          - FDR-CD-DETECT-BOOLEANNOTMODAL
          - FDR-CD-DETECT-FASTDETECTION
          - FDR-CD-DETECT-NODIRECTVARIABLECHECK
          - FDR-CD-DETECT-PARAMETERSOVERDETECTION
          - FDR-CD-DETECT-VISIBLECONTEXTBEHAVIOUR
      - cell: (no track)/(other)
        by: [.gitattributes, .gitignore, ADR-AUTO-PARITY-ONESEAM]
    axis:
      - cell: DSGN/*
        by:
          - FDR-CD-DETECT-BOOLEANNOTMODAL
          - FDR-CD-DETECT-FASTDETECTION
          - FDR-CD-DETECT-NODIRECTVARIABLECHECK
          - FDR-CD-DETECT-PARAMETERSOVERDETECTION
          - FDR-CD-DETECT-VISIBLECONTEXTBEHAVIOUR
      - cell: AUTO/*
        by: [ADR-AUTO-PARITY-ONESEAM]
layout:
  band-detection: { x: 20, y: 108, w: 1260, h: 130 }
  band-consumers: { x: 20, y: 258, w: 1260, h: 130 }
  band-enforcement: { x: 20, y: 408, w: 1260, h: 140 }
  g-detector: { x: 500, y: 150, w: 220, h: 44 }
  g-hook: { x: 780, y: 150, w: 190, h: 44 }
  s-consumers: { x: 100, y: 300, w: 460, h: 44 }
  g-analyzer: { x: 100, y: 440, w: 300, h: 84 }
  g-test: { x: 450, y: 440, w: 320, h: 84 }
```

![One gate checks the raw-read rule](.assets/one-gate-checks-the-raw-read-rule.drawio.png)

## Walkthrough

1. **Test-IsRunningInPipeline.** Rule 4, detection is boolean, is tested, so its chip is solid. Rule 5, only two variable reads and no I/O,
   is checked by nothing: a dashed chip.
2. **Assert-BashTimeout.** The C# hook reads both variables itself. The analyzer checks PowerShell files only, so rule 1 is unchecked there:
   a dashed chip. The hook stands alone on the diagram because nothing feeds it and nothing checks it.
3. **consumers.** The 24 call sites. Rule 1 is checked on them by the analyzer, so that chip is solid. Rule 2, context-dependent behavior
   must be intentional and visible, rule 3, prefer a parameter over detection, and ADR-AUTO-PARITY-ONESEAM, branch on the seam only where
   the environments genuinely differ, have no gate: dashed chips.
4. **Test-IsRunningInPipeline.Tests.ps1.** An L0 logic test. It sets `TF_BUILD`, then `GITHUB_ACTIONS`, then neither, and asserts true, true
   and false.
5. **Measure-NoRawPipelineDetection.** The analyzer rule. `analyzer-drs-map.yml` maps it to FDR-CD-DETECT-NODIRECTVARIABLECHECK, and
   `Test-AnalyzerDrsMap` fails when a custom rule is unmapped or cites a rule that does not exist, so the credit the rule-coverage report
   gives to this rule is itself checked.

## Why it holds

- Never check the detection variables directly; one analyzer rule checks it on every PowerShell file (FDR-CD-DETECT-NODIRECTVARIABLECHECK).
- Context-dependent behavior must be intentional and visible, through the detector or a parameter; the FDR alone states it
  (FDR-CD-DETECT-VISIBLECONTEXTBEHAVIOUR).
- Prefer a parameter over detection; detection is the fallback; the FDR alone states it (FDR-CD-DETECT-PARAMETERSOVERDETECTION).
- Detection is boolean, not modal; the L0 test proves all three cases (FDR-CD-DETECT-BOOLEANNOTMODAL).
- The function stays fast, reading two variables and nothing else; the FDR alone states it (FDR-CD-DETECT-FASTDETECTION).
- A command branches on the seam only where the environments genuinely differ, never to change what it does; the FDR alone states it
  (ADR-AUTO-PARITY-ONESEAM).

## Where the code and the decision record differ

- The FDR forbids every direct read of the variables, and the analyzer enforces that for PowerShell; the C# hook `Assert-BashTimeout` reads
  both, and no gate reaches it.
- The FDR says the analyzer rule flags raw reads anywhere outside `Test-IsRunningInPipeline`; the rule also exempts `*.Tests.ps1` files.

## See also

- [Pipeline detection](../../drs/flow/pipeline-detection.md) — the decision this article explains;
  [Devbox and pipeline parity](../../drs/automation/devbox-pipeline-parity.md) — the seam it keeps.
- The other lenses on the same detector: [meta](one-boolean-answer-from-one-function.md),
  [architecture](the-loader-holds-the-one-detector.md), [implementation](two-variables-read-in-one-place.md) and
  [operations](the-analyzer-names-the-raw-read.md).
- [The flow explanations](index.md) · [How to read the diagrams](../index.md#how-to-read-the-diagrams)
