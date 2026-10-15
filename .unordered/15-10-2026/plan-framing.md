# Plan: the framing ADR, open questions

The framing (thesis) ADR is written, its placement is decided, and depended-on contract versions version with the bundle
(`contracts/<unit>/<version>/<module>/`). Two questions remain for the user:

1. **Adjacent stores.** Does catzc have, or plan, any adjacent repositories that its pipelines drive?
2. **Queryable surface.** Is the PowerShell `Get-*` surface _the_ query interface, or should it also export data (JSON or a graph) that
   service-management tools read?
