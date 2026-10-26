function Install-AzCli {
    [CmdletBinding()]
    param(
        [string] $Version = (Get-ToolConfig -Tool 'az_cli').version,
        [switch] $Force
    )

    Install-UvVenvTool -Tool 'az_cli' -Version $Version -Force:$Force
}
