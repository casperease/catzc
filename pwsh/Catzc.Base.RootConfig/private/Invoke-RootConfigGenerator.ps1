<#
---
catzc:
  docs: "../../../docs/references/pwsh/catzc-base-root-config/private/Invoke-RootConfigGenerator.ps1.md"
  header: "generated"
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
            # -DryRun returns the shim's content; Build-RootConfig does the one write.
            New-Importer -DryRun
        }
        'New-GitIgnore' {
            # The managed-copies section is injected here, so New-GitIgnore never reads rootconfig.yml.
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
        'New-Cspell' {
            New-Cspell
        }
        'New-VsCodeSettings' {
            # Managed targets join search.exclude here, so find-all lands on sources and the edge stays one-way.
            $config = Get-Config -Config rootconfig
            $managedTargets = @(foreach ($entry in @(Get-RootConfigTargets -Config $config)) {
                    $entry.target
                })
            # Pin the managed Go toolchain: on Windows a machine-wide go would otherwise win on PATH.
            $machineSetting = @{}
            $go = Resolve-ToolExecutable -Tool go
            if ($go.Found -and $go.VersionOk) {
                $machineSetting['go.goroot'] = [System.IO.Path]::GetDirectoryName([System.IO.Path]::GetDirectoryName($go.Path))
            }
            # The Python extension resolves and runs the tests in the one workspace environment.
            $python = Get-Config -Config python
            $pythonRoot = $python.ResolveRoot((Get-RepositoryRoot))
            $machineSetting['python.defaultInterpreterPath'] = if ($IsWindows) {
                "`${workspaceFolder}/$pythonRoot/.venv/Scripts/python.exe"
            }
            else {
                "`${workspaceFolder}/$pythonRoot/.venv/bin/python"
            }
            # Pylance runs pyright in the mode Test-PythonTypes runs it in ([ADR-AUTO-PY-EVERYFILETYPECHECKED](/docs/drs/automation/python/python-test-artifacts.md#rule-adr-auto-py-everyfiletypechecked)).
            $machineSetting['python.analysis.typeCheckingMode'] = $python.type_checking
            # Format Document runs the same engine Format-Code runs for each language.
            $languageFormatter = [ordered]@{}
            $editorFormatters = (Get-Config -Config languages).EditorFormatters()
            foreach ($id in $editorFormatters.Keys) {
                $languageFormatter[$id] = $editorFormatters[$id]
            }
            # The lamps' filters, each resolved to its include/exclude sets from filters.yml, in lamp order.
            $filter = [ordered]@{}
            foreach ($resolved in Get-RepositoryFilter) {
                $filter[$resolved.name] = @($resolved.sets)
            }
            # The languages a lamp can be clicked in for: every one with a tag, which is the lamp's label.
            $lampLanguage = [ordered]@{}
            foreach ($language in @((Get-Config -Config languages).languages | Where-Object tag)) {
                $lampLanguage[$language.name] = @{ tag = $language.tag; extensions = @($language.extensions) }
            }
            $render = @{
                ManagedTarget     = $managedTargets
                MachineSetting    = $machineSetting
                LanguageFormatter = $languageFormatter
                RepositoryFilter  = $filter
                LampLanguage      = $lampLanguage
            }
            New-VsCodeSettings @render
        }
        'New-VsCodeExtensions' {
            # The registry's recommendations, completed with every formatter engine's editor extension.
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
        'New-JsConfig' {
            # The type roots are npm's global root beside the managed node, where Install-TypeScript puts the declarations; no process runs.
            $node = Resolve-ToolExecutable -Tool node_js
            $typeRoot = if ($node.Found) {
                $folder = Split-Path $node.Path
                $global = if ($IsWindows) {
                    Join-Path $folder 'node_modules'
                }
                else {
                    Join-Path (Split-Path $folder) 'lib/node_modules'
                }
                (Join-Path $global '@types') -replace '\\', '/'
            }
            New-JsConfig -TypeRoot $typeRoot -Target $Target
        }
        'New-GoWorkspace' {
            # One record per file; the entry's target picks go.work or a go.mod.
            New-GoWorkspace -Target $Target
        }
        'Build-WidthConfigs' {
            Build-WidthConfigs -Target $Target
        }
        'New-PythonProject' {
            # One record per file; the entry's target picks the workspace root or a member.
            New-PythonProject -Target $Target
        }
        'New-NuGetConfig' {
            New-NuGetConfig
        }
        'New-DotnetBuildProps' {
            New-DotnetBuildProps
        }
        'New-Solution' {
            New-Solution
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
