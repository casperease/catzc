---
plan:
  status: active
  value: medium
  reviewed: 2026-10-27
  class: feature
  targets: [pwsh/Base.FileLimits]
---

# File limits: an extensions entry adds to the defaults, never replaces them

The `extensions:` key of `file-limits.yml` clears every default the C# type declares (`extensionsValue.Clear()` in `FileLimitsConfig.cs`),
so one entry unclassifies `LICENSE`, `.csv`, `.psd1` and the rest; the key is unusable. Decided by the meister (2026-10-27, PDR-CONFIG: a
default is declared once, an entry configures one instance): an entry adds or overrides one extension and keeps the other defaults.

## Open steps

- [ ] `pwsh/Base.FileLimits/types/FileLimitsConfig.cs`: the `extensions:` reader merges each entry over the defaults instead of clearing
      them; one L0 case in `FileLimitsConfig.Tests.ps1` pins that a one-entry `extensions:` keeps `.csv` classed. Lands by staged burst.
      Check: `FileLimitsConfig.Tests.ps1` and `Test-FileLimits.Tests.ps1` pass in the burst, read from the results XML.
