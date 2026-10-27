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

- [ ] `design/visual-design.md`: "slate" names both a stage-box tint and staged WIP; the stage box takes another tint name. Check: the
      record check.

### Vendor and engine detail down a tier

Each step keeps a neutral rule in place and moves the spelling to its twin. Check for each: the record check plus `Test-DrsEngineNeutrality`
on the neutral record.

- [ ] `configuration/config-value-addressing.md`: its pwsh code moves to `automation/pwsh/`. Check: as above.
- [ ] `automation/BCL/native-csharp-types.md`: the pwsh host rules (ADR-BCL-TYPES-CHANGEDAFTERLOAD, -STALETYPESGUARD, -ONEDRIFTMEASURE,
      -CONSOLEVERIFIESONLY, -ACCELERATORSNOTFULLNAMES, -JANITORSBYCALLER) move to `automation/pwsh/hosting-csharp-types.md`, merging with
      ADR-PWSH-TYPES-RESTARTTORELOAD and -ONEINSTANCEPERSESSION; the shadow-copy mechanics already moved. Check: as above.
- [ ] `repository/conventional-folders.md`: the `Join-Path`, `Get-CatzcModuleRoot` and `Format-Types` samples move to `automation/pwsh/`.
      Check: as above.
- [ ] The three value-chain rules of `design/tracks.md` (DDR-TRACK-VALUECHAINSTACK, -VALUECHAINCONCERN, -VALUECHAINMAP) move to a DRS record
      in `repository/`. Check: as above.
- [ ] Engine names leave DDR-TRACK-ONETRACKTYPE (its Go, Python and Bash test-holder sentences). Check: as above.
- [ ] DDR-VISUAL-ARROWSPOINTATDEPENDENCY keeps the arrow meaning and its routing mechanics move to the renderer docs. Check: as above.

### Rules that state one thing

Check for each: `Update-AdrCitation` dry run, then the record check.

- [ ] Automation: ADR-AUTO-DEPS-TWODEPENDENCYKINDS into -DEPS-TWODEPENDENCYKINDS; -DEPS-NOPREINSTALLEDTOOLS into -DEPS-ASSERTBEFOREINVOKE;
      -TEST-LOGICANDINTEGRITY into -TEST-TWOMANDATORYTAGS; -LAYERS-IMPORTERDECIDESMIX into -IMPORTER-DECIDESMIX; -ENGINE-IMPORTERENTRY keeps
      only the dispatcher beside -IMPORTER-ONEENTRY; -ZERO-MISTAKESHARDTOMAKE into -ZERO-DESIGNQUESTIONS. Check: as above.
- [ ] pwsh: `avoid-using-semicolons.md` (ADR-PWSH-FORMAT) folds into `powershell-formatting.md`; ADR-PWSH-FOREACH-OBJECTFORTRANSFORMS into
      -OBJECTFORTRANSFORMS. Check: as above.
- [ ] Flow and ado: FDR-CD-GATEDEFINED into -TWORELEASEGATES; FDR-LIFE-FAILEDSTAYSUPSTREAM into -DIRTYHEADUNSAFE;
      FDR-TYPE-CDEAUTOMATESPRODROLL, -CDEINTERNALGATES and -CDESHARESDEPLOYPATH into one rule citing FDR-CD-CDEINTERNALIZESPROMOTION;
      ADR-ADO-NAME-ABSOLUTETEMPLATEPATH into ADR-ADO-TEMPLATE-ABSOLUTEPATHS, and "Flat pipelines" cites FDR-PIPELINE-TYPEPREFIX. Check: as
      above.
- [ ] Design: DDR-VISUAL-COLOURISTEMPORAL, -NUMBERTIESAPPEARANCES and -ONLYGITLANEISTIME into one; -GREYYELLOWATBVT into
      -FIXEDCOMMITPALETTE; DDR-REMOTE-INTEGRATEFROMVERIFIED into -INTEGRATEFROMVERIFIED; PDR-EAC-EVERYTHINGCOMMITTED, -TRUNKWITHGUARDRAILS
      and PDR-EAC-EVERYTHINGCOMMITTED become citations of TDR-ONETRUTH, PDR-ONELIVE-TRUNKBASED and PDR-EAC; DDR-TRACK-ONETRACKTYPE cites
      DDR-TRACKTYPE-CLOSEDSETOFTYPES. Check: as above.
- [ ] Principles and process: PDR-ONELIVE-HISTORYINGIT with -HISTORYINGIT; PDR-POKAYOKE-FAILFAST with -FAILFAST;
      WDR-BUILTIN-QUALITYFURTHESTLEFT with WDR-BUILTIN-QUALITYFURTHESTLEFT; WDR-LEANTERMS-OPTIMISETHEWHOLE with
      WDR-LEANTERMS-OPTIMISETHEWHOLE; WDR-QUEUECOST-ATTENTIONISTHECONSTRAINT with WDR-QUEUECOST-ATTENTIONISTHECONSTRAINT;
      WDR-PULLWORK-LIMITWORKINPROGRESS, WDR-PULLWORK-LIMITWORKINPROGRESS and WDR-PULLWORK-LIMITWORKINPROGRESS into one;
      WDR-PULLWORK-SMALLESTBATCH with WDR-PULLWORK-SMALLESTBATCH; each keeps the process-side wording. Check: as above.
- [ ] Repository: ADR-REPO-README-READMEIDEMPOTENT and ADR-REPO-README-READMEIDEMPOTENT get one owning rule; ADR-REPO-OUTFMT-OUTPUTFORMAT
      into ADR-REPO-OUTFMT-OUTPUTFORMAT; ADR-REPO-FOLDERS-CONTRACTSFOLDER points at ADR-REPO-CONTRACT-LAYOUT; ADR-REPO-FILEMETA-METAKIND
      folds into file-meta after the head contradiction. Check: as above.
- [ ] Azure: ADR-AZ-LZ-GOVERNANCELIMITS keeps only what is ungoverned and -EVERYPILLAR indexes the pillar rules;
      ADR-AZ-SESSION-REVERSELOOKUP into -THREESEPARATECONCERNS (renamed for its layers). Check: as above.

### Sections that restate their rules

- [ ] `repository/conventional-folders.md`: "How this is enforced" becomes one current list. Check: the record check.
- [ ] `repository/api-contracts.md`: "The name picks the kind", the Decision restatement and "Three version ranges" go; rejected
      alternatives 1/3/10 and 2/7 fold together; HEADPOLICY's carrier detail in `repository/file-meta.md` defers to JSONCARRIER. Check: the
      record check.

### Records still owed a full prose pass

- [ ] The same in-place tightening for `repository/` (slides-as-markdown, command-contracts, drs-code-language, uniform-formatting,
      controlled-vocabulary, markdown-links, agent-definitions and the rest), the Context bodies of the larger `automation/` records
      (platform-bundle, console-output-matters, path-representation, fail-fast-with-asserts, environment-variables, caching, module-model)
      and ~25 smaller ones, and `automation/pwsh/` (dynamic-module-manifests, environment-variable-mechanics, pwsh-engine, error-handling,
      powershell-formatting and the rest). Check: the record check.
