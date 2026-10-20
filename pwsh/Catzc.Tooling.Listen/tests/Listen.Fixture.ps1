function Write-ListenFixtureFile {
    param(
        [string] $Relative,
        [string] $Content
    )
    $path = Join-Path $ExecutionContext.SessionState.PSVariable.GetValue('script:root') $Relative
    [void] [System.IO.Directory]::CreateDirectory([System.IO.Path]::GetDirectoryName($path))
    [System.IO.File]::WriteAllText($path, $Content)
}

function Initialize-ListenFixture {
    $script:root = Join-Path $TestDrive ('repo-' + [guid]::NewGuid().ToString('N').Substring(0, 8))
    Write-ListenFixtureFile 'docs/adr/widget.md' "# Widget`n`nThe widget rule, ADR-WIDGET-PARTS-SINGLE.`n"
    Write-ListenFixtureFile 'docs/explanation/gadget.md' "# Gadget`n`nWhy the gadget turns.`n"
    $script:root
}

function Register-ListenFixtureMocks {
    $script:config = [Catzc.Tooling.Listen.ListenConfig]::new([ordered]@{
            poll_milliseconds = 100
            quiet_seconds     = 0
            tiers             = @(
                [ordered]@{ name = 'rule'; kinds = @('adr') }
                [ordered]@{ name = 'docs'; kinds = @('explanation') }
            )
        })

    Mock Get-RepositoryRoot -ModuleName Catzc.Tooling.Listen { $ExecutionContext.SessionState.PSVariable.GetValue('script:root') }
    Mock Get-Config -ModuleName Catzc.Tooling.Listen -ParameterFilter { $Config -eq 'listen' } { $script:config }
    Mock Write-Message -ModuleName Catzc.Tooling.Listen { }
    Mock Get-FileKind -ModuleName Catzc.Tooling.Listen {
        if ($Path -like '*/adr/*') {
            [Catzc.Base.Globs.FileKindMatch]::new('adr', $null, 'A widget rule.')
        }
        elseif ($Path -like '*/explanation/*') {
            [Catzc.Base.Globs.FileKindMatch]::new('explanation', $null, 'A gadget page.')
        }
    }
    # The committed reference: the fixture's files as committed, plus a code file and a binary one outside the watched folder.
    Mock New-RepositorySnapshot -ModuleName Catzc.Tooling.Listen {
        $root = $ExecutionContext.SessionState.PSVariable.GetValue('script:root')
        foreach ($relative in 'docs/adr/widget.md', 'docs/explanation/gadget.md') {
            $target = Join-Path $Destination $relative
            [void] [System.IO.Directory]::CreateDirectory([System.IO.Path]::GetDirectoryName($target))
            [System.IO.File]::Copy((Join-Path $root $relative), $target)
        }
        [System.IO.File]::WriteAllText((Join-Path $Destination 'Get-Widget.ps1'), "# Follows ADR-WIDGET-PARTS-SINGLE.`n")
        [System.IO.File]::WriteAllBytes((Join-Path $Destination 'widget.bin'), [byte[]] @(65, 0, 66))
        [void] [System.IO.Directory]::CreateDirectory((Join-Path $Destination '.git'))
        [System.IO.File]::WriteAllText((Join-Path $Destination '.git/HEAD'), "ADR-WIDGET-PARTS-SINGLE`n")
        [pscustomobject]@{ Path = $Destination; Commit = 'c0ffee0000000000000000000000000000000000' }
    }
}
