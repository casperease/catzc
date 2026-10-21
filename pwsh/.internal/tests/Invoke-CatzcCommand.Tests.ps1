<#
---
catzc:
  immutable:
    with_body_sha: "409138e82efb"
---
#>

Describe 'Invoke-CatzcCommand' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:entry = Join-Path $PSScriptRoot '../assets/Invoke-CatzcCommand.ps1'
        $script:importer = Join-Path $TestDrive 'importer.ps1'
        [System.IO.File]::WriteAllText($script:importer, "function Get-Widget { 'widget' }`nfunction Test-Gadget { param([string] `$Result) [pscustomobject]@{ Result = `$Result } }`n")
    }

    It 'reports a passing and a failing command and runs the one after the failure' {
        $lines = @(& $script:entry 'Get-Widget' 'throw "the gadget broke"' 'Get-Widget' -Importer $script:importer)
        $LASTEXITCODE | Should -Be 1
        $lines | Should -Be @(
            '[Invoke-CatzcCommand] passed: Get-Widget'
            '[Invoke-CatzcCommand] failed: throw "the gadget broke" — the gadget broke'
            '[Invoke-CatzcCommand] passed: Get-Widget'
            '[Invoke-CatzcCommand] 2 of 3 passed'
        )
    }

    It 'counts a written error as a failure' {
        $lines = @(& $script:entry 'Write-Error "gadget error"' -Importer $script:importer)
        $LASTEXITCODE | Should -Be 1
        $lines[0] | Should -BeExactly '[Invoke-CatzcCommand] failed: Write-Error "gadget error" — gadget error'
    }

    It 'reads the verdict of a result object: Failed fails, Passed passes' {
        $lines = @(& $script:entry 'Test-Gadget -Result Failed' 'Test-Gadget -Result Passed' -Importer $script:importer)
        $LASTEXITCODE | Should -Be 1
        $lines[0] | Should -BeExactly '[Invoke-CatzcCommand] failed: Test-Gadget -Result Failed — it reported Failed'
        $lines[1] | Should -BeExactly '[Invoke-CatzcCommand] passed: Test-Gadget -Result Passed'
    }

    It 'exits 0 when every command passes' {
        $lines = @(& $script:entry 'Get-Widget' -Importer $script:importer)
        $LASTEXITCODE | Should -Be 0
        $lines[-1] | Should -BeExactly '[Invoke-CatzcCommand] 1 of 1 passed'
    }

    It 'runs every command from the importer''s folder, and gives the caller its location back' {
        $caller = (Get-Location).Path
        $lines = @(& $script:entry "if ((Get-Location).Path -ne '$TestDrive') { throw `"ran in `$((Get-Location).Path)`" }" -Importer $script:importer)
        $lines[0] | Should -BeLike '`[Invoke-CatzcCommand`] passed: *'
        (Get-Location).Path | Should -Be $caller
    }

    It 'throws when no command is named' {
        { & $script:entry -Importer $script:importer } | Should -Throw '*name at least one command*'
    }
}
