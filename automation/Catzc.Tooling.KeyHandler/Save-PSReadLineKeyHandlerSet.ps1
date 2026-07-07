<#
.SYNOPSIS
    Captures the current session's PSReadLine key bindings to configs/key-handler-bindings.yml.
.DESCRIPTION
    The Windows-side capture step: serializes the active Set-PSReadLineKeyHandler bindings (key + function
    only — the pair Import-PSReadLineKeyHandlerSet consumes) as YAML so they can be replayed on Linux. Run it
    in a Windows session whose editing experience is the one to replicate, then commit the regenerated config.
    Writes canonically (UTF-8, LF, one trailing newline) through Write-FileIfChanged, so re-capturing an
    unchanged session is a no-op.
.PARAMETER Path
    Target file. Defaults to the module's configs/key-handler-bindings.yml — the config Import- reads back.
.EXAMPLE
    Save-PSReadLineKeyHandlerSet
#>
function Save-PSReadLineKeyHandlerSet {
    [CmdletBinding()]
    param(
        [string] $Path = (Join-Path $PSScriptRoot 'configs/key-handler-bindings.yml')
    )

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
