function Install-TypeScript {
    [CmdletBinding()]
    param(
        [switch] $Force
    )

    # npm ships with Node.js — assert it is present and at the locked version first.
    Assert-Tool 'node_js'

    # The declarations land in a repository-relative gitignored folder the generated jsconfig names relatively, so no machine path reaches a generated file.
    $folder = Join-Path (Get-RepositoryRoot) (Get-Config -Config javascript).types_folder
    # TypeScript itself, then every tool the tools config says it installs alongside itself.
    $tools = (Get-Config -Config tools).Keys | Where-Object { (Get-ToolConfig -Tool $_).installed_by -ceq 'typescript' }
    foreach ($tool in @('typescript') + @($tools)) {
        $config = Get-ToolConfig -Tool $tool
        $installed = if (Test-Command $config.command) {
            Get-ToolVersion -Config $config
        }
        if ($installed -and $installed.StartsWith($config.version) -and -not $Force) {
            Write-Message "$($config.npm_package) $($config.version) is already installed"
            continue
        }
        $into = if ($tool -eq 'typescript') {
            '-g'
        }
        else {
            "--prefix `"$folder`""
        }
        Invoke-Npm "install $into $($config.npm_package)@$($config.version)"
        Write-Message "$($config.npm_package) $($config.version) installed"
    }
    Assert-Command tsc -ErrorText 'TypeScript was installed but tsc is not on PATH. You may need to restart your shell.'
}
