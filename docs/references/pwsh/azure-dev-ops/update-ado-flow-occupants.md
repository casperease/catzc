# pwsh/Azure.DevOps/Update-AdoFlowOccupants.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading. Prose written above the first section survives every
later export.

## help

### synopsis

Writes the latest successfully deployed commit of each environment of a flow declaration into its `about.occupants`.

### description

Reads the declaration's `about.point` to find the pipeline, lists the environments of its lanes (Get-AdoFlowRows), and asks Azure DevOps for
each environment's deployment records. The occupant of an environment is the commit of its latest succeeded deployment, resolved through
Resolve-AdoRunCommit. The old `about.occupants` map is replaced by the freshly read one and the file is written only when it changed. An
environment Azure DevOps does not know, or that has no succeeded deployment, has no entry. Throws when the file has no `about:` block or no
`about.point`. Supports `-WhatIf`.

### parameter `Path`

The flow declaration file whose `about.occupants` is written.

### parameter `Project`

The Azure DevOps project. Defaults to the `project` of ado.yml.

### parameter `Organization`

The Azure DevOps organization URL. Defaults to the `organization` of ado.yml.

### parameter `Top`

How many deployment records to read per environment, newest first. Default 50, from 1 to 1000.

### parameter `RepositoryRoot`

The repository root the flow rows are read from. Defaults to the current repository.

### outputs

`[System.Collections.Specialized.OrderedDictionary]` The occupants written: environment id to commit.

### example 1

```powershell
Update-AdoFlowOccupants -Path docs/flows/delivery.yml
```

## comment:1

Above `$block = [System.Collections.Generic.List[string]]::new()`, written with `#`.

```text
The occupants are an input of the declaration, never a row
([TDR-STORES-FACTSOURCEREADONLY](/docs/drs/thesis/truth-stores.md#rule-tdr-stores-factsourcereadonly)): the old
map goes, the read one takes its place.
```
