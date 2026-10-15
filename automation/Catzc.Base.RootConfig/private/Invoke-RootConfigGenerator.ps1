<#
---
catzc:
  derived:
    path: automation/Catzc.Base.RootConfig/private/Invoke-RootConfigGenerator.ps1
    kind: function
    module: Catzc.Base.RootConfig
    visibility: private
---
#>

<#
.SYNOPSIS
    Renders the content of a generator-produced managed root file — the registry's generator dispatch.
.DESCRIPTION
    An unknown generator name throws instead of invoking an arbitrary command: this dispatch is the only binding.
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
            # -DryRun makes New-Importer return the content instead of writing it; Build-RootConfig owns the write.
            # [comment:2](/docs/references/automation/catzc-base-rootconfig/private/Invoke-RootConfigGenerator.ps1.md#comment2)
            New-Importer -DryRun
        }
        'New-GitIgnore' {
            # Injected here so the ignored-copies list lives once in rootconfig.yml and Git never reads it.
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
            # Managed targets go into search.exclude here, so find-all lands on sources, never generated copies.
            # [comment:4](/docs/references/automation/catzc-base-rootconfig/private/Invoke-RootConfigGenerator.ps1.md#comment4)
            $config = Get-Config -Config rootconfig
            $managedTargets = @(foreach ($entry in @(Get-RootConfigTargets -Config $config)) {
                    $entry.target
                })
            # On Windows a machine-wide Go precedes the managed one on PATH, so the pin is set explicitly.
            # [ADR-AUTO-GO#6](/docs/adr/automation/go/go-test-artifacts.md#rule-adr-auto-go6)
            # [comment:5](/docs/references/automation/catzc-base-rootconfig/private/Invoke-RootConfigGenerator.ps1.md#comment5)
            $machineSetting = @{}
            $go = Resolve-ToolExecutable -Tool go
            if ($go.Found -and $go.VersionOk) {
                $machineSetting['go.goroot'] = [System.IO.Path]::GetDirectoryName([System.IO.Path]::GetDirectoryName($go.Path))
            }
            # The Python extension resolves test imports in this one environment, whose path differs per platform.
            # [ADR-AUTO-PY#4](/docs/adr/automation/python/python-test-artifacts.md#rule-adr-auto-py4)
            # [comment:6](/docs/references/automation/catzc-base-rootconfig/private/Invoke-RootConfigGenerator.ps1.md#comment6)
            $pythonRoot = (Get-Config -Config python).ResolveRoot((Get-RepositoryRoot))
            $machineSetting['python.defaultInterpreterPath'] = if ($IsWindows) {
                "`${workspaceFolder}/$pythonRoot/.venv/Scripts/python.exe"
            }
            else {
                "`${workspaceFolder}/$pythonRoot/.venv/bin/python"
            }
            # Format Document runs the same engine as Format-Code, so the editor and the gate never disagree.
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
            # Each formatter engine's editor extension is added from the language registry, beyond the static list.
            # [comment:8](/docs/references/automation/catzc-base-rootconfig/private/Invoke-RootConfigGenerator.ps1.md#comment8)
            $engineExtension = @((Get-Config -Config languages).engines.Values | Where-Object vscode_extension | ForEach-Object vscode_extension)
            New-VSCodeExtensions -EngineExtension $engineExtension
        }
        'New-VSCodeLaunch' {
            # The VS Code launch profiles, rendered from the vscode-launch registry (Catzc.Base.VSCode).
            New-VSCodeLaunch
        }
        'New-VSCodePipelineSchema' {
            # Replaces the bundled per-task anyOf, the source of the offline PowerShell@2 false positives.
            # [comment:9](/docs/references/automation/catzc-base-rootconfig/private/Invoke-RootConfigGenerator.ps1.md#comment9)
            New-VSCodePipelineSchema
        }
        'New-GoWorkspace' {
            # A multi-file generator: one record per file, and the entry's target selects which files render.
            # [comment:10](/docs/references/automation/catzc-base-rootconfig/private/Invoke-RootConfigGenerator.ps1.md#comment10)
            New-GoWorkspace -Target $Target
        }
        'New-PythonProject' {
            # One record per Python test folder, and the entry's target selects which files render.
            # [comment:11](/docs/references/automation/catzc-base-rootconfig/private/Invoke-RootConfigGenerator.ps1.md#comment11)
            New-PythonProject -Target $Target
        }
        default {
            throw "Unknown root-config generator '$Name'. Register its invocation in Invoke-RootConfigGenerator (Catzc.Base.RootConfig)."
        }
    }
}
