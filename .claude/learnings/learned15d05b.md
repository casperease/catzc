# Session learnings 15d05b

Started 2026-10-26T16:36:54.9565876+01:00.

- 2026-10-26 Cats: Token tip: Next time, save tokens by: grepping a C# config type for its defaults instead of importing to call Get-*.
- 2026-10-26 Cats: In hindsight I wish I knew this fact: a staged copy under out/ or a scratchpad has no module manifest beside it, so
  Get-ModuleFullName and Format-Types fall back to the bare folder name; format a staged .cs in place as the burst's first step.
- 2026-10-26 Cats: In hindsight I wish I knew this fact: contract keys are validated in two places, ContractAsset.cs and ContractManifest.cs
  IsKey, plus Test-Contracts.Tests fixtures; a layout change must sweep all three.
- 2026-10-26 Cats: In hindsight I wish I knew this fact: Invoke-StagedBurst restores journalled files but (before catzc-2c's fix) left
  folders the swap created, and gitignored generated files like .vscode/settings.json sit outside the journal.
- 2026-10-26 Cats: In hindsight I wish I knew this fact: Get-CommentPage has 10 non-test callers, so any change to the page path must land
  together with the page move, never before it.
- 2026-10-26 Cats: In hindsight I wish I knew this fact: the docs: code head is a whole file-meta kind (relative-edges) with its own
  processor, candidate finder and input-stamp hook, not one yml key.
- 2026-10-26 Cats: In hindsight I wish I knew this fact: out/ is cleared by hand mid-session, so staging and user scripts that must survive
  belong in a scratchpad or are rebuildable from the plan text.
- 2026-10-26 Cats: Token tip: grep every reader of a key or path form (code, types, test fixtures) before staging a burst, instead of
  discovering them one failed burst at a time.
- 2026-10-26 Cats: Token tip: read a background task's output with one targeted grep for passed/failed/issue lines, never the whole output
  file.
- 2026-10-26 Cats: In hindsight I wish I knew this fact: Clear-ModuleTypeCache deletes every Catzc.Types DLL in the shared shadow root
  except its own tree hash, so an off-tree import needs a private LOCALAPPDATA.
- 2026-10-26 Cats: In hindsight I wish I knew this fact: Get-FileMetaScope keeps only files a meta kind selects, so a test that mocks it
  cannot prove old heads get stripped.
- 2026-10-26 Cats: In hindsight I wish I knew this fact: pwsh -File binds a comma-joined argument as one string, and a failing
  Invoke-CatzcCommand step swallows its own output, so print measures to a transcript.
- 2026-10-26 Cats: In hindsight I wish I knew this fact: the Edit tool can drop a trailing space at the end of old_string, so git diff -U0
  must show only # lines after a comment edit.
- 2026-10-26 Cats: In hindsight I wish I knew this fact: pwsh/.internal/assets/types/burst-journal.psd1 is gitignored by pwsh/**/*.psd1 yet
  Invoke-StagedBurst needs it.
- 2026-10-26 Cats: Token tip: Next time, save tokens by: grepping a results-shard XML for total and failures instead of tailing whole run
  outputs.
- 2026-10-26 Cats: Token tip: Next time, save tokens by: building one helper script per repeated check (copy, dry run, measure) instead of
  retyping long command lines.
