<#
---
catzc:
  immutable:
    with_body_sha: cced929203cc
  edges:
    code: pwsh/Catzc.Base.QualityGates/Test-Parsing.ps1
    cites:
      - ADR-AUTO-TEST-QUALITYGATE
---
#>

Describe 'Test-Parsing' -Tag 'L0', 'logic', 'ADR-AUTO-TEST-QUALITYGATE' {
    BeforeAll {
        $script:root = Join-Path $TestDrive 'widgets'
        $null = [System.IO.Directory]::CreateDirectory($script:root)
        $script:write = {
            param([string] $Name, [string] $Text)
            $file = Join-Path $script:root $Name
            [System.IO.File]::WriteAllText($file, $Text)
            $file
        }
        $script:cleanScript = & $script:write 'Get-Widget.ps1' "function Get-Widget {`n    'widget'`n}`n"
        $script:brokenScript = & $script:write 'Get-Gadget.ps1' "function Get-Gadget {`n    'gadget`n}`n"
        $script:cleanModule = & $script:write 'Widget.psm1' "Set-StrictMode -Version Latest`n"
        $script:cleanData = & $script:write 'Widget.psd1' "@{ ModuleVersion = '0.0.0' }`n"
        $script:cleanYaml = & $script:write 'widget.yml' "widgets:`n  - gadget`n  - sprocket`n"
        $script:brokenYaml = & $script:write 'gadget.yml' "gadgets:`n  - gadget`n  sprocket: [`n"
        $script:other = & $script:write 'widget.txt' "widget`n"
        $script:report = Join-Path $TestDrive 'report'
    }

    It 'passes PowerShell and YAML files that parse, and counts every file' {
        $result = Test-Parsing -Path $script:cleanScript, $script:cleanModule, $script:cleanData, $script:cleanYaml -OutputFolder $script:report -PassThru
        $result.IssueCount | Should -Be 0
        $result.Facts['FileCount'] | Should -Be 4
    }

    It 'reports a PowerShell file with a stray quote at the line the parser stopped at' {
        $result = Test-Parsing -Path $script:cleanScript, $script:brokenScript -OutputFolder $script:report -PassThru
        $result.IssueCount | Should -BeGreaterOrEqual 1
        @($result.Issues | Where-Object { $_ -like "${script:brokenScript}:2: *" }).Count | Should -BeGreaterOrEqual 1
        @($result.Issues | Where-Object { $_ -like "${script:cleanScript}*" }).Count | Should -Be 0
    }

    It 'reports a YAML file that does not parse, naming the file' {
        $result = Test-Parsing -Path $script:cleanYaml, $script:brokenYaml -OutputFolder $script:report -PassThru
        $result.IssueCount | Should -Be 1
        $result.Issues[0] | Should -BeLike "${script:brokenYaml}: *"
    }

    It 'throws once listing every file that does not parse, without -PassThru' {
        { Test-Parsing -Path $script:brokenScript, $script:brokenYaml -OutputFolder $script:report } | Should -Throw '*Get-Gadget.ps1*gadget.yml*'
    }

    It 'throws on a file it has no parser for' {
        { Test-Parsing -Path $script:other -OutputFolder $script:report -PassThru } | Should -Throw "*widget.txt' is not a PowerShell*"
    }
}
