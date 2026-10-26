# ContractLayout lists one level of the contracts tree through the bounded walker: folders, file names and entry names,
# in ordinal order.
Describe 'ContractLayout' -Tag 'L0', 'logic', 'ADR-REPO-CONTRACT-LAYOUT' {
    BeforeAll {
        $root = Join-Path $TestDrive ([guid]::NewGuid().ToString('N'))
        foreach ($folder in 'widget/1.2.0', 'widget/0.0.0', 'widget/node_modules', 'widget/.vendor') {
            [System.IO.Directory]::CreateDirectory((Join-Path $root $folder)) | Out-Null
        }
        foreach ($file in 'widget/contract.yml', 'widget/README.md') {
            [System.IO.File]::WriteAllText((Join-Path $root $file), 'x')
        }
        $script:unit = Join-Path $root 'widget'
        $script:layout = [Catzc.Base.Contracts.ContractLayout]::new()
    }

    It 'lists the folders directly in a folder as full paths, in ordinal order, the config''s names pruned' -Tag 'ADR-PWSH-ENUM-PRUNEFOLDERS' {
        @($script:layout.Folders($script:unit) | ForEach-Object { [System.IO.Path]::GetFileName($_) }) |
            Should -Be @('0.0.0', '1.2.0')
        $script:layout.Folders($script:unit) | ForEach-Object { [System.IO.Path]::IsPathFullyQualified($_) |
            Should -BeTrue }
    }

    It 'lists the names of the files directly in a folder, in ordinal order' {
        $script:layout.FileNames($script:unit) | Should -Be @('README.md', 'contract.yml')
    }

    It 'lists every entry name for a presence check, none pruned' {
        $script:layout.EntryNames($script:unit) | Should -Be @('.vendor', '0.0.0', '1.2.0', 'README.md', 'contract.yml',
            'node_modules')
    }

    It 'fails on a folder the layout requires that is missing, naming it' -Tag 'ADR-AUTO-FAILFAST-ASSERTINPUTSATENTRY' {
        { $script:layout.Folders((Join-Path $script:unit 'gone')) } | Should -Throw '*does not exist*gone*'
        { $script:layout.FileNames((Join-Path $script:unit 'gone')) } | Should -Throw '*does not exist*gone*'
        { $script:layout.Folders('') } | Should -Throw '*folder*'
    }
}
