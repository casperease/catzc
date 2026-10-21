<#
---
catzc:
  immutable:
    with_body_sha: aae69797af47
  edges:
    docs: "[Invoke-RootConfigGenerator.ps1.md](docs/references/pwsh/catzc-base-rootconfig/private/Invoke-RootConfigGenerator.ps1.md)"
    cites:
      - ADR-AUTO-GO-MANAGEDTOOLCHAIN
      - ADR-AUTO-PY-GENERATEDWORKSPACE
      - ADR-AUTO-PY-EVERYFILETYPECHECKED
      - ADR-REPO-FORMAT-CONFIGUREDFORMATTERS
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
        'New-VsCodeSettings' {
            $config = Get-Config -Config rootconfig
            $managedTargets = @(foreach ($entry in @(Get-RootConfigTargets -Config $config)) {
                    $entry.target
                })
            $machineSetting = @{}
            $go = Resolve-ToolExecutable -Tool go
            if ($go.Found -and $go.VersionOk) {
                $machineSetting['go.goroot'] = [System.IO.Path]::GetDirectoryName([System.IO.Path]::GetDirectoryName($go.Path))
            }
            $python = Get-Config -Config python
            $pythonRoot = $python.ResolveRoot((Get-RepositoryRoot))
            $machineSetting['python.defaultInterpreterPath'] = if ($IsWindows) {
                "`${workspaceFolder}/$pythonRoot/.venv/Scripts/python.exe"
            }
            else {
                "`${workspaceFolder}/$pythonRoot/.venv/bin/python"
            }
            # Pylance runs pyright in the mode Test-PythonTypes runs it in ([ADR-AUTO-PY-EVERYFILETYPECHECKED](/docs/adr/automation/python/python-test-artifacts.md#rule-adr-auto-py-everyfiletypechecked)).
            $machineSetting['python.analysis.typeCheckingMode'] = $python.type_checking
            $languageFormatter = [ordered]@{}
            $editorFormatters = (Get-Config -Config languages).EditorFormatters()
            foreach ($id in $editorFormatters.Keys) {
                $languageFormatter[$id] = $editorFormatters[$id]
            }
            New-VsCodeSettings -ManagedTarget $managedTargets -MachineSetting $machineSetting -LanguageFormatter $languageFormatter
        }
        'New-VsCodeExtensions' {
            $engineExtension = @((Get-Config -Config languages).formatters.Values | Where-Object vscode_extension | ForEach-Object vscode_extension)
            New-VsCodeExtensions -EngineExtension $engineExtension
        }
        'New-VsCodeLaunch' {
            # The VS Code launch profiles, rendered from the vscode-launch registry (Catzc.Base.VSCode).
            New-VsCodeLaunch
        }
        'New-VsCodeTasks' {
            # The VS Code tasks, rendered from the vscode-tasks registry (Catzc.Base.VSCode).
            New-VsCodeTasks
        }
        'New-VsCodePipelineSchema' {
            New-VsCodePipelineSchema
        }
        'New-GoWorkspace' {
            New-GoWorkspace -Target $Target
        }
        'New-PythonProject' {
            New-PythonProject -Target $Target
        }
        'New-CatsCommandLookup' {
            # The lookup cats checks a call against, from the command contracts (Catzc.Base.Contracts).
            New-CatsCommandLookup
        }
        default {
            throw "Unknown root-config generator '$Name'. Register its invocation in Invoke-RootConfigGenerator (Catzc.Base.RootConfig)."
        }
    }
}
