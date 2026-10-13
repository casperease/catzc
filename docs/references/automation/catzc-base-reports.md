# docs/references/automation/catzc-base-reports.md

`Catzc.Base.Reports`

Owns the one output shape every quality gate shares: a report written under the output root, the issues printed, and a single verdict — a
throw listing every issue, or a result object under `-PassThru` (see [test-automation](../../adr/automation/test-automation.md), the
quality-gate rule). A gate collects its issues and hands them here last, so no gate writes its own report or invents its own message. It
deliberately does **not** decide what a gate checks — that stays with each gate's module.

## Domains

| Domain   | Area     | Name                                                         |
| -------- | -------- | ------------------------------------------------------------ |
| domain:1 | report   | [Quality-gate reporting](#domain1--quality-gate-reporting)   |
| domain:2 | settings | [Report settings](#domain2--report-settings)                 |

### domain:1 — Quality-gate reporting

Ending a quality gate the same way every time: a stamped run folder with a markdown report naming the gate, its facts, and every issue; a
file beside the stamped folders naming the latest run; each issue and the count printed, then the report path; and one verdict — a throw
that lists every issue (fail fast, aggregated), or the result object when the caller asks for it.

### domain:2 — Report settings

Where reports land and how their files are named, from `configs/reports.yml`. Every setting has a sensible default — the report folder
`test-<subject>` under the output root, the report `<subject>.md`, `latest.txt`, and a `yyyyMMdd-HHmmss` stamp — so the file overrides only
what differs, and a typed config validates it on load.

## What the module does

A quality gate is a check of one property of the whole repository. What differs between gates is the check; what must not differ is how a
gate reports, because people and CI read every gate's output the same way. This module is that shared ending. It sits low in the module
graph — above the config reader, the output-root anchor, and the console writers — so a gate in any module can use it without a new
dependency cycle.

## Division

Each function belongs to one domain.

| Domain                           | Function                  |
| -------------------------------- | ------------------------- |
| domain:1 — Quality-gate reporting | `Write-QualityGateReport` |
| domain:2 — Report settings       | `reports.yml`             |
