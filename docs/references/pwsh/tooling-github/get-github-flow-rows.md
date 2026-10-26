# pwsh/Tooling.Github/Get-GithubFlowRows.ps1

The GitHub reader of the flow lens: it turns a flow diagram's workflow files into the one row the renderer lays out, so the diagram never
parses workflow YAML and never declares what the files already say.

## help

### synopsis

Returns the flow lens's row for a set of GitHub workflow files: one lane per workflow, with its triggers, jobs, steps and environments.

### description

The GitHub engine's reader for a flow diagram ([DDR-VISUAL-FLOWISALENS](../../../drs/design/visual-design.md#rule-ddr-visual-flowisalens)).
The point is the diagram's `about.point`: one or more repository-relative workflow files, separated by `;`. Each file becomes a lane: its
pipeline type and unit from the file name's prefix, its triggers from the `on` events (push, pull request, schedule, and a manual dispatch;
a pull request marks it for review), each job and its steps (a step by its name, else by the action it uses), and the environment a job
names. The row has the shape the ADO reader returns, with no edges.

### parameter `Point`

The workflow files, repository-relative and separated by `;`, in the order their lanes are drawn.

### parameter `RepositoryRoot`

The repository the files are read from. Defaults to the loaded repository root.

### outputs

`[System.Collections.Specialized.OrderedDictionary]` One row: point, lens (`flow`), lanes and edges.

### example 1

```powershell
Get-GithubFlowRows -Point '.github/workflows/ci-pwsh.yml'
```
