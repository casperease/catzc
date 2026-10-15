<#
.SYNOPSIS
    Refreshes the vendored bats-core test runner from the release bash.yml pins.
.DESCRIPTION
    The Bash tests run on the bats-core runner checked in at <bashRoot>/.vendor/bats-core/, so a test run needs no...
    [ADR-AUTO-BASH](/docs/adr/automation/bash/bash-test-artifacts.md)
    [comment:1](/docs/references/automation/catzc-tooling-toolchain/Update-BatsVendor.ps1.md#comment1)
.EXAMPLE
    Update-BatsVendor
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
        # A relative name inside the staging folder, so no path carries a drive letter's colon (GNU tar reads one as...
        # [comment:2](/docs/references/automation/catzc-tooling-toolchain/Update-BatsVendor.ps1.md#comment2)
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
