---
plan:
  status: active
  value: medium
  reviewed: 2026-10-22
  class: feature
  targets: [.claude/skills/catzc-run/SKILL.md]
---

# Debt root assets: a root asset edit lands under a burst

catzc-e9 edited `pwsh/Catzc.Base.RootConfig/assets/root/importer.sh` and saw the generated root `importer.sh` regenerate (head sha
`0725a57c58eb` to `53f1e31f2b76`) before its burst, with no command of its own; `Build-RootConfig` in the burst then reported
`Changed : False`. By design: the importer's tail runs `Build-RootConfig -Silent` on every load (`Catzc.Internal.Importer.psm1:406-407`;
`docs/references/pwsh/catzc-base-root-config.md:62-64`, "a bad root config breaks every session's next import"), so any peer's import, an
`Invoke-CatzcCommand` run included, materialises the edited asset. The gap is in the capabilities: `catzc-verify` step 1 asks for a HOLD
only for a rename, and `catzc-run` step 4 names the shared configs that every next import reads but not the root assets. The chunk owns
`catzc-run` only.

## Open steps

1. [ ] Susan from HR: catzc-e9's finding (2026-10-22): `.claude/skills/catzc-run/SKILL.md` step 4's shared-config sentence also names the
       root assets, `pwsh/Catzc.Base.RootConfig/assets/root/*`, which the importer's `Build-RootConfig` janitor materialises on every
       session's next import, so an edit of one starts with a HOLD to every live peer, merged into the existing sentence, the file kept at
       10 lines. Cost: an import-path write outside a burst reaches every live session. Check: `Test-AgentDefinitions` reports 0 issues.
