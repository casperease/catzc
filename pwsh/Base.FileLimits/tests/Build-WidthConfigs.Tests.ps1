<#
---
catzc:
  docs: "../../../docs/references/pwsh/catzc-base-file-limits/tests/Build-WidthConfigs.Tests.ps1.md"
  header: "generated"
---
#>

# The widths are rendered from file-limits.yml, so this pins them to the formatters' widths.
Describe 'Build-WidthConfigs' -Tag 'L1', 'integrity', 'ADR-REPO-FORMAT-CONFIGUREDFORMATTERS' {
    It 'renders .editorconfig with ps1 at 120 and md and py at 140, and leaves no token' {
        $text = Build-WidthConfigs -Target '.editorconfig'
        $text | Should -Not -Match '\$width\.'
        $widths = [regex]::Matches($text, '(?m)^max_line_length = (\d+)\s*$') |
            ForEach-Object { [int] $_.Groups[1].Value }
        $widths | Should -Be @(120, 140, 140)
    }

    It 'renders prettier printWidth at 140' {
        $text = Build-WidthConfigs -Target '.prettierrc.yml'
        $text | Should -Not -Match '\$width\.'
        $text | Should -Match '(?m)^printWidth: 140\s*$'
    }

    It 'renders every markdownlint MD013 length at 140' {
        $text = Build-WidthConfigs -Target '.markdownlint.yml'
        $text | Should -Not -Match '\$width\.'
        $md013 = ($text | ConvertFrom-Yaml -Ordered)['MD013']
        $md013['line_length'] | Should -Be 140
        $md013['heading_line_length'] | Should -Be 140
        $md013['code_block_line_length'] | Should -Be 140
    }

    It 'rejects a target it does not render' {
        { Build-WidthConfigs -Target '.prettierignore' } | Should -Throw
    }
}

Describe 'Build-WidthConfigs — shipped assets/root templates' -Tag 'L1', 'integrity', 'ADR-AUTO-ASSETDEP-COVEREDBYREALTEST' {
    It 'renders every target from the template the loaded RootConfig module ships, each width token filled' {
        foreach ($target in '.editorconfig', '.prettierrc.yml', '.markdownlint.yml') {
            $text = Build-WidthConfigs -Target $target
            $text | Should -Not -BeNullOrEmpty -Because "the shipped template for $target is found"
            $text | Should -Not -Match '[$]width[.]' -Because "every width token of $target is filled"
        }
    }
}
