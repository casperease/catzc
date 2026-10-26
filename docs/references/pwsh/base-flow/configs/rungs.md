# pwsh/Base.Flow/configs/rungs.yml

The promotion ladder a commit climbs, in climbing order: each rung with the configuration environment it deploys, the gate a commit clears
to enter it, and the rule codes that define it.

## Keys

Every key is optional: an omitted `rungs` takes the ladder declared once on `RungsConfig.DefaultRungs`, so remapping a rung is a one-line
edit there. A repository with its own ladder states it here as
`rungs: { <rung>: { environment: <env>, gate: <gate>, rules: [<code>, ...] }, ... }`:

- `environment` is the configuration slot the rung deploys; a unit's ADO environment for the rung is `<unit>-<rung>`.
- `gate` is what a commit clears to enter the rung: `none`, `rc`, `rbc` or `prod-approval`.
- `rules` lists the rule codes that define the rung, so a file that cites one of them, or the record that holds it, concerns the rung.
