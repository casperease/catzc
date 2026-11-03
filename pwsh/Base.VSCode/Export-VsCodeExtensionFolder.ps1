function Export-VsCodeExtensionFolder {
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [Parameter(Mandatory)]
        [string] $Module,

        [Parameter(Mandatory)]
        [string] $OutputDirectory
    )

    # The module's folder name is matched against the source folder each registered extension renders from.
    $leaf = ($Module.Replace('\', '/').TrimEnd('/') -split '/')[-1]
    $track = Get-Track -Name js
    $entry = @((Get-Config -Config vscode-extensions).extensions | Where-Object { $track.FolderNameOf($_.name) -ceq $leaf }) |
        Select-Object -First 1
    if ($null -eq $entry) {
        return
    }
    New-VsCodeExtensionFolder -Extension $entry -OutputDirectory $OutputDirectory
}
