<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Base.Exporter/tests/Assert-BundleFootprint.Tests.ps1
    folder: tests
    name: assert-bundle-footprint-tests
    filetype: ps1
    kind: test
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Base.Exporter
    moduletype: pwsh-folder
    catzc_bundle: azure
---
#>

Describe 'Assert-BundleFootprint' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:run = {
            param($Path, $Bundle)
            & (Get-Module Catzc.Base.Exporter) { param($p, $b) Assert-BundleFootprint -Path $p -Bundle $b } $Path $Bundle
        }
    }

    BeforeEach {
        # A small fixture build: 3 files, 60 bytes, most of them under .vendor/.
        $script:root = Join-Path $TestDrive 'Catzc/1.2.3'
        foreach ($entry in @(
                @{ Path = 'build.json'; Size = 10 }
                @{ Path = 'Catzc.Base.Widget/Catzc.Base.Widget.functions.ps1'; Size = 10 }
                @{ Path = '.vendor/gadget/gadget.psm1'; Size = 40 }
            )) {
            $file = Join-Path $root $entry.Path
            [System.IO.Directory]::CreateDirectory([System.IO.Path]::GetDirectoryName($file)) | Out-Null
            [System.IO.File]::WriteAllBytes($file, [byte[]]::new($entry.Size))
        }
        $script:limits = { param($Files, $Bytes) [pscustomobject]@{ name = 'widgets'; max_files = $Files; max_bytes = $Bytes } }
    }

    It 'measures the build and passes within its limits' {
        $footprint = & $run $root (& $limits 3 60)
        $footprint.Files | Should -Be 3
        $footprint.Bytes | Should -Be 60
    }

    It 'checks nothing a bundle does not limit' {
        { & $run $root (& $limits $null $null) } | Should -Not -Throw
    }

    It 'reports every exceeded limit in one throw, naming the heaviest folders' {
        $failure = { & $run $root (& $limits 2 59) } | Should -Throw -PassThru
        $message = $failure.Exception.Message
        $message | Should -BeLike "*Bundle 'widgets' outgrew its footprint limits*"
        $message | Should -BeLike '*3 files, over max_files 2*'
        $message | Should -BeLike '*60 bytes, over max_bytes 59*'
        $message | Should -BeLike '*Heaviest top-level entries (bytes): .vendor 40,*'
    }
}
