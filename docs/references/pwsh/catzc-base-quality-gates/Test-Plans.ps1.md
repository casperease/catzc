# pwsh/Catzc.Base.QualityGates/Test-Plans.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Quality gate: holds every file of the plans folder to the plan rules.

### description

One finding per broken rule, each naming the rule ([ADR-REPO-PLANS](../../../drs/repository/plans.md)):

- a file name the folder does not accept: a plan is `plan-<topic>.md` and a name never carries an order
  ([ADR-REPO-PLANS-ONETOPICONEFILE](../../../drs/repository/plans.md#rule-adr-repo-plans-onetopiconefile),
  [ADR-REPO-FOLDERS-STABLEFILENAMES](../../../drs/repository/conventional-folders.md#rule-adr-repo-folders-stablefilenames));
- a plan head without the `plan:` block, a required key missing, a key outside the allowed set, a status or value outside the declared sets,
  a blocked plan that names nothing it is blocked on, or a target path that does not exist
  ([ADR-REPO-PLANS-PLANHEAD](../../../drs/repository/plans.md#rule-adr-repo-plans-planhead));
- a plan with no row in the value overlay or no chunk line in the master plan, and a step count that its chunk line or the last cell of its
  row states ("three steps", "one step left") other than the plan's open steps
  ([ADR-REPO-PLANS-THREEPARTS](../../../drs/repository/plans.md#rule-adr-repo-plans-threeparts));
- a plan without a required section, the open steps first among them
  ([ADR-REPO-PLANS-ONESHAPE](../../../drs/repository/plans.md#rule-adr-repo-plans-oneshape));
- an open step, a `- [ ]` or `1. [ ]` item with its continuation lines, that names no check, and a numbered line of the open steps section
  with no checkbox ([ADR-REPO-PLANS-OPENSTEP](../../../drs/repository/plans.md#rule-adr-repo-plans-openstep));
- a task file whose `task:` head misses a key or which has no steps section, more task files than the roof, a line in any file that names a
  task by a number, and a master plan without its own sections
  ([ADR-REPO-PLANS-MASTERANDTASKS](../../../drs/repository/plans.md#rule-adr-repo-plans-masterandtasks)).

The folder, the sets and the patterns are the plans registry (configs/plans.yml), its defaults declared once on PlansConfig. A quality gate
([ADR-AUTO-TEST-QUALITYGATE](../../../drs/automation/test-automation.md#rule-adr-auto-test-qualitygate)): it ends through
Write-QualityGateReport, which writes out/test-plans/, prints every issue, and throws once listing them all. The plans live only in the
source tree.

### parameter `Path`

The plans folder, or plan files, to check; a relative path resolves against the repository root, never the process folder. The overlays the
cross-file checks read are those of the folder the first path names or sits in. Default: the registry's folder under the repository root.

### parameter `Config`

The plans registry. Default: the shipped plans.yml.

### parameter `RepositoryRoot`

The repository root target paths resolve against. Default: the loaded repository root.

### parameter `OutputFolder`

The report base folder. Defaults to `<out>/test-plans`.

### parameter `PassThru`

Return a result object ({ Subject; IssueCount; Issues; ReportPath; Files; Plans; Tasks }) instead of throwing.

### outputs

Throws on any finding; with -PassThru, returns the result object.

### example 1

```powershell
Test-Plans
```

### example 2

```powershell
(Test-Plans -PassThru).Issues
```
