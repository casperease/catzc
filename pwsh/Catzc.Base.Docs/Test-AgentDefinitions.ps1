<#
---
catzc:
  docs: "../../docs/references/pwsh/catzc-base-docs/Test-AgentDefinitions.ps1.md"
  header: "generated"
---
#>

function Test-AgentDefinitions {
    [CmdletBinding()]
    [OutputType([Catzc.Base.Reports.QualityGateResult])]
    param(
        [string] $OutputFolder,

        [switch] $PassThru
    )

    $config = Get-Config -Config agents
    $capabilityConfig = Get-Config -Config capabilities
    $agentsFile = ConvertTo-RepoRelativePath (Get-CatzcModuleRoot 'configs/agents.yml')
    $capabilitiesFile = ConvertTo-RepoRelativePath (Get-CatzcModuleRoot 'configs/capabilities.yml')
    $agentsRoot = Resolve-RepoPath '.claude/agents'
    $skillsRoot = Resolve-RepoPath '.claude/skills'
    $claudeMd = Resolve-RepoPath '.claude/CLAUDE.md'
    $issues = [System.Collections.Generic.List[string]]::new()
    $robotKeys = @('name', 'description', 'tools', 'disallowedTools', 'model', 'effort', 'maxTurns', 'skills', 'catzc')
    $modelRank = @{ haiku = 1; sonnet = 2; opus = 3; fable = 4 }
    # A body line wider than this is a finding, so a merge-into-one-line edit is proved by this one gate.
    $columnRoof = 140

    $entries = [ordered]@{}
    foreach ($entry in $config.agents) {
        $entries[$entry.name] = $entry
    }

    # The capability files first: their floors decide what model an agent may name.
    $capabilityFiles = @(if ([System.IO.Directory]::Exists($skillsRoot)) {
            Get-ChildPath $skillsRoot -Depth 2 -File -Filter 'SKILL.md' | ForEach-Object { [string]$_ } | Sort-Object
        })
    $floors = @{}
    # A user skill is invoked by the user, never preloaded; the registry says which capabilities are.
    $userSkills = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::Ordinal)
    foreach ($entry in $capabilityConfig.capabilities) {
        if ($entry.invoked_by -eq 'user') {
            [void]$userSkills.Add($entry.name)
        }
    }
    # The carrier registry says where a capability's catzc head nests, under the file kind's class; the gate never fixes the key itself.
    $carriers = Get-Config -Config file-carriers
    $fileKinds = Get-Config -Config file-kinds
    foreach ($file in $capabilityFiles) {
        $name = [System.IO.Path]::GetFileName([System.IO.Path]::GetDirectoryName($file))
        $relative = ".claude/skills/$name/SKILL.md"
        $carrier = $carriers.Find($fileKinds.Resolve($relative).Class)
        $key = if ($carrier -and $carrier.key) {
            $carrier.key
        }
        else {
            [Catzc.Base.MarkdownMeta.MarkdownDocument]::MetaKey
        }
        try {
            $frontMatter = Get-AgentFrontMatter -Path $file
        }
        catch {
            $issues.Add("${relative}: $($_.Exception.Message)")
            continue
        }
        $declared = if ($frontMatter.Contains('name')) {
            [string]$frontMatter['name']
        }
        if ($declared -cne $name) {
            $issues.Add("${relative}: front-matter name '$declared' must equal the folder name '$name'")
        }
        $invocable = if ($userSkills.Contains($name)) {
            'True'
        }
        else {
            'False'
        }
        if (-not $frontMatter.Contains('user-invocable') -or [string]$frontMatter['user-invocable'] -ne $invocable) {
            $issues.Add("${relative}: front matter must set user-invocable: $($invocable.ToLowerInvariant())")
        }
        if (-not $frontMatter.Contains('allowed-tools') -or [string]::IsNullOrWhiteSpace([string]$frontMatter['allowed-tools'])) {
            $issues.Add("${relative}: front matter has no allowed-tools")
        }
        # The floor is the author's one line in the catzc head's config part, beside the imprinted parts, so it survives every imprint.
        $floor = $null
        $authored = $frontMatter
        foreach ($segment in @('metadata', 'catzc', 'config')) {
            $authored = if ($authored -is [System.Collections.IDictionary] -and $authored.Contains($segment)) {
                $authored[$segment]
            }
            else {
                $null
            }
        }
        if ($authored -is [System.Collections.IDictionary] -and $authored.Contains('model_floor')) {
            $floor = [string]$authored['model_floor']
        }
        if (-not $floor -or -not $modelRank.ContainsKey($floor)) {
            $issues.Add("${relative}: metadata.catzc.config.model_floor must be haiku, sonnet or opus")
        }
        else {
            $floors[$name] = $floor
        }
        $lines = Get-RobotLineCount -Path $file -Key $key
        if ($lines.Capability -gt $config.capability_lines) {
            $issues.Add("${relative}: has $($lines.Capability) lines outside its catzc head ($($lines.Capability - $lines.Body) front-matter keys and $($lines.Body) body lines), the roof is $($config.capability_lines) (roofs.capability_lines)")
        }
        $number = 0
        foreach ($line in ([Catzc.Base.MarkdownMeta.MarkdownDocument]::Parse([System.IO.File]::ReadAllText($file), $key).Body -split "`r?`n")) {
            $number++
            if ($line.Length -gt $columnRoof) {
                $issues.Add("${relative}: body line $number has $($line.Length) columns, the roof is $columnRoof")
            }
        }
    }
    $capabilityNames = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::Ordinal)
    foreach ($file in $capabilityFiles) {
        [void]$capabilityNames.Add([System.IO.Path]::GetFileName([System.IO.Path]::GetDirectoryName($file)))
    }

    # The agent files, by name, and the descriptions the standard-agent check reads.
    Assert-PathExist $agentsRoot -PathType Container -ErrorText "Test-AgentDefinitions: no agents folder at '$agentsRoot'."
    $files = @(Get-ChildPath -Path $agentsRoot -Depth 1 -Filter '*.md' -File | Sort-Object)
    $descriptions = @{}
    $preloaded = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::Ordinal)
    foreach ($file in $files) {
        $name = [System.IO.Path]::GetFileNameWithoutExtension($file)
        $relative = ".claude/agents/$name.md"
        if (-not $entries.Contains($name)) {
            $issues.Add("${relative}: has no entry in agents.yml")
        }
        try {
            $frontMatter = Get-AgentFrontMatter -Path $file
        }
        catch {
            $issues.Add("${relative}: $($_.Exception.Message)")
            continue
        }
        $declared = if ($frontMatter.Contains('name')) {
            [string]$frontMatter['name']
        }
        if ($declared -cne $name) {
            $issues.Add("${relative}: front-matter name '$declared' must equal the file name '$name'")
        }
        $description = if ($frontMatter.Contains('description')) {
            [string]$frontMatter['description']
        }
        if ([string]::IsNullOrWhiteSpace($description)) {
            $issues.Add("${relative}: front matter has no description")
        }
        else {
            $descriptions[$name] = $description
            if (-not $description.Contains('Do NOT')) {
                $issues.Add("${relative}: description has no 'Do NOT' clause saying when not to use the agent")
            }
        }
        if (-not $frontMatter.Contains('tools') -or [string]::IsNullOrWhiteSpace([string]$frontMatter['tools'])) {
            $issues.Add("${relative}: front matter has no tools")
        }
        $position = -1
        foreach ($key in @($frontMatter.Keys)) {
            $index = [Array]::IndexOf($robotKeys, [string]$key)
            if ($index -lt 0) {
                $issues.Add("${relative}: front-matter key '$key' is outside the robot set ($($robotKeys -join ', '))")
            }
            elseif ($index -lt $position) {
                $issues.Add("${relative}: front-matter key '$key' is out of the fixed order ($($robotKeys -join ', '))")
            }
            else {
                $position = $index
            }
        }
        $model = if ($frontMatter.Contains('model')) {
            [string]$frontMatter['model']
        }
        if ([string]::IsNullOrWhiteSpace($model) -or $model -eq 'inherit') {
            $issues.Add("${relative}: front matter must name a model (haiku, sonnet or opus), never inherit")
            $model = $null
        }
        $skills = @(if ($frontMatter.Contains('skills') -and $null -ne $frontMatter['skills']) {
                @($frontMatter['skills'])
            })
        foreach ($skill in $skills) {
            $skill = [string]$skill
            if (-not $capabilityNames.Contains($skill)) {
                $issues.Add("${relative}: skills names '$skill', which has no file .claude/skills/$skill/SKILL.md")
                continue
            }
            [void]$preloaded.Add($skill)
            if ($userSkills.Contains($skill)) {
                $issues.Add("${relative}: skills names '$skill', a user skill that no robot preloads")
            }
            if ($model -and $floors.ContainsKey($skill) -and $modelRank.ContainsKey($model) -and $modelRank[$model] -lt $modelRank[$floors[$skill]]) {
                $issues.Add("${relative}: model '$model' is below the model_floor '$($floors[$skill])' of capability '$skill'")
            }
        }
        $lines = Get-RobotLineCount -Path $file
        if ($lines.Body -gt $config.agent_body_lines) {
            $issues.Add("${relative}: body has $($lines.Body) lines, the roof is $($config.agent_body_lines) (roofs.agent_body_lines)")
        }
        $number = 0
        foreach ($line in ([Catzc.Base.MarkdownMeta.MarkdownDocument]::Parse([System.IO.File]::ReadAllText($file), [Catzc.Base.MarkdownMeta.MarkdownDocument]::MetaKey).Body -split "`r?`n")) {
            $number++
            if ($line.Length -gt $columnRoof) {
                $issues.Add("${relative}: body line $number has $($line.Length) columns, the roof is $columnRoof")
            }
        }
    }

    foreach ($name in $capabilityNames) {
        if (-not $preloaded.Contains($name) -and -not $userSkills.Contains($name)) {
            $issues.Add(".claude/skills/$name/SKILL.md: no agent preloads it in its skills list")
        }
    }

    $fileNames = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::Ordinal)
    foreach ($file in $files) {
        [void]$fileNames.Add([System.IO.Path]::GetFileNameWithoutExtension($file))
    }
    # Get-CatsDrsRuleIds returns its array as one object (`, $ret`); the assignment takes that array as is.
    [string[]] $ruleIdList = Get-CatsDrsRuleIds
    $ruleIds = [System.Collections.Generic.HashSet[string]]::new($ruleIdList, [System.StringComparer]::Ordinal)
    foreach ($entry in $config.agents) {
        if (-not $fileNames.Contains($entry.name)) {
            $issues.Add("${agentsFile}: agent '$($entry.name)' has no file .claude/agents/$($entry.name).md")
        }
        foreach ($citation in $entry.supported_by) {
            if (-not $ruleIds.Contains($citation)) {
                $issues.Add("${agentsFile}: agent '$($entry.name)' supported_by '$citation' names no ADR rule")
            }
        }
        foreach ($check in $entry.checks) {
            if (-not (Get-Command -Name $check -ErrorAction Ignore)) {
                $issues.Add("${agentsFile}: agent '$($entry.name)' checks '$check' names no command")
            }
        }
    }

    $registered = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::Ordinal)
    foreach ($entry in $capabilityConfig.capabilities) {
        [void]$registered.Add($entry.name)
        if (-not $capabilityNames.Contains($entry.name)) {
            $issues.Add("${capabilitiesFile}: capability '$($entry.name)' has no file .claude/skills/$($entry.name)/SKILL.md")
        }
        foreach ($citation in $entry.supported_by) {
            if (-not $ruleIds.Contains($citation)) {
                $issues.Add("${capabilitiesFile}: capability '$($entry.name)' supported_by '$citation' names no ADR rule")
            }
        }
        foreach ($check in $entry.checks) {
            if (-not (Get-Command -Name $check -ErrorAction Ignore)) {
                $issues.Add("${capabilitiesFile}: capability '$($entry.name)' checks '$check' names no command")
            }
        }
    }
    foreach ($name in $capabilityNames) {
        if (-not $registered.Contains($name)) {
            $issues.Add(".claude/skills/$name/SKILL.md: has no entry in capabilities.yml")
        }
    }

    # The contracts every robot reads first are named once, in the registry and in CLAUDE.md, never per file.
    $claudeText = ''
    if ([System.IO.File]::Exists($claudeMd)) {
        $claudeText = [System.IO.File]::ReadAllText($claudeMd)
    }
    foreach ($contract in @($config.contracts)) {
        if (-not $claudeText.Contains($contract)) {
            $issues.Add(".claude/CLAUDE.md: does not name the contract '$contract' that agents.yml contracts requires every robot to read first")
        }
    }

    $listed = @(Get-ClaudeMdAgentNames -Path $claudeMd)
    foreach ($name in $entries.Keys) {
        if ($listed -cnotcontains $name) {
            $issues.Add(".claude/CLAUDE.md: the Sub-agents section does not list registered agent '$name'")
        }
    }
    foreach ($name in $listed) {
        if (-not $entries.Contains($name)) {
            $issues.Add(".claude/CLAUDE.md: the Sub-agents section lists '$name', which agents.yml does not register")
        }
    }

    if ($descriptions.ContainsKey($config.standard)) {
        foreach ($name in $entries.Keys) {
            if ($name -cne $config.standard -and -not $descriptions[$config.standard].Contains($name)) {
                $issues.Add(".claude/agents/$($config.standard).md: the standard agent's description does not name specialised agent '$name'")
            }
        }
    }

    Write-QualityGateReport -Subject 'agent-definitions' -Title 'Test-AgentDefinitions' -Issues $issues `
        -Facts ([ordered]@{ Agents = $entries.Count; Files = $files.Count; Capabilities = $capabilityFiles.Count }) -OutputFolder $OutputFolder -PassThru:$PassThru
}
