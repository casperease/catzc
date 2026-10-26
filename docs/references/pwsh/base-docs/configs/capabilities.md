# pwsh/Base.Docs/configs/capabilities.yml

The capability registry: one entry per capability `.claude/skills/<name>/SKILL.md`, naming the rules behind it and the checks it runs or
guards. The model floor is not here; it lives once in the capability file's own metadata, and `Test-AgentDefinitions` enforces it.
