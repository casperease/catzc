<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Base.VSCode/Install-VSCodeExtension.ps1
    name: install-vs-code-extension
    filetype: ps1
    kind: function
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Base.VSCode
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  edges:
    test: automation/Catzc.Base.VSCode/tests/Install-VSCodeExtension.Tests.ps1
  config:
    synopsis: Installs the repository's own editor extensions, the folders of .vscode that hold a package.json, through the editor's CLI.
    description: |-
      Each extension folder under `.vscode/` is packed with Build-VSCodeExtension and installed with `code --install-extension --force`, so
      the editor writes its own registry entry and a clone needs this one command. An extension of the same name is replaced; restart the
      editor afterwards so it loads.

      A link from the editor's extensions folder into the repository is not the install: the editor would write the extension's files
      through the link into the working tree. Remove such a link first.
    parameters:
      Name: 'The extension folder names to install. Default: every folder of .vscode that holds a package.json.'
    outputs: '[string[]] The .vsix files that were installed.'
    examples:
      - Install-VSCodeExtension
      - Install-VSCodeExtension -Name catzc-compiled-info
---
#>

function Install-VSCodeExtension {
    [CmdletBinding()]
    [OutputType([string[]])]
    param(
        [string[]] $Name
    )

    if (-not (Test-Command 'code')) {
        throw "Install-VSCodeExtension: the editor's CLI 'code' is not on PATH. Add it (VS Code: Shell Command: Install 'code' command in PATH), then re-run."
    }

    $root = Join-Path (Get-RepositoryRoot) '.vscode'
    $folders = @(Get-ChildItem -LiteralPath $root -Directory | Where-Object { Test-Path -LiteralPath (Join-Path $_.FullName 'package.json') })
    if ($Name) {
        $folders = @($folders | Where-Object { $_.Name -in $Name })
        $found = @($folders | ForEach-Object Name)
        foreach ($wanted in $Name | Where-Object { $_ -notin $found }) {
            throw "Install-VSCodeExtension: '.vscode/$wanted' holds no package.json."
        }
    }

    foreach ($folder in $folders) {
        $vsix = Build-VSCodeExtension -Path $folder.FullName
        Invoke-Executable "code --install-extension `"$vsix`" --force"
        $vsix
    }
}
