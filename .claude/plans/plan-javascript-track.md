---
plan:
  status: active
  value: high
  reviewed: 2026-10-25
  class: feature
  targets:
    [
      js,
      pwsh/Catzc.Base.Languages/configs/languages.yml,
      pwsh/Catzc.Base.Variants/configs/variants.yml,
      pwsh/Catzc.Base.Variants/configs/module-types.yml,
      pwsh/Catzc.Base.VSCode,
      contracts,
      docs/drs/index.md,
    ]
---

# JavaScript is a language track, and the editor extensions are its modules

The editor extensions are JavaScript programs parked as assets of a PowerShell module (`pwsh/Catzc.Base.VSCode/assets/extensions/`). They
get their own track, `js`, with the language features Python, Go and pwsh have: a track and module layout, naming, a test runner, a types
gate, and an ADR. pwsh keeps everything that does not depend on an extension's inside (the manifest render from catzc configs, the palette,
the icon theme, packing, installing, the importer's janitor) and reaches each extension only through a versioned contract.

## Why its value is high

The lamps are key to daily work and their engine is the largest JavaScript file in the tree, yet it has no linting, no type check, and its
tests are Pester driving node one function at a time. A track gives it the gates the other languages have, and a contract makes the
pwsh-to-extension boundary checked instead of implied.

## Decided (2026-10-25)

- **Track `js`**, type `modules`, place `js` (dot-prefixed `.js` when the repository has no `js/` root, like `go` and `python`), languages
  `javascript`, `json`, `asset`. The language key stays `javascript`.
- **One module per extension**: `js/<extension-name>/`, its entry `extension.js` (exporting `activate` and `deactivate`), its own files in
  `media/`. Naming: folder kebab, file kebab, function camel, type pascal.
- **Tests**: node's built-in runner (`node --test`), no package; black-box tests per module in `js/tests/<module>/*.test.js`;
  `Invoke-JavaScriptTest` mirrors `Invoke-GoTest`. The engine-core cases now in `catzc-track-lamps.Tests.ps1` move to node:test, and their
  Pester copies are deleted (one living version); Pester keeps the pwsh-side render and manifest cases.
- **Types**: `Test-JavaScriptTypes` runs `tsc --noEmit` over a generated `jsconfig.json` (`checkJs`, strict) at the tools.yml pin, the same
  role pyright plays for Python. No ESLint: tsc's strict checks plus Prettier cover it without a second npm tool and config.
- **Contract**: pwsh and the `js` modules ship from one commit, so the boundary between them is internal and gets no contract
  (`PDR-ONELIVE`, ADR-REPO-CONTRACT-BINDINGINTERFACE). The outside party is VS Code: a vendor root `vscode`, current at `0.1.0` like `ado`
  and `github`, holds the trimmed extension-manifest schema VS Code expects, and the pwsh build checks every rendered `package.json` against
  it before packing, in process and fast. It follows the layout of `plan-contracts-layout.md` and lands after that plan's move.

## Open steps

- [ ] The stub-editor scenarios (`pwsh/Catzc.Base.VSCode/tests/assets/catzc-track-lamps-harness.js`) to node:test in
      `js/catzc-track-lamps/tests/`, and the shared lamp vectors read there too once they are JSON; the Pester copies deleted. Check:
      `Invoke-JavaScriptTest catzc-track-lamps`, case count kept, and `catzc-track-lamps.Tests.ps1` holds only the real-repository cases.
- [ ] Test files for the new pieces: `JavaScriptConfig`, `JavaScriptTestResult`, `ConvertFrom-NodeTestJunit`, `Invoke-JavaScriptTest`,
      `Get-JavaScriptTestCases`, and their reference pages. Check: each Pester file, then `Test-Links` on the pages.
- [ ] Phase 4, types: `typescript` in `tools.yml` (npm, like prettier), the generated `jsconfig.json`, `Test-JavaScriptTypes`. Check: the
      gate green on all five extensions.
- [ ] Phase 5, contract (after `plan-contracts-layout.md`'s move): `contracts/vscode/0.1.0/extensions/package.schema.json`, the trimmed
      manifest schema, bound in its `contract.yml`; `Build-VsCodeExtension` refuses a rendered `package.json` that breaks it. Check:
      `Build-VsCodeExtension.Tests.ps1` with one passing and one broken manifest, then `Test-Contracts`.
- [ ] Phase 6, rules and docs: `docs/drs/automation/javascript/` (ADR-AUTO-JS, index row in `docs/drs/index.md`), DDR-TRACK-ONETRACKTYPE
      names `js`, the Catzc.Base.VSCode reference re-cut. Check: `Test-Links`, `Test-Markdownlint`.
