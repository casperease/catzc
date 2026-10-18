# automation/Catzc.Base.Globs/private/Get-PipelineTrigger.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Reads a pipeline or workflow YAML's trigger path filters — the actual, on-disk trigger globs.

### description

The counterpart to Get-GlobSetTrigger (which computes what a pipeline's trigger SHOULD be): this reads what it actually IS, so an integrity
quality gate can compare the two (Test-AdoPipelineTriggerGlob / Test-GitHubWorkflowTriggerGlob,
[ADR-FLOW-CD-GLOBS](../../../../adr/flow/durable-sha-globs.md)). Parses the file with ConvertFrom-Yaml and pulls the filters:

- Ado: trigger.paths.include/exclude and pr.paths.include/exclude.
- GitHub: on.push.paths and on.pull_request.paths. YAML 1.1 parses the bare key 'on' as the boolean true, so both the string key 'on' and
  the boolean key are tried.

A missing section comes back as an empty array, never $null, so a caller compares without null guards.

### parameter `Path`

The pipeline/workflow YAML file to read (absolute path).

### parameter `Vendor`

Ado or GitHub — which dialect's trigger keys to extract.

### outputs

`[pscustomobject]` Ado: { TriggerInclude; TriggerExclude; PrInclude; PrExclude }.

```text
GitHub: { PushPaths; PrPaths }.
```
