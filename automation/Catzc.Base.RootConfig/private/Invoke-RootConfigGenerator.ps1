<#
.SYNOPSIS
    Renders the full content of a generator-produced managed root file — the registry's generator dispatch.
.DESCRIPTION
    A rootconfig entry with a `generator` names a function that renders the target's whole content (header
    included) rather than an authored source file to copy. This dispatch is the one place a generator name is
    bound to its invocation, so Build-RootConfig stays generic and an unknown name fails loudly instead of
    invoking an arbitrary command. Each generator is called in its content-returning form (never its writing
    form) — Build-RootConfig owns the write, through the same Write-FileIfChanged path as every copy-in.
.PARAMETER Name
    The generator function name from the registry entry (e.g. 'New-Importer').
.OUTPUTS
    [string] The rendered target content.
#>
function Invoke-RootConfigGenerator {
    [OutputType([string])]
    param(
        [Parameter(Mandatory)]
        [string] $Name
    )

    switch ($Name) {
        'New-Importer' {
            # The importer.ps1 shim, rendered from the Invoke-Importer overlay's param block (-DryRun returns
            # the content without writing).
            New-Importer -DryRun
        }
        'New-GitIgnore' {
            # The root .gitignore, rendered from the gitignore zone registry (Catzc.Base.Git). The managed-
            # copies zone is injected HERE, from this module's own registry — the committed:false targets,
            # root-anchored — so the ignored-copies list lives once in rootconfig.yml and the dependency edge
            # stays one-way (RootConfig -> Git; New-GitIgnore never reads rootconfig.yml).
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
            # Every opted-in managed target is injected into search.exclude HERE, from this module's own
            # registry — find-all lands on sources of truth, never generated copies — and the dependency
            # edge stays one-way (RootConfig -> VSCode; New-VSCodeSettings never reads rootconfig.yml).
            $config = Get-Config -Config rootconfig
            $managedTargets = @(foreach ($entry in @(Get-RootConfigTargets -Config $config)) {
                    $entry.target
                })
            New-VSCodeSettings -ManagedTarget $managedTargets
        }
        'New-VSCodeExtensions' {
            # The VS Code extension recommendations, rendered from the vscode-extensions registry
            # (Catzc.Base.VSCode).
            New-VSCodeExtensions
        }
        'New-VSCodeLaunch' {
            # The VS Code launch profiles, rendered from the vscode-launch registry (Catzc.Base.VSCode).
            New-VSCodeLaunch
        }
        default {
            throw "Unknown root-config generator '$Name'. Register its invocation in Invoke-RootConfigGenerator (Catzc.Base.RootConfig)."
        }
    }
}
