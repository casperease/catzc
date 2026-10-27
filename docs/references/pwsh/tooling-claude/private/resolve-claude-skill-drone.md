# pwsh/Tooling.Claude/private/Resolve-ClaudeSkillDrone.ps1

Names the drone a job skill runs on, from the `model_floor` in the skill's front matter: each model has one drone.

## help

### synopsis

Returns the drone agent a skill's model floor names.

### description

Reads `.claude/skills/<Skill>/SKILL.md`, takes `metadata.catzc.config.model_floor` from its front matter, and returns `drone-<floor>`.
Throws when the skill, its front matter or a floor of haiku, sonnet, opus or fable is missing.

### parameter `Skill`

The skill's folder name under `.claude/skills`.

### parameter `RepositoryRoot`

The repository root the skills folder is under.

### outputs

`[string]` the drone agent's name, such as `drone-sonnet`.
