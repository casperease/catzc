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
