<#
.SYNOPSIS
    Renders .vscode/launch.json content from the vscode-launch registry — the debug launch profiles the
    editor offers.
.DESCRIPTION
    Reads the authored launch-profile registry (configs/vscode-launch.yml, via Get-Config -Config
    vscode-launch, which validates it as binding shape) and renders it to the launch.json content: a
    generated-file header (JSONC — VS Code reads comments in launch.json) followed by the version and
    configurations as JSON, in registry order. The per-profile explanations live as comments in the yml — the
    authored, searched artifact — not in the rendering.

    This is a pure renderer: it returns the content and writes nothing — it is the `generator` the
    root-config registry names for the .vscode/launch.json target, and Build-RootConfig owns the write.
    See docs/adr/repository/generated-root-configs.md.
.OUTPUTS
    [string] The rendered launch.json content (LF-joined; the writer canonicalises).
.EXAMPLE
    New-VSCodeLaunch
#>
function New-VSCodeLaunch {
    [CmdletBinding()]
    [OutputType([string])]
    param()

    $config = Get-Config -Config vscode-launch

    $rendered = [ordered]@{
        version        = $config['version']
        configurations = @($config['configurations'])
    }

    $header = @(
        '// GENERATED FILE — do not edit. Single source of truth:'
        '//   automation/Catzc.Base.VSCode/configs/vscode-launch.yml (the authored launch profiles + comments)'
        '// Regenerated on import by Build-RootConfig; edit the yml, not this file (VS Code reads the // header fine).'
    ) -join "`n"

    $header + "`n" + (ConvertTo-Json -InputObject $rendered -Depth 8) + "`n"
}
