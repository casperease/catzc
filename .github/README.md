# CATZC — Cloud Automation Toolkit, Zero-Ceremony

<!-- cspell:ignore utomation oolkit ero eremony -- the bold-initial expansion below splits into these fragments -->

**C**loud **A**utomation **T**oolkit, **Z**ero-**C**eremony — a PowerShell 7.4+ module system for monorepos, with Azure/Bicep
infrastructure-as-code and Azure DevOps pipelines, built on one founding rule: **zero ceremony**.

**Drop a file, get a function** — no manifests, no installers, no configuration. Copy `automation/` and `importer.ps1` into your repo and
everything is self-contained: vendored dependencies, no network calls, no global state.

In code the system is **catzc** — the `Catzc.*` modules and namespaces; in prose we call it **cats** ("ask cats").

[![CI](../../../actions/workflows/ci.yml/badge.svg)](../../../actions/workflows/ci.yml)

---

## Quick start

From the repository root:

| Context              | Command            |
| -------------------- | ------------------ |
| Interactive terminal | `.\importer.ps1`   |
| Inside a script      | `. ./importer.ps1` |

Every function from every module is available after import — load time is roughly half a second.

```powershell
. ./importer.ps1
trap { Write-Exception $_; break }

Assert-Command git
Write-Message 'Ready to go'
```

---

## Documentation

- **[Getting started](../docs/how-to/getting-started/automation/index.md)** — load the system, use it in a script and in CI, and follow
  short how-to articles for the common jobs: add a function, add a module, add a C# type, add an infrastructure template, debug in VS Code,
  run the tests, vendor a dependency, and write a new doc chapter.
- **[Architecture decision records](../docs/adr/README.md)** — the design rationale behind every rule: error handling, folder conventions,
  vendoring, cross-platform support, the data/naming model, and more.
- **[FAQ](../docs/faq.md)** — why importing everything is fast, why there is no dependency hell, and why this beats flat scripts that
  dot-source each other.

The design in one line: [**zero ceremony, hard to fail**](../docs/adr/automation/zero-ceremony-poka-yoke.md) — every choice is judged
against _does this add ceremony?_ and _can the author get this wrong?_
