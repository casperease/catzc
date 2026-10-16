<#
---
catzc:
  immutable:
    path: automation/Catzc.Base.RootConfig/private/Invoke-RootConfigGenerator.ps1
    folder: private
    name: invoke-root-config-generator
    filetype: ps1
    kind: function
    language: powershell
    track: automation
    module: Catzc.Base.RootConfig
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: private
  edges:
    page: docs/references/automation/catzc-base-rootconfig/private/Invoke-RootConfigGenerator.ps1.md
    cites:
      - ADR-AUTO-GO#6
      - ADR-AUTO-PY#4
      - ADR-REPO-FORMAT#8
  config:
    synopsis: Renders the content of a generator-produced managed root file — the registry's generator dispatch.
    description: |-
      A rootconfig entry with a `generator` names a function that renders the target's whole content (header
      included) rather than an authored source file to copy. This dispatch is the one place a generator name is
      bound to its invocation, so Build-RootConfig stays generic and an unknown name fails loudly instead of
      invoking an arbitrary command. Each generator is called in its content-returning form (never its writing
      form) — Build-RootConfig owns the write, through the same Write-FileIfChanged path as every copy-in.

      A generator returns either one string (the content of the entry's single target) or one { Target; Content }
      record per file it renders (a multi-file generator, e.g. New-GoWorkspace with its
      Catzc.Base.Languages.GoWorkspaceFile records). The entry's target is passed on, so a multi-file generator
      renders only the files the entry names; a wildcard target (e.g. go/tests/*/go.mod) selects a set of files.
    parameters:
      Name: The generator function name from the registry entry (e.g. 'New-Importer').
      Target: 'The entry''s target: a repository-relative path, or a wildcard pattern over a multi-file generator''s files.'
    outputs: '[string] The rendered target content, or [object[]] one { Target; Content } record per rendered file.'
---
#>

function Invoke-RootConfigGenerator {
    [OutputType([string], [object[]])]
    param(
        [Parameter(Mandatory)]
        [string] $Name,

        [Parameter(Mandatory)]
        [string] $Target
    )

    switch ($Name) {
        'New-Importer' {
            New-Importer -DryRun
        }
        'New-GitIgnore' {
            $config = Get-Config -Config rootconfig
            $ignoredCopies = @(foreach ($entry in @(Get-RootConfigTargets -Config $config)) {
                    if (-not $entry.committed) {
                        '/' + $entry.target
                    }
                })
            New-GitIgnore -Inject @{ 'rootconfig-committed-false' = $ignoredCopies }
        }
        'New-GitAttributes' {
            New-GitAttributes
        }
        'New-VSCodeSettings' {
            $config = Get-Config -Config rootconfig
            $managedTargets = @(foreach ($entry in @(Get-RootConfigTargets -Config $config)) {
                    $entry.target
                })
            $machineSetting = @{}
            $go = Resolve-ToolExecutable -Tool go
            if ($go.Found -and $go.VersionOk) {
                $machineSetting['go.goroot'] = [System.IO.Path]::GetDirectoryName([System.IO.Path]::GetDirectoryName($go.Path))
            }
            $pythonRoot = (Get-Config -Config python).ResolveRoot((Get-RepositoryRoot))
            $machineSetting['python.defaultInterpreterPath'] = if ($IsWindows) {
                "`${workspaceFolder}/$pythonRoot/.venv/Scripts/python.exe"
            }
            else {
                "`${workspaceFolder}/$pythonRoot/.venv/bin/python"
            }
            $languageFormatter = [ordered]@{}
            $editorFormatters = (Get-Config -Config languages).EditorFormatters()
            foreach ($id in $editorFormatters.Keys) {
                $languageFormatter[$id] = $editorFormatters[$id]
            }
            New-VSCodeSettings -ManagedTarget $managedTargets -MachineSetting $machineSetting -LanguageFormatter $languageFormatter
        }
        'New-VSCodeExtensions' {
            $engineExtension = @((Get-Config -Config languages).engines.Values | Where-Object vscode_extension | ForEach-Object vscode_extension)
            New-VSCodeExtensions -EngineExtension $engineExtension
        }
        'New-VSCodeLaunch' {
            # The VS Code launch profiles, rendered from the vscode-launch registry (Catzc.Base.VSCode).
            New-VSCodeLaunch
        }
        'New-VSCodePipelineSchema' {
            New-VSCodePipelineSchema
        }
        'New-GoWorkspace' {
            New-GoWorkspace -Target $Target
        }
        'New-PythonProject' {
            New-PythonProject -Target $Target
        }
        default {
            throw "Unknown root-config generator '$Name'. Register its invocation in Invoke-RootConfigGenerator (Catzc.Base.RootConfig)."
        }
    }
}
