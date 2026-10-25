# Session learnings 167e52

Started 2026-10-23T19:08:35.6112403+02:00.

- 2026-10-23 Cats: In hindsight I wish I knew this fact: allowed span sentences are the statements vocabulary in drawio.yml, so a new span
  label needs a vocabulary entry in the same change, and the old sentence leaves it.
- 2026-10-23 Cats: In hindsight I wish I knew this fact: a span attaches to whole gate columns, so a label wider than about 100 px per
  column needs two columns or a shorter sentence; the renderer lets it spill past its bar.
- 2026-10-23 Cats: In hindsight I wish I knew this fact: a SKILL.md front-matter description is a plain YAML scalar, so a colon followed by
  a space inside it breaks the front matter; the roof of 10 lines counts the heading and each numbered item.
- 2026-10-23 Cats: In hindsight I wish I knew this fact: Test-AgentDefinitions needs a new agent listed in CLAUDE.md Sub-agents and named in
  catzc-drone description, so a new agent leaves that gate red until the user edits CLAUDE.md.
- 2026-10-23 Cats: In hindsight I wish I knew this fact: a markdown link written in chat is not clickable for the user, so a file to open is
  named as a plain path from the repository root.
- 2026-10-23 Cats: Token tip: Next time, save tokens by: briefing one drone for a multi-file kit change with a progress file under out/, so
  a 50-turn limit resumes with one message instead of a re-read.
- 2026-10-23 Cats: Token tip: Next time, save tokens by: running Build-Diagrams before Format-Code, not together; a race left a stale png
  once.
- 2026-10-24 Cats: In hindsight I wish I knew this fact: diagram labels and edges live in a yml drawio block in the article or a .drawio.yml
  beside the png, and edge_audit.py and language_audit.py read every declaration without reading pngs.
- 2026-10-24 Cats: In hindsight I wish I knew this fact: the Where does it live minimap rows are computed in Catzc.Base.Maps (PlaceRows) and
  only drawn by minimaps.py.
- 2026-10-24 Cats: In hindsight I wish I knew this fact: renderer findings-fail makes every diagram finding an E_ error, so a build stops on
  the first keep-out or orphan.
- 2026-10-24 Cats: In hindsight I wish I knew this fact: a long diagram-review subagent hits its 80-turn limit on multi-step engine work;
  one step per brief avoids lost reports.
- 2026-10-24 Cats: Token tip: brief one engine step per subagent run and ask for a report after each step.
- 2026-10-24 Cats: Token tip: use the audits (edge_audit, language_audit) instead of reading pngs to measure diagram work.
- 2026-10-25 Cats: In hindsight I wish I knew this fact: VS Code hands files.exclude to its search and watcher processes as command-line
  globs, so a few thousand entries fail with spawn ENAMETOOLONG on Windows.
- 2026-10-25 Cats: In hindsight I wish I knew this fact: a files.exclude glob also hides a folder whose name it matches, case-insensitively
  on Windows (**/*.config hides pwsh/Catzc.Base.Config).
- 2026-10-25 Cats: In hindsight I wish I knew this fact: vscode-extensions.yml is parsed on every import, and an unquoted {placeholder}
  inside a YAML flow mapping breaks every session's import.
- 2026-10-25 Cats: In hindsight I wish I knew this fact: VS Code exposes no other extension's decorations or test results; the lamps read
  their sources instead (vscode.git getAPI(1), languages.getDiagnostics, tabGroups) and out/test-results/\<test file>.failed markers from
  Invoke-TestFile.
- 2026-10-25 Cats: In hindsight I wish I knew this fact: the extension folder generator expands contributes entries by repeat (a config
  list, e.g. filters.yml) and by states (one command per context-key value).
- 2026-10-25 Cats: In hindsight I wish I knew this fact: Format-Code moves multi-line comments into docs/references comment pages and then
  requires a ## help section there for that function.
- 2026-10-25 Cats: In hindsight I wish I knew this fact: a design record may not cite a flow record; Test-DrsRegistry refuses the layer.
- 2026-10-25 Cats: In hindsight I wish I knew this fact: every import re-renders .vscode/settings.json and installs any own extension whose
  version changed, so a version bump installs itself.
- 2026-10-25 Cats: Token tip: Next time, save tokens by: measuring the real files.exclude entry count with a node driver before installing,
  instead of reacting to editor logs.
- 2026-10-25 Cats: Token tip: Next time, save tokens by: checking git status of shared files before editing, since a peer session may be in
  them.
- 2026-10-25 Cats: Pytest writes its cache to out/pytest-cache (cache_dir) and Python its bytecode to out/pycache (PYTHONPYCACHEPREFIX),
  both set in Invoke-PythonTest and the VS Code pytestArgs; no config carries a .pytest_cache or **pycache** exception any more.
- 2026-10-25 Cats: A filter lamp is a tri-state toggle (off, on, veto) stepped by one click; veto hides its whole zone even where a lit lamp
  claims it (DDR-FILTER-TOTALUNION, evaluate(..., vetoed) in catzc-track-lamps.js, \<lamp>-veto.svg icons).
- 2026-10-25 Cats: The lamp extension reinstalls itself into VS Code whenever the importer runs (a reload is the user's); catzc-track-lamps
  tests drive the pure JS functions through node.
- 2026-10-25 Cats: Token tip: read catzc-track-lamps.js once whole (about 640 lines) and edit it in place; its tests and the manifest test
  already cover icons, commands and menus.
- 2026-10-25 Cats: Token tip: write a run script under out/ with its own Set-Location, since the Bash session cwd can drift into a module
  folder.
- 2026-10-25 Cats: In hindsight I wish I knew this fact: a generated-file writer is due only when an output is missing or its declared
  inputs' stamp changed (Catzc.Base.GeneratedFiles), never because the tree is dirty.
- 2026-10-25 Cats: In hindsight I wish I knew this fact: Write-FileIfChanged leaves an output's mtime untouched when the render is equal, so
  an mtime comparison can never decide whether a writer is due.
- 2026-10-25 Cats: In hindsight I wish I knew this fact: Get-InputStamp -By Metadata stamps path, ticks and size for speed, while the
  file-meta cache keeps -By Content so a checkout does not re-imprint the tree.
- 2026-10-25 Cats: In hindsight I wish I knew this fact: an authored source head is only docs plus header: "generated"; a warning belongs to
  a wholly generated file's immutable head alone.
- 2026-10-25 Cats: In hindsight I wish I knew this fact: two adjacent comment lines reach the export threshold (min_lines 2), so Format-Code
  moves both to the comment page.
- 2026-10-25 Cats: In hindsight I wish I knew this fact: a C# type edit on disk breaks every session's import until all its callers match; a
  staged copy swapped in once avoids the window.
- 2026-10-25 Cats: In hindsight I wish I knew this fact: the link-direction rows only allow or deny edges that exist; requiring an edge
  needs the require verdict, and aspect facts stay in the aspect gates.
- 2026-10-25 Cats: In hindsight I wish I knew this fact: Format-Code renumbers an ordered plan list, so plan steps cross-reference each
  other by name, never by number.
- 2026-10-25 Cats: Token tip: Next time, save tokens by: orchestrating peers from the main session directly instead of a relay subagent that
  cannot see their replies.
- 2026-10-25 Cats: Token tip: Next time, save tokens by: summarising a worker's line list with a sample instead of echoing every line back.
- 2026-10-25 Cats: In hindsight I wish I knew this fact: the DRS has no C0-C4 zoom; diagrams cross only the closed lenses list in
  python/catzc_diagrams/configs.
- 2026-10-25 Cats: In hindsight I wish I knew this fact: Test-Plans rejects a plan head target that does not exist yet and a check naming an
  unexported command; the DRS gate is Test-DrsRegistry.
- 2026-10-25 Cats: In hindsight I wish I knew this fact: the meta queries already exist (Get-Track, Get-TrackPlace, Get-Aspect,
  Get-ModuleDependencyEdges, Get-LinkEdge, Get-DrsDomainEdges).
- 2026-10-25 Cats: Token tip: write the out/ script before starting its background run.
- 2026-10-25 Cats: Token tip: list exported Test-* names with ls pwsh/*/ before naming a check in a plan.
- 2026-10-25 Cats: In hindsight I wish I knew this fact: renaming a member of a C# type that the importer compiles breaks every session the
  moment the file is saved, so a type and every reference to it must land in one edit or a staged copy.
- 2026-10-25 Cats: In hindsight I wish I knew this fact: an insight line placed directly next to another comment line reaches the export
  threshold (min_lines: 2) and Format-Code moves both lines to the comment page.
- 2026-10-25 Cats: In hindsight I wish I knew this fact: Get-ScopeLookup resolves a relative -Path from the caller's location only when it
  is inside the repository root; a snapshot run resolves from the root.
- 2026-10-25 Cats: In hindsight I wish I knew this fact: Format-Code over the whole tree takes about 40 to 80 seconds and fits one run-lock
  burst, so the head rollout needs no sweep script.
- 2026-10-25 Cats: In hindsight I wish I knew this fact: once most files are already modified, git status cannot tell what a new Format-Code
  run changed; a copy of the tracked files taken before the run can.
- 2026-10-25 Cats: In hindsight I wish I knew this fact: inside a PowerShell double-quoted string, a $( ) subexpression containing a
  single-quoted literal with "(" fails to parse; assign the value to a variable first.
- 2026-10-25 Cats: Token tip: Next time, save tokens by: reading every comment section of a module at once with out/drone27-sections.ps1,
  which prints each anchor, its code line and the line above, instead of grepping file by file.
