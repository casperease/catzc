---
task:
  id: "008"
  status: open
  plans: [plan-plans-body-sha-landing-zone]
  value: highest
  blocked_on: step 4 is the user's git rm
  targets: [.unordered, automation, docs/adr/design/tracks.md, .gitattributes]
---

# task008: the .unordered binding audit and the deletion of the 20 finished plans

Decided Q09: the 20 plans in `.unordered/15-10-2026` are deleted now (still present on 2026-10-17). Decided: `.unordered` becomes the import
landing zone (T009), so every binding to it is audited first, read-only. Measured 2026-10-17: 12 non-markdown files name `.unordered`
(GlossaryConfig.Tests.ps1, GlossaryOptions.cs, file-kinds.yml, globs.yml, source-conventions.yml, Export-SpellingTriage.ps1,
Get-TerminologyCorpus.ps1, Test-Markdownlint.ps1, Test-Spelling.ps1, variants.yml, Get-Track.Tests.ps1, .gitattributes) and 283 markdown
files, most of them plans and comment pages.

## Steps

1. Audit, read-only, one file per line in `plan-plans-body-sha-landing-zone.md` under a new "Binding audit" section: for each of the 12
   code and config files, the line, what it does with `.unordered`, and a verdict: `go` for a measure, a track getter or a default that
   reads it; `stay` for a scan exclusion where the tool walks the disk and not the git index (ADR-AUTO-TRACKED); `track` for the tracks
   registry entry in variants.yml (the unordered track class stays, imported content is tracked). Check: 12 verdict lines.
2. The 283 markdown mentions: count by folder (`grep -rl .unordered docs automation --include=*.md | cut -d/ -f1-3 | sort | uniq -c`), record
   the counts, and name only the authored pages (ADRs, how-tos, explanations) that state the old meaning ("frozen fragments, finished
   plans"): tracks.md rule 17, track-types.md, the glossary source. Comment pages and plans are not edited here. Check: a counts table and a
   list of at most ten authored pages in the plan.
3. Write `out/delete-unordered-15-10-2026.ps1`: `git rm -r .unordered/15-10-2026` and nothing else, with a comment naming Q09. Check: the
   script has one git command.
4. The user runs the script and commits. Check: `ls .unordered` shows no `15-10-2026`.
5. After step 4: `plan-plans-body-sha-landing-zone.md` ticks the audit and deletion steps; the `.unordered` target stays in its head for
   T009. Check: grep `- [ ]` in the plan counts the T009 and T010 steps only.

## Report

As report-fixed; the verdict table verbatim.
