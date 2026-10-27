# Catzc.Tooling.Claude

The Claude module of the Tooling group: it starts new Claude Code drone sessions, each in a terminal window of its own, so a coordinator or
the user opens several drones in one call instead of by hand, and it keeps one editor at a time on a shared config. It starts sessions and
interprets nothing. Like [Catzc.Tooling.Inspiration](../tooling-inspiration/index.md), it installs nothing, so it rests only on the `Base`
group.

## Responsibilities

| Responsibility   | Area    | Name                                                                           |
| ---------------- | ------- | ------------------------------------------------------------------------------ |
| responsibility:1 | start   | [Start drone sessions](#responsibility1--start-drone-sessions)                 |
| responsibility:2 | declare | [Declare the session settings](#responsibility2--declare-the-session-settings) |
| responsibility:3 | claim   | [Claim a shared config](#responsibility3--claim-a-shared-config)               |

### responsibility:1 — Start drone sessions

Open `Count` terminals, each running `claude --agent <Agent>` in the repository root, with a model only when one is asked for and an
optional first prompt. A dry run starts nothing and returns the command lines.

### responsibility:2 — Declare the session settings

The default agent and the terminal launcher are entries in `configs/claude-drone.yml`, each default declared once on its config type
([sensible-defaults](../../../drs/automation/sensible-defaults.md)).

### responsibility:3 — Claim a shared config

Give one session at a time the edits of a shared config, one every session's next import reads: a file-backed claim, keyed by the file and
the session, lapses after the run lock's wait, and the `Assert-EditClaim` hook denies another session's Edit of the claimed file. The shared
configs are the `shared_configs` entry of `configs/editor-claims.yml`.

## What the module does

Starting a session is deterministic, so it is a command: it resolves the agent and the terminal as a setting resolves anywhere in catzc, the
caller's value first, then the config entry, then the default declared on the config type
([sensible-defaults](../../../drs/automation/sensible-defaults.md)). A model is passed only when asked for, so the agent file's model
applies otherwise. The launch is shown before it is made: `-DryRun` returns each planned command line and starts nothing
([prefer-dryrun-over-shouldprocess](../../../drs/automation/pwsh/prefer-dryrun-over-shouldprocess.md)).

## Division

The module's public functions, sorted into the responsibilities above.

| Responsibility                                  | Function              |
| ----------------------------------------------- | --------------------- |
| responsibility:1 — Start drone sessions         | `Start-ClaudeDrone`   |
| responsibility:2 — Declare the session settings | `claude-drone.yml`    |
| responsibility:3 — Claim a shared config        | `Lock-SharedConfig`   |
|                                                 | `Unlock-SharedConfig` |
| config                                          | `editor-claims.yml`   |
