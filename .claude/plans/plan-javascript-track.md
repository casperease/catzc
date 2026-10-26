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

- [ ] Strict types for `catzc-track-lamps`, one part per change: strict is per module, so the module stays out of `strict:` until every part
      is clean, and each part is measured by a local run with the lamps listed (391 findings on 2026-10-26: glob 24, language 16, status 16,
      host 16, facts 37, tree 34, apply 12, engine 126, extension 11, tests 99). Order: glob, language, status, host, facts, tree, apply,
      extension, engine, tests; then `catzc-track-lamps` joins `strict:`. Check after each part: its findings at zero in the local run,
      `Invoke-JavaScriptTest catzc-track-lamps`, and `catzc-track-lamps.Tests.ps1` (lamp vectors); at the end `Test-JavaScriptTypes` green
      with the lamps strict.
