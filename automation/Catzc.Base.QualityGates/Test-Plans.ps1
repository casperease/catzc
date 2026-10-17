<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Base.QualityGates/Test-Plans.ps1
    name: test-plans
    filetype: ps1
    kind: function
    subkind: gate
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Base.QualityGates
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  edges:
    test: automation/Catzc.Base.QualityGates/tests/Test-Plans.Tests.ps1
    cites:
      - ADR-AUTO-TEST#35
      - ADR-REPO-FOLDERS#12
      - ADR-REPO-PLANS#{1,2,3,4,8}
  config:
    synopsis: 'Quality gate: holds every file of the plans folder to the plan rules.'
    description: |-
      One finding per broken rule, each naming the rule ([ADR-REPO-PLANS](/docs/adr/repository/plans.md)):
        - a file name the folder does not accept: a plan is `plan-<topic>.md` and a name never carries an order
          ([ADR-REPO-PLANS#1](/docs/adr/repository/plans.md#rule-adr-repo-plans1),
          [ADR-REPO-FOLDERS#12](/docs/adr/repository/conventional-folders.md#rule-adr-repo-folders12));
        - a plan head without the `plan:` block, a required key missing, a key outside the allowed set, a status or value
          outside the declared sets, a blocked plan that names nothing it is blocked on, or a target path that does not
          exist ([ADR-REPO-PLANS#2](/docs/adr/repository/plans.md#rule-adr-repo-plans2));
        - a plan without a required section, the open steps first among them
          ([ADR-REPO-PLANS#3](/docs/adr/repository/plans.md#rule-adr-repo-plans3));
        - an open step, a `- [ ]` item with its continuation lines, that names no check
          ([ADR-REPO-PLANS#4](/docs/adr/repository/plans.md#rule-adr-repo-plans4));
        - a task file whose `task:` head misses a key, whose id is not its file number, whose number is over the roof, or
          which has no steps section, and a master plan without its own sections
          ([ADR-REPO-PLANS#8](/docs/adr/repository/plans.md#rule-adr-repo-plans8)).
      The folder, the sets and the patterns are the plans registry (configs/plans.yml), its defaults declared once on
      PlansConfig. A quality gate ([ADR-AUTO-TEST#35](/docs/adr/automation/test-automation.md#rule-adr-auto-test35)): it
      ends through Write-QualityGateReport, which writes out/test-plans/, prints every issue, and throws once listing
      them all. The plans live only in the source tree.
    parameters:
      Path: 'The plans folder to check. Default: the registry''s folder under the repository root.'
      Config: 'The plans registry. Default: the shipped plans.yml.'
      RepositoryRoot: 'The repository root target paths resolve against. Default: the loaded repository root.'
      OutputFolder: The report base folder. Defaults to <out>/test-plans.
      PassThru: Return a result object ({ Subject; IssueCount; Issues; ReportPath; Files; Plans; Tasks }) instead of throwing.
    outputs: Throws on any finding; with -PassThru, returns the result object.
    examples:
      - Test-Plans
      - (Test-Plans -PassThru).Issues
---
#>

function Test-Plans {
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [string] $Path,

        [Catzc.Base.QualityGates.PlansConfig] $Config = (Get-Config -Config plans),

        [string] $RepositoryRoot = (Get-RepositoryRoot),

        [string] $OutputFolder,

        [switch] $PassThru
    )

    Assert-SourceTree

    $root = [System.IO.Path]::GetFullPath($RepositoryRoot)
    $folder = if ($Path) {
        [System.IO.Path]::GetFullPath($Path)
    }
    else {
        Join-Path $root $Config.folder
    }
    Assert-True ([System.IO.Directory]::Exists($folder)) -ErrorText "Test-Plans: the plans folder '$folder' does not exist."
    $label = if ($Path) {
        [System.IO.Path]::GetFileName($folder)
    }
    else {
        $Config.folder
    }

    $issues = [System.Collections.Generic.List[string]]::new()
    $plans = 0
    $tasks = 0
    $files = @(Get-ChildPath $folder -Depth 1 -File -Filter '*.md' | Sort-Object)
    foreach ($file in $files) {
        $name = [System.IO.Path]::GetFileName($file)
        $where = "$label/$name"
        $add = {
            param([int] $Line, [string] $Rule, [string] $Message)
            $issues.Add("${where}:${Line} [ADR-REPO-PLANS#${Rule}] $Message")
        }
        if (-not $Config.Accepts($name)) {
            & $add 1 1 'the name is not one the plans folder accepts (plan-<topic>.md, prompt-<topic>-continue.md, taskNNN.md, …); a name never carries an order (ADR-REPO-FOLDERS#12)'
            continue
        }
        $text = [System.IO.File]::ReadAllText($file)
        $lines = $text -split "`r?`n"
        $headings = [System.Collections.Generic.List[pscustomobject]]::new()
        for ($i = 0; $i -lt $lines.Count; $i++) {
            if ($lines[$i] -match '^##\s+(?<text>.+?)\s*$') {
                $headings.Add([pscustomobject]@{ Line = $i + 1; Text = $Matches['text'] })
            }
        }
        $hasHeading = {
            param([string] $Prefix)
            @($headings | Where-Object { $_.Text.StartsWith($Prefix, [System.StringComparison]::OrdinalIgnoreCase) }).Count -gt 0
        }

        $isMaster = $name -ceq $Config.master_file
        $isTask = $name -match '^task(?<number>[0-9]{3})\.md$'
        $isPlan = -not $isMaster -and -not $isTask -and $name -like 'plan-*.md'
        if (-not ($isMaster -or $isTask -or $isPlan)) {
            continue
        }

        # The front matter: the block between the first two fences, read as YAML.
        $frontMatter = $null
        if ($lines.Count -gt 2 -and $lines[0] -ceq '---') {
            $end = [System.Array]::IndexOf($lines, '---', 1)
            if ($end -gt 0) {
                try {
                    $frontMatter = ($lines[1..($end - 1)] -join "`n") | ConvertFrom-Yaml -Ordered
                }
                catch {
                    & $add 1 2 "the front matter is not YAML: $($_.Exception.Message)"
                }
            }
        }

        if ($isMaster) {
            foreach ($section in $Config.master_sections) {
                if (-not (& $hasHeading $section)) {
                    & $add 1 8 "the master plan has no '## $section' section"
                }
            }
            continue
        }

        if ($isTask) {
            $tasks++
            $number = [int] $Matches['number']
            if ($number -gt $Config.tasks_max) {
                & $add 1 8 "task number $number is over the roof of $($Config.tasks_max)"
            }
            $block = if ($frontMatter -is [System.Collections.IDictionary] -and $frontMatter.Contains('task')) {
                $frontMatter['task']
            }
            if (-not ($block -is [System.Collections.IDictionary])) {
                & $add 1 8 "the head has no 'task:' block"
            }
            else {
                foreach ($key in 'id', 'status', 'plans', 'value', 'blocked_on', 'targets') {
                    if (-not $block.Contains($key)) {
                        & $add 1 8 "the task head misses '$key'"
                    }
                }
                if ($block.Contains('id') -and "$($block['id'])" -cne $Matches['number']) {
                    & $add 1 8 "the task id '$($block['id'])' is not the file number '$($Matches['number'])'"
                }
            }
            if (-not (& $hasHeading 'Steps')) {
                & $add 1 8 "the task file has no '## Steps' section"
            }
            continue
        }

        $plans++
        $block = if ($frontMatter -is [System.Collections.IDictionary] -and $frontMatter.Contains('plan')) {
            $frontMatter['plan']
        }
        if (-not ($block -is [System.Collections.IDictionary])) {
            & $add 1 2 "the head has no 'plan:' block"
        }
        else {
            foreach ($key in $Config.head_required) {
                if (-not $block.Contains($key)) {
                    & $add 1 2 "the head misses '$key'"
                }
            }
            foreach ($key in @($block.Keys)) {
                if ($key -notin $Config.head_required -and $key -notin $Config.head_allowed) {
                    & $add 1 2 "the head key '$key' is outside the plan keys ($(($Config.head_required + $Config.head_allowed) -join ', '))"
                }
            }
            if ($block.Contains('status')) {
                $status = "$($block['status'])"
                if ($status -notin $Config.statuses) {
                    & $add 1 2 "status '$status' is not one of: $($Config.statuses -join ', ')"
                }
                elseif ($status -ceq 'blocked' -and -not ($block.Contains('blocked_on') -or $block.Contains('waits_on'))) {
                    & $add 1 2 "a blocked plan names what blocks it in 'blocked_on' or 'waits_on'"
                }
            }
            if ($block.Contains('value') -and "$($block['value'])" -notin $Config.ranks) {
                & $add 1 2 "value '$($block['value'])' is not one of the ranks: $($Config.ranks -join ', ')"
            }
            if ($block.Contains('targets')) {
                $targets = @($block['targets'])
                if ($targets.Count -eq 0) {
                    & $add 1 2 'targets names no path'
                }
                foreach ($target in $targets) {
                    $candidate = Join-Path $root "$target"
                    if (-not ([System.IO.File]::Exists($candidate) -or [System.IO.Directory]::Exists($candidate))) {
                        & $add 1 2 "target '$target' does not exist"
                    }
                }
            }
        }

        foreach ($section in $Config.sections_required) {
            if (-not (& $hasHeading $section)) {
                & $add 1 3 "the plan has no '## $section' section"
            }
        }

        # An open step is the `- [ ]` line with its indented continuation lines; each names its check.
        $stepLine = 0
        $step = $null
        $flush = {
            if ($stepLine -gt 0 -and $step -notmatch '(?i)check:') {
                & $add $stepLine 4 "the open step names no check: `"$($step.Trim())`""
            }
        }
        for ($i = 0; $i -lt $lines.Count; $i++) {
            $line = $lines[$i]
            if ($line -match '^\s*- \[ \]') {
                & $flush
                $stepLine = $i + 1
                $step = $line
            }
            elseif ($stepLine -gt 0 -and $line -match '^\s{2,}\S' -and $line -notmatch '^\s*- \[') {
                $step += ' ' + $line.Trim()
            }
            elseif ($stepLine -gt 0) {
                & $flush
                $stepLine = 0
                $step = $null
            }
        }
        & $flush
    }

    Write-QualityGateReport -Subject plans -Title Test-Plans -Issues $issues.ToArray() `
        -Facts ([ordered]@{ Files = $files.Count; Plans = $plans; Tasks = $tasks }) -OutputFolder $OutputFolder -PassThru:$PassThru
}
