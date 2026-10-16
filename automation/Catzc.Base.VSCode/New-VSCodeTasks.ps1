<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Base.VSCode/New-VSCodeTasks.ps1
    name: new-vs-code-tasks
    filetype: ps1
    kind: function
    subkind: writer
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Base.VSCode
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  edges:
    test: automation/Catzc.Base.VSCode/tests/New-VSCodeTasks.Tests.ps1
    cites:
      - ADR-REPO-ROOTCFG
  config:
    synopsis: |-
      Renders .vscode/tasks.json content from the vscode-tasks registry — the tasks the editor offers, such as the
      fast push.
    description: |-
      Reads the authored task registry (configs/vscode-tasks.yml, via Get-Config -Config vscode-tasks, which maps and
      validates it as a VscodeTasksConfig) and renders it to the tasks.json content: the version, tasks, and inputs as
      JSON, in registry order, without a head (Build-RootConfig writes the generated-file head as a JSONC comment head,
      which VS Code reads in tasks.json). The explanations live as comments in the yml, not in the rendering.

      This is a pure renderer: it returns the content and writes nothing — it is the `generator` the
      root-config registry names for the .vscode/tasks.json target, and Build-RootConfig owns the write.
      See [ADR-REPO-ROOTCFG](/docs/adr/repository/generated-root-configs.md).
    outputs: '[string] The rendered tasks.json content (LF-joined; the writer canonicalises).'
    examples:
      - New-VSCodeTasks
---
#>

function New-VSCodeTasks {
    [CmdletBinding()]
    [OutputType([string])]
    param()

    $config = Get-Config -Config vscode-tasks

    $rendered = [ordered]@{
        version = $config.version
        tasks   = @($config.tasks)
    }
    if ($config.inputs.Count) {
        $rendered['inputs'] = @($config.inputs)
    }

    (ConvertTo-Json -InputObject $rendered -Depth 8) + "`n"
}
