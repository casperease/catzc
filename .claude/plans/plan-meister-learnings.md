---
plan:
  status: active
  value: low
  reviewed: 2026-10-27
  targets: [.claude]
---

# Meister learnings: where the night's facts shrink what the next session reads

The meister session of 2026-10-26/27 logged eight learnings (Add-SessionLearning). Each proposal below places one where the next session
reads it instead of rediscovering it; none is applied until the user answers.

## Open questions

- Should `.claude/prompts/meister.md` say that a repeated idle-notice timestamp means a held, unread message (the worker runs in prompting
  mode), so the meister asks the user to approve rather than re-pinging?
- Should the `catzc-run` capability say that a "0 warnings" claim on bicep is proven only by `Test-BicepLint` (bicep warns on stderr with
  exit 0), and that read-only checks build with `Build-Bicep -OutputFolder`?
- Should `.claude/prompts/worker.md` say that a template or import-run file is edited only in a staged folder, never live mid-step, since a
  half edit breaks every peer's proof?
