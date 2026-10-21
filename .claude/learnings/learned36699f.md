# Session learnings 36699f

Started 2026-10-21T20:42:19.8972026+02:00.

- 2026-10-21 Cats: In hindsight I wish I knew this fact: Python subprocess text output on this devbox decodes in the Windows code page
  unless encoding=utf-8 is named, so a git show compare reports false differences on every non-ASCII yml.
- 2026-10-21 Cats: In hindsight I wish I knew this fact: Get-Config, the ADO auth header function, the importer and the bash hook now cite
  their rules, so they light on the minimaps.
- 2026-10-21 Cats: Token tip: Next time, save tokens by: diffing one suspected loss byte-wise before trusting a bulk compare that reports
  many.
- 2026-10-21 Cats: Token tip: Next time, save tokens by: asking for the final shape of a cross-cutting record before writing its first
  hundred entries.
- 2026-10-21 Cats: In hindsight I wish I knew this fact: a code head's cites: derives only for the file classes the adr-codes select in
  file-meta.yml names (type, function, config, hook, module/internal; test, fixture, asset for powershell); a page citing rules for any
  other class lights nothing.
- 2026-10-21 Cats: In hindsight I wish I knew this fact: a file's class is (Get-Config -Config file-kinds).Resolve(\<path>).Class, and
  Get-FileMetaFact -Path shows the cites a file derives, both without editing anything.
- 2026-10-21 Cats: In hindsight I wish I knew this fact: Test-Slides requires a quotes: slide's body to equal the registry rule verbatim,
  and the rule pattern holds at most 70 words split on whitespace, so a spaced dash counts as a word.
- 2026-10-21 Cats: In hindsight I wish I knew this fact: the spelled file types are the languages.yml languages whose checks list
  Test-Spelling, read through LanguagesConfig.ExtensionsCheckedBy('Test-Spelling').
- 2026-10-21 Cats: In hindsight I wish I knew this fact: the full-repository case of Test-Spelling.Tests is skipped while the repository
  globset is protected, so touching any spelled file re-runs it and surfaces every old unapproved word.
- 2026-10-21 Cats: In hindsight I wish I knew this fact: the reserved category's scope globs in terminology.yml match case-sensitively;
  _accosted_ does not cover a ConvertTo-AccostedCallText page.
- 2026-10-21 Cats: In hindsight I wish I knew this fact: 'comman' in GitFlowConfig.cs is a deliberate prefix of pwsh's -Command switch,
  approved as a powershell term, not a typo.
- 2026-10-21 Cats: Token tip: Next time, save tokens by: probing a file's class and derived facts with file-kinds Resolve and
  Get-FileMetaFact before writing any citation text.
- 2026-10-21 Cats: Token tip: Next time, save tokens by: putting a whole burst (edit check, fresh import, format, gates, tests) in one out/
  script so the import runs once.
- 2026-10-21 Cats: In hindsight I wish I knew this fact: a code head's docs edge is built from the link template `[{leaf}]({path})` in
  QualityGates configs/file-meta.yml, and {path} is repository-relative, so the link breaks from the file's folder.
- 2026-10-21 Cats: In hindsight I wish I knew this fact: a head's cites include every registered code its comment page cites, so an
  unexpected cite like ADR-AZ-CUSTOMER-REFERENCENOTVALIDATEDONLOAD on a QualityGates type comes from its page, not an error.
- 2026-10-21 Cats: In hindsight I wish I knew this fact: Test-Plans fails an open step that names no check (ADR-REPO-PLANS-OPENSTEP), and a
  new plan also needs its value-of-plan.md row and plan-master.md chunk line.
- 2026-10-21 Cats: Token tip: Next time, save tokens by: writing one out/ script for Format-Code plus Test-Plans on the exact plan files
  before the first plan edit, instead of guessing an existing script name.
- 2026-10-21 Cats: Token tip: Next time, save tokens by: waiting for a background run's notification instead of polling its output file or
  reaching for Monitor.
