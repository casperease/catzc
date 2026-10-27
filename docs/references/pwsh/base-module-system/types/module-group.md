# pwsh/Base.ModuleSystem/types/ModuleGroup.cs

One declared module group of `dependencies.yml` (`groups: <name>: <member>: [members]`): a named set of on-disk modules with its own
internal member-to-member graph. A group is a concept, not a disk module
([ADR-AUTO-DEPM-TWOSECTIONS](../../../../drs/automation/controlling-module-dependencies.md#rule-adr-auto-depm-twosections)).
`DependenciesConfig` builds one per group.

## Validation

Constructing a group maps and validates its member map and gathers every violation into one `ArgumentException`:

- the group maps to a map of member modules, not a list or a string;
- each member maps to a list of member names, not a single string;
- no member depends on itself, and every dependency is a member of the same group, so the group is closed;
- the internal member graph is acyclic.

Members match case-insensitively, like the PowerShell ordered dictionary the YAML parses into.

## Properties

- **`name`** — the group's name, its key under `groups:`.
- **`members`** — member module to the members it may depend on (`string[]`), in declaration order, read-only.
