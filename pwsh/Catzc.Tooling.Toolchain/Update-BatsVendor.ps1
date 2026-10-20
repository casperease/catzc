<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Tooling.Toolchain/Update-BatsVendor.ps1
    name: update-bats-vendor
    filetype: ps1
    role: function
    language: powershell
    track: pwsh
    tracktype: modules
    module: Catzc.Tooling.Toolchain
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  edges:
    test: pwsh/Catzc.Tooling.Toolchain/tests/Update-BatsVendor.Tests.ps1
    docs: "[Update-BatsVendor.ps1.md](docs/references/pwsh/catzc-tooling-toolchain/Update-BatsVendor.ps1.md)"
    cites:
      - ADR-AUTO-BASH
---
#>

function Update-BatsVendor {
    [CmdletBinding()]
    param()

    $root = Get-RepositoryRoot
    $config = Get-Config -Config bash
    $target = Join-Path (Join-Path $root $config.ResolveRoot($root)) ([Catzc.Base.Languages.BashConfig]::BatsFolder)
    Assert-Command tar -ErrorText 'Update-BatsVendor extracts the bats-core archive with tar, which is not on PATH.'

    $staging = "$target.staging"
    if (Test-Path -LiteralPath $staging) {
        Remove-Item -LiteralPath $staging -Recurse -Force
    }
    New-Item -Path $staging -ItemType Directory -Force | Out-Null
    try {
        $fileName = "v$($config.bats_version).tar.gz"
        $uri = "https://github.com/bats-core/bats-core/archive/refs/tags/$fileName"
        $null = Save-VerifiedDownload -Uri $uri -OutFile (Join-Path $staging $fileName) -Sha256 $config.bats_sha256
        Invoke-Executable "tar -xzf `"$fileName`"" -WorkingDirectory $staging -Silent
        $extracted = Join-Path $staging "bats-core-$($config.bats_version)"
        Assert-PathExist (Join-Path $extracted 'bin/bats') -PathType Leaf

        if (Test-Path -LiteralPath $target) {
            Remove-Item -LiteralPath $target -Recurse -Force
        }
        New-Item -Path $target -ItemType Directory -Force | Out-Null
        foreach ($item in 'bin', 'libexec', 'lib', 'LICENSE.md') {
            Copy-Item -LiteralPath (Join-Path $extracted $item) -Destination $target -Recurse -Force
        }
    }
    finally {
        Remove-Item -LiteralPath $staging -Recurse -Force -ErrorAction Ignore
    }
    Write-Message "bats-core $($config.bats_version) vendored at $target"
}
