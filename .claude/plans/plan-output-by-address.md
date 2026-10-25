---
plan:
  status: active
  value: medium
  reviewed: 2026-10-25
  targets: [pwsh/Catzc.Base.Maps, pwsh/Catzc.Base.QualityGates]
---

# The output track is reached by address only

ADR-AUTO-DEFAULT-OUTPUTONLYBYADDRESS landed 2026-10-25 in `docs/drs/automation/sensible-defaults.md`: no default scope reaches `out/`, and
an explicit address there, a file or a folder, is worked on as it is on disk. The defaults already keep out of `out/` (git-tracked scopes,
`folder-walk.yml`, `markdown-scope`); these steps close the one default that points in, the folder-address gap, and lock it with a test.

## Open steps

- [ ] `Test-PlaceRows`: `-Path` becomes mandatory, so its caller names the minimap folder under `out/` instead of a default pointing there;
      every caller passes it. Check: `Test-PlaceRows.Tests.ps1` and a grep for its callers.
- [ ] `Format-Code`'s scope: a folder address under the output root resolves to the files on disk under it, not to its (empty) git-tracked
      set. Check: `Get-FormatScope.Tests.ps1`, one file under a folder in `out/` returned for that folder.
- [ ] An L1 test over every exported `Test-*`, `Assert-*` and `Format-*` command: no parameter default resolves under the output root.
      Check: the test passes on the tree and fails on a fixture command whose default points into `out/`.
