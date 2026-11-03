Describe 'A consumer root with a bundle installed and a .catzc/ overlay' -Tag 'L2', 'logic', 'greedy', 'source-only' {
    BeforeAll {
        Import-InternalModule TestKit

        # One row per gate: its name and how many of the report's issues carry its prefix.
        function Get-GateRow {
            param([string[]] $GateSet, [string[]] $Issue)

            foreach ($gate in $GateSet) {
                [pscustomobject]@{ Gate = $gate; Issues = @($Issue | Where-Object { $_.StartsWith("${gate}: ", [System.StringComparison]::Ordinal) }).Count }
            }
        }

        # The overlay's track folder is the one name every import publishes, so no fixture path spells it.
        $overlay = ".catzc/$env:CatzcModulesFolder"
        $overridden = @'
function Test-IsGuid {
    [OutputType([bool])]
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string] $ObjectGuid
    )

    $true
}

'@
        # The consumer module's public function, a file of its own in the consumer's track.
        $widget = @'
function Get-LocalWidget {
    [OutputType([string])]
    [CmdletBinding()]
    param()

    'widget-v1'
}

'@
        # The consumer's own repository description, read whole from the working root's configs folder: its tracks only; the engine supplies the bundle's own.
        $variants = @'
tracks:
  widget:
    members: [widget]
    type: modules
    namespace: Widget
  docs:
    members: [docs]
    type: documentation
  go:
    members: [go]
    type: modules
    languages: [go]
    namespace: widget
    join: ""
  python:
    members: [python]
    type: modules
    languages: [python]
    namespace: widget
    join: _
  bash:
    members: [bash]
    type: modules
    languages: [bash]
    namespace: widget
    join: "-"
  js:
    members: [js]
    type: modules
    languages: [javascript]
    namespace: widget
    join: "-"

'@
        # The smallest module of each other language the consumer holds, each with the smallest test its language's runner finds.
        $goMod = "module widget/gadget`n`ngo 1.22`n"
        $goSource = "package gadget`n`nfunc Name() string {`n`treturn `"gadget`"`n}`n"
        $goTest = "package tests`n`nimport `"testing`"`n`nfunc TestGadget(t *testing.T) {`n`tif 1+1 != 2 {`n`t`tt.Fatal(`"arithmetic`")`n`t}`n}`n"
        $pythonProject = "[project]`nname = `"widget-gadget`"`nversion = `"0.0.0`"`nrequires-python = `">=3.12`"`n"
        $pythonSource = "def name() -> str:`n    return `"gadget`"`n"
        $pythonTest = "def test_gadget() -> None:`n    assert 1 + 1 == 2`n"
        $bashSource = "#!/usr/bin/env bash`nset -euo pipefail`n`necho gadget`n"
        $bashTest = "@test `"gadget`" {`n  [ `"`$((1 + 1))`" -eq 2 ]`n}`n"
        $jsSource = "function name() {`n    return `"gadget`";`n}`n`nmodule.exports = { name };`n"
        $jsTest = "const test = require(`"node:test`");`nconst assert = require(`"node:assert`");`n`ntest(`"gadget`", () => {`n    assert.strictEqual(1 + 1, 2);`n});`n"
        # The consumer module's own config, its registry and the record type the registry names, which the session compiles from the module's types folder.
        $gadget = "depth: 3`n"
        $gadgetRegistry = @'
configs:
  gadget:
    type: Widget.Local.Gadget

'@
        $gadgetType = @'
using System.Collections;
using System.Globalization;

namespace Widget.Local;

public sealed class Gadget
{
    public int depth { get; }

    public Gadget(IDictionary raw)
    {
        depth = raw != null && raw.Contains("depth") ? System.Convert.ToInt32(raw["depth"], CultureInfo.InvariantCulture) : 0;
    }
}

'@
        # The consumer's own DRS: one kind, one domain, read whole from the working root's configs folder, with its record and its index.
        $drsConfig = @'
kinds:
  ADR: { name: Architecture Decision Record }

domains:
  widget:
    kind: ADR
    role: naming # how the consumer names its widgets
    description: How the consumer names its widgets.
    stack: AUTO
    concern: [automation]
    rulesets:
      widget-naming: { external: ADR-WIDGET }

'@
        $drsRecord = @'
# Widget naming

## Rules: ADR-WIDGET

### Rule ADR-WIDGET-NAMING

A widget is named for what it does, in one lower-case word.

- [Context](#context)

## Context

A name that says what a widget does needs no lookup.

'@
        $drsDora = @'
# DORA explanations - widget

The rationale for the records in the `widget/` domain.

## Widget naming

[ADR-WIDGET](widget-naming.md)

> A name that says what a widget does shortens the feedback loop of whoever reads it.

'@
        $drsIndex = @'
# DRS index

## Codes

### widget/

| Code         | Record                                   |
| ------------ | ---------------------------------------- |
| `ADR-WIDGET` | [widget-naming](widget/widget-naming.md) |

'@
        # The consumer module's own test, a file in its tests folder, tagged as the consumer's test run requires (ADR-AUTO-TEST-TWOMANDATORYTAGS).
        $widgetTest = @'
Describe 'Get-LocalWidget' -Tag 'L0', 'logic' {
    It 'returns the widget' {
        Get-LocalWidget | Should -Be 'widget-v1'
    }
}

'@
        # One install per file: the full bundle, the only declared one whose closure carries Catzc.Base.Overlay, plus the consumer's overlay entries.
        $script:handle = New-ConsumerRoot -Bundle 'full' -File @{
            # A repository ignores its output folder: the install's first import writes the writers' memo under it before the fixture adds its files.
            '.gitignore'                                    = "out/`n"
            'widget/Local/Get-LocalWidget.ps1'              = $widget
            'widget/Local/tests/Get-LocalWidget.Tests.ps1'  = $widgetTest
            'go/gadget/go.mod'                              = $goMod
            'go/gadget/gadget.go'                           = $goSource
            'go/gadget/tests/gadget_test.go'                = $goTest
            'python/gadget/pyproject.toml'                  = $pythonProject
            'python/gadget/gadget.py'                       = $pythonSource
            'python/gadget/tests/test_gadget.py'            = $pythonTest
            'bash/gadget/gadget.sh'                         = $bashSource
            'bash/gadget/tests/gadget.bats'                 = $bashTest
            'js/gizmo/gizmo.js'                             = $jsSource
            'js/gizmo/tests/gizmo.test.js'                  = $jsTest
            'widget/Local/types/Gadget.cs'                  = $gadgetType
            'widget/Local/configs/gadget.yml'               = $gadget
            'widget/Local/configs/configs.yml'              = $gadgetRegistry
            '.catzc/configs/variants.yml'                   = $variants
            '.catzc/configs/drs.yml'                        = $drsConfig
            # The python config is a working-root config: a consumer with a python track pins its own tool versions.
            '.catzc/configs/python.yml'                     = "dependencies:`n  pyright: `"1.1.414`"`n  pytest: `"9.1.1`"`n  ruff: `"0.17.0`"`n"
            'docs/drs/widget/widget-naming.md'              = $drsRecord
            'docs/drs/widget/dora-explains.md'              = $drsDora
            'docs/drs/index.md'                             = $drsIndex
            "$overlay/Base.Folders/configs/folder-walk.yml" = "prune_vendor_in_searches: false`n"
            "$overlay/Base.Asserts/Test-IsGuid.ps1"         = $overridden
        }

        foreach ($step in @(@('init', '-q'), @('add', '-A'), @('update-index', '--chmod=+x', 'bash/gadget/gadget.sh'))) {
            $gitOutput = & git -C $script:handle.WorkingRoot @step 2>&1
            if ($LASTEXITCODE -ne 0) {
                throw "git $($step -join ' ') failed in the consumer root: $gitOutput"
            }
        }

        # The consumer syncs its python workspace once, as catzc does, so the python gates and the python test run read its environment offline.
        $null = Invoke-InBuiltCatzc -Handle $script:handle -ScriptBlock { Install-PythonWorkspace }

        # One fresh session through the root's importer answers every case below.
        $script:session = Invoke-InBuiltCatzc -Handle $script:handle -ScriptBlock {
            [pscustomobject]@{
                RunMode        = Get-CatzcRunMode
                PruneVendor    = (Get-Config -Config folder-walk).prune_vendor_in_searches
                Tracks         = @(Get-Track | ForEach-Object name)
                IsGuid         = Test-IsGuid 'not-a-guid'
                IsGuidModule   = (Get-Command Test-IsGuid).ModuleName
                LocalWidget    = Get-LocalWidget
                ConsumerModule =(Get-Command Get-LocalWidget).ModuleName
                LocalFile      = (Get-Command Get-LocalWidget).ScriptBlock.File
                OverlayRecord  = @(Get-Overlay | ForEach-Object { "$($_.Kind):$($_.Module):$($_.Target)" })
                AssertOverlay  = $(
                    try {
                        Assert-Overlay
                        'passed'
                    }
                    catch {
                        $_.Exception.Message
                    }
                )
                CodeRoot       = Get-CatzcModulesRoot
                TestPaths      = @(& (Get-Module Catzc.Base.QualityGates) { Get-TestAutomationTestPaths })
                AnalyzerIssues = (Test-ScriptAnalyzer -Path (Join-Path (Get-RepositoryRoot) 'widget/Local/Get-LocalWidget.ps1') -PassThru).IssueCount
                GadgetEntry    = & (Get-Module Catzc.Base.Config) { Resolve-ConfigEntry -Name gadget -Namespace Widget }
                GadgetInCatzc  = @(& (Get-Module Catzc.Base.Config) { Resolve-ConfigEntry -Name gadget -All }).Count
                GadgetTyped    = Get-Config gadget -Namespace Widget
                GadgetType     = [Widget.Local.Gadget].FullName
                GadgetIsOwn    = (Get-Config gadget -Namespace Widget) -is [Widget.Local.Gadget]
                GateSet        = @(& (Get-Module Catzc.Base.QualityGates) { Get-QualityGateCheckSet })
                GateReport     = Test-QualityGates -PassThru
                DrsRegistry    = Test-DrsRegistry -PassThru
                DrsDomains     = @((Get-Config -Config drs).Domains | ForEach-Object Name)
                DrsIndexCodes  = $(
                    $indexRows = Get-DrsIndex
                    @($indexRows | ForEach-Object Code)
                )
                BareFromHere   = try {
                    Get-Config gadget
                }
                catch {
                    $_.Exception.Message
                }
            }
        }
    }

    AfterAll {
        # Git writes its object files read-only, which the recursive delete of the root cannot remove.
        foreach ($gitFile in (Get-ChildPath (Join-Path $script:handle.WorkingRoot '.git') -Depth 5 -File -Exclude @())) {
            [System.IO.File]::SetAttributes($gitFile, [System.IO.FileAttributes]::Normal)
        }
        Remove-BuiltCatzcRoot $script:handle
    }

    It 'installs the bundle into the root with its importer' {
        $script:handle.Importer | Should -Exist
        $script:handle.BuildRoot | Should -Exist
    }

    It 'runs in the run mode build' {
        $script:session.RunMode | Should -Be 'build'
    }

    It 'reads the fragment''s value over the bundled module-scope config through Get-Config' {
        $script:session.PruneVendor | Should -BeFalse
    }

    It 'reads the repository''s tracks whole from the working root and adds the engine''s own, so the consumer''s tracks, its language tracks among them, and pwsh are there and catzc''s others are not' -Tag 'ADR-CONF-LOADING-WORKINGROOTREADWHOLE', 'ADR-AUTO-CONSUMER-OWNTRACKS' {
        $script:session.Tracks | Should -Be @('pwsh', 'widget', 'docs', 'go', 'python', 'bash', 'js')
        $script:session.Tracks | Should -Not -Contain 'vendor_azure.bicep'
        $script:session.Tracks | Should -Not -Contain 'contracts'
    }

    It 'runs the override in place of the bundled function, inside the bundled module' {
        $script:session.IsGuid | Should -BeTrue
        $script:session.IsGuidModule | Should -Be 'Catzc.Base.Asserts'
    }

    It 'loads the consumer module from its own track, named by its namespace and folder, its function read from the consumer''s file' -Tag 'ADR-AUTO-CONSUMER-SOURCEMODULES' {
        $script:session.LocalWidget | Should -Be 'widget-v1'
        $script:session.ConsumerModule | Should -Be 'Widget.Local'
        $source = $script:session.LocalFile.Replace('\', '/')
        $source | Should -BeLike '*/widget/Local/Get-LocalWidget.ps1'
        $source | Should -BeLike "$($script:handle.WorkingRoot.Replace('\', '/'))/*"
    }

    It 'lists the consumer module''s tests folder for the test run, and no path under the bundle''s code root' -Tag 'ADR-AUTO-CONSUMER-CATZCGATES' {
        $paths = @($script:session.TestPaths | ForEach-Object { $_.Replace('\', '/') })
        $paths | Should -Contain "$($script:handle.WorkingRoot.Replace('\', '/'))/widget/Local/tests"
        $codeRoot = $script:session.CodeRoot.Replace('\', '/')
        @($paths | Where-Object { $_.StartsWith($codeRoot, [System.StringComparison]::OrdinalIgnoreCase) }) | Should -HaveCount 0
    }

    It 'lists the test folder of each consumer language module, found in its own track, and no catzc path' -Tag 'ADR-AUTO-CONSUMER-CATZCGATES', 'ADR-AUTO-CONSUMER-OWNTRACKS' {
        $paths = @($script:session.TestPaths | ForEach-Object { $_.Replace('\', '/') })
        $workingRoot = $script:handle.WorkingRoot.Replace('\', '/')
        foreach ($module in 'go/gadget', 'python/gadget', 'bash/gadget', 'js/gizmo') {
            $paths | Should -Contain "$workingRoot/$module/tests"
        }
        $codeRoot = $script:session.CodeRoot.Replace('\', '/')
        @($paths | Where-Object { -not $_.StartsWith($workingRoot, [System.StringComparison]::OrdinalIgnoreCase) -or $_.StartsWith($codeRoot, [System.StringComparison]::OrdinalIgnoreCase) }) | Should -HaveCount 0
    }

    It 'runs the consumer''s own tests, the widget test and the four language tests, through the bundle''s handlers and none of catzc''s' -Tag 'ADR-AUTO-CONSUMER-CATZCGATES', 'ADR-AUTO-CONSUMER-OWNTRACKS' {
        $run = Invoke-InBuiltCatzc -Handle $script:handle -ScriptBlock {
            $result = Test-Automation -Output Minimal -PassThru
            [pscustomobject]@{
                Passed     = $result.PassedCount
                Failed     = $result.FailedCount
                FailedRows = @($result.Rows | Where-Object { $_.Result -eq 'Failed' } | ForEach-Object { ConvertTo-Json -InputObject $_ -Compress -Depth 2 })
                Files      = @($result.Rows | ForEach-Object { "$($_.File)" })
                CodeRoot   = Get-CatzcModulesRoot
            }
        }
        $run.Failed | Should -Be 0 -Because "every failed row is named: $($run.FailedRows -join ' | ')"
        $run.Passed | Should -BeGreaterOrEqual 5
        $codeRoot = $run.CodeRoot.Replace('\', '/')
        @($run.Files | Where-Object { $_.Replace('\', '/').StartsWith($codeRoot, [System.StringComparison]::OrdinalIgnoreCase) }) | Should -HaveCount 0
    }

    It 'defines cats in a bash session through the installed shell entry' -Tag 'ADR-AUTO-ENGINE' {
        $bash = $null
        try {
            $bash = Resolve-EngineExecutable -Engine bash
        }
        catch {
            Set-ItResult -Skipped -Because "no bash on this host: $($_.Exception.Message)"
            return
        }
        # One script file, since Invoke-Executable runs a single command: source the entry, then ask cats for the run mode.
        $probe = Join-Path $script:handle.Root 'cats-probe.sh'
        [System.IO.File]::WriteAllText($probe, ". ./importer.sh`ncats Get-CatzcRunMode`n", [System.Text.UTF8Encoding]::new($false))
        $shell = Invoke-Executable "`"$bash`" ./cats-probe.sh" -WorkingDirectory $script:handle.Root -PassThru -NoAssert -Silent
        $shell.ExitCode | Should -Be 0 -Because "the bash run said: $($shell.Full)"
        "$($shell.Output)".Trim() | Should -Be 'build'
    }

    It 'runs catzc''s analyzer rules over the consumer module''s public function and finds it clean, the rules resolved from the bundle''s code root' -Tag 'ADR-AUTO-CONSUMER-CATZCGATES', 'ADR-AUTO-OVERLAY' {
        $script:session.AnalyzerIssues | Should -Be 0
    }

    It 'shows an edit of the consumer module''s file in the next fresh session, with nothing built in between' -Tag 'ADR-AUTO-CONSUMER-SOURCEMODULES' {
        $file = Join-Path $script:handle.WorkingRoot 'widget/Local/Get-LocalWidget.ps1'
        [System.IO.File]::WriteAllText($file, ([System.IO.File]::ReadAllText($file)).Replace('widget-v1', 'widget-v2'))
        $second = Invoke-InBuiltCatzc -Handle $script:handle -ScriptBlock { Get-LocalWidget }
        $second | Should -Be 'widget-v2'
    }

    It 'indexes the consumer module''s config under the consumer''s namespace, and finds nothing of it in catzc''s' -Tag 'ADR-AUTO-CONSUMER-OWNCONFIGS' {
        $script:session.GadgetEntry.Namespace | Should -BeExactly 'Widget'
        $script:session.GadgetEntry.Module | Should -BeExactly 'Widget.Local'
        $script:session.GadgetEntry.Path.Replace('\', '/') | Should -BeLike '*/widget/Local/configs/gadget.yml'
        $script:session.GadgetInCatzc | Should -Be 0
    }

    It 'reads the consumer module''s config typed with -Namespace, and a bare name from the console resolves in catzc''s namespace and throws' -Tag 'ADR-AUTO-CONSUMER-OWNCONFIGS' {
        # The session crossed a process boundary, so the typed value arrives deserialized and keeps its type name only as a type-name entry.
        $script:session.GadgetTyped.PSObject.TypeNames[0] | Should -BeLike '*Widget.Local.Gadget'
        $script:session.GadgetTyped.depth | Should -Be 3
        $script:session.GadgetIsOwn | Should -BeTrue
        $script:session.BareFromHere | Should -BeLike "No config 'gadget'*namespace 'Catzc'*"
    }

    It 'compiles the consumer module''s types into the working root''s out/ and resolves them in the session' -Tag 'ADR-AUTO-CONSUMER-OWNTYPES' {
        $script:session.GadgetType | Should -BeExactly 'Widget.Local.Gadget'
        @([System.IO.Directory]::GetFiles((Join-Path $script:handle.WorkingRoot 'out'), 'Widget.Types.*.dll')).Count | Should -Be 1
    }

    It 'runs every gate of the language registry once, each issue naming its gate, and finds the gates that need nothing of catzc''s tree green' -Tag 'ADR-AUTO-CONSUMER-CATZCGATES', 'ADR-AUTO-TEST-QUALITYGATE' {
        $rows = Get-GateRow -GateSet $script:session.GateSet -Issue $script:session.GateReport.Issues
        $rows.Gate | Should -HaveCount @($script:session.GateSet).Count
        @($script:session.GateReport.Issues | Where-Object { $_ -notmatch '^Test-[A-Za-z]+: ' }) | Should -HaveCount 0
        @($rows | Where-Object { $_.Issues -eq 0 } | ForEach-Object Gate | Sort-Object) | Should -Be @('Test-BclReferences', 'Test-Comments', 'Test-Formatting', 'Test-IdiomaticNames', 'Test-LinkDirections', 'Test-Links', 'Test-Markdownlint', 'Test-MarkdownTitle', 'Test-PythonLint', 'Test-PythonTypes', 'Test-ScriptAnalyzer', 'Test-ShellScripts', 'Test-Spelling')
    }

    It 'runs no gate of a language the consumer has no tracked file of, nor of a folder it lacks: the bicep gates, and the plans and agents folders gates, are not in the set, and the gates of the python, bash and javascript modules it holds are' -Tag 'ADR-AUTO-CONSUMER-CATZCGATES', 'ADR-AUTO-TEST-QUALITYGATE' {
        @($script:session.GateSet | Where-Object { $_ -in 'Test-BicepLint', 'Test-BicepApiVersions', 'Test-Plans', 'Test-AgentDefinitions' }) | Should -HaveCount 0
        @($script:session.GateSet | Where-Object { $_ -in 'Test-PythonLint', 'Test-PythonTypes', 'Test-ShellScripts', 'Test-JavaScriptTypes' } | Sort-Object) | Should -Be @('Test-JavaScriptTypes', 'Test-PythonLint', 'Test-PythonTypes', 'Test-ShellScripts')
    }

    # A gate red on the clean consumer is listed here with its cause until a step takes it off.
    It 'is red on the clean consumer exactly in the gates whose pending step is named here' -Tag 'ADR-AUTO-CONSUMER-CATZCGATES' {
        $pending = @(
            'Test-JavaScriptTypes'
        )
        $rows = Get-GateRow -GateSet $script:session.GateSet -Issue $script:session.GateReport.Issues
        @($rows | Where-Object { $_.Issues -gt 0 } | ForEach-Object Gate | Sort-Object) | Should -Be @($pending | Sort-Object)
    }

    It 'reads the consumer''s own drs.yml whole from the working root: the registry finds no issue, the domain is the consumer''s only, and the index lists its record code' -Tag 'ADR-CONF-LOADING-WORKINGROOTREADWHOLE' {
        @($script:session.DrsRegistry.Issues) | Should -HaveCount 0
        $script:session.DrsDomains | Should -Be @('widget')
        $script:session.DrsIndexCodes | Should -Be @('ADR-WIDGET')
    }

    It 'turns a green gate red when the consumer''s own source carries its defect' -Tag 'ADR-AUTO-CONSUMER-CATZCGATES', 'ADR-AUTO-TEST-QUALITYGATE' {
        # A tracked file of the consumer's module whose name is no verb-noun form, which Test-IdiomaticNames flags for a PowerShell file.
        [System.IO.File]::WriteAllText((Join-Path $script:handle.WorkingRoot 'widget/Local/planted_widget.ps1'), "function Get-PlantedWidget {`n    [CmdletBinding()]`n    param()`n`n    'planted'`n}`n")
        # Only the planted file joins the index: the first gate run left its cache under out/, which is no source of the consumer's.
        git -C $script:handle.WorkingRoot add widget/Local/planted_widget.ps1
        $second = Invoke-InBuiltCatzc -Handle $script:handle -ScriptBlock { (Test-QualityGates -PassThru).Issues }
        $before = Get-GateRow -GateSet $script:session.GateSet -Issue $script:session.GateReport.Issues
        $after = Get-GateRow -GateSet $script:session.GateSet -Issue $second
        ($after | Where-Object Gate -EQ 'Test-IdiomaticNames').Issues | Should -BeGreaterThan 0
        @($second | Where-Object { $_ -like 'Test-IdiomaticNames: *planted_widget.ps1*' }) | Should -Not -HaveCount 0
        $state = { param($row) @($row | Where-Object Gate -NE 'Test-IdiomaticNames' | ForEach-Object { "$($_.Gate)=$($_.Issues -gt 0)" }) }
        & $state $after | Should -Be (& $state $before)
    }

    It 'lists the fragment and the override, and nothing else, through Get-Overlay' {
        $script:session.OverlayRecord | Should -Be @(
            'FunctionOverride:Catzc.Base.Asserts:Test-IsGuid'
            'ConfigFragment:Catzc.Base.Folders:folder-walk'
        )
    }

    It 'passes Assert-Overlay on the clean consumer: its namespace is its own, and it shadows and overrides nothing of the bundle' -Tag 'ADR-AUTO-CONSUMER-OWNTRACKS', 'ADR-AUTO-CONSUMER-OWNCONFIGS' {
        $script:session.AssertOverlay | Should -Be 'passed'
    }

    It 'refuses the import when the overlay holds a folder that names no bundled module, pointing at the consumer''s tracks' -Tag 'ADR-AUTO-OVERLAY-MODULEOVERRIDEENTRIES', 'ADR-AUTO-CONSUMER-OWNTRACKS' {
        $file = Join-Path $script:handle.WorkingRoot "$overlay/Widget.Orphan/Get-Orphan.ps1"
        [System.IO.Directory]::CreateDirectory([System.IO.Path]::GetDirectoryName($file)) | Out-Null
        [System.IO.File]::WriteAllText($file, 'function Get-Orphan { }')
        { Invoke-InBuiltCatzc -Handle $script:handle -ScriptBlock { Get-Command Get-Orphan -ErrorAction Ignore } } |
            Should -Throw -ExpectedMessage '*Widget.Orphan: names no bundled module*its tracks (widget, docs, go, python, bash, js)*'
    }
}

Describe 'A consumer root with no repository' -Tag 'L2', 'logic', 'greedy', 'source-only' {
    BeforeAll {
        Import-InternalModule TestKit

        # The consumer module's public function and the consumer's tracks, the same small strings as the first Describe of this file.
        $widget = @'
function Get-LocalWidget {
    [OutputType([string])]
    [CmdletBinding()]
    param()

    'widget-v1'
}

'@
        $variants = @'
tracks:
  widget:
    members: [widget]
    type: modules
    namespace: Widget
  docs:
    members: [docs]
    type: documentation

'@
        # The bundle installed and no `git init`: the working root is no checkout.
        $script:handle = New-ConsumerRoot -Bundle 'full' -File @{
            'widget/Local/Get-LocalWidget.ps1' = $widget
            '.catzc/configs/variants.yml'      = $variants
        }

        $script:session = Invoke-InBuiltCatzc -Handle $script:handle -ScriptBlock {
            [pscustomobject]@{
                RunMode     = Get-CatzcRunMode
                LocalWidget = Get-LocalWidget
                TrackedPath = @(Get-GitTrackedPath '.')
                RepoStatus  = $(
                    try {
                        Get-RepoStatus -Path '.'
                        'passed'
                    }
                    catch {
                        $_.Exception.Message
                    }
                )
                ChangedPath = $(
                    try {
                        Get-GitChangedPath
                        'passed'
                    }
                    catch {
                        $_.Exception.Message
                    }
                )
                GateOutcome = $(
                    try {
                        $report = Test-QualityGates -PassThru
                        "issues:$(@($report.Issues).Count)"
                    }
                    catch {
                        "threw:$($_.Exception.Message)"
                    }
                )
            }
        }
    }

    AfterAll {
        Remove-BuiltCatzcRoot $script:handle
    }

    It 'runs in the run mode build' -Tag 'ADR-REPO-REPOKIND-NOREPO' {
        $script:session.RunMode | Should -Be 'build'
    }

    It 'loads the consumer module, which needs no repository' -Tag 'ADR-REPO-REPOKIND-NOREPO' {
        $script:session.LocalWidget | Should -Be 'widget-v1'
    }

    It 'lists no tracked path, since there is no index' -Tag 'ADR-REPO-REPOKIND-NOREPO' {
        $script:session.TrackedPath | Should -HaveCount 0
    }

    It 'stops a command that needs git with a message naming it' -Tag 'ADR-REPO-REPOKIND-NOREPO' {
        $script:session.RepoStatus | Should -BeLike 'Get-RepoStatus works on a git work tree*not a git checkout.'
        $script:session.ChangedPath | Should -BeLike 'Get-GitChangedPath works on a git work tree*not a git checkout.'
    }

    It 'runs the quality gates and finds no issue, since no gate finds a tracked file' -Tag 'ADR-REPO-REPOKIND-NOREPO' {
        $script:session.GateOutcome | Should -Be 'issues:0'
    }
}
