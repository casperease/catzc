@{
    RootModule        = ''
    ModuleVersion     = '0.1.0'
    PowerShellVersion = '7.4'
    NestedModules     = @('../.internal/assets/Import-ModuleFiles.ps1')
    FunctionsToExport = @('Build-AdrIndex', 'Build-GitKeep', 'Build-Glossary', 'Build-Readme', 'ConvertTo-AdrDomainDiagram', 'Format-MarkdownParagraph', 'Get-AdrCitationMap', 'Get-AdrDomainEdges', 'Get-AdrRuleSet', 'Get-CatsAdrRuleIds', 'Get-Glossary', 'Show-Cats', 'Test-AdrEngineNeutrality', 'Test-AdrRegistry', 'Test-AgentDefinitions', 'Test-GeneratedReadmes', 'Test-Glossary', 'Update-AdrCitation')
    CmdletsToExport   = @()
    VariablesToExport = @()
    AliasesToExport   = @('*')
    PrivateData       = @{ CatzcFiles = @('private/Get-AdrCitationGraphViolations.ps1', 'private/Get-AdrDoraCoverageViolations.ps1', 'private/Get-AdrFileIndex.ps1', 'private/Get-AdrRuleSummaryLines.ps1', 'private/Get-AgentFrontMatter.ps1', 'private/Get-CatsAdrIndex.ps1', 'private/Get-CatsAdrRules.ps1', 'private/Get-CatsModules.ps1', 'private/Get-CatsRuleEnforcers.ps1', 'private/Get-ClaudeMdAgentNames.ps1', 'private/Get-GlossaryAnchorViolations.ps1', 'private/Get-GlossaryDefinitionViolations.ps1', 'private/Get-GlossaryEnforcementViolations.ps1', 'private/Get-GlossaryFormViolations.ps1', 'private/Get-GlossaryPhrasingViolations.ps1', 'private/Get-GlossaryRuleStatements.ps1', 'private/Get-GlossarySourceViolations.ps1', 'private/Get-GlossarySources.ps1', 'private/Get-ReadmeContent.ps1', 'private/Get-ReadmeMappings.ps1', 'private/Get-RobotLineCount.ps1', 'private/Import-AdrCitationMapFile.ps1', 'private/Resolve-AdrLinkTarget.ps1', 'Build-AdrIndex.ps1', 'Build-GitKeep.ps1', 'Build-Glossary.ps1', 'Build-Readme.ps1', 'ConvertTo-AdrDomainDiagram.ps1', 'Format-MarkdownParagraph.ps1', 'Get-AdrCitationMap.ps1', 'Get-AdrDomainEdges.ps1', 'Get-AdrRuleSet.ps1', 'Get-CatsAdrRuleIds.ps1', 'Get-Glossary.ps1', 'Show-Cats.ps1', 'Test-AdrEngineNeutrality.ps1', 'Test-AdrRegistry.ps1', 'Test-AgentDefinitions.ps1', 'Test-GeneratedReadmes.ps1', 'Test-Glossary.ps1', 'Update-AdrCitation.ps1') }
}
