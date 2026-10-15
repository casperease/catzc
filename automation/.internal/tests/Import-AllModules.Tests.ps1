<#
---
catzc:
  derived:
    path: automation/.internal/tests/Import-AllModules.Tests.ps1
    kind: pester-test
---
#>

BeforeAll {
    # Build an isolated sandbox = importer + the .internal shared modules (loader, bootstrap, …) + vendor, with
    # NO application modules. Each test populates it and runs the importer in a fresh child pwsh process (a cold,
    # fully-isolated re-derive of module state from the current files). The importer is a pure function of the
    # filesystem, so we only need ONE import per distinct tree shape — each test below captures everything it
    # needs from a single import, then asserts the facets in separate It blocks.
    $sandbox = Join-Path ([System.IO.Path]::GetTempPath()) "bootstrap-test-$([guid]::NewGuid().ToString('N'))"
    $sandboxAuto = Join-Path $sandbox 'automation'
    New-Item -Path $sandboxAuto -ItemType Directory -Force | Out-Null

    Copy-Item -Path (Join-Path $env:RepositoryRoot 'importer.ps1') -Destination $sandbox
    # Copy-Directory (raw [System.IO]) instead of Copy-Item -Recurse: .vendor (Pester + powershell-yaml, ~88
    # files) copies in ~190ms vs ~1.25s with the cmdlet.
    Copy-Directory (Join-Path $env:RepositoryRoot 'automation/.internal') (Join-Path $sandboxAuto '.internal')
    Copy-Directory (Join-Path $env:RepositoryRoot 'automation/.vendor') (Join-Path $sandboxAuto '.vendor')

    # Expression (run inside the child) that lists the loaded application modules and their exported functions.
    # Bootstrap and the vendored modules are filtered out; $_ is escaped so it evaluates in the child.
    $script:moduleListExpr =
    "@(Get-Module | Where-Object { `$_.Path -like '$sandboxAuto*' -and `$_.Name -ne 'Bootstrap' -and `$_.Path -notlike '*/.vendor/*' -and `$_.Path -notlike '*\.vendor\*' -and `$_.Path -notlike '*/.internal/*' -and `$_.Path -notlike '*\.internal\*' } | " +
    "ForEach-Object { [pscustomobject]@{ Name = `$_.Name; Exported = @(`$_.ExportedFunctions.Keys | Sort-Object) } })"

    function Invoke-Sandbox {
        # ONE cold import in a child pwsh; $Capture is evaluated AFTER the import and returned as parsed JSON. The
        # import's announcements are information records
        # ([ADR-AUTO-CONSOLE#11](/docs/adr/automation/console-output-matters.md#rule-adr-auto-console11)), so
        # 6>$null keeps them out of the JSON.
        param([Parameter(Mandatory)][string]$Capture)
        $script = ". '$sandbox/importer.ps1' 6>`$null`n$Capture | ConvertTo-Json -Depth 6 -Compress"
        $raw = pwsh -NoProfile -Command $script 2>&1
        if ($LASTEXITCODE -ne 0) {
            throw "Importer failed: $raw"
        }
        $text = "$raw".Trim()
        if (-not $text) {
            return @()
        }
        return ($text | ConvertFrom-Json)
    }

    function Add-SandboxFunction {
        param([string]$Module, [string]$Function, [string]$Body, [switch]$Private)
        $directory = Join-Path $sandboxAuto $Module
        if ($Private) {
            $directory = Join-Path $directory 'private'
        }
        # [System.IO] rather than New-Item/Set-Content — ~20 calls of cmdlet per-call overhead add up here.
        [System.IO.Directory]::CreateDirectory($directory) | Out-Null
        [System.IO.File]::WriteAllText((Join-Path $directory "$Function.ps1"), "function $Function { $Body }")
    }

    function Remove-SandboxFunction {
        param([string]$Module, [string]$Function, [switch]$Private)
        $directory = Join-Path $sandboxAuto $Module
        if ($Private) {
            $directory = Join-Path $directory 'private'
        }
        Remove-Item -Path (Join-Path $directory "$Function.ps1") -Force
    }

    function Remove-SandboxModule {
        param([string]$Module)
        Remove-Item -Path (Join-Path $sandboxAuto $Module) -Recurse -Force
    }
}

AfterAll {
    if (Test-Path $sandbox) {
        Remove-Item $sandbox -Recurse -Force
    }
}

Describe 'Bootstrap' -Tag 'L0', 'logic' {
    # NOTE: contexts run in file order and share one sandbox. 'empty' must come before any module is added.

    Context 'empty automation folder' -Tag 'L1' {
        It 'imports without error and loads no modules' {
            @(Invoke-Sandbox -Capture $moduleListExpr) | Should -HaveCount 0
        }
    }

    Context 'a populated tree' {
        # One import of a rich tree covers discovery, public export, the public/private boundary, a private
        # being callable from a public function, multiple independent modules, and the collision guard NOT
        # falsely-giving-positives on a private name shared across modules (the import simply succeeds).
        BeforeAll {
            Add-SandboxFunction -Module 'Acme' -Function 'Get-Acme' -Body '"v1"'
            Add-SandboxFunction -Module 'Acme' -Function 'Get-AcmeVersion' -Body '"1.0"'
            Add-SandboxFunction -Module 'Acme' -Function 'Get-AcmeSecret' -Body '"secret"' -Private
            Add-SandboxFunction -Module 'Acme' -Function 'Get-AcmeProxy' -Body 'Get-AcmeSecret'
            Add-SandboxFunction -Module 'Alpha' -Function 'Get-Alpha' -Body '"a"'
            Add-SandboxFunction -Module 'Beta' -Function 'Get-Beta' -Body '"b"'
            Add-SandboxFunction -Module 'PrivA' -Function 'Get-PrivAThing' -Body 'Get-Shared'
            Add-SandboxFunction -Module 'PrivA' -Function 'Get-Shared' -Body '"a"' -Private
            Add-SandboxFunction -Module 'PrivB' -Function 'Get-PrivBThing' -Body 'Get-Shared'
            Add-SandboxFunction -Module 'PrivB' -Function 'Get-Shared' -Body '"b"' -Private
            # Reads a variable nobody set: strict mode makes that an error, so the answer says how the module runs.
            Add-SandboxFunction -Module 'Acme' -Function 'Test-AcmeStrict' -Body 'try { $null = $acmeNeverSet; "not strict" } catch { "strict" }'

            $script:observed = Invoke-Sandbox -Capture "[pscustomobject]@{ Modules = $moduleListExpr; Proxy = (Get-AcmeProxy); Strict = (Test-AcmeStrict) }"
            $script:modules = @($observed.Modules)
        }

        It 'discovers a module and exports its public functions' {
            $acme = $modules | Where-Object { $_.Name -eq 'Acme' }
            $acme.Exported | Should -Contain 'Get-Acme'
            $acme.Exported | Should -Contain 'Get-AcmeVersion'
            $acme.Exported | Should -Contain 'Get-AcmeProxy'
        }

        It 'does not export functions under private/' {
            $acme = $modules | Where-Object { $_.Name -eq 'Acme' }
            $acme.Exported | Should -Not -Contain 'Get-AcmeSecret'
        }

        It 'makes a private function callable from a public one (shared module scope)' {
            $observed.Proxy | Should -Be 'secret'
        }

        It 'runs the module''s functions strict' {
            $observed.Strict | Should -Be 'strict'
        }

        It 'loads multiple modules independently' {
            ($modules | Where-Object { $_.Name -eq 'Alpha' }).Exported | Should -Contain 'Get-Alpha'
            ($modules | Where-Object { $_.Name -eq 'Beta' }).Exported | Should -Contain 'Get-Beta'
        }

        It 'allows the same private name in different modules (no false collision)' {
            # The import above succeeded with PrivA and PrivB each defining a private Get-Shared; both modules
            # loaded and neither exports it — proving the collision guard ignores module-scoped privates.
            ($modules | Where-Object { $_.Name -eq 'PrivA' }).Exported | Should -Contain 'Get-PrivAThing'
            ($modules | Where-Object { $_.Name -eq 'PrivB' }).Exported | Should -Contain 'Get-PrivBThing'
            ($modules | Where-Object { $_.Name -eq 'PrivA' }).Exported | Should -Not -Contain 'Get-Shared'
        }
    }

    Context 're-derives state from the filesystem (add / change / delete)' {
        # Mutate the populated tree every way an author can, then re-import: one cold import must reflect a
        # changed body, an added function, a deleted function, and a deleted module.
        BeforeAll {
            Add-SandboxFunction -Module 'Acme' -Function 'Get-Acme' -Body '"v2"'            # change a body
            Add-SandboxFunction -Module 'Acme' -Function 'Get-AcmeExtra' -Body '"extra"'    # add a function
            Remove-SandboxFunction -Module 'Acme' -Function 'Get-AcmeVersion'               # delete a public fn
            Remove-SandboxFunction -Module 'Acme' -Function 'Get-AcmeSecret' -Private       # delete a private fn
            Add-SandboxFunction -Module 'Acme' -Function 'Get-AcmeProxy' -Body '"no-secret"' # stop calling it
            Remove-SandboxModule -Module 'Beta'                                             # delete a module

            $script:observed = Invoke-Sandbox -Capture "[pscustomobject]@{ Modules = $moduleListExpr; Acme = (Get-Acme) }"
            $script:modules = @($observed.Modules)
        }

        It 'picks up a changed function body' {
            $observed.Acme | Should -Be 'v2'
        }

        It 'picks up a newly added function' {
            ($modules | Where-Object { $_.Name -eq 'Acme' }).Exported | Should -Contain 'Get-AcmeExtra'
        }

        It 'drops a deleted function (and the module still loads)' {
            $acme = $modules | Where-Object { $_.Name -eq 'Acme' }
            $acme | Should -Not -BeNullOrEmpty
            $acme.Exported | Should -Not -Contain 'Get-AcmeVersion'
        }

        It 'drops a deleted module' {
            $modules | Where-Object { $_.Name -eq 'Beta' } | Should -BeNullOrEmpty
        }
    }

    Context 'duplicate public function across modules' -Tag 'L1' {
        BeforeAll {
            Add-SandboxFunction -Module 'DupeA' -Function 'Get-Dupe' -Body '"a"'
            Add-SandboxFunction -Module 'DupeB' -Function 'Get-Dupe' -Body '"b"'
        }

        AfterAll {
            Remove-SandboxModule -Module 'DupeA'
            Remove-SandboxModule -Module 'DupeB'
        }

        It 'fails the import, naming the duplicated function' {
            { Invoke-Sandbox -Capture $moduleListExpr } | Should -Throw -ExpectedMessage '*collision*Get-Dupe: defined by*'
        }
    }

    Context 'function shadowing an imported vendor command' -Tag 'L1' {
        BeforeAll {
            # powershell-yaml (a vendored module) imports before our modules and exports ConvertFrom-Yaml.
            Add-SandboxFunction -Module 'Shadower' -Function 'ConvertFrom-Yaml' -Body '"nope"'
        }

        AfterAll {
            Remove-SandboxModule -Module 'Shadower'
        }

        It 'fails the import, naming the shadowed command' {
            { Invoke-Sandbox -Capture $moduleListExpr } | Should -Throw -ExpectedMessage '*ConvertFrom-Yaml*shadow*'
        }
    }
}

# Greedy: one child pwsh dot-sources three importers in sequence (process-global module state), so it consumes the
# machine beyond its own process and carries an L2-scale budget
# ([ADR-AUTO-TEST#26](/docs/adr/automation/test-automation.md#rule-adr-auto-test26)).
Describe 'Run-mode eviction across code roots' -Tag 'L2', 'logic', 'greedy' {
    BeforeAll {
        # Two complete sandbox roots (importer + .internal + .vendor) — stand-ins for a source tree and a build.
        # Each holds a module only it ships and a same-named module that reports which root it came from.
        function New-EvictionRoot {
            param([string] $Label, [string] $OnlyModule, [string] $OnlyFunction, [string] $OnlyBody)
            $root = Join-Path ([System.IO.Path]::GetTempPath()) "eviction-$Label-$([guid]::NewGuid().ToString('N'))"
            $automation = Join-Path $root 'automation'
            [System.IO.Directory]::CreateDirectory($automation) | Out-Null
            Copy-Item -Path (Join-Path $env:RepositoryRoot 'importer.ps1') -Destination $root
            Copy-Directory (Join-Path $env:RepositoryRoot 'automation/.internal') (Join-Path $automation '.internal')
            Copy-Directory (Join-Path $env:RepositoryRoot 'automation/.vendor') (Join-Path $automation '.vendor')
            foreach ($entry in @(@($OnlyModule, $OnlyFunction, $OnlyBody), @('Catzc.Shared', 'Get-SharedOrigin', "'$Label'"))) {
                $folder = Join-Path $automation $entry[0]
                [System.IO.Directory]::CreateDirectory($folder) | Out-Null
                [System.IO.File]::WriteAllText((Join-Path $folder "$($entry[1]).ps1"), "function $($entry[1]) { $($entry[2]) }")
            }
            $root
        }

        # A $script: counter: a fresh module scope answers 1 on its first call.
        $hitBody = 'if (-not (Test-Path variable:script:hits)) { $script:hits = 0 }; $script:hits++; $script:hits'
        $script:rootA = New-EvictionRoot -Label 'A' -OnlyModule 'Catzc.Widget' -OnlyFunction 'Get-WidgetHit' -OnlyBody $hitBody
        $script:rootB = New-EvictionRoot -Label 'B' -OnlyModule 'Catzc.Gadget' -OnlyFunction 'Get-Gadget' -OnlyBody "'gadget'"

        # Snapshot (evaluated in the child) of which catzc modules are loaded and where from.
        $snapshot = '[pscustomobject]@{ ' +
        'Widget = [bool](Get-Module Catzc.Widget); Gadget = [bool](Get-Module Catzc.Gadget); Shared = (Get-SharedOrigin); ' +
        'Internal = @(Get-Module Catzc.Internal.* | ForEach-Object { $_.ModuleBase }); ' +
        'TestKit = (Get-Module Catzc.Internal.TestKit | ForEach-Object { $_.ModuleBase }); ' +
        'ModulesRoot = $env:CatzcModulesRoot }'

        # A -> (two calls into Widget, TestKit from A) -> B -> A, all in ONE child process.
        $childScript = @(
            ". '$rootA/importer.ps1'"
            '$null = Get-WidgetHit; $hitsBeforeSwitch = Get-WidgetHit'
            'Import-InternalModule TestKit'
            "`$afterB = & { . '$rootB/importer.ps1'; $snapshot }"
            "`$afterA = & { . '$rootA/importer.ps1'; $snapshot }"
            '$hitsAfterReturn = Get-WidgetHit'
            '[pscustomobject]@{ HitsBeforeSwitch = $hitsBeforeSwitch; AfterB = $afterB; AfterA = $afterA; HitsAfterReturn = $hitsAfterReturn } | ConvertTo-Json -Depth 6 -Compress'
        ) -join "`n"
        $raw = pwsh -NoProfile -Command $childScript 2>&1
        if ($LASTEXITCODE -ne 0) {
            throw "Child import sequence failed: $raw"
        }
        $script:observed = (@($raw)[-1]).ToString() | ConvertFrom-Json
        $script:fullA = [System.IO.Path]::GetFullPath((Join-Path $rootA 'automation'))
        $script:fullB = [System.IO.Path]::GetFullPath((Join-Path $rootB 'automation'))
    }

    AfterAll {
        foreach ($root in $rootA, $rootB) {
            if ($root -and (Test-Path $root)) {
                Remove-Item $root -Recurse -Force -ErrorAction SilentlyContinue
            }
        }
    }

    It 'loads root B''s modules and evicts the module only root A ships' {
        $observed.AfterB.Gadget | Should -BeTrue
        $observed.AfterB.Widget | Should -BeFalse
    }

    It 'replaces a same-named module with root B''s copy' {
        $observed.AfterB.Shared | Should -Be 'B'
    }

    It 'loads every Catzc.Internal.* module from root B, re-importing the on-demand TestKit there' {
        $observed.AfterB.TestKit | Should -Not -BeNullOrEmpty
        foreach ($base in @($observed.AfterB.Internal)) {
            [System.IO.Path]::GetFullPath($base) | Should -BeLike "$fullB*"
        }
    }

    It 'switching back evicts root B''s module and restores root A''s' {
        $observed.AfterA.Gadget | Should -BeFalse
        $observed.AfterA.Widget | Should -BeTrue
        $observed.AfterA.Shared | Should -Be 'A'
        foreach ($base in @($observed.AfterA.Internal)) {
            [System.IO.Path]::GetFullPath($base) | Should -BeLike "$fullA*"
        }
    }

    It 'gives the returning module a fresh script scope (no cache from before the switch)' {
        $observed.HitsBeforeSwitch | Should -Be 2
        $observed.HitsAfterReturn | Should -Be 1
    }
}
