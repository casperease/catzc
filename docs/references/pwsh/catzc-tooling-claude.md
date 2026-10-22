# Catzc.Tooling.Claude

The Claude module of the Tooling group: it starts new Claude Code worker sessions, each in a terminal window of its own, so a coordinator or
the user opens several workers in one call instead of by hand. It starts sessions and interprets nothing. Like
[Catzc.Tooling.Inspiration](catzc-tooling-inspiration.md), it installs nothing, so it rests only on the `Base` group.

## Responsibilities

| Responsibility   | Area    | Name                                                                           |
| ---------------- | ------- | ------------------------------------------------------------------------------ |
| responsibility:1 | start   | [Start worker sessions](#responsibility1--start-worker-sessions)               |
| responsibility:2 | declare | [Declare the session settings](#responsibility2--declare-the-session-settings) |

### responsibility:1 — Start worker sessions

Open `Count` terminals, each running `claude --agent <Agent>` in the repository root, with a model only when one is asked for and an
optional first prompt. A dry run starts nothing and returns the command lines.

### responsibility:2 — Declare the session settings

The default agent and the terminal launcher are entries in `configs/claude-worker.yml`, each default declared once on its config type
([sensible-defaults](../../drs/automation/sensible-defaults.md)).

## What the module does

Starting a session is deterministic, so it is a command: it resolves the agent and the terminal as a setting resolves anywhere in catzc, the
caller's value first, then the config entry, then the default declared on the config type
([sensible-defaults](../../drs/automation/sensible-defaults.md)). A model is passed only when asked for, so the agent file's model applies
otherwise. The launch is shown before it is made: `-DryRun` returns each planned command line and starts nothing
([prefer-dryrun-over-shouldprocess](../../drs/automation/pwsh/prefer-dryrun-over-shouldprocess.md)).

## Division

The module's public functions, sorted into the responsibilities above.

| Responsibility                                  | Function             |
| ----------------------------------------------- | -------------------- |
| responsibility:1 — Start worker sessions        | `Start-ClaudeWorker` |
| responsibility:2 — Declare the session settings | `claude-worker.yml`  |
