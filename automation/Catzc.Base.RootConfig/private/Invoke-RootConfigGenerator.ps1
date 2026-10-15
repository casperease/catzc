<#
.SYNOPSIS
    Renders the content of a generator-produced managed root file — the registry's generator dispatch.
.DESCRIPTION
    A rootconfig entry with a `generator` names a function that renders the target's whole content (header included)...
    [comment:1](/docs/references/automation/catzc-base-rootconfig/private/Invoke-RootConfigGenerator.ps1.md#comment1)
.PARAMETER Name
    The generator function name from the registry entry (e.g. 'New-Importer').
.PARAMETER Target
    The entry's target: a repository-relative path, or a wildcard pattern over a multi-file generator's files.
.OUTPUTS
    [string] The rendered target content, or [object[]] one { Target; Content } record per rendered file.
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
            # The importer.ps1 shim, rendered from the Invoke-Importer overlay's param block (-DryRun returns the...
            # [comment:2](/docs/references/automation/catzc-base-rootconfig/private/Invoke-RootConfigGenerator.ps1.md#comment2)
            New-Importer -DryRun
        }
        'New-GitIgnore' {
            # The root.gitignore, rendered from the gitignore section registry (Catzc.Base.Git).
            # [comment:3](/docs/references/automation/catzc-base-rootconfig/private/Invoke-RootConfigGenerator.ps1.md#comment3)
            $config = Get-Config -Config rootconfig
            $ignoredCopies = @(foreach ($entry in @(Get-RootConfigTargets -Config $config)) {
                    if (-not $entry.committed) {
                        '/' + $entry.target
                    }
                })
            New-GitIgnore -Inject @{ 'rootconfig-committed-false' = $ignoredCopies }
        }
        'New-VSCodeSettings' {
            # The VS Code workspace settings, rendered from the vscode-settings registry (Catzc.Base.VSCode).
            # [comment:4](/docs/references/automation/catzc-base-rootconfig/private/Invoke-RootConfigGenerator.ps1.md#comment4)
            $config = Get-Config -Config rootconfig
            $managedTargets = @(foreach ($entry in @(Get-RootConfigTargets -Config $config)) {
                    $entry.target
                })
            # The managed Go toolchain, when found at the pin: the Go extension and gopls otherwise run whichever go...
            # [ADR-AUTO-GO#6](/docs/adr/automation/go/go-test-artifacts.md#rule-adr-auto-go6)
            # [comment:5](/docs/references/automation/catzc-base-rootconfig/private/Invoke-RootConfigGenerator.ps1.md#comment5)
            $machineSetting = @{}
            $go = Resolve-ToolExecutable -Tool go
            if ($go.Found -and $go.VersionOk) {
                $machineSetting['go.goroot'] = [System.IO.Path]::GetDirectoryName([System.IO.Path]::GetDirectoryName($go.Path))
            }
            # The Python test workspace's one environment, under the resolved Python root and in this platform's...
            # [ADR-AUTO-PY#4](/docs/adr/automation/python/python-test-artifacts.md#rule-adr-auto-py4)
            # [comment:6](/docs/references/automation/catzc-base-rootconfig/private/Invoke-RootConfigGenerator.ps1.md#comment6)
            $pythonRoot = (Get-Config -Config python).ResolveRoot((Get-RepositoryRoot))
            $machineSetting['python.defaultInterpreterPath'] = if ($IsWindows) {
                "`${workspaceFolder}/$pythonRoot/.venv/Scripts/python.exe"
            }
            else {
                "`${workspaceFolder}/$pythonRoot/.venv/bin/python"
            }
            # Each language's editor formatter, from the file-language registry: Format Document runs the engine...
            # [ADR-REPO-FORMAT#8](/docs/adr/repository/uniform-formatting.md#rule-adr-repo-format8)
            # [comment:7](/docs/references/automation/catzc-base-rootconfig/private/Invoke-RootConfigGenerator.ps1.md#comment7)
            $languageFormatter = [ordered]@{}
            $editorFormatters = (Get-Config -Config languages).EditorFormatters()
            foreach ($id in $editorFormatters.Keys) {
                $languageFormatter[$id] = $editorFormatters[$id]
            }
            New-VSCodeSettings -ManagedTarget $managedTargets -MachineSetting $machineSetting -LanguageFormatter $languageFormatter
        }
        'New-VSCodeExtensions' {
            # The VS Code extension recommendations, rendered from the vscode-extensions registry...
            # [comment:8](/docs/references/automation/catzc-base-rootconfig/private/Invoke-RootConfigGenerator.ps1.md#comment8)
            $engineExtension = @((Get-Config -Config languages).engines.Values | Where-Object vscode_extension | ForEach-Object vscode_extension)
            New-VSCodeExtensions -EngineExtension $engineExtension
        }
        'New-VSCodeLaunch' {
            # The VS Code launch profiles, rendered from the vscode-launch registry (Catzc.Base.VSCode).
            New-VSCodeLaunch
        }
        'New-VSCodePipelineSchema' {
            # The repo-controlled Azure Pipelines JSON Schema, rendered from the vscode-pipeline-schema registry...
            # [comment:9](/docs/references/automation/catzc-base-rootconfig/private/Invoke-RootConfigGenerator.ps1.md#comment9)
            New-VSCodePipelineSchema
        }
        'New-GoWorkspace' {
            # The Go test workspace (Catzc.Base.Languages): the root go.work and one go.mod per go/tests/<folder>/,...
            # [comment:10](/docs/references/automation/catzc-base-rootconfig/private/Invoke-RootConfigGenerator.ps1.md#comment10)
            New-GoWorkspace -Target $Target
        }
        'New-PythonProject' {
            # The Python test workspace (Catzc.Base.Languages): the uv workspace root and one member per Python test...
            # [comment:11](/docs/references/automation/catzc-base-rootconfig/private/Invoke-RootConfigGenerator.ps1.md#comment11)
            New-PythonProject -Target $Target
        }
        default {
            throw "Unknown root-config generator '$Name'. Register its invocation in Invoke-RootConfigGenerator (Catzc.Base.RootConfig)."
        }
    }
}
