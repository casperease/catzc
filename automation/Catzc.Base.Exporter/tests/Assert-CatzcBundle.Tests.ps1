Describe 'Assert-CatzcBundle' -Tag 'L0', 'logic' {
    BeforeEach {
        $script:bundle = Join-Path $TestDrive ([System.Guid]::NewGuid())
        $compiled = Join-Path $bundle 'automation/.compiled'
        [System.IO.Directory]::CreateDirectory($compiled) | Out-Null
        [System.IO.File]::WriteAllText((Join-Path $compiled 'Catzc.Types.abc12345.dll'), 'MZ')
        $moduleDir = Join-Path $bundle 'automation/Catzc.Base.Widget'
        [System.IO.Directory]::CreateDirectory($moduleDir) | Out-Null
        [System.IO.File]::WriteAllText((Join-Path $moduleDir 'Get-Widget.ps1'), 'function Get-Widget { }')
        [System.IO.File]::WriteAllText((Join-Path $bundle 'importer.ps1'), '# bundle importer')

        $hash = Get-CatzcContentHash -Path $bundle -Exclude 'build.json'
        [System.IO.File]::WriteAllText((Join-Path $bundle 'build.json'), (@{ contentHash = $hash } | ConvertTo-Json))
    }

    It 'passes a well-formed bundle' {
        { Assert-CatzcBundle -Path $bundle } | Should -Not -Throw
    }

    It 'throws on a content-hash mismatch (drift after build)' {
        [System.IO.File]::WriteAllText((Join-Path $bundle 'automation/Catzc.Base.Widget/Get-Widget.ps1'), 'changed')
        { Assert-CatzcBundle -Path $bundle } | Should -Throw -ExpectedMessage '*content hash mismatch*'
    }

    It 'throws when a tests file leaked in (aspect purity)' {
        $testsDir = Join-Path $bundle 'automation/Catzc.Base.Widget/tests'
        [System.IO.Directory]::CreateDirectory($testsDir) | Out-Null
        [System.IO.File]::WriteAllText((Join-Path $testsDir 'Get-Widget.Tests.ps1'), 'x')
        { Assert-CatzcBundle -Path $bundle } | Should -Throw -ExpectedMessage '*test file*leaked*'
    }

    It 'throws when the prebuilt types DLL is missing' {
        [System.IO.File]::Delete((Join-Path $bundle 'automation/.compiled/Catzc.Types.abc12345.dll'))
        { Assert-CatzcBundle -Path $bundle } | Should -Throw -ExpectedMessage '*exactly one prebuilt types DLL*'
    }

    It 'throws when the bundle importer.ps1 is missing' {
        [System.IO.File]::Delete((Join-Path $bundle 'importer.ps1'))
        { Assert-CatzcBundle -Path $bundle } | Should -Throw -ExpectedMessage '*importer.ps1*'
    }

    It 'throws when build.json is missing' {
        [System.IO.File]::Delete((Join-Path $bundle 'build.json'))
        { Assert-CatzcBundle -Path $bundle } | Should -Throw -ExpectedMessage '*build.json*'
    }
}
