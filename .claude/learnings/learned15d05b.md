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
- 2026-10-26 Cats: In hindsight I wish I knew this fact: cspell 10 skips every file under the gitignored out/ folder even with
  --no-gitignore, and checks text given on stdin.
- 2026-10-26 Cats: In hindsight I wish I knew this fact: Test-/Assert- verbs bind by ADR-PWSH-VERBS-TESTANDASSERT and a code transform is
  ConvertTo-, never Format-, which only arranges for display.
- 2026-10-26 Cats: In hindsight I wish I knew this fact: Update-DrsCitation reads a tab-separated rule map, old_rule new_rule kind why, so a
  rename map needs no new format.
- 2026-10-26 Cats: In hindsight I wish I knew this fact: in all-caps codes a word boundary is invisible, so dropping a repeated word needs a
  dictionary proof that the said word does not run on into a longer word.
- 2026-10-26 Cats: In hindsight I wish I knew this fact: 19 rule names repeat across records today, so a rule name alone is no identity
  until the rename lands.
- 2026-10-26 Cats: In hindsight I wish I knew this fact: YAML reads a bare on as true, so a config value on is written quoted.
- 2026-10-26 Cats: Token tip: Next time, save tokens by: generating a large list to a file and reading only the counts and the review lines,
  not the whole list.
- 2026-10-26 Cats: Token tip: Next time, save tokens by: probing a CLI on three sample words before wiring it into a generator run.
- 2026-10-26 Cats: In hindsight I wish I knew this fact: a staged burst whose C# adds an enum member must not be dry-run from a process that
  dot-sourced the importer; the old Catzc.Types stays loaded and the new member reads unknown.
- 2026-10-26 Cats: In hindsight I wish I knew this fact: Pester expands \<name> in an It title as a template variable, so a literal
  {tool.\<name>} title fails with an unset variable.
- 2026-10-26 Cats: In hindsight I wish I knew this fact: Test-GeneratedFiles over the whole tree fails on peers' stale outputs during a busy
  session; -Generator scopes it to the writer a change touches.
- 2026-10-26 Cats: In hindsight I wish I knew this fact: Get-FileMetaScope and Get-GeneratedStampDrift read tracked files only, so a
  gitignored generated file never reaches the head checks.
- 2026-10-26 Cats: Token tip: Next time, save tokens by: running the analyzer on staged files directly before the first dry run, not after
  it fails.
- 2026-10-26 Cats: Token tip: Next time, save tokens by: making the dry-run script snapshot in a child process from the start.
- 2026-10-26 Cats: In hindsight I wish I knew this fact: Get-TimeoutSeconds -Command resolves the function with Get-Command, so a private
  function is invisible and the lookup throws; a private step takes its limit by -Executable.
- 2026-10-26 Cats: In hindsight I wish I knew this fact: the user clears out/ by hand mid-session, so a burst staging or journal under out/
  can vanish; staging lives in the session scratchpad.
- 2026-10-26 Cats: In hindsight I wish I knew this fact: the Edit tool can drop a trailing space from replacement text and glue code ($x
  =value), which still parses; a comment-only edit is proven by diff, not parse.
- 2026-10-26 Cats: In hindsight I wish I knew this fact: an import that writes generated files during a burst is not undone by its rollback
  unless the writer journals itself (now Save-BurstJournalWrite).
- 2026-10-26 Cats: In hindsight I wish I knew this fact: Windows apps started from Explorer keep the sign-in PATH, so a removed machine tool
  still shadows in VS Code; go.alternateTools now pins the managed go.
- 2026-10-26 Cats: In hindsight I wish I knew this fact: a tool printed for pwsh must quote brace tokens ('{GUID}'), or pwsh parses a script
  block and msiexec shows its usage popup.
- 2026-10-26 Cats: In hindsight I wish I knew this fact: two sessions editing one config file at once can merge lines silently (timeouts.yml
  lost brew to a comment); a shared config has one editor at a time.
- 2026-10-26 Cats: Token tip: Next time, save tokens by: answering an idle notice with one line, never a recap.
- 2026-10-26 Cats: Token tip: Next time, save tokens by: reading a gate output with one grep for its verdict lines.
- 2026-10-26 Cats: Test-FileLimits counts lines per file against 400 for md and psm1 and 300 for glossary.yml; a decision-record rewrite
  that adds rules can push a neighbouring file over its roof.
- 2026-10-26 Cats: Build-Diagrams refuses a diagram no article embeds, so every new diagram lands with its article and an index row.
- 2026-10-26 Cats: Token tip: subscribe with notify_when_idle instead of waiting on a busy worker.
