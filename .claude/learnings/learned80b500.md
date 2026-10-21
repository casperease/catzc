# Session learnings 80b500

Started 2026-10-21T02:21:00.2535622+02:00.

- 2026-10-21: The markdown formatter rewraps any list line past 140 columns, so code that reads its own markdown back treats indented
  continuation lines as part of the item.
- 2026-10-21: Format-MarkdownParagraph returns its lines as one array object; pipe it through ForEach-Object before joining.
- 2026-10-21: `[System.IO.File]::ReadLines($f) | Select-Object -First 1` leaves the file open; read the whole file before writing to it.
- 2026-10-21: markdownlint (MD033) reads a `<word>` outside code spans as inline HTML; escape it as `\<`.
- 2026-10-21: Session learnings live in .claude/learnings/ as learned\<sha>.md files ordered by their Started line; Add-SessionLearning
  writes them, 5 files of 50.
- 2026-10-21: A thesis ADR may cite only research and thesis rules (adrs.yml depends_on), and Test-AdrRegistry fails any other citation, so
  later-domain ideas appear there as plain words.
- 2026-10-21: Test-Glossary (G1) requires a contrast written on both terms, in each owning module's glossary.yml, even across modules.
- 2026-10-21: Test-Links reports a link to an existing but uncommitted file as an error, so a new ADR always shows one finding until it is
  committed.
- 2026-10-21: Adding an ADR touches the page, the adrs.yml ruleset and domain description, Build-AdrIndex, glossary.yml with Build-Glossary,
  the domain's dora-explains.md, and Format-Code; no how-to lists these.
- 2026-10-21: A background Bash call takes one command after its timeout prefix, so running several catzc gates needs a script file under
  out/.
- 2026-10-21: plan-master.md and value-of-plan.md are edited by several sessions at once; a new plan adds one master line and one value row
  without touching other lines.
- 2026-10-21: "eac" names both everything as code (ADR-PRIN-EAC, the eac normal form) and the sibling repository C:\projects\eac.
- 2026-10-21: "repository normal form" (ADR-AUTO-IDIOM) is a name's spelling, while "eac normal form" (ADR-THES-NORMALFORM) is the
  verifiable shape of a whole piece of code.
- 2026-10-21: Token tip: read docs/references/pwsh/index.md and file-kinds.yml before designing a feature; most parts already exist, and a
  design round on a part that exists is the costliest waste.
- 2026-10-21: Token tip: run every check of a round in one out/ script with one fresh import, not one background call per gate or test file.
- 2026-10-21: Token tip: read a failed test's cause straight from its results XML (grep the \<failure> message), not by listing artifacts
  first.
- 2026-10-21: Each session appends its own learnings and token tips with Add-SessionLearning; lines relayed through another session get
  logged twice.
- 2026-10-21: Token tip: start every out/ script with Set-Location (Get-RepositoryRoot) after the import, since the shell's working folder
  drifts between calls and a relative path then fails.
