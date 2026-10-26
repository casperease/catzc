# pwsh/Base.QualityGates/private/Update-PlanStepCount.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Rewrites the step counts the master and the value overlay state from each plan's open steps, so striking a step never needs a hand sync.

### description

The plan-counts imprint step of Format-Code. In the master, a chunk line names its plan after `->`, and the first line of the item that
states a count has it rewritten. In the value overlay, a row names its plan's topic in its second cell, and its last cell's count is
rewritten. The phrase keeps its first letter's case; a line or cell that states no count, a count that is already right, and a plan with no
file are left as they are. A file keeps its line ends. Test-Plans still reports a count left stale, such as one split across two lines.

### parameter `Folder`

The plans folder whose overlays are rewritten.

### parameter `Config`

The plans settings, which name the master and the value file.

### parameter `DryRun`

Report the files that would change, and write none.

### outputs

`[string[]]` the overlay files changed, or that would change.

## comment:1

Above `$rewrite = {`, written with `#`.

```text
The stated phrase becomes the plan's count, its first letter's case kept; a text that states none is left as it
is.
```

## comment:2

Above `$master = Join-Path $Folder $Config.master_file`, written with `#`.

```text
A chunk line of the master names its plan after '->'; the phrase is read across the item's lines, so a count
Prettier wrapped is found.
```
