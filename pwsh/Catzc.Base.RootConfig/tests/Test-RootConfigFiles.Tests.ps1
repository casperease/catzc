<#
---
catzc:
  immutable:
    with_body_sha: "2c57e7f6c741"
  edges:
    docs: "[Test-RootConfigFiles.Tests.ps1.md](../../../docs/references/pwsh/catzc-base-root-config/tests/Test-RootConfigFiles.Tests.ps1.md)"
    code: pwsh/Catzc.Base.RootConfig/Test-RootConfigFiles.ps1
    cites:
      - ADR-AUTO-TEST-DISTINCTFIXTUREIDENTITIES
---
#>

Describe 'Test-RootConfigFiles' -Tag 'L0', 'logic' {
    BeforeAll {
        $root = Join-Path $TestDrive 'repo'
        [void][System.IO.Directory]::CreateDirectory((Join-Path $root 'src'))
        [System.IO.File]::WriteAllText((Join-Path $root 'src/widget.json'), '{}')
        [System.IO.File]::WriteAllText((Join-Path $root 'src/gadget.json'), '{ "a": 1 }')
        [System.IO.File]::WriteAllText((Join-Path $root 'sprocket.json'), '{}')
        New-Item -ItemType HardLink -Path (Join-Path $root 'cog.json') -Value (Join-Path $root 'src/widget.json') | Out-Null
        # A managed copy is its template under the generated head, as Build-RootConfig writes it.
        $copyOf = {
            param([string] $Target, [string] $Source)
            InModuleScope Catzc.Base.RootConfig -Parameters @{ Target = $Target; Source = $Source; Root = $root } {
                param($Target, $Source, $Root)
                Get-RootConfigCopyContent -Entry ([pscustomobject]@{ target = $Target; source = $Source; carrier = $null }) -SourcePath (Join-Path $Root $Source)
            }
        }
        $script:gadgetCopy = & $copyOf 'gadget.json' 'src/gadget.json'
        [System.IO.File]::WriteAllText((Join-Path $root 'gadget.json'), $script:gadgetCopy)
        [System.IO.File]::WriteAllText((Join-Path $root 'widget.json'), (& $copyOf 'widget.json' 'src/widget.json'))
        $script:out = Join-Path $TestDrive 'out'
    }

    BeforeEach {
        Mock Get-RepositoryRoot -ModuleName Catzc.Base.RootConfig { Join-Path $TestDrive 'repo' }
        Mock Write-Message -ModuleName Catzc.Base.Reports { }
        Mock Get-Config -ModuleName Catzc.Base.RootConfig -ParameterFilter { $Config -eq 'rootconfig' } { [pscustomobject]@{} }
        $script:entries = @(
            [pscustomobject]@{ target = 'widget.json'; source = 'src/widget.json'; carrier = $null; committed = $false }
            [pscustomobject]@{ target = 'gadget.json'; source = 'src/gadget.json'; carrier = $null; committed = $true }
        )
        Mock Get-RootConfigTargets -ModuleName Catzc.Base.RootConfig { $entries }
        $script:ignored = @('widget.json')
        $script:tracked = @('gadget.json')
        Mock Invoke-Executable -ModuleName Catzc.Base.RootConfig -ParameterFilter { $Command -match ' check-ignore --no-index ' } {
            [pscustomobject]@{ Output = $ignored -join "`n"; Errors = ''; ExitCode = [int]($ignored.Count -eq 0) }
        }
        Mock Get-GitTrackedPath -ModuleName Catzc.Base.RootConfig { $Path | Where-Object { $_ -in $tracked } }
    }

    It 'passes when the registry, .gitignore, git tracking and the copies agree' {
        $result = Test-RootConfigFiles -OutputFolder $out -PassThru
        $result.IssueCount | Should -Be 0
        $result.Facts['Files'] | Should -Be 2
    }

    It 'throws once naming every disagreement' {
        $script:entries += [pscustomobject]@{ target = 'sprocket.json'; source = 'src/widget.json'; carrier = $null; committed = $false }
        $script:entries += [pscustomobject]@{ target = 'cog.json'; source = 'src/widget.json'; carrier = $null; committed = $true }
        $script:ignored = @('widget.json', 'cog.json')
        $script:tracked = @('gadget.json', 'sprocket.json')
        $thrown = { Test-RootConfigFiles -OutputFolder $out } | Should -Throw -PassThru
        $message = $thrown.Exception.Message
        $message | Should -BeLike 'Test-RootConfigFiles failed: 6 issue(s)*'
        $message | Should -Match 'sprocket.json: committed:false but no .gitignore rule ignores it'
        $message | Should -Match "sprocket.json: committed:false but tracked — a gitignored artifact; run 'git rm --cached sprocket.json'"
        $message | Should -Match 'sprocket.json: differs from src/widget.json under its generated head'
        $message | Should -Match 'cog.json: committed:true but not tracked'
        $message | Should -Match 'cog.json: committed:true but matched by a .gitignore rule'
        $message | Should -Match 'cog.json: a link, but must be a real, independent file'
    }

    It 'passes a copy that is its template under the head, and fails a copy with any other difference or none at all' {
        $gadget = Join-Path $TestDrive 'repo/gadget.json'
        (Test-RootConfigFiles -OutputFolder $out -PassThru).IssueCount | Should -Be 0
        try {
            [System.IO.File]::WriteAllText($gadget, $script:gadgetCopy + "edited`n")
            (Test-RootConfigFiles -OutputFolder $out -PassThru).Issues | Should -Be @('gadget.json: differs from src/gadget.json under its generated head — edit the template, then re-run the importer')
            [System.IO.File]::Delete($gadget)
            (Test-RootConfigFiles -OutputFolder $out -PassThru).Issues | Should -Be @('gadget.json: missing — re-run the importer (Build-RootConfig copies src/gadget.json)')
        }
        finally {
            [System.IO.File]::WriteAllText($gadget, $script:gadgetCopy)
        }
    }

    It 'checks a wildcard entry per file its generator renders' {
        Mock Get-RootConfigRenderedFile -ModuleName Catzc.Base.RootConfig {
            [pscustomobject]@{ Target = 'widgets/alpha/gadget.txt'; Content = "alpha`n" }
            [pscustomobject]@{ Target = 'widgets/beta/gadget.txt'; Content = "beta`n" }
        }
        $script:entries += [pscustomobject]@{ target = 'widgets/*/gadget.txt'; source = $null; generator = 'New-Widget'; carrier = $null; committed = $false }
        $script:ignored = @('widget.json', 'widgets/alpha/gadget.txt')
        $result = Test-RootConfigFiles -OutputFolder $out -PassThru
        $result.Facts['Files'] | Should -Be 4
        $result.Issues | Should -Be @('widgets/beta/gadget.txt: committed:false but no .gitignore rule ignores it')
        Should -Invoke Get-RootConfigRenderedFile -ModuleName Catzc.Base.RootConfig -Times 1 -Exactly
    }

    It 'throws on a git failure rather than reporting every target unignored' {
        Mock Invoke-Executable -ModuleName Catzc.Base.RootConfig -ParameterFilter { $Command -match ' check-ignore ' } {
            [pscustomobject]@{ Output = ''; Errors = 'fatal: not a git repository'; ExitCode = 128 }
        }
        { Test-RootConfigFiles -OutputFolder $out } | Should -Throw '*git check-ignore failed (128)*'
    }

    It 'returns the issues under -PassThru instead of throwing' {
        $script:tracked = @()
        $result = Test-RootConfigFiles -OutputFolder $out -PassThru
        $result.Subject | Should -Be 'root-config-files'
        $result.Issues | Should -HaveCount 1
    }
}
