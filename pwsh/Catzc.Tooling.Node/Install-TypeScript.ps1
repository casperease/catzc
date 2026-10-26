function Install-TypeScript {
    [CmdletBinding()]
    param(
        [switch] $Force
    )

    # npm ships with Node.js — assert it is present and at the locked version first.
    Assert-Tool 'node_js'

    # The compiler is a tool on PATH, in npm's global root; the declarations it checks against go into the repository-relative,
    # gitignored folder javascript.yml declares (types_folder), which the generated jsconfig.json names relatively, so no machine path
    # reaches a generated file. Each at its tools.yml pin.
    $folder = Join-Path (Get-RepositoryRoot) (Get-Config -Config javascript).types_folder
    foreach ($tool in 'typescript', 'types_node', 'types_vscode') {
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
