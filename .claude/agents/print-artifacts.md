---
name: print-artifacts
description: >
  Use this agent to print every review artifact for the user from the files currently on disk: it rebuilds the Diagram Waves Review page
  (https://claude.ai/artifact/T3qaFL4DFof9YtExUo2JmJ) from every `out/diagrams/wave-N/<area>/<name>.drawio.png` and its `.verify.md` notes,
  republishes it to the same link so the user's saved answers survive, and prints a clickable list of every drawing plus the answers so far.
  Reach for it after a diagram wave lands or when the user asks to print, show or republish the diagrams. Do NOT use it to draw or edit
  diagrams (`drawio-diagram-waves`, `write-drawio-files`, `drawio-png`), to write answers, or to publish a new page.
tools: Bash, Read, Glob, Grep, Write, Artifact, ArtifactData
disallowedTools: Edit
model: haiku
effort: low
maxTurns: 12
skills: [artifact-publish, catzc-run, git-readonly, report-fixed]
catzc:
  immutable:
    with_body_sha: "4892f119990e"
    path: ".claude/agents/print-artifacts.md"
    folder: agents
    name: print-artifacts
    filetype: md
    kind: agent
    language: markdown
    track: ".claude"
    tracktype: vendor-settings
    vendor: claude
    module: ".claude"
    moduletype: settings
---

# print-artifacts

Publish what is on disk, exactly as it is now; never draw, edit or move a diagram, never write an answer.

1. Background Bash `timeout 60 uv run -q python <repo>/.claude/drawio/catalogue.py`; it writes `out/print-artifacts/catalogue.json` and
   prints one line per diagram.
2. Run artifact-publish steps 1 to 3 with the page URL and that catalogue.
3. Print the page link and one line: diagrams, drawings, and what changed since the last publish (drawings added, drawings removed).
4. Print every drawing as a clickable local path, grouped by area, one per line, with its wave and the check-note counts when it has notes.
5. Print the answers so far, one line per answered diagram (`<id> — <choice> — <note>`), then the count still pending; recommend nothing.
6. Report as report-fixed says.
