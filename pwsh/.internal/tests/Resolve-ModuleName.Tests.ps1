Describe 'Resolve-ModuleName' -Tag 'L0', 'logic', 'DDR-TRACK-MODULENAMESPACE' {
    BeforeAll {
        Import-Module (Join-Path (Get-CatzcModulesRoot) '.internal/Catzc.Internal.Bootstrap.psm1') -Force
        $script:resolve = {
            param([hashtable] $Arguments)
            InModuleScope Catzc.Internal.Bootstrap -Parameters @{ Arguments = $Arguments } {
                param($Arguments)
                Resolve-ModuleName @Arguments
            }
        }
    }

    AfterAll {
        Remove-Module Catzc.Internal.Bootstrap -Force -ErrorAction SilentlyContinue
    }

    It 'joins the namespace to a short folder name, and takes it off a full name, both ways round' {
        & $script:resolve @{ Folder = 'Base.Widget'; Namespace = 'Gadgets' } | Should -BeExactly 'Gadgets.Base.Widget'
        & $script:resolve @{ FullName = 'Gadgets.Base.Widget'; Namespace = 'Gadgets' } | Should -BeExactly 'Base.Widget'
        $full = & $script:resolve @{ Folder = 'Widget'; Namespace = 'Gadgets.Kit' }
        $full | Should -BeExactly 'Gadgets.Kit.Widget'
        & $script:resolve @{ FullName = $full; Namespace = 'Gadgets.Kit' } | Should -BeExactly 'Widget'
    }

    It 'takes the folder name as the full name when the track declares no namespace' {
        & $script:resolve @{ Folder = 'Gadgets.Base.Widget' } | Should -BeExactly 'Gadgets.Base.Widget'
        & $script:resolve @{ FullName = 'Gadgets.Base.Widget' } | Should -BeExactly 'Gadgets.Base.Widget'
    }

    It 'takes a folder that already spells its full name as it is, and leaves a full name outside the namespace whole' {
        & $script:resolve @{ Folder = 'Gadgets.Base.Widget'; Namespace = 'Gadgets' } | Should -BeExactly 'Gadgets.Base.Widget'
        & $script:resolve @{ FullName = 'Sprockets.Base.Widget'; Namespace = 'Gadgets' } | Should -BeExactly 'Sprockets.Base.Widget'
        & $script:resolve @{ FullName = 'Gadgets.'; Namespace = 'Gadgets' } | Should -BeExactly 'Gadgets.' -Because 'a bare namespace names no module'
    }

    It 'agrees with its C# twin on the track type for every case' {
        $track = [Catzc.Base.Variants.VariantTrack]::new('widgets', @([Catzc.Base.Variants.VariantMember]::new('widgets')), 'modules', $null, @(),
            $null, $null, $null, 'Gadgets')
        foreach ($folder in 'Base.Widget', 'Gadgets.Base.Widget', 'Widget') {
            $track.FullNameOf($folder) | Should -BeExactly (& $script:resolve @{ Folder = $folder; Namespace = 'Gadgets' })
        }
        foreach ($full in 'Gadgets.Base.Widget', 'Sprockets.Widget') {
            $track.FolderNameOf($full) | Should -BeExactly (& $script:resolve @{ FullName = $full; Namespace = 'Gadgets' })
        }
    }
}

Describe 'Resolve-ModuleName — the real pwsh track' -Tag 'L1', 'integrity' {
    BeforeAll {
        Import-Module (Join-Path (Get-CatzcModulesRoot) '.internal/Catzc.Internal.Bootstrap.psm1') -Force
    }

    AfterAll {
        Remove-Module Catzc.Internal.Bootstrap -Force -ErrorAction SilentlyContinue
    }

    It 'resolves every module folder of the tree to its own name, under the namespace the pwsh track declares' {
        $track = Get-Track -Name pwsh
        $track.namespace | Should -BeExactly 'Catzc'
        $root = Join-Path (Get-RepositoryRoot) (Get-CatzcModulesFolder)
        InModuleScope Catzc.Internal.Bootstrap -Parameters @{ Root = $root } { param($Root) Get-ModuleNamespace -ModulesRoot $Root } |
            Should -BeExactly $track.namespace -Because 'the bootstrap reads the same declaration before the types load'
        $folders = @([System.IO.Directory]::GetDirectories($root) | ForEach-Object { [System.IO.Path]::GetFileName($_) } | Where-Object { -not $_.StartsWith('.') })
        $folders.Count | Should -BeGreaterThan 0
        foreach ($folder in $folders) {
            $full = InModuleScope Catzc.Internal.Bootstrap -Parameters @{ Folder = $folder; Namespace = $track.namespace } {
                param($Folder, $Namespace)
                Resolve-ModuleName -Folder $Folder -Namespace $Namespace
            }
            $full | Should -BeExactly $folder -Because "every folder carries the namespace today, so $folder is its own full name"
            $track.FullNameOf($folder) | Should -BeExactly $folder
        }
    }
}
