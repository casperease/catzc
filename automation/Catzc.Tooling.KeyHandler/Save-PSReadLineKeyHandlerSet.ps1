<#
.SYNOPSIS
    Captures the current session's PSReadLine key bindings to configs/key-handler-bindings.yml.
.DESCRIPTION
    The Windows-side capture step: serializes the active Set-PSReadLineKeyHandler bindings (key + function only — the...
    [comment:1](/docs/references/automation/catzc-tooling-keyhandler/Save-PSReadLineKeyHandlerSet.ps1.md#comment1)
.PARAMETER Path
    Target file.
    [comment:2](/docs/references/automation/catzc-tooling-keyhandler/Save-PSReadLineKeyHandlerSet.ps1.md#comment2)
.EXAMPLE
    Save-PSReadLineKeyHandlerSet
.EXAMPLE
    Save-PSReadLineKeyHandlerSet -Path ./key-handler-bindings.yml
#>
function Save-PSReadLineKeyHandlerSet {
    [CmdletBinding()]
    param(
        [string] $Path
    )

    if (-not $Path) {
        # The capture is an authoring step: it writes the committed source config, never the loaded copy.
        Assert-SourceTree
        $Path = Join-Path (Get-RepositoryRoot) 'automation/Catzc.Tooling.KeyHandler/configs/key-handler-bindings.yml'
    }

    Assert-PsModule 'PSReadLine'

    $handlers = Get-PSReadLineKeyHandler | Where-Object { $_.Function }
    $bindings = foreach ($handler in $handlers) {
        [ordered]@{ key = [string]$handler.Key; function = [string]$handler.Function }
    }
    Assert-True (@($bindings).Count -gt 0) -ErrorText 'Get-PSReadLineKeyHandler returned no bound handlers to capture.'

    $header = "# Windows PSReadLine key bindings captured by Save-PSReadLineKeyHandlerSet, replicated on Linux by`n" +
    "# Import-PSReadLineKeyHandlerSet (filtered to key-handler-supported). Only key + function are consumed.`n"
    $content = $header + (ConvertTo-YamlSafe $bindings | ConvertTo-Yaml)

    $changed = Write-FileIfChanged -Path $Path -Content $content
    $message = if ($changed) {
        "Captured $(@($bindings).Count) key bindings to $(ConvertTo-RepoRelativePath $Path)"
    }
    else {
        "Key bindings already current at $(ConvertTo-RepoRelativePath $Path) — no change"
    }
    Write-Message $message
}
