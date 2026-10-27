---
plan:
  status: active
  value: high
  reviewed: 2026-10-27
  class: meta
  targets: [docs/drs]
---

# DRS simplification: contradictions settled, tiers clean, one rule per point

The records are strong but have grown. The in-place prose pass landed (57 records tightened, no code, heading or anchor changed); this plan
holds what that pass could not do in place: contradictions, content a tier too high, rules that state one thing, and sections that only
restate their rules. Every step keeps each decision and its rationale; a merged rule's code is retired and every citation re-cited in the
same change (`Update-AdrCitation`, PDR-ONELIVE). The check "the record check" means `Test-DrsRegistry` and `Test-Links` on the touched
records.

## Open steps

### Contradictions, settled first

- [ ] `azure/azure-network-model.md`: the hub firewall the templates deploy (`landing-zone-network.bicep`, `firewall.bicep`, the spoke route
      to it) settles ADR-AZ-NETWORK-CAFTOPOLOGY, -CAFCONNECTIVITY and "CAF connectivity", which say egress is unfiltered and the firewall
      planned; `docs/references/infrastructure/discovery.md` and `templates/discovery/main.md` say three policy assignments where
      `landing-zone-policies.bicep` assigns ten. Check: a grep of the templates.
- [ ] `design/visual-design.md`: "slate" names both a stage-box tint and staged WIP; the stage box takes another tint name. Check: the
      record check.

### Vendor and engine detail down a tier

Each step keeps a neutral rule in place and moves the spelling to its twin. Check for each: the record check plus `Test-DrsEngineNeutrality`
on the neutral record.

- [ ] `flow/cd-discipline-and-promotion-flow.md`: the ADO mechanics of FDR-CD-PRODAPPROVALGATE, -CERTIFYINGRECORD, -SEPARATEPIPELINEKINDS
      and -RUNGSREGISTRY (`environment-approvals.yml`, `Sync-AdoEnvironmentApprovals`, `Assert-AdoDeploymentHistory`, environment naming,
      `rungs.yml`) move to `ado/`. Check: as above.
- [ ] "Pre-prod is a staging slot in the production subscription" (FDR-CD-TWOENVIRONMENTACTIVATION, FDR-LIFE-ONECOMMITPERENVIRONMENT) is
      said once, in `azure/`. Check: as above.
- [ ] `flow/durable-sha-globs.md`: the GitHub and ADO path-filter projections, YAML samples and drift gates (FDR-GLOBS-NATIVEPATHFILTER)
      move to `github/` and `ado/`. Check: as above.
- [ ] `flow/pipeline-detection.md` (the FDR-DETECT rules) moves to `automation/pwsh/`; `flow/pipeline-runner-pattern.md` (the FDR-RUNNER
      rules, which duplicate FDR-TYPE-ALLTHROUGHRUNNER) moves to `ado/`, flow keeping "no inline script in pipeline YAML". Check: as above.
- [ ] `flow/pipeline-types.md` (FDR-TYPE-SIXTYPES, -ALLTHROUGHRUNNER) and FDR-QUEUE-AUTHORINGISTHEFIRST lose their ADO wording. Check: as
      above.
- [ ] `ado/dual-authentication.md`, `ado/pipeline-variables.md` and `configuration/config-value-addressing.md`: their pwsh code moves to
      `automation/pwsh/`; the step-template sample matches the runner pattern. Check: as above.
- [ ] `automation/test-automation.md`: the pwsh, Pester and Bicep names in ADR-AUTO-TEST-SAFESEAMSWAPS, -PROCESSTRIPWIRE,
      -GENERICTEMPLATETESTS, -TAGSENFORCED, -TESTRUN, -QUALITYGATE, -TESTSUITE and -TESTINGINPRODUCTION, the Build-Bicep example, and the
      harness and snapshot mechanics move to `automation/pwsh/pester-testing.md`; the decisions of -FILEPARALLELISM, -ONESCHEDULINGPOOL and
      -SYSTEMTESTSATLTHREE stay. Check: as above.
- [ ] `automation/BCL/native-csharp-types.md`: the pwsh host behaviour (ADR-BCL-TYPES-CHANGEDAFTERLOAD, -STALETYPESGUARD, -ONEDRIFTMEASURE,
      -CONSOLEVERIFIESONLY, -ACCELERATORSNOTFULLNAMES, -JANITORSBYCALLER and its two sections) moves to
      `automation/pwsh/hosting-csharp-types.md`, merging with ADR-PWSH-TYPES-RESTARTTORELOAD and -ONEINSTANCEPERSESSION. Check: as above.
- [ ] `repository/conventional-folders.md`: the `Join-Path`, `Get-CatzcModuleRoot` and `Format-Types` samples move to `automation/pwsh/`.
      Check: as above.
- [ ] `design/run-modes.md` (all PowerShell) moves to `automation/pwsh/`; the three value-chain rules of `design/tracks.md`
      (DDR-TRACK-VALUECHAINSTACK, -VALUECHAINCONCERN, -VALUECHAINMAP) move to a DRS record in `repository/`. Check: as above.
- [ ] Engine names leave DDR-TRACK-ONETRACKTYPE (its Go, Python and Bash test-holder sentences). Check: as above.
- [ ] DDR-VISUAL-ARROWSPOINTATDEPENDENCY keeps the arrow meaning and its routing mechanics move to the renderer docs. Check: as above.

### Rules that state one thing

Check for each: `Update-AdrCitation` dry run, then the record check.

- [ ] Automation: ADR-AUTO-DEPM-NOTSYSTEMDEPENDENCY into -DEPS-TWODEPENDENCYKINDS; -DEPS-NOPREINSTALLEDTOOLS into -DEPS-ASSERTBEFOREINVOKE;
      -TEST-LOGICANDINTEGRITY into -TEST-TWOMANDATORYTAGS; -LAYERS-IMPORTERDECIDESMIX into -IMPORTER-DECIDESMIX; -ENGINE-IMPORTERENTRY keeps
      only the dispatcher beside -IMPORTER-ONEENTRY; -ZERO-MISTAKESHARDTOMAKE into -ZERO-DESIGNQUESTIONS. Check: as above.
- [ ] pwsh: `avoid-using-semicolons.md` (ADR-PWSH-NOSEMI) folds into `powershell-formatting.md`; ADR-PWSH-FOREACH-NOCONTROLFLOWINOBJECT into
      -OBJECTFORTRANSFORMS. Check: as above.
- [ ] Flow and ado: FDR-CD-GATEDEFINED into -TWORELEASEGATES; FDR-LIFE-FAILEDSTAYSUPSTREAM into -DIRTYHEADUNSAFE;
      FDR-TYPE-CDEAUTOMATESPRODROLL, -CDEINTERNALGATES and -CDESHARESDEPLOYPATH into one rule citing FDR-CD-CDEINTERNALIZESPROMOTION;
      ADR-ADO-NAME-ABSOLUTETEMPLATEPATH into ADR-ADO-TEMPLATE-ABSOLUTEPATHS, and "Flat pipelines" cites FDR-PIPELINE-TYPEPREFIX. Check: as
      above.
- [ ] Design: DDR-VISUAL-COLOURISTEMPORAL, -NUMBERTIESAPPEARANCES and -ONLYGITLANEISTIME into one; -GREYYELLOWATBVT into
      -FIXEDCOMMITPALETTE; DDR-REMOTE-NORECONCILINGTIPS into -INTEGRATEFROMVERIFIED; DDR-SELFSERV-REPOSITORYISTRUTH, -TRUNKWITHGUARDRAILS
      and DDR-THINPLAT-REPRESENTEDASCODE become citations of TDR-ONETRUTH, PDR-ONELIVE-TRUNKBASED and PDR-EAC; DDR-TRACK-ONETRACKTYPE cites
      DDR-TRACKTYPE-CLOSEDSETOFTYPES. Check: as above.
- [ ] Principles and process: PDR-ONELIVE-NODEADCODE with -HISTORYINGIT; PDR-POKAYOKE-DETECTEARLIEST with -FAILFAST;
      WDR-BUILTIN-QUALITYFURTHESTLEFT with WDR-ANDON-STOPPINGISCHEAP; WDR-LEANTERMS-OPTIMISETHEWHOLE with WDR-OBSERVEWIP-OBSERVEWHOLESTREAM;
      WDR-LEANTERMS-AUTOMATEDORMANUAL with WDR-QUEUECOST-ATTENTIONISTHECONSTRAINT; WDR-LEANTERMS-FLOWISMEASURED, WDR-QUEUECOST-LITTLESLAW
      and WDR-PULLWORK-LIMITWORKINPROGRESS into one; WDR-PULLWORK-SMALLESTBATCH with WDR-QUEUECOST-BATCHSIZEDRIVESQUEUES; each keeps the
      process-side wording. Check: as above.
- [ ] Repository: ADR-REPO-README-READMEIDEMPOTENT and ADR-REPO-ROOTCFG-ROOTCFGIDEMPOTENT get one owning rule;
      ADR-REPO-OUTDIR-EVERYFILEHASFORMAT into ADR-REPO-OUTFMT-OUTPUTFORMAT; ADR-REPO-FOLDERS-CONTRACTSFOLDER points at
      ADR-REPO-CONTRACT-LAYOUT; ADR-REPO-CODEMETA-SAMEENGINE folds into file-meta after the head contradiction. Check: as above.
- [ ] Azure: ADR-AZ-LZ-GOVERNANCELIMITS keeps only what is ungoverned and -EVERYPILLAR indexes the pillar rules;
      ADR-AZ-SESSION-REVERSELOOKUP into -THREESEPARATECONCERNS (renamed for its layers). Check: as above.

### Sections that restate their rules

- [ ] `flow/cd-discipline-and-promotion-flow.md`: the "AT and UAT" section and Consequences bullets 1, 2, 4, 5. Check: the record check.
- [ ] `azure/azure-data-model.md`: Consequences keeps its final trade-off; "One tenant" and "The subscription as the unit" move to
      `az-session-verification.md`, `azure-customer-model.md` and `landing-zones.md`, cited from here. Check: the record check.
- [ ] `repository/conventional-folders.md`: "How this is enforced" becomes one current list. Check: the record check.
- [ ] `repository/api-contracts.md`: "The name picks the kind", the Decision restatement and "Three version ranges" go; rejected
      alternatives 1/3/10 and 2/7 fold together; HEADPOLICY's carrier detail in `repository/file-meta.md` defers to JSONCARRIER. Check: the
      record check.
- [ ] Azure: per-config values in `landing-zones-well-architected.md` stated once. Check: the record check.

### Gate extension (decided by the user, 2026-10-27: yes)

- [ ] Extend `Test-DrsEngineNeutrality` from `automation/` to `flow/` (vendor names), `design/`, `principles/` and `thesis/` (engine names),
      so tier drift is caught at the gate instead of by review. Runs after the tier moves above land, so the gate goes green on arrival.
      Check: `Test-DrsEngineNeutrality` passes on the whole DRS and its test file covers one widget record per new folder.

### Records still owed a full prose pass

- [ ] The same in-place tightening for `repository/` (slides-as-markdown, command-contracts, drs-code-language, uniform-formatting,
      controlled-vocabulary, markdown-links, agent-definitions and the rest), the Context bodies of the larger `automation/` records
      (platform-bundle, console-output-matters, path-representation, fail-fast-with-asserts, environment-variables, caching, module-model)
      and ~25 smaller ones, and `automation/pwsh/` (dynamic-module-manifests, environment-variable-mechanics, pwsh-engine, error-handling,
      powershell-formatting and the rest). Check: the record check.
