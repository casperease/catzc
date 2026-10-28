# pwsh/Base.Drs/types/DrsDomainEdge.cs

One edge of the DRS domain dependency graph from `drs.yml`: `From` depends on `To`, one per declared `depends_on` link. `DrsConfig` builds
it from the domains it has already validated and exposes it as `DrsConfig.Edges`.

## Invariant

The constructor holds the edge's own invariant: both ends are non-empty and distinct, so there is no self-edge
([ADR-BCL-TYPES-NATIVETYPEDMODEL](../../../../drs/automation/BCL/native-csharp-types.md#rule-adr-bcl-types-nativetypedmodel)).
