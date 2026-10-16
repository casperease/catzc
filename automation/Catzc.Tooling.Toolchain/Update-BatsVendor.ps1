<#
---
catzc:
  derived:
    path: automation/Catzc.Tooling.Toolchain/Update-BatsVendor.ps1
    kind: automation-function
    language: powershell
    track: automation
    module: Catzc.Tooling.Toolchain
    visibility: public
    relatives:
      page: docs/references/automation/catzc-tooling-toolchain/Update-BatsVendor.ps1.md
      test: automation/Catzc.Tooling.Toolchain/tests/Update-BatsVendor.Tests.ps1
    adrs:
      - ADR-AUTO-BASH
  config:
    synopsis: Refreshes the vendored bats-core test runner from the release bash.yml pins.
    description: |-
      The Bash tests run on the bats-core runner checked in at <bashRoot>/.vendor/bats-core/
      ([ADR-AUTO-BASH](/docs/adr/automation/bash/bash-test-artifacts.md)), so a test run needs no install and no network.
      This rebuilds that copy from the pin in bash.yml (bats_version, bats_sha256): it downloads the release's source
      archive from GitHub, verifies its SHA-256 (Save-VerifiedDownload), extracts it with tar inside a staging folder by
      relative name, and replaces the vendored folder with the runner's files only — bin/, libexec/, lib/ and
      LICENSE.md. To move to a new release, change both pins in bash.yml, run this, and commit the result; the files
      are LF by .gitattributes, and their executable bits are set in git with git update-index --chmod=+x.
    examples:
      - Update-BatsVendor
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
