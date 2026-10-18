# automation/Catzc.Base.RootConfig/private/Get-RootConfigTargets.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its
comment sat above (Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Resolves the rootconfig registry into the list of opted-in managed root files Build-RootConfig generates.

### description

Filters the validated registry (Get-Config -Config rootconfig) down to the entries with optIn true — the
files the automation actually manages. Opted-out entries are inert: validated for shape when the config
loads, but neither written nor treated as owned. The full registry semantics live in
configs/rootconfig.yml; see [ADR-REPO-ROOTCFG](../../../../adr/repository/generated-root-configs.md).

### parameter Config

The parsed rootconfig config (Get-Config -Config rootconfig): a `{ files }` object.

### outputs

`[object[]]` The opted-in RootConfigFile entries, in registry order.
