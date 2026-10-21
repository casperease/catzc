<#
---
catzc:
  immutable:
    with_body_sha: "226373a3446e"
  edges:
    code: pwsh/Catzc.Tooling.Listen/New-DocSnapshot.ps1
---
#>

Describe 'New-DocSnapshot' -Tag 'L0', 'logic' {
    BeforeAll {
        . (Join-Path $PSScriptRoot 'Listen.Fixture.ps1')
        Register-ListenFixtureMocks
    }

    BeforeEach {
        Initialize-ListenFixture | Out-Null
    }

    It 'copies the watched folder twice, indexes it, and pins the committed reference' {
        $session = New-DocSnapshot
        $session.Watch | Should -BeExactly 'docs'
        $session.Commit | Should -BeExactly 'c0ffee0000000000000000000000000000000000'
        $session.Path | Should -BeLike (Join-Path $script:root 'out/listen/*')

        foreach ($copy in 'baseline', 'seen') {
            [System.IO.File]::ReadAllText((Join-Path $session.Path "$copy/adr/widget.md")) | Should -BeLike '*widget rule*'
            [System.IO.File]::Exists((Join-Path $session.Path "$copy/explanation/gadget.md")) | Should -BeTrue
            $index = [System.IO.File]::ReadAllText((Join-Path $session.Path "$copy.json")) | ConvertFrom-Json -AsHashtable
            @($index.Keys | Sort-Object) | Should -Be @('docs/drs/widget.md', 'docs/explanation/gadget.md')
            $index['docs/drs/widget.md'].hash | Should -Not -BeNullOrEmpty
        }
        [System.IO.Directory]::Exists((Join-Path $session.Path 'notes')) | Should -BeTrue
        Should -Invoke New-RepositorySnapshot -ModuleName Catzc.Tooling.Listen -Times 1 -Exactly -ParameterFilter {
            $Committed -and $Destination -eq (Join-Path $session.Path 'reference')
        }

        $manifest = [System.IO.File]::ReadAllText((Join-Path $session.Path 'manifest.json')) | ConvertFrom-Json
        $manifest.watch | Should -BeExactly 'docs'
        $manifest.commit | Should -BeExactly $session.Commit
    }

    It 'leaves no session behind when the committed reference fails' {
        Mock New-RepositorySnapshot -ModuleName Catzc.Tooling.Listen { throw 'the checkout broke' }
        { New-DocSnapshot } | Should -Throw '*the checkout broke*'
        $folders = @([System.IO.Directory]::GetDirectories((Join-Path $script:root 'out/listen')))
        [System.IO.File]::Exists((Join-Path $folders[0] 'seen.json')) | Should -BeFalse
        { Get-DocNote } | Should -Throw '*No listen session under*'
    }

    It 'throws when the watched folder does not exist' {
        { New-DocSnapshot -Watch 'gizmo' } | Should -Throw "*watched folder 'gizmo' does not exist*"
    }
}
