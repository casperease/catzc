---
plan:
  status: active
  value: low
  reviewed: 2026-10-27
  targets: [.claude]
---

# Meister learnings: where the night's facts shrink what the next session reads

The meister session of 2026-10-26/27 logged eight learnings (Add-SessionLearning). The three questions are decided by the meister
(2026-10-27): each learning goes where the next session reads it instead of rediscovering it.

## Open steps

- [ ] `.claude/prompts/meister.md`: one bullet saying a repeated idle-notice timestamp means the worker has not finished a new turn (it
      waits on a background run, or holds a message for the user's approval in prompting mode); the meister does not re-ping. Check: the
      bullet reads in the file.
- [ ] The `catzc-run` capability: one sentence saying a "0 warnings" claim on bicep is proven only by `Test-BicepLint` (bicep warns on
      stderr with exit 0), and read-only checks build with `Build-Bicep -OutputFolder`. Check: the sentence reads in the skill.
- [ ] `.claude/prompts/worker.md`: one bullet saying a template or import-run file is edited only in a staged folder, never live mid-step,
      since a half edit breaks every peer's proof. Check: the bullet reads in the file.
