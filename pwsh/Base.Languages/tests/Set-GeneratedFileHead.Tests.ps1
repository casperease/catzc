Describe 'Set-GeneratedFileHead' -Tag 'L0', 'logic', 'ADR-REPO-FILEMETA-COMPOSEDFILES' {
    BeforeAll {
        $script:warning = (Get-Config -Config generated-head).warning
        $script:writer = [Catzc.Base.Variants.GeneratedWriterRow]::new('Build-Widget', [ordered]@{
                class   = 'rollable'
                inputs  = @('docs/widget.yml')
                outputs = @('docs/gen.svg', 'docs/gen.png')
            })
    }

    BeforeEach {
        $script:root = Join-Path $TestDrive 'repository'
        $null = New-Item -ItemType Directory -Path (Join-Path $script:root 'docs') -Force
        Mock Resolve-RepoPath -ModuleName Catzc.Base.Languages { Join-Path $script:root $Path }
        Mock ConvertTo-RepoRelativePath -ModuleName Catzc.Base.Languages { $Path.Substring($script:root.Length + 1) -replace '\\', '/' }
        Mock Get-GitTrackedPath -ModuleName Catzc.Base.Languages { $Path }
        Mock Get-GeneratedWriterRow -ModuleName Catzc.Base.Languages { $script:writer }
    }

    It 'stamps a text file in place from the writer row, its carrier found by its glob, and a second call changes nothing' {
        $file = Join-Path $script:root 'docs/gen.svg'
        [System.IO.File]::WriteAllText($file, "<svg><g/></svg>`n")
        Set-GeneratedFileHead -Path docs/gen.svg -Writer Build-Widget
        $once = [System.IO.File]::ReadAllText($file)
        $once | Should -BeLike "<svg><metadata id=`"catzc`"><!``[CDATA``[catzc:*regenerate: `"Build-Widget -Path docs/gen.svg`"`n    with_body_sha: *]]></metadata><g/></svg>`n"
        $once | Should -BeLike "*warning: `"$script:warning`"*"
        Set-GeneratedFileHead -Path docs/gen.svg -Writer Build-Widget
        [System.IO.File]::ReadAllText($file) | Should -BeExactly $once
        Should -Invoke Get-GeneratedWriterRow -ModuleName Catzc.Base.Languages -ParameterFilter { $Name -eq 'Build-Widget' }
    }

    It 'stamps a png as bytes, its carrier found by its glob, and a second call changes nothing' {
        $file = Join-Path $script:root 'docs/gen.png'
        $png = [byte[]] @(0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A, 0, 0, 0, 0, 0x49, 0x48, 0x44, 0x52, 0x2E, 0x5A, 0x8F, 0x8B, 0, 0, 0, 0, 0x49, 0x45, 0x4E, 0x44, 0xAE, 0x42, 0x60, 0x82)
        [System.IO.File]::WriteAllBytes($file, $png)
        Set-GeneratedFileHead -Path docs/gen.png -Writer Build-Widget
        $once = [System.IO.File]::ReadAllBytes($file)
        [Catzc.Base.Languages.PngTextCarrier]::Text($once) | Should -BeLike '*regenerate: "Build-Widget -Path docs/gen.png"*'
        [Catzc.Base.Languages.PngTextCarrier]::Body($once) | Should -Be $png
        Set-GeneratedFileHead -Path docs/gen.png -Writer Build-Widget
        [System.Linq.Enumerable]::SequenceEqual([byte[]] [System.IO.File]::ReadAllBytes($file), [byte[]] $once) | Should -BeTrue
    }

    It 'refuses a file no carrier entry names, by glob or by file language' {
        $file = Join-Path $script:root 'docs/gen.widget-unknown'
        [System.IO.File]::WriteAllText($file, "widget`n")
        { Set-GeneratedFileHead -Path docs/gen.widget-unknown -Writer Build-Widget } | Should -Throw '*matches no file-carriers.yml entry*'
        [System.IO.File]::ReadAllText($file) | Should -BeExactly "widget`n"
    }

    It 'leaves the file alone under -WhatIf, and refuses a missing file' {
        $file = Join-Path $script:root 'docs/gen.svg'
        [System.IO.File]::WriteAllText($file, "<svg><g/></svg>`n")
        Set-GeneratedFileHead -Path docs/gen.svg -Writer Build-Widget -WhatIf
        [System.IO.File]::ReadAllText($file) | Should -BeExactly "<svg><g/></svg>`n"
        { Set-GeneratedFileHead -Path docs/none.svg -Writer Build-Widget } | Should -Throw
    }
}
