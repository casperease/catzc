<#
---
catzc:
  derived:
    path: automation/Catzc.Tooling.KeyHandler/Save-PSReadLineKeyHandlerSet.ps1
    kind: automation-function
    module: Catzc.Tooling.KeyHandler
    visibility: public
  config:
    synopsis: Captures the current session's PSReadLine key bindings to configs/key-handler-bindings.yml.
    description: |-
      The Windows-side capture step: serializes the active Set-PSReadLineKeyHandler bindings (key + function
      only — the pair Import-PSReadLineKeyHandlerSet consumes) as YAML so they can be replayed on Linux. Run it
      in a Windows session whose editing experience is the one to replicate, then commit the regenerated config.
      Writes canonically (UTF-8, LF, one trailing newline) through Write-FileIfChanged, so re-capturing an
      unchanged session is a no-op.
    parameters:
      Path: |-
        Target file. Defaults to the catzc source tree's
        automation/Catzc.Tooling.KeyHandler/configs/key-handler-bindings.yml — the authored config that
        Import-PSReadLineKeyHandlerSet reads back once loaded. The default needs a session running the source tree
        (Assert-SourceTree), so a capture is never written into a built package.
    examples:
      - Save-PSReadLineKeyHandlerSet
      - Save-PSReadLineKeyHandlerSet -Path ./key-handler-bindings.yml
---
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
