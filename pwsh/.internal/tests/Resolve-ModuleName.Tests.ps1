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

    It 'joins the namespace to any folder, one that spells it included, and leaves a full name outside the namespace whole' {
        & $script:resolve @{ Folder = 'Gadgets.Base.Widget'; Namespace = 'Gadgets' } | Should -BeExactly 'Gadgets.Gadgets.Base.Widget' -Because 'a folder never carries the namespace, so nothing is taken as already full'
        & $script:resolve @{ FullName = 'Sprockets.Base.Widget'; Namespace = 'Gadgets' } | Should -BeExactly 'Sprockets.Base.Widget'
        & $script:resolve @{ FullName = 'Gadgets.'; Namespace = 'Gadgets' } | Should -BeExactly 'Gadgets.' -Because 'a bare namespace names no module'
    }

    It 'joins by the track''s join: <Join> between <Namespace> and the folder' -ForEach @(
        @{ Namespace = 'gadgets'; Join = '-'; Folder = 'spin-lamps'; Full = 'gadgets-spin-lamps' }
        @{ Namespace = 'gadgets'; Join = '_'; Folder = 'spin'; Full = 'gadgets_spin' }
        @{ Namespace = 'gadgets'; Join = ''; Folder = 'spin'; Full = 'gadgetsspin' }
    ) {
        & $script:resolve @{ Folder = $Folder; Namespace = $Namespace; Join = $Join } | Should -BeExactly $Full
        & $script:resolve @{ FullName = $Full; Namespace = $Namespace; Join = $Join } | Should -BeExactly $Folder
    }

    It 'agrees with its C# twin on the track type for every case and every join' {
        foreach ($case in @(@{ Namespace = 'Gadgets'; Join = '.' }, @{ Namespace = 'gadgets'; Join = '-' }, @{ Namespace = 'gadgets'; Join = '_' },
                @{ Namespace = 'gadgets'; Join = '' })) {
            $track = [Catzc.Base.Variants.VariantTrack]::new('widgets', @([Catzc.Base.Variants.VariantMember]::new('widgets')), 'modules', $null,
                @(), $null, $null, $null, $case.Namespace, $case.Join)
            $joined = "$($case.Namespace)$($case.Join)"
            foreach ($folder in 'Base.Widget', "${joined}Base.Widget", 'Widget') {
                $track.FullNameOf($folder) | Should -BeExactly (& $script:resolve @{ Folder = $folder; Namespace = $case.Namespace; Join = $case.Join })
            }
            foreach ($full in "${joined}Base.Widget", 'Sprockets.Widget') {
                $track.FolderNameOf($full) | Should -BeExactly (& $script:resolve @{ FullName = $full; Namespace = $case.Namespace; Join = $case.Join })
            }
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

    It 'resolves every module folder of the tree, short on disk, to its full name under the namespace the pwsh track declares, and back' {
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
            $folder | Should -Not -BeLike "$($track.namespace)$($track.join)*" -Because 'no folder spells the namespace on disk'
            $full | Should -BeExactly "$($track.namespace)$($track.join)$folder"
            $track.FullNameOf($folder) | Should -BeExactly $full
            $track.FolderNameOf($full) | Should -BeExactly $folder
        }
    }
}
