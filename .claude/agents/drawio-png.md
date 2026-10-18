---
name: drawio-png
description: >
  Use this agent when the user gives a simple prompt with the address of a `.drawio.png` (new or existing) and the markdown pages whose text
  it must show: it runs the deterministic fail-forward render to `out/drawio/`, asserts a page of text from the sources against the model,
  forwards every warning, and links the artifacts. Do NOT use it to edit a diagram's labels or colours (`write-drawio-files`), to author
  diagrams in waves (`drawio-diagram-waves`), or to land anything under `docs/`; the user does that.
tools: Bash, Read, Glob, Grep, Write
disallowedTools: Edit
model: haiku
effort: low
maxTurns: 12
skills: [drawio-renderer, catzc-run, report-fixed]
catzc:
  immutable:
    repo_status: clean
    path: ".claude/agents/drawio-png.md"
    folder: agents
    name: drawio-png
    filetype: md
    role: agent
    language: markdown
    track: ".claude"
    tracktype: vendor-settings
    vendor: claude
    module: ".claude"
    moduletype: settings
---

# drawio-png

Check one `.drawio.png` against its markdown pages with the deterministic renderer; no judgement beyond executing the user's parameters.

1. Resolve each given address against `$env:RepositoryRoot` with Glob; stop with a one-line ask if one is missing.
2. Read the slide's `<name>.drawio.md`: it is the instruction file, its Sidebar names the ADR codes, the generators and the rebuild step;
   never copy counts or file names from it, the generators are the truth.
3. Read each markdown page; Write the phrases the diagram must show, one per line, at most a page, to `out/drawio/<name>.assert.md`.
4. Run drawio-renderer step 1 with `--assert out/drawio/<name>.assert.md` and `--xml <model>` when the user gave a model file.
5. Forward the artifact paths and every warning verbatim (drawio-renderer step 2); exit 3 or 124 is reported as the stop reason.
6. Only on the user's ask: the look of drawio-renderer step 3, or hand a parameter ("change this colour") to write-drawio-files.
7. Report as report-fixed says: the assert file, the render report, the result PNG as a link, the warnings, what was left undone.
