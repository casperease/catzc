<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Base.VSCode/private/New-VSCodeExtensionFolder.ps1
    folder: private
    name: new-vs-code-extension-folder
    filetype: ps1
    kind: function
    subkind: writer
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Base.VSCode
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: private
  edges:
    test: automation/Catzc.Base.VSCode/tests/New-VSCodeExtensionFolder.Tests.ps1
    cites:
      - ADR-AUTO-ASSETDEP#1
  config:
    synopsis: Renders one of the repository's own editor extensions to a folder the editor can pack, from its registry entry and its script.
    description: |-
      The extension's package.json is rendered from its entry under `extensions:` in vscode-extensions.yml, and its script is copied from
      the module's `assets/extensions/<name>.js` to `extension.js`. The folder is generated output: it is replaced on every render, so
      nothing in it is edited by hand.
    parameters:
      Extension: The registry entry to render.
      OutputDirectory: The folder the extension folder is written under, as `<OutputDirectory>/<name>/`.
      AssetDirectory: "The folder that holds the extension scripts. Default: the module's assets/extensions/."
    outputs: '[string] The full path of the rendered extension folder.'
    examples:
      - New-VSCodeExtensionFolder -Extension $entry -OutputDirectory (Join-Path (Get-OutputRoot) 'vscode-extensions')
---
#>

function New-VSCodeExtensionFolder {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseShouldProcessForStateChangingFunctions', '', Justification = 'Writes generated output under the output root; the folder is replaced on every render')]
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [Parameter(Mandatory)]
        [Catzc.Base.VSCode.VscodeOwnExtension] $Extension,

        [Parameter(Mandatory)]
        [string] $OutputDirectory,

        [string] $AssetDirectory = (Get-CatzcModuleRoot -ChildPath 'assets/extensions')
    )

    $script = Join-Path $AssetDirectory "$($Extension.name).js"
    Assert-PathExist $script -ErrorText "New-VSCodeExtensionFolder: extension '$($Extension.name)' has no script at '$script'."

    $manifest = [ordered]@{
        name             = $Extension.name
        displayName      = $Extension.displayName
        description      = $Extension.description
        version          = $Extension.version
        publisher        = $Extension.publisher
        engines          = [ordered]@{ vscode = $Extension.engine }
        main             = './extension.js'
        activationEvents = @($Extension.activationEvents)
    }
    if ($Extension.contributes.Count -gt 0) {
        $manifest.contributes = $Extension.contributes
    }

    $folder = Join-Path $OutputDirectory $Extension.name
    if (Test-Path -LiteralPath $folder) {
        Remove-Item -LiteralPath $folder -Recurse -Force
    }
    $null = New-Item -ItemType Directory -Path $folder -Force
    $utf8 = [System.Text.UTF8Encoding]::new($false)
    [System.IO.File]::WriteAllText((Join-Path $folder 'package.json'), ($manifest | ConvertTo-Json -Depth 32) + "`n", $utf8)
    Copy-Item -LiteralPath $script -Destination (Join-Path $folder 'extension.js')
    (Resolve-Path -LiteralPath $folder).Path
}
