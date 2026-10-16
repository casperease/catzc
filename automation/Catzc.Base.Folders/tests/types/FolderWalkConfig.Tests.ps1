<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Folders/tests/types/FolderWalkConfig.Tests.ps1
    kind: test
    language: powershell
    filekind: ps1
    track: automation
    module: Catzc.Base.Folders
    relatives:
      page: docs/references/automation/catzc-base-folders/tests/types/FolderWalkConfig.Tests.ps1.md
      source: automation/Catzc.Base.Folders/types/FolderWalkConfig.cs
    adrs:
      - ADR-AUTO-DEFAULT#6
---
#>

Describe 'FolderWalkConfig' -Tag 'L0', 'logic' {
    It 'takes the declared defaults for every omitted key' -Tag 'ADR-AUTO-DEFAULT#6' {
        $config = [Catzc.Base.Folders.FolderWalkConfig]::new(@{})
        $config.depth | Should -Be 2
        $config.exclude | Should -Be @('.git', 'node_modules', 'out')
        $config.prune_vendor_in_searches | Should -BeTrue
    }

    It 'takes the defaults from a missing file as well' -Tag 'ADR-AUTO-DEFAULT#6' {
        ([Catzc.Base.Folders.FolderWalkConfig]::new($null)).depth | Should -Be 2
    }

    It 'maps every key it is given' {
        $config = [Catzc.Base.Folders.FolderWalkConfig]::new(@{ depth = 3; exclude = @('gadget'); prune_vendor_in_searches = $false })
        $config.depth | Should -Be 3
        $config.exclude | Should -Be @('gadget')
        $config.prune_vendor_in_searches | Should -BeFalse
    }

    It 'names the vendor folder once' {
        [Catzc.Base.Folders.FolderWalkConfig]::VendorFolder | Should -Be '.vendor'
    }

    It 'rejects an unknown key, naming the allowed set' {
        { [Catzc.Base.Folders.FolderWalkConfig]::new(@{ gadget = 1 }) } | Should -Throw '*unknown key ''gadget''*depth, exclude, prune_vendor_in_searches*'
    }

    It 'rejects a depth that is not a whole number from 1 to 64' {
        { [Catzc.Base.Folders.FolderWalkConfig]::new(@{ depth = 0 }) } | Should -Throw '*depth ''0'' must be a whole number from 1 to 64*'
        { [Catzc.Base.Folders.FolderWalkConfig]::new(@{ depth = 65 }) } | Should -Throw '*from 1 to 64*'
        { [Catzc.Base.Folders.FolderWalkConfig]::new(@{ depth = 'deep' }) } | Should -Throw '*from 1 to 64*'
    }

    It 'rejects an exclude that is not a list of bare folder names' {
        { [Catzc.Base.Folders.FolderWalkConfig]::new(@{ exclude = 'gadget' }) } | Should -Throw '*exclude must be a list*'
        { [Catzc.Base.Folders.FolderWalkConfig]::new(@{ exclude = @('widget/gadget') }) } | Should -Throw '*without a path separator*'
        { [Catzc.Base.Folders.FolderWalkConfig]::new(@{ exclude = @(' ') }) } | Should -Throw '*not blank*'
    }

    It 'rejects a prune flag that is not a boolean' {
        { [Catzc.Base.Folders.FolderWalkConfig]::new(@{ prune_vendor_in_searches = 'yes' }) } | Should -Throw '*must be true or false*'
    }

    It 'reports every violation in one exception' {
        { [Catzc.Base.Folders.FolderWalkConfig]::new(@{ depth = 0; gadget = 1 }) } | Should -Throw '*unknown key*depth*'
    }
}

Describe 'FolderWalkConfig (shipped folder-walk.yml)' -Tag 'L1', 'integrity' {
    It 'loads the shipped folder-walk.yml as a FolderWalkConfig' -Tag 'ADR-AUTO-DEFAULT#6' {
        (Get-Config -Config folder-walk) | Should -BeOfType ([Catzc.Base.Folders.FolderWalkConfig])
    }

    It 'is readable as the global address global.folder-walk.prune_vendor_in_searches' -Tag 'ADR-CONF-ADDRESS' {
        Get-ConfigValue -Address 'global.folder-walk.prune_vendor_in_searches' | Should -BeTrue
    }
}
