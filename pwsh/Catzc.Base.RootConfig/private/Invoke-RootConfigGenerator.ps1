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
            $python = Get-Config -Config python
            $pythonRoot = $python.ResolveRoot((Get-RepositoryRoot))
            $machineSetting['python.defaultInterpreterPath'] = if ($IsWindows) {
                "`${workspaceFolder}/$pythonRoot/.venv/Scripts/python.exe"
            }
            else {
                "`${workspaceFolder}/$pythonRoot/.venv/bin/python"
            }
            # Pylance runs pyright in the mode Test-PythonTypes runs it in (ADR-AUTO-PY#9).
            $machineSetting['python.analysis.typeCheckingMode'] = $python.type_checking
            if ($python.extra_paths.Count -gt 0) {
                $machineSetting['python.analysis.extraPaths'] = @(foreach ($extraPath in $python.extra_paths) {
                        "`${workspaceFolder}/$extraPath"
                    })
            }
            $languageFormatter = [ordered]@{}
            $editorFormatters = (Get-Config -Config languages).EditorFormatters()
            foreach ($id in $editorFormatters.Keys) {
                $languageFormatter[$id] = $editorFormatters[$id]
            }
            New-VSCodeSettings -ManagedTarget $managedTargets -MachineSetting $machineSetting -LanguageFormatter $languageFormatter
        }
        'New-VSCodeExtensions' {
            $engineExtension = @((Get-Config -Config languages).formatters.Values | Where-Object vscode_extension | ForEach-Object vscode_extension)
            New-VSCodeExtensions -EngineExtension $engineExtension
        }
        'New-VSCodeLaunch' {
            # The VS Code launch profiles, rendered from the vscode-launch registry (Catzc.Base.VSCode).
            New-VSCodeLaunch
        }
        'New-VSCodeTasks' {
            # The VS Code tasks, rendered from the vscode-tasks registry (Catzc.Base.VSCode).
            New-VSCodeTasks
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
        'New-CatsCommandLookup' {
            # The lookup cats checks a call against, from the command contracts (Catzc.Base.Contracts).
            New-CatsCommandLookup
        }
        default {
            throw "Unknown root-config generator '$Name'. Register its invocation in Invoke-RootConfigGenerator (Catzc.Base.RootConfig)."
        }
    }
}
