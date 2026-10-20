<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Tooling.KeyHandler/Save-PSReadLineKeyHandlerSet.ps1
    name: save-ps-read-line-key-handler-set
    filetype: ps1
    role: function
    language: powershell
    track: pwsh
    tracktype: modules
    module: Catzc.Tooling.KeyHandler
    moduletype: pwsh-folder
    catzc_bundle: full
    visibility: public
  edges:
    test: pwsh/Catzc.Tooling.KeyHandler/tests/Save-PSReadLineKeyHandlerSet.Tests.ps1
    docs: "[Save-PSReadLineKeyHandlerSet.ps1.md](docs/references/pwsh/catzc-tooling-keyhandler/Save-PSReadLineKeyHandlerSet.ps1.md)"
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
        $Path = Join-Path (Get-CatzcModulesRoot) 'Catzc.Tooling.KeyHandler/configs/key-handler-bindings.yml'
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
