# ---
# catzc:
#   immutable:
#     with_body_sha: "47e23cd8a81a"
#     warning: "Do Not Edit, this file is generated"
#     repo_status: locked
#     path: pwsh/.internal/assets/importer-commands.sh
#     source: contracts/catzc/0.0.0
#     role: asset
#     language: bash
#     filetype: sh
#     track: pwsh
#     tracktype: modules
#     module: Catzc.Internal.Assets
#     moduletype: pwsh-folder
#     generator: pwsh/Catzc.Base.Contracts/New-CatsCommandLookup.ps1
# ---

# shellcheck shell=bash
# The command lookup `cats` reads before it starts pwsh (ADR-REPO-CMDCONTRACT-ONEREADER): one line per contracted parameter of
# contracts/catzc/0.0.0, tab-separated: command, parameter, type, list (1 or 0), mandatory (1 or 0), pipeline (1 or 0), asset,
# the parameter's sets (comma-separated, empty for every set) and the command's default set (empty for none). A command with no
# parameter has one line with an empty parameter.
_catzc_commands='
Assert-DevBoxToolsStatus			0	0	0	contracts/catzc/0.0.0/Catzc.Tooling.Provisioning/Assert-DevBoxToolsStatus.command.yml		
Build-ContractReference	RepositoryRoot	string	0	0	0	contracts/catzc/0.0.0/Catzc.Base.Contracts/Build-ContractReference.command.yml		
Build-ContractReference	DryRun	switch	0	0	0	contracts/catzc/0.0.0/Catzc.Base.Contracts/Build-ContractReference.command.yml		
Build-ContractReference	Silent	switch	0	0	0	contracts/catzc/0.0.0/Catzc.Base.Contracts/Build-ContractReference.command.yml		
Build-ContractReference	PassThru	switch	0	0	0	contracts/catzc/0.0.0/Catzc.Base.Contracts/Build-ContractReference.command.yml		
Build-EnglishDictionary	DryRun	switch	0	0	0	contracts/catzc/0.0.0/Catzc.Base.QualityGates/Build-EnglishDictionary.command.yml		
Build-EnglishDictionary	PassThru	switch	0	0	0	contracts/catzc/0.0.0/Catzc.Base.QualityGates/Build-EnglishDictionary.command.yml		
Clear-GlobSetProtection			0	0	0	contracts/catzc/0.0.0/Catzc.Base.Globs/Clear-GlobSetProtection.command.yml		
Export-SpellingTriage	Path	string	1	0	0	contracts/catzc/0.0.0/Catzc.Base.QualityGates/Export-SpellingTriage.command.yml		
Export-SpellingTriage	Exclude	string	1	0	0	contracts/catzc/0.0.0/Catzc.Base.QualityGates/Export-SpellingTriage.command.yml		
Export-SpellingTriage	DryRun	switch	0	0	0	contracts/catzc/0.0.0/Catzc.Base.QualityGates/Export-SpellingTriage.command.yml		
Export-WorldMapPdf	View	string	1	0	0	contracts/catzc/0.0.0/Catzc.Base.Maps/Export-WorldMapPdf.command.yml		Plain
Export-WorldMapPdf	Adr	string	1	1	0	contracts/catzc/0.0.0/Catzc.Base.Maps/Export-WorldMapPdf.command.yml	Adr	Plain
Export-WorldMapPdf	Path	string	1	1	0	contracts/catzc/0.0.0/Catzc.Base.Maps/Export-WorldMapPdf.command.yml	Path	Plain
Format-MarkdownTitle	Path	string	1	0	0	contracts/catzc/0.0.0/Catzc.Base.QualityGates/Format-MarkdownTitle.command.yml		
Format-MarkdownTitle	RepositoryRoot	string	0	0	0	contracts/catzc/0.0.0/Catzc.Base.QualityGates/Format-MarkdownTitle.command.yml		
Format-MarkdownTitle	DryRun	switch	0	0	0	contracts/catzc/0.0.0/Catzc.Base.QualityGates/Format-MarkdownTitle.command.yml		
Format-MarkdownTitle	PassThru	switch	0	0	0	contracts/catzc/0.0.0/Catzc.Base.QualityGates/Format-MarkdownTitle.command.yml		
Get-BicepParameterModel	Template	string	0	1	0	contracts/catzc/0.0.0/Catzc.Azure.Templates/Get-BicepParameterModel.command.yml		
Get-BicepTemplateNames			0	0	0	contracts/catzc/0.0.0/Catzc.Azure.Templates/Get-BicepTemplateNames.command.yml		
Get-CommandContract	Name	string	1	0	0	contracts/catzc/0.0.0/Catzc.Base.Contracts/Get-CommandContract.command.yml		
Get-CommandContract	Module	string	1	0	0	contracts/catzc/0.0.0/Catzc.Base.Contracts/Get-CommandContract.command.yml		
Get-CommandContract	Unit	string	1	0	0	contracts/catzc/0.0.0/Catzc.Base.Contracts/Get-CommandContract.command.yml		
Get-CommandContract	Version	string	1	0	0	contracts/catzc/0.0.0/Catzc.Base.Contracts/Get-CommandContract.command.yml		
Get-CommandContract	RepositoryRoot	string	0	0	0	contracts/catzc/0.0.0/Catzc.Base.Contracts/Get-CommandContract.command.yml		
Get-ContractCheckResults	Asset	Catzc.Base.Contracts.ContractAsset	1	0	1	contracts/catzc/0.0.0/Catzc.Base.Contracts/Get-ContractCheckResults.command.yml		
Get-ContractCheckResults	RepositoryRoot	string	0	0	0	contracts/catzc/0.0.0/Catzc.Base.Contracts/Get-ContractCheckResults.command.yml		
Get-FileLanguage	Name	string	1	1	0	contracts/catzc/0.0.0/Catzc.Base.Languages/Get-FileLanguage.command.yml	Name	All
Get-FileLanguage	Path	string	0	1	0	contracts/catzc/0.0.0/Catzc.Base.Languages/Get-FileLanguage.command.yml	Path	All
Get-Inspiration	Id	string	0	1	0	contracts/catzc/0.0.0/Catzc.Tooling.Inspiration/Get-Inspiration.command.yml	Id	All
Get-Inspiration	Count	int	0	1	0	contracts/catzc/0.0.0/Catzc.Tooling.Inspiration/Get-Inspiration.command.yml	Random	All
Get-Inspiration	Seed	int	0	0	0	contracts/catzc/0.0.0/Catzc.Tooling.Inspiration/Get-Inspiration.command.yml	Random	All
Get-Inspiration	IncludeUnavailable	switch	0	0	0	contracts/catzc/0.0.0/Catzc.Tooling.Inspiration/Get-Inspiration.command.yml	All,Random	All
Get-PathFileType	Path	string	0	1	0	contracts/catzc/0.0.0/Catzc.Base.Languages/Get-PathFileType.command.yml		
Get-RepositoryFile	Path	string	0	1	0	contracts/catzc/0.0.0/Catzc.Base.Repository/Get-RepositoryFile.command.yml		
Install-AzCli	Version	string	0	0	0	contracts/catzc/0.0.0/Catzc.Tooling.Toolchain/Install-AzCli.command.yml		
Install-AzCli	Force	switch	0	0	0	contracts/catzc/0.0.0/Catzc.Tooling.Toolchain/Install-AzCli.command.yml		
Install-Bicep	Version	string	0	0	0	contracts/catzc/0.0.0/Catzc.Tooling.Toolchain/Install-Bicep.command.yml		
Install-Bicep	Force	switch	0	0	0	contracts/catzc/0.0.0/Catzc.Tooling.Toolchain/Install-Bicep.command.yml		
Install-Cspell	Version	string	0	0	0	contracts/catzc/0.0.0/Catzc.Tooling.Node/Install-Cspell.command.yml		
Install-Cspell	Force	switch	0	0	0	contracts/catzc/0.0.0/Catzc.Tooling.Node/Install-Cspell.command.yml		
Install-DevBoxTools	Force	switch	0	0	0	contracts/catzc/0.0.0/Catzc.Tooling.Provisioning/Install-DevBoxTools.command.yml		
Install-Dotnet	Version	string	0	0	0	contracts/catzc/0.0.0/Catzc.Tooling.Toolchain/Install-Dotnet.command.yml		
Install-Dotnet	Force	switch	0	0	0	contracts/catzc/0.0.0/Catzc.Tooling.Toolchain/Install-Dotnet.command.yml		
Install-Go	Version	string	0	0	0	contracts/catzc/0.0.0/Catzc.Tooling.Toolchain/Install-Go.command.yml		
Install-Go	Force	switch	0	0	0	contracts/catzc/0.0.0/Catzc.Tooling.Toolchain/Install-Go.command.yml		
Install-Java	Version	string	0	0	0	contracts/catzc/0.0.0/Catzc.Tooling.Toolchain/Install-Java.command.yml		
Install-Java	Force	switch	0	0	0	contracts/catzc/0.0.0/Catzc.Tooling.Toolchain/Install-Java.command.yml		
Install-Markdownlint	Version	string	0	0	0	contracts/catzc/0.0.0/Catzc.Tooling.Node/Install-Markdownlint.command.yml		
Install-Markdownlint	Force	switch	0	0	0	contracts/catzc/0.0.0/Catzc.Tooling.Node/Install-Markdownlint.command.yml		
Install-NodeJs	Version	string	0	0	0	contracts/catzc/0.0.0/Catzc.Tooling.Node/Install-NodeJs.command.yml		
Install-NodeJs	Force	switch	0	0	0	contracts/catzc/0.0.0/Catzc.Tooling.Node/Install-NodeJs.command.yml		
Install-Poetry	Version	string	0	0	0	contracts/catzc/0.0.0/Catzc.Tooling.Python/Install-Poetry.command.yml		
Install-Poetry	Force	switch	0	0	0	contracts/catzc/0.0.0/Catzc.Tooling.Python/Install-Poetry.command.yml		
Install-Prettier	Version	string	0	0	0	contracts/catzc/0.0.0/Catzc.Tooling.Node/Install-Prettier.command.yml		
Install-Prettier	Force	switch	0	0	0	contracts/catzc/0.0.0/Catzc.Tooling.Node/Install-Prettier.command.yml		
Install-PySpark	Version	string	0	0	0	contracts/catzc/0.0.0/Catzc.Tooling.Python/Install-PySpark.command.yml		
Install-PySpark	Force	switch	0	0	0	contracts/catzc/0.0.0/Catzc.Tooling.Python/Install-PySpark.command.yml		
Install-Python	Version	string	0	0	0	contracts/catzc/0.0.0/Catzc.Tooling.Python/Install-Python.command.yml		
Install-Python	Force	switch	0	0	0	contracts/catzc/0.0.0/Catzc.Tooling.Python/Install-Python.command.yml		
Install-Shellcheck	Version	string	0	0	0	contracts/catzc/0.0.0/Catzc.Tooling.Toolchain/Install-Shellcheck.command.yml		
Install-Shellcheck	Force	switch	0	0	0	contracts/catzc/0.0.0/Catzc.Tooling.Toolchain/Install-Shellcheck.command.yml		
Install-Terraform	Version	string	0	0	0	contracts/catzc/0.0.0/Catzc.Tooling.Toolchain/Install-Terraform.command.yml		
Install-Terraform	Force	switch	0	0	0	contracts/catzc/0.0.0/Catzc.Tooling.Toolchain/Install-Terraform.command.yml		
Install-Uv	Version	string	0	0	0	contracts/catzc/0.0.0/Catzc.Tooling.Toolchain/Install-Uv.command.yml		
Install-Uv	Force	switch	0	0	0	contracts/catzc/0.0.0/Catzc.Tooling.Toolchain/Install-Uv.command.yml		
Invoke-BashTest	Module	string	0	1	0	contracts/catzc/0.0.0/Catzc.Base.Languages/Invoke-BashTest.command.yml		
Invoke-BashTest	EntryScript	string	0	0	0	contracts/catzc/0.0.0/Catzc.Base.Languages/Invoke-BashTest.command.yml		
Invoke-BashTest	EngineExecutable	string	0	0	0	contracts/catzc/0.0.0/Catzc.Base.Languages/Invoke-BashTest.command.yml		
Invoke-GoTest	Module	string	0	1	0	contracts/catzc/0.0.0/Catzc.Base.Languages/Invoke-GoTest.command.yml		
Invoke-GoTest	EntryScript	string	0	0	0	contracts/catzc/0.0.0/Catzc.Base.Languages/Invoke-GoTest.command.yml		
Invoke-GoTest	GoExecutable	string	0	0	0	contracts/catzc/0.0.0/Catzc.Base.Languages/Invoke-GoTest.command.yml		
Invoke-GoTest	Engine	string	0	0	0	contracts/catzc/0.0.0/Catzc.Base.Languages/Invoke-GoTest.command.yml		
Invoke-GoTest	EngineExecutable	string	0	0	0	contracts/catzc/0.0.0/Catzc.Base.Languages/Invoke-GoTest.command.yml		
Invoke-Poetry	Arguments	string	0	1	0	contracts/catzc/0.0.0/Catzc.Tooling.Python/Invoke-Poetry.command.yml		
Invoke-Poetry	PassThru	switch	0	0	0	contracts/catzc/0.0.0/Catzc.Tooling.Python/Invoke-Poetry.command.yml		
Invoke-Poetry	NoAssert	switch	0	0	0	contracts/catzc/0.0.0/Catzc.Tooling.Python/Invoke-Poetry.command.yml		
Invoke-Poetry	Silent	switch	0	0	0	contracts/catzc/0.0.0/Catzc.Tooling.Python/Invoke-Poetry.command.yml		
Invoke-Poetry	DryRun	switch	0	0	0	contracts/catzc/0.0.0/Catzc.Tooling.Python/Invoke-Poetry.command.yml		
Invoke-PythonTest	Module	string	0	1	0	contracts/catzc/0.0.0/Catzc.Base.Languages/Invoke-PythonTest.command.yml		
Invoke-PythonTest	EntryScript	string	0	0	0	contracts/catzc/0.0.0/Catzc.Base.Languages/Invoke-PythonTest.command.yml		
Invoke-PythonTest	UvExecutable	string	0	0	0	contracts/catzc/0.0.0/Catzc.Base.Languages/Invoke-PythonTest.command.yml		
Invoke-PythonTest	Engine	string	0	0	0	contracts/catzc/0.0.0/Catzc.Base.Languages/Invoke-PythonTest.command.yml		
Invoke-PythonTest	EngineExecutable	string	0	0	0	contracts/catzc/0.0.0/Catzc.Base.Languages/Invoke-PythonTest.command.yml		
New-GoWorkspace	Target	string	0	0	0	contracts/catzc/0.0.0/Catzc.Base.Languages/New-GoWorkspace.command.yml		
New-PythonProject	Target	string	0	0	0	contracts/catzc/0.0.0/Catzc.Base.Languages/New-PythonProject.command.yml		
Publish-ContractRelease	Unit	string	0	1	0	contracts/catzc/0.0.0/Catzc.Base.Contracts/Publish-ContractRelease.command.yml		
Publish-ContractRelease	Version	string	0	1	0	contracts/catzc/0.0.0/Catzc.Base.Contracts/Publish-ContractRelease.command.yml		
Publish-ContractRelease	RepositoryRoot	string	0	0	0	contracts/catzc/0.0.0/Catzc.Base.Contracts/Publish-ContractRelease.command.yml		
Register-AdoBuildValidation	GlobSet	string	0	1	0	contracts/catzc/0.0.0/Catzc.Azure.DevOps.BuildValidation/Register-AdoBuildValidation.command.yml		
Register-AdoBuildValidation	Pipeline	string	0	0	0	contracts/catzc/0.0.0/Catzc.Azure.DevOps.BuildValidation/Register-AdoBuildValidation.command.yml		
Register-AdoBuildValidation	Branch	string	0	0	0	contracts/catzc/0.0.0/Catzc.Azure.DevOps.BuildValidation/Register-AdoBuildValidation.command.yml		
Register-AdoBuildValidation	Project	string	0	0	0	contracts/catzc/0.0.0/Catzc.Azure.DevOps.BuildValidation/Register-AdoBuildValidation.command.yml		
Register-AdoBuildValidation	Organization	string	0	0	0	contracts/catzc/0.0.0/Catzc.Azure.DevOps.BuildValidation/Register-AdoBuildValidation.command.yml		
Register-AdoBuildValidation	RepositoryName	string	0	0	0	contracts/catzc/0.0.0/Catzc.Azure.DevOps.BuildValidation/Register-AdoBuildValidation.command.yml		
Register-AdoBuildValidation	DryRun	switch	0	0	0	contracts/catzc/0.0.0/Catzc.Azure.DevOps.BuildValidation/Register-AdoBuildValidation.command.yml		
Remove-AzCli	InstallDir	string	0	0	0	contracts/catzc/0.0.0/Catzc.Tooling.Toolchain/Remove-AzCli.command.yml		
Remove-AzCli	Force	switch	0	0	0	contracts/catzc/0.0.0/Catzc.Tooling.Toolchain/Remove-AzCli.command.yml		
Remove-Dotnet	InstallDir	string	0	0	0	contracts/catzc/0.0.0/Catzc.Tooling.Toolchain/Remove-Dotnet.command.yml		
Remove-Dotnet	Force	switch	0	0	0	contracts/catzc/0.0.0/Catzc.Tooling.Toolchain/Remove-Dotnet.command.yml		
Remove-Java	InstallDir	string	0	0	0	contracts/catzc/0.0.0/Catzc.Tooling.Toolchain/Remove-Java.command.yml		
Remove-Java	Force	switch	0	0	0	contracts/catzc/0.0.0/Catzc.Tooling.Toolchain/Remove-Java.command.yml		
Remove-NodeJs	InstallDir	string	0	0	0	contracts/catzc/0.0.0/Catzc.Tooling.Node/Remove-NodeJs.command.yml		
Remove-NodeJs	Force	switch	0	0	0	contracts/catzc/0.0.0/Catzc.Tooling.Node/Remove-NodeJs.command.yml		
Remove-Python	InstallDir	string	0	0	0	contracts/catzc/0.0.0/Catzc.Tooling.Python/Remove-Python.command.yml		
Remove-Python	Force	switch	0	0	0	contracts/catzc/0.0.0/Catzc.Tooling.Python/Remove-Python.command.yml		
Remove-TokenFromHistory	Token	string	0	1	0	contracts/catzc/0.0.0/Catzc.Tooling.Github/Remove-TokenFromHistory.command.yml		
Remove-TokenFromHistory	ReplaceWith	string	0	0	0	contracts/catzc/0.0.0/Catzc.Tooling.Github/Remove-TokenFromHistory.command.yml		
Remove-TokenFromHistory	SkipMessages	switch	0	0	0	contracts/catzc/0.0.0/Catzc.Tooling.Github/Remove-TokenFromHistory.command.yml		
Remove-TokenFromHistory	RepositoryPath	string	0	0	0	contracts/catzc/0.0.0/Catzc.Tooling.Github/Remove-TokenFromHistory.command.yml		
Remove-TokenFromHistory	DryRun	switch	0	0	0	contracts/catzc/0.0.0/Catzc.Tooling.Github/Remove-TokenFromHistory.command.yml		
Test-AdoPipelineTriggerGlob	Name	string	1	0	0	contracts/catzc/0.0.0/Catzc.Base.Globs/Test-AdoPipelineTriggerGlob.command.yml		
Test-AdoPipelineTriggerGlob	OutputFolder	string	0	0	0	contracts/catzc/0.0.0/Catzc.Base.Globs/Test-AdoPipelineTriggerGlob.command.yml		
Test-AdoPipelineTriggerGlob	PassThru	switch	0	0	0	contracts/catzc/0.0.0/Catzc.Base.Globs/Test-AdoPipelineTriggerGlob.command.yml		
Test-AdrEngineNeutrality	OutputFolder	string	0	0	0	contracts/catzc/0.0.0/Catzc.Base.Docs/Test-AdrEngineNeutrality.command.yml		
Test-AdrEngineNeutrality	PassThru	switch	0	0	0	contracts/catzc/0.0.0/Catzc.Base.Docs/Test-AdrEngineNeutrality.command.yml		
Test-AdrRegistry	OutputFolder	string	0	0	0	contracts/catzc/0.0.0/Catzc.Base.Docs/Test-AdrRegistry.command.yml		
Test-AdrRegistry	PassThru	switch	0	0	0	contracts/catzc/0.0.0/Catzc.Base.Docs/Test-AdrRegistry.command.yml		
Test-AgentDefinitions	OutputFolder	string	0	0	0	contracts/catzc/0.0.0/Catzc.Base.Docs/Test-AgentDefinitions.command.yml		
Test-AgentDefinitions	PassThru	switch	0	0	0	contracts/catzc/0.0.0/Catzc.Base.Docs/Test-AgentDefinitions.command.yml		
Test-AnalyzerAdrMap	OutputFolder	string	0	0	0	contracts/catzc/0.0.0/Catzc.Base.QualityGates/Test-AnalyzerAdrMap.command.yml		
Test-AnalyzerAdrMap	PassThru	switch	0	0	0	contracts/catzc/0.0.0/Catzc.Base.QualityGates/Test-AnalyzerAdrMap.command.yml		
Test-Automation	MinLevel	int	0	0	0	contracts/catzc/0.0.0/Catzc.Base.QualityGates/Test-Automation.command.yml		
Test-Automation	MaxLevel	int	0	0	0	contracts/catzc/0.0.0/Catzc.Base.QualityGates/Test-Automation.command.yml		
Test-Automation	Modules	string	1	0	0	contracts/catzc/0.0.0/Catzc.Base.QualityGates/Test-Automation.command.yml		
Test-Automation	Category	string	0	0	0	contracts/catzc/0.0.0/Catzc.Base.QualityGates/Test-Automation.command.yml		
Test-Automation	Workers	int	0	0	0	contracts/catzc/0.0.0/Catzc.Base.QualityGates/Test-Automation.command.yml		
Test-Automation	GreedyGroupSize	int	0	0	0	contracts/catzc/0.0.0/Catzc.Base.QualityGates/Test-Automation.command.yml		
Test-Automation	TimeoutSeconds	int	0	0	0	contracts/catzc/0.0.0/Catzc.Base.QualityGates/Test-Automation.command.yml		
Test-Automation	Output	string	0	0	0	contracts/catzc/0.0.0/Catzc.Base.QualityGates/Test-Automation.command.yml		
Test-Automation	PassThru	switch	0	0	0	contracts/catzc/0.0.0/Catzc.Base.QualityGates/Test-Automation.command.yml		
Test-Automation	EnforceTimings	switch	0	0	0	contracts/catzc/0.0.0/Catzc.Base.QualityGates/Test-Automation.command.yml		
Test-Automation	Rule	string	1	0	0	contracts/catzc/0.0.0/Catzc.Base.QualityGates/Test-Automation.command.yml		
Test-Automation	Suite	string	0	0	0	contracts/catzc/0.0.0/Catzc.Base.QualityGates/Test-Automation.command.yml		
Test-Automation	OutputFolder	string	0	0	0	contracts/catzc/0.0.0/Catzc.Base.QualityGates/Test-Automation.command.yml		
Test-Automation	Isolated	switch	0	0	0	contracts/catzc/0.0.0/Catzc.Base.QualityGates/Test-Automation.command.yml		
Test-Automation	KeepSandbox	switch	0	0	0	contracts/catzc/0.0.0/Catzc.Base.QualityGates/Test-Automation.command.yml		
Test-AzureNetworkPlan	OutputFolder	string	0	0	0	contracts/catzc/0.0.0/Catzc.Azure/Test-AzureNetworkPlan.command.yml		
Test-AzureNetworkPlan	PassThru	switch	0	0	0	contracts/catzc/0.0.0/Catzc.Azure/Test-AzureNetworkPlan.command.yml		
Test-BuildArtifact	Module	string	1	0	0	contracts/catzc/0.0.0/Catzc.Base.QualityGates/Test-BuildArtifact.command.yml		
Test-BuildArtifact	ModuleProfile	string	0	0	0	contracts/catzc/0.0.0/Catzc.Base.QualityGates/Test-BuildArtifact.command.yml		
Test-BuildArtifact	Facet	string	1	0	0	contracts/catzc/0.0.0/Catzc.Base.QualityGates/Test-BuildArtifact.command.yml		
Test-BuildArtifact	OutputFolder	string	0	0	0	contracts/catzc/0.0.0/Catzc.Base.QualityGates/Test-BuildArtifact.command.yml		
Test-BuildArtifact	PassThru	switch	0	0	0	contracts/catzc/0.0.0/Catzc.Base.QualityGates/Test-BuildArtifact.command.yml		
Test-CatzcBuild	Module	string	1	0	0	contracts/catzc/0.0.0/Catzc.Base.QualityGates/Test-CatzcBuild.command.yml		
Test-CatzcBuild	ModuleProfile	string	0	0	0	contracts/catzc/0.0.0/Catzc.Base.QualityGates/Test-CatzcBuild.command.yml		
Test-CatzcBuild	MinLevel	int	0	0	0	contracts/catzc/0.0.0/Catzc.Base.QualityGates/Test-CatzcBuild.command.yml		
Test-CatzcBuild	MaxLevel	int	0	0	0	contracts/catzc/0.0.0/Catzc.Base.QualityGates/Test-CatzcBuild.command.yml		
Test-CatzcBuild	Category	string	0	0	0	contracts/catzc/0.0.0/Catzc.Base.QualityGates/Test-CatzcBuild.command.yml		
Test-CatzcBuild	Workers	int	0	0	0	contracts/catzc/0.0.0/Catzc.Base.QualityGates/Test-CatzcBuild.command.yml		
Test-CatzcBuild	Output	string	0	0	0	contracts/catzc/0.0.0/Catzc.Base.QualityGates/Test-CatzcBuild.command.yml		
Test-CatzcBuild	PassThru	switch	0	0	0	contracts/catzc/0.0.0/Catzc.Base.QualityGates/Test-CatzcBuild.command.yml		
Test-Change	Path	string	1	0	0	contracts/catzc/0.0.0/Catzc.Base.QualityGates/Test-Change.command.yml		
Test-Change	WholeModule	switch	0	0	0	contracts/catzc/0.0.0/Catzc.Base.QualityGates/Test-Change.command.yml		
Test-Change	DryRun	switch	0	0	0	contracts/catzc/0.0.0/Catzc.Base.QualityGates/Test-Change.command.yml		
Test-Change	OutputFolder	string	0	0	0	contracts/catzc/0.0.0/Catzc.Base.QualityGates/Test-Change.command.yml		
Test-Change	PassThru	switch	0	0	0	contracts/catzc/0.0.0/Catzc.Base.QualityGates/Test-Change.command.yml		
Test-CheckedInBinaries	OutputFolder	string	0	0	0	contracts/catzc/0.0.0/Catzc.Base.ModuleSystem/Test-CheckedInBinaries.command.yml		
Test-CheckedInBinaries	PassThru	switch	0	0	0	contracts/catzc/0.0.0/Catzc.Base.ModuleSystem/Test-CheckedInBinaries.command.yml		
Test-ConfigIdentityHygiene	Path	string	1	0	0	contracts/catzc/0.0.0/Catzc.Base.QualityGates/Test-ConfigIdentityHygiene.command.yml		
Test-ConfigIdentityHygiene	OutputFolder	string	0	0	0	contracts/catzc/0.0.0/Catzc.Base.QualityGates/Test-ConfigIdentityHygiene.command.yml		
Test-ConfigIdentityHygiene	PassThru	switch	0	0	0	contracts/catzc/0.0.0/Catzc.Base.QualityGates/Test-ConfigIdentityHygiene.command.yml		
Test-ConfigValidators	OutputFolder	string	0	0	0	contracts/catzc/0.0.0/Catzc.Base.ConfigExtensions/Test-ConfigValidators.command.yml		
Test-ConfigValidators	PassThru	switch	0	0	0	contracts/catzc/0.0.0/Catzc.Base.ConfigExtensions/Test-ConfigValidators.command.yml		
Test-Contracts	Version	string	0	0	0	contracts/catzc/0.0.0/Catzc.Base.Contracts/Test-Contracts.command.yml		
Test-Contracts	RepositoryRoot	string	0	0	0	contracts/catzc/0.0.0/Catzc.Base.Contracts/Test-Contracts.command.yml		
Test-Contracts	OutputFolder	string	0	0	0	contracts/catzc/0.0.0/Catzc.Base.Contracts/Test-Contracts.command.yml		
Test-Contracts	PassThru	switch	0	0	0	contracts/catzc/0.0.0/Catzc.Base.Contracts/Test-Contracts.command.yml		
Test-FileMetaProcessors	Config	Catzc.Base.QualityGates.FileMetaConfig	0	0	0	contracts/catzc/0.0.0/Catzc.Base.QualityGates/Test-FileMetaProcessors.command.yml		
Test-FileMetaProcessors	OutputFolder	string	0	0	0	contracts/catzc/0.0.0/Catzc.Base.QualityGates/Test-FileMetaProcessors.command.yml		
Test-FileMetaProcessors	PassThru	switch	0	0	0	contracts/catzc/0.0.0/Catzc.Base.QualityGates/Test-FileMetaProcessors.command.yml		
Test-FolderConventions	OutputFolder	string	0	0	0	contracts/catzc/0.0.0/Catzc.Base.ModuleSystem/Test-FolderConventions.command.yml		
Test-FolderConventions	PassThru	switch	0	0	0	contracts/catzc/0.0.0/Catzc.Base.ModuleSystem/Test-FolderConventions.command.yml		
Test-Formatting	Language	string	1	0	0	contracts/catzc/0.0.0/Catzc.Base.QualityGates/Test-Formatting.command.yml		
Test-Formatting	OutputFolder	string	0	0	0	contracts/catzc/0.0.0/Catzc.Base.QualityGates/Test-Formatting.command.yml		
Test-Formatting	PassThru	switch	0	0	0	contracts/catzc/0.0.0/Catzc.Base.QualityGates/Test-Formatting.command.yml		
Test-FunctionDependency	ModulesRoot	string	0	0	0	contracts/catzc/0.0.0/Catzc.Base.ModuleSystem/Test-FunctionDependency.command.yml		
Test-FunctionDependency	OutputFolder	string	0	0	0	contracts/catzc/0.0.0/Catzc.Base.ModuleSystem/Test-FunctionDependency.command.yml		
Test-FunctionDependency	PassThru	switch	0	0	0	contracts/catzc/0.0.0/Catzc.Base.ModuleSystem/Test-FunctionDependency.command.yml		
Test-GeneratedFileCurrent	Path	string	0	1	0	contracts/catzc/0.0.0/Catzc.Base.Languages/Test-GeneratedFileCurrent.command.yml		
Test-GeneratedFileCurrent	InputsSha	string	0	1	0	contracts/catzc/0.0.0/Catzc.Base.Languages/Test-GeneratedFileCurrent.command.yml		
Test-GeneratedFiles	Generator	string	1	0	0	contracts/catzc/0.0.0/Catzc.Base.QualityGates/Test-GeneratedFiles.command.yml		
Test-GeneratedFiles	OutputFolder	string	0	0	0	contracts/catzc/0.0.0/Catzc.Base.QualityGates/Test-GeneratedFiles.command.yml		
Test-GeneratedFiles	PassThru	switch	0	0	0	contracts/catzc/0.0.0/Catzc.Base.QualityGates/Test-GeneratedFiles.command.yml		
Test-GeneratedReadmes	OutputFolder	string	0	0	0	contracts/catzc/0.0.0/Catzc.Base.Docs/Test-GeneratedReadmes.command.yml		
Test-GeneratedReadmes	PassThru	switch	0	0	0	contracts/catzc/0.0.0/Catzc.Base.Docs/Test-GeneratedReadmes.command.yml		
Test-GitHubWorkflowTriggerGlob	Name	string	0	1	0	contracts/catzc/0.0.0/Catzc.Base.Globs/Test-GitHubWorkflowTriggerGlob.command.yml		
Test-GitHubWorkflowTriggerGlob	WorkflowPath	string	0	1	0	contracts/catzc/0.0.0/Catzc.Base.Globs/Test-GitHubWorkflowTriggerGlob.command.yml		
Test-GitHubWorkflowTriggerGlob	OutputFolder	string	0	0	0	contracts/catzc/0.0.0/Catzc.Base.Globs/Test-GitHubWorkflowTriggerGlob.command.yml		
Test-GitHubWorkflowTriggerGlob	PassThru	switch	0	0	0	contracts/catzc/0.0.0/Catzc.Base.Globs/Test-GitHubWorkflowTriggerGlob.command.yml		
Test-GlobSetAffected	Name	string	0	1	0	contracts/catzc/0.0.0/Catzc.Base.Globs/Test-GlobSetAffected.command.yml		
Test-GlobSetIndependence	OutputFolder	string	0	0	0	contracts/catzc/0.0.0/Catzc.Base.Globs/Test-GlobSetIndependence.command.yml		
Test-GlobSetIndependence	PassThru	switch	0	0	0	contracts/catzc/0.0.0/Catzc.Base.Globs/Test-GlobSetIndependence.command.yml		
Test-GlobSetTriggerCoverage	OutputFolder	string	0	0	0	contracts/catzc/0.0.0/Catzc.Base.Globs/Test-GlobSetTriggerCoverage.command.yml		
Test-GlobSetTriggerCoverage	PassThru	switch	0	0	0	contracts/catzc/0.0.0/Catzc.Base.Globs/Test-GlobSetTriggerCoverage.command.yml		
Test-Glossary	OutputFolder	string	0	0	0	contracts/catzc/0.0.0/Catzc.Base.Docs/Test-Glossary.command.yml		
Test-Glossary	PassThru	switch	0	0	0	contracts/catzc/0.0.0/Catzc.Base.Docs/Test-Glossary.command.yml		
Test-InIsolation	ModuleProfile	string	0	0	0	contracts/catzc/0.0.0/Catzc.Base.QualityGates/Test-InIsolation.command.yml	ModuleProfile	ModuleProfile
Test-InIsolation	Modules	string	1	1	0	contracts/catzc/0.0.0/Catzc.Base.QualityGates/Test-InIsolation.command.yml	Modules	ModuleProfile
Test-InIsolation	Isolation	string	0	0	0	contracts/catzc/0.0.0/Catzc.Base.QualityGates/Test-InIsolation.command.yml		ModuleProfile
Test-InIsolation	Category	string	0	0	0	contracts/catzc/0.0.0/Catzc.Base.QualityGates/Test-InIsolation.command.yml		ModuleProfile
Test-InIsolation	MaxLevel	int	0	0	0	contracts/catzc/0.0.0/Catzc.Base.QualityGates/Test-InIsolation.command.yml		ModuleProfile
Test-InIsolation	MinLevel	int	0	0	0	contracts/catzc/0.0.0/Catzc.Base.QualityGates/Test-InIsolation.command.yml		ModuleProfile
Test-InIsolation	Destination	string	0	0	0	contracts/catzc/0.0.0/Catzc.Base.QualityGates/Test-InIsolation.command.yml		ModuleProfile
Test-InIsolation	KeepSandbox	switch	0	0	0	contracts/catzc/0.0.0/Catzc.Base.QualityGates/Test-InIsolation.command.yml		ModuleProfile
Test-InIsolation	PassThru	switch	0	0	0	contracts/catzc/0.0.0/Catzc.Base.QualityGates/Test-InIsolation.command.yml		ModuleProfile
Test-Links	Path	string	1	0	0	contracts/catzc/0.0.0/Catzc.Base.QualityGates/Test-Links.command.yml		
Test-Links	Kind	Catzc.Base.QualityGates.LinkKind	0	0	0	contracts/catzc/0.0.0/Catzc.Base.QualityGates/Test-Links.command.yml		
Test-Links	RepositoryRoot	string	0	0	0	contracts/catzc/0.0.0/Catzc.Base.QualityGates/Test-Links.command.yml		
Test-Links	OutputFolder	string	0	0	0	contracts/catzc/0.0.0/Catzc.Base.QualityGates/Test-Links.command.yml		
Test-Links	PassThru	switch	0	0	0	contracts/catzc/0.0.0/Catzc.Base.QualityGates/Test-Links.command.yml		
Test-LogicTestIdentity	Path	string	1	0	0	contracts/catzc/0.0.0/Catzc.Base.QualityGates/Test-LogicTestIdentity.command.yml		
Test-LogicTestIdentity	OutputFolder	string	0	0	0	contracts/catzc/0.0.0/Catzc.Base.QualityGates/Test-LogicTestIdentity.command.yml		
Test-LogicTestIdentity	PassThru	switch	0	0	0	contracts/catzc/0.0.0/Catzc.Base.QualityGates/Test-LogicTestIdentity.command.yml		
Test-ManagedGuids	OutputFolder	string	0	0	0	contracts/catzc/0.0.0/Catzc.Base.QualityGates/Test-ManagedGuids.command.yml		
Test-ManagedGuids	PassThru	switch	0	0	0	contracts/catzc/0.0.0/Catzc.Base.QualityGates/Test-ManagedGuids.command.yml		
Test-Markdownlint	Path	string	1	0	0	contracts/catzc/0.0.0/Catzc.Base.QualityGates/Test-Markdownlint.command.yml		
Test-Markdownlint	OutputFolder	string	0	0	0	contracts/catzc/0.0.0/Catzc.Base.QualityGates/Test-Markdownlint.command.yml		
Test-Markdownlint	PassThru	switch	0	0	0	contracts/catzc/0.0.0/Catzc.Base.QualityGates/Test-Markdownlint.command.yml		
Test-MarkdownTitle	Path	string	1	0	0	contracts/catzc/0.0.0/Catzc.Base.QualityGates/Test-MarkdownTitle.command.yml		
Test-MarkdownTitle	RepositoryRoot	string	0	0	0	contracts/catzc/0.0.0/Catzc.Base.QualityGates/Test-MarkdownTitle.command.yml		
Test-MarkdownTitle	OutputFolder	string	0	0	0	contracts/catzc/0.0.0/Catzc.Base.QualityGates/Test-MarkdownTitle.command.yml		
Test-MarkdownTitle	PassThru	switch	0	0	0	contracts/catzc/0.0.0/Catzc.Base.QualityGates/Test-MarkdownTitle.command.yml		
Test-ModuleCycles	OutputFolder	string	0	0	0	contracts/catzc/0.0.0/Catzc.Base.ModuleSystem/Test-ModuleCycles.command.yml		
Test-ModuleCycles	PassThru	switch	0	0	0	contracts/catzc/0.0.0/Catzc.Base.ModuleSystem/Test-ModuleCycles.command.yml		
Test-ModuleDependency	OutputFolder	string	0	0	0	contracts/catzc/0.0.0/Catzc.Base.ModuleSystem/Test-ModuleDependency.command.yml		
Test-ModuleDependency	PassThru	switch	0	0	0	contracts/catzc/0.0.0/Catzc.Base.ModuleSystem/Test-ModuleDependency.command.yml		
Test-ParameterConsistency	OutputFolder	string	0	0	0	contracts/catzc/0.0.0/Catzc.Base.QualityGates/Test-ParameterConsistency.command.yml		
Test-ParameterConsistency	PassThru	switch	0	0	0	contracts/catzc/0.0.0/Catzc.Base.QualityGates/Test-ParameterConsistency.command.yml		
Test-Pipelines	Path	string	0	0	0	contracts/catzc/0.0.0/Catzc.Azure.DevOps/Test-Pipelines.command.yml		
Test-Pipelines	OutputFolder	string	0	0	0	contracts/catzc/0.0.0/Catzc.Azure.DevOps/Test-Pipelines.command.yml		
Test-Pipelines	PassThru	switch	0	0	0	contracts/catzc/0.0.0/Catzc.Azure.DevOps/Test-Pipelines.command.yml		
Test-PythonLint	OutputFolder	string	0	0	0	contracts/catzc/0.0.0/Catzc.Base.QualityGates/Test-PythonLint.command.yml		
Test-PythonLint	PassThru	switch	0	0	0	contracts/catzc/0.0.0/Catzc.Base.QualityGates/Test-PythonLint.command.yml		
Test-PythonTypes	OutputFolder	string	0	0	0	contracts/catzc/0.0.0/Catzc.Base.QualityGates/Test-PythonTypes.command.yml		
Test-PythonTypes	PassThru	switch	0	0	0	contracts/catzc/0.0.0/Catzc.Base.QualityGates/Test-PythonTypes.command.yml		
Test-RootAnalyzerSettings	OutputFolder	string	0	0	0	contracts/catzc/0.0.0/Catzc.Base.RootConfig/Test-RootAnalyzerSettings.command.yml		
Test-RootAnalyzerSettings	PassThru	switch	0	0	0	contracts/catzc/0.0.0/Catzc.Base.RootConfig/Test-RootAnalyzerSettings.command.yml		
Test-RootConfigFiles	OutputFolder	string	0	0	0	contracts/catzc/0.0.0/Catzc.Base.RootConfig/Test-RootConfigFiles.command.yml		
Test-RootConfigFiles	PassThru	switch	0	0	0	contracts/catzc/0.0.0/Catzc.Base.RootConfig/Test-RootConfigFiles.command.yml		
Test-ScriptAnalyzer	Path	string	1	0	0	contracts/catzc/0.0.0/Catzc.Base.QualityGates/Test-ScriptAnalyzer.command.yml		
Test-ScriptAnalyzer	OutputFolder	string	0	0	0	contracts/catzc/0.0.0/Catzc.Base.QualityGates/Test-ScriptAnalyzer.command.yml		
Test-ScriptAnalyzer	NoCache	switch	0	0	0	contracts/catzc/0.0.0/Catzc.Base.QualityGates/Test-ScriptAnalyzer.command.yml		
Test-ScriptAnalyzer	PassThru	switch	0	0	0	contracts/catzc/0.0.0/Catzc.Base.QualityGates/Test-ScriptAnalyzer.command.yml		
Test-ShellScripts	ShellCheckExclude	string	1	0	0	contracts/catzc/0.0.0/Catzc.Base.QualityGates/Test-ShellScripts.command.yml		
Test-ShellScripts	OutputFolder	string	0	0	0	contracts/catzc/0.0.0/Catzc.Base.QualityGates/Test-ShellScripts.command.yml		
Test-ShellScripts	PassThru	switch	0	0	0	contracts/catzc/0.0.0/Catzc.Base.QualityGates/Test-ShellScripts.command.yml		
Test-ShippedConfigs	OutputFolder	string	0	0	0	contracts/catzc/0.0.0/Catzc.Base.QualityGates/Test-ShippedConfigs.command.yml		
Test-ShippedConfigs	PassThru	switch	0	0	0	contracts/catzc/0.0.0/Catzc.Base.QualityGates/Test-ShippedConfigs.command.yml		
Test-ShippedTypes	OutputFolder	string	0	0	0	contracts/catzc/0.0.0/Catzc.Base.TypesSystem/Test-ShippedTypes.command.yml		
Test-ShippedTypes	PassThru	switch	0	0	0	contracts/catzc/0.0.0/Catzc.Base.TypesSystem/Test-ShippedTypes.command.yml		
Test-Spelling	Path	string	1	0	0	contracts/catzc/0.0.0/Catzc.Base.QualityGates/Test-Spelling.command.yml		
Test-Spelling	Exclude	string	1	0	0	contracts/catzc/0.0.0/Catzc.Base.QualityGates/Test-Spelling.command.yml		
Test-Spelling	OutputFolder	string	0	0	0	contracts/catzc/0.0.0/Catzc.Base.QualityGates/Test-Spelling.command.yml		
Test-Spelling	PassThru	switch	0	0	0	contracts/catzc/0.0.0/Catzc.Base.QualityGates/Test-Spelling.command.yml		
Test-Terminology	OutputFolder	string	0	0	0	contracts/catzc/0.0.0/Catzc.Base.QualityGates/Test-Terminology.command.yml		
Test-Terminology	PassThru	switch	0	0	0	contracts/catzc/0.0.0/Catzc.Base.QualityGates/Test-Terminology.command.yml		
Test-ValueChainMap	OutputFolder	string	0	0	0	contracts/catzc/0.0.0/Catzc.Base.Maps/Test-ValueChainMap.command.yml		
Test-ValueChainMap	PassThru	switch	0	0	0	contracts/catzc/0.0.0/Catzc.Base.Maps/Test-ValueChainMap.command.yml		
Test-WorldMap	OutputFolder	string	0	0	0	contracts/catzc/0.0.0/Catzc.Base.Maps/Test-WorldMap.command.yml		
Test-WorldMap	PassThru	switch	0	0	0	contracts/catzc/0.0.0/Catzc.Base.Maps/Test-WorldMap.command.yml		
Uninstall-AzCli	Remove	switch	0	0	0	contracts/catzc/0.0.0/Catzc.Tooling.Toolchain/Uninstall-AzCli.command.yml		
Uninstall-AzCli	Force	switch	0	0	0	contracts/catzc/0.0.0/Catzc.Tooling.Toolchain/Uninstall-AzCli.command.yml		
Uninstall-Bicep	Version	string	0	0	0	contracts/catzc/0.0.0/Catzc.Tooling.Toolchain/Uninstall-Bicep.command.yml		
Uninstall-Chocolatey			0	0	0	contracts/catzc/0.0.0/Catzc.Tooling.Provisioning/Uninstall-Chocolatey.command.yml		
Uninstall-Cspell			0	0	0	contracts/catzc/0.0.0/Catzc.Tooling.Node/Uninstall-Cspell.command.yml		
Uninstall-DevBoxTools			0	0	0	contracts/catzc/0.0.0/Catzc.Tooling.Provisioning/Uninstall-DevBoxTools.command.yml		
Uninstall-Dotnet	Remove	switch	0	0	0	contracts/catzc/0.0.0/Catzc.Tooling.Toolchain/Uninstall-Dotnet.command.yml		
Uninstall-Dotnet	Force	switch	0	0	0	contracts/catzc/0.0.0/Catzc.Tooling.Toolchain/Uninstall-Dotnet.command.yml		
Uninstall-Git			0	0	0	contracts/catzc/0.0.0/Catzc.Tooling.Provisioning/Uninstall-Git.command.yml		
Uninstall-Go			0	0	0	contracts/catzc/0.0.0/Catzc.Tooling.Toolchain/Uninstall-Go.command.yml		
Uninstall-Java	Version	string	0	0	0	contracts/catzc/0.0.0/Catzc.Tooling.Toolchain/Uninstall-Java.command.yml		
Uninstall-Java	Remove	switch	0	0	0	contracts/catzc/0.0.0/Catzc.Tooling.Toolchain/Uninstall-Java.command.yml		
Uninstall-Java	Force	switch	0	0	0	contracts/catzc/0.0.0/Catzc.Tooling.Toolchain/Uninstall-Java.command.yml		
Uninstall-Markdownlint			0	0	0	contracts/catzc/0.0.0/Catzc.Tooling.Node/Uninstall-Markdownlint.command.yml		
Uninstall-NodeJs	Version	string	0	0	0	contracts/catzc/0.0.0/Catzc.Tooling.Node/Uninstall-NodeJs.command.yml		
Uninstall-NodeJs	Remove	switch	0	0	0	contracts/catzc/0.0.0/Catzc.Tooling.Node/Uninstall-NodeJs.command.yml		
Uninstall-NodeJs	Force	switch	0	0	0	contracts/catzc/0.0.0/Catzc.Tooling.Node/Uninstall-NodeJs.command.yml		
Uninstall-Poetry			0	0	0	contracts/catzc/0.0.0/Catzc.Tooling.Python/Uninstall-Poetry.command.yml		
Uninstall-Postman			0	0	0	contracts/catzc/0.0.0/Catzc.Tooling.Provisioning/Uninstall-Postman.command.yml		
Uninstall-Prettier			0	0	0	contracts/catzc/0.0.0/Catzc.Tooling.Node/Uninstall-Prettier.command.yml		
Uninstall-PySpark			0	0	0	contracts/catzc/0.0.0/Catzc.Tooling.Python/Uninstall-PySpark.command.yml		
Uninstall-Python	Version	string	0	0	0	contracts/catzc/0.0.0/Catzc.Tooling.Python/Uninstall-Python.command.yml		
Uninstall-Shellcheck	Version	string	0	0	0	contracts/catzc/0.0.0/Catzc.Tooling.Toolchain/Uninstall-Shellcheck.command.yml		
Uninstall-Terraform	Version	string	0	0	0	contracts/catzc/0.0.0/Catzc.Tooling.Toolchain/Uninstall-Terraform.command.yml		
Uninstall-Uv	Version	string	0	0	0	contracts/catzc/0.0.0/Catzc.Tooling.Toolchain/Uninstall-Uv.command.yml		
Uninstall-Zsh			0	0	0	contracts/catzc/0.0.0/Catzc.Tooling.Provisioning/Uninstall-Zsh.command.yml		
'
