# pwsh/Catzc.Base.QualityGates/New-Plan.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Starts a plan: writes `plan-<topic>.md` in the plans folder with its head and its open steps section, its value row and its master line.

### description

The way a plan starts ([ADR-REPO-PLANS-ONETOPICONEFILE](../../../drs/repository/plans.md#rule-adr-repo-plans-onetopiconefile)): the file it
writes carries the plan head (status active, the value, today's date as reviewed, the targets) and the sections
[ADR-REPO-PLANS-ONESHAPE](../../../drs/repository/plans.md#rule-adr-repo-plans-oneshape) requires, so Test-Plans passes it before a step is
written. A plan is three parts ([ADR-REPO-PLANS-THREEPARTS](../../../drs/repository/plans.md#rule-adr-repo-plans-threeparts)), so it also
adds the plan's row to the value overlay's table under the "`<Class>` plans" heading, and its chunk line to the master's Chunks list, ahead
of the pointer lines to task files, which the master keeps last; the planner moves the line to its place. It refuses a topic whose file
exists, a name the plans folder does not accept, a value outside the ranks, a target that does not exist, and an overlay without the section
the plan goes in.

### parameter `Topic`

The plan's topic in kebab case; the file is `plan-<topic>.md`.

### parameter `Value`

The plan's rank, one of the plans config's ranks.

### parameter `Class`

The plan's class, such as feature or meta.

### parameter `Target`

The repository-relative paths the plan changes, each one existing.

### parameter `Summary`

One line on what the plan delivers: the text of its master line, and the Why of its value row where the table has that column.

### parameter `NeededDocs`

The text of the value row's "Needed docs" cell where the table has that column. Default: empty, for the planner to fill.

### parameter `NeededTests`

The text of the value row's "Needed tests" cell where the table has that column. Default: empty, for the planner to fill.

### parameter `Config`

The plans config. Default: Get-Config -Config plans.

### parameter `RepositoryRoot`

The repository the plans folder and the targets are relative to. Default: the loaded repository root.

### outputs

`[string]` The full path of the plan file written.
