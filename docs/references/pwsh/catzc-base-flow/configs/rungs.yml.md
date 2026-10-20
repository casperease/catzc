# pwsh/Catzc.Base.Flow/configs/rungs.yml

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

At the end of the file, written with `#`.

```text
The promotion ladder a commit climbs, in climbing order. Every key is optional: an omitted `rungs` takes the ladder declared once on
RungsConfig.DefaultRungs, so remapping a rung is a one-line edit there. A repository with its own ladder states it here as
`rungs: { <rung>: { environment: <env>, gate: <gate>, rules: [<code>, ...] }, ... }`. A rung's ADO environment is `<unit>-<rung>`;
`environment` is the configuration slot it deploys; `gate` is what a commit clears to enter it: none, rc, rbc or prod-approval; `rules`
lists the ADR rule codes that define the rung, so a file that cites one of them, or the ADR that holds it, concerns the rung.
```
