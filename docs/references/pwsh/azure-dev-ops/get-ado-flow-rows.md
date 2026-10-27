# pwsh/Azure.DevOps/Get-AdoFlowRows.ps1

The ADO reader of the flow lens: it turns a flow diagram's pipeline files into the one row the renderer lays out, so the diagram never
parses pipeline YAML and never declares what the files already say.

## help

### synopsis

Returns the flow lens's row for a set of ADO pipeline files: one lane per pipeline, its environments and the edges between lanes.

### description

The ADO engine's reader for a flow diagram ([DDR-VISUAL-FLOWISALENS](../../../drs/design/visual-design.md#rule-ddr-visual-flowisalens)). The
point is the diagram's `about.point`: one or more repository-relative pipeline files, separated by `;`. Each file becomes a lane: its
pipeline type and unit from the file name's prefix (ci-, cd-, cde-, deploy-, cron-, input-), its triggers from the top-level `trigger:`,
`pr:` and `schedules:` keys (a lane with none is run by hand, and a pull request marks it for review), and its templates with the kind each
one's folder gives (extends, stage, job, step, variables).

A lane's environments come from the rungs registry, never from the YAML, whose deploy stages name their environment through template
expressions: a CD lane holds the rungs with no gate, a DEPLOY lane the gated ones, each named `<unit>-<rung>` and marked for approval when
its gate is not none. A deploy lane is pinned to the cd lane of the same unit, an edge with the word `pins`, since nothing in its trigger
points back.

### parameter `Point`

The pipeline files, repository-relative and separated by `;`, in the order their lanes are drawn.

### parameter `RepositoryRoot`

The repository the files are read from. Defaults to the loaded repository root.

### outputs

`[System.Collections.Specialized.OrderedDictionary]` One row: point, lens (`flow`), lanes and edges.

### example 1

```powershell
Get-AdoFlowRows -Point '.ado/pipelines/ci-pwsh.yaml;.ado/pipelines/cd-apex.yaml;.ado/pipelines/deploy-apex.yaml'
```
