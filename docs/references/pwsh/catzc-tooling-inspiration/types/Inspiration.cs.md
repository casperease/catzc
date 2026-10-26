# pwsh/Tooling.Inspiration/types/Inspiration.cs

One inspiration as `Get-Inspiration` reports it on this machine: its id, where its root resolves here, whether that root exists, what it is,
and the folders inside it worth reading
([ADR-REPO-INSPIRE-SIBLINGFORIDEAS](../../../../drs/repository/inspiration.md#rule-adr-repo-inspire-siblingforideas)).

## Absent inspirations

An inspiration that is absent is reported with `Available` false, never thrown on: the work carries on without it.

## Root

`Root` is absolute. An inspiration lives outside the repository, so no repository-relative form exists and the path degrades to a normalized
absolute ([ADR-AUTO-PATH-FOREIGNPATHS](../../../../drs/automation/path-representation.md#rule-adr-auto-path-foreignpaths)). The stored,
portable form stays in `inspiration.yml`.
