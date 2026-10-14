<#
.SYNOPSIS
    Renders .vscode/extensions.json content from the vscode-extensions registry — the recommended-extension
    list the editor offers on workspace open.
.DESCRIPTION
    Reads the authored recommendation registry (configs/vscode-extensions.yml, via Get-Config -Config
    vscode-extensions, which maps and validates it as a VscodeExtensionsConfig) and renders it to the extensions.json content: a
    generated-file header (JSONC — VS Code reads comments in extensions.json) followed by the recommendations
    as JSON, in registry order. The per-extension explanations live as comments in the yml — the authored,
    searched artifact — not in the rendering.

    This is a pure renderer: it returns the content and writes nothing — it is the `generator` the
    root-config registry names for the .vscode/extensions.json target, and Build-RootConfig owns the write.
    See [ADR-REPO-ROOTCFG](/docs/adr/repository/generated-root-configs.md).
.PARAMETER EngineExtension
    The extensions that run the repository's formatter engines in the editor, appended after the authored
    recommendations when not already listed. Supplied by the generator dispatch from the file-language registry, so
    an engine's extension is recommended wherever a language uses it
    ([ADR-REPO-FORMAT#8](/docs/adr/repository/uniform-formatting.md#rule-adr-repo-format8)).
.OUTPUTS
    [string] The rendered extensions.json content (LF-joined; the writer canonicalises).
.EXAMPLE
    New-VSCodeExtensions
#>
function New-VSCodeExtensions {
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [AllowEmptyCollection()]
        [string[]] $EngineExtension = @()
    )

    $config = Get-Config -Config vscode-extensions

    $recommendations = [System.Collections.Generic.List[string]]::new()
    foreach ($id in @($config.recommendations) + @($EngineExtension | Sort-Object)) {
        if (-not $recommendations.Contains($id)) {
            $recommendations.Add($id)
        }
    }
    $rendered = [ordered]@{
        recommendations = $recommendations.ToArray()
    }

    $header = @(
        '// GENERATED FILE — do not edit. Single source of truth:'
        '//   automation/Catzc.Base.VSCode/configs/vscode-extensions.yml (the authored recommendations + comments)'
        '//   automation/Catzc.Base.Languages/configs/languages.yml (the formatter engines'' extensions)'
        '// Regenerated on import by Build-RootConfig; edit the yml, not this file (VS Code reads the // header fine).'
    ) -join "`n"

    $header + "`n" + (ConvertTo-Json -InputObject $rendered -Depth 4) + "`n"
}
