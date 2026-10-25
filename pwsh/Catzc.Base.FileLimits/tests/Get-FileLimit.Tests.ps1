# A file's limits come from its language in the one registry, so a file no language declares fails instead of escaping unlimited.
Describe 'Get-FileLimit' -Tag 'L0', 'logic' {
    It 'resolves a file by the language that declares it' {
        $limit = Get-FileLimit -Path 'widget/gadget.ps1'
        $limit.language | Should -Be 'powershell'
        $limit.file_class | Should -Be 'code'
        $limit.length | Should -BeGreaterThan 0
    }

    It 'resolves markdown as prose' {
        (Get-FileLimit -Path 'widget/gadget.md').file_class | Should -Be 'prose'
    }

    It 'resolves a psd1 as config by its extension override, before its language' {
        $limit = Get-FileLimit -Path 'widget/gadget.psd1'
        $limit.language | Should -Be 'powershell'
        $limit.file_class | Should -Be 'config'
        $limit.length_source | Should -Be 'extensions..psd1'
    }

    It 'fails on a file no language declares' {
        { Get-FileLimit -Path 'widget/gadget.nolanguage' } | Should -Throw '*No file language declares*'
    }
}

Describe 'Get-FileLimit (shipped registry)' -Tag 'L1', 'integrity' {
    It 'gives every declared language a class' {
        foreach ($language in Get-FileLanguage) {
            { (Get-Config -Config file-limits).Resolve($language.name) } | Should -Not -Throw -Because $language.name
        }
    }
}
