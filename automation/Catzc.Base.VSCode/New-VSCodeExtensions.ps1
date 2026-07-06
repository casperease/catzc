<#
.SYNOPSIS
    Renders .vscode/extensions.json content from the vscode-extensions registry — the recommended-extension
    list the editor offers on workspace open.
.DESCRIPTION
    Reads the authored recommendation registry (configs/vscode-extensions.yml, via Get-Config -Config
    vscode-extensions, which validates it as binding shape) and renders it to the extensions.json content: a
    generated-file header (JSONC — VS Code reads comments in extensions.json) followed by the recommendations
    as JSON, in registry order. The per-extension explanations live as comments in the yml — the authored,
    searched artifact — not in the rendering.

    This is a pure renderer: it returns the content and writes nothing — it is the `generator` the
    root-config registry names for the .vscode/extensions.json target, and Build-RootConfig owns the write.
    See docs/adr/repository/generated-root-configs.md.
.OUTPUTS
    [string] The rendered extensions.json content (LF-joined; the writer canonicalises).
.EXAMPLE
    New-VSCodeExtensions
#>
function New-VSCodeExtensions {
    [CmdletBinding()]
    [OutputType([string])]
    param()

    $config = Get-Config -Config vscode-extensions

    $rendered = [ordered]@{
        recommendations = @($config['recommendations'])
    }

    $header = @(
        '// GENERATED FILE — do not edit. Single source of truth:'
        '//   automation/Catzc.Base.VSCode/configs/vscode-extensions.yml (the authored recommendations + comments)'
        '// Regenerated on import by Build-RootConfig; edit the yml, not this file (VS Code reads the // header fine).'
    ) -join "`n"

    $header + "`n" + (ConvertTo-Json -InputObject $rendered -Depth 4) + "`n"
}
