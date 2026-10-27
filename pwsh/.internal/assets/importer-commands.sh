# ---
# catzc:
#   immutable:
#     with_body_sha: "4b194f88a01c"
#     warning: "Do Not Edit, this file is generated"
# ---

# shellcheck shell=bash
# The command lookup `cats` reads before it starts pwsh (ADR-REPO-CMDCONTRACT-CONTRACTONEREADER): one line per contracted parameter of
# contracts/catzc/0.1.0, tab-separated: command, parameter, type, list (1 or 0), mandatory (1 or 0), pipeline (1 or 0), asset,
# the parameter's sets (comma-separated, empty for every set), the command's default set (empty for none), then the command and
# the parameter in kebab case, as cats takes them, and in PowerShell's case, as pwsh binds them. Names are in the normal form; a
# command with no parameter has one line with an empty parameter.
_catzc_commands='
assert_dev_box_tools_status			0	0	0	contracts/catzc/0.1.0/pwsh.tooling.provisioning/assert_dev_box_tools_status.command.yml			assert-dev-box-tools-status		Assert-DevBoxToolsStatus	
build_contract_reference	repository_root	string	0	0	0	contracts/catzc/0.1.0/pwsh.base.contracts/build_contract_reference.command.yml			build-contract-reference	repository-root	Build-ContractReference	RepositoryRoot
build_contract_reference	dry_run	switch	0	0	0	contracts/catzc/0.1.0/pwsh.base.contracts/build_contract_reference.command.yml			build-contract-reference	dry-run	Build-ContractReference	DryRun
build_contract_reference	silent	switch	0	0	0	contracts/catzc/0.1.0/pwsh.base.contracts/build_contract_reference.command.yml			build-contract-reference	silent	Build-ContractReference	Silent
build_contract_reference	pass_thru	switch	0	0	0	contracts/catzc/0.1.0/pwsh.base.contracts/build_contract_reference.command.yml			build-contract-reference	pass-thru	Build-ContractReference	PassThru
build_english_dictionary	dry_run	switch	0	0	0	contracts/catzc/0.1.0/pwsh.base.quality_gates/build_english_dictionary.command.yml			build-english-dictionary	dry-run	Build-EnglishDictionary	DryRun
build_english_dictionary	pass_thru	switch	0	0	0	contracts/catzc/0.1.0/pwsh.base.quality_gates/build_english_dictionary.command.yml			build-english-dictionary	pass-thru	Build-EnglishDictionary	PassThru
clear_glob_set_protection			0	0	0	contracts/catzc/0.1.0/pwsh.base.globs/clear_glob_set_protection.command.yml			clear-glob-set-protection		Clear-GlobSetProtection	
export_spelling_triage	path	string	1	0	0	contracts/catzc/0.1.0/pwsh.base.quality_gates/export_spelling_triage.command.yml			export-spelling-triage	path	Export-SpellingTriage	Path
export_spelling_triage	exclude	string	1	0	0	contracts/catzc/0.1.0/pwsh.base.quality_gates/export_spelling_triage.command.yml			export-spelling-triage	exclude	Export-SpellingTriage	Exclude
export_spelling_triage	dry_run	switch	0	0	0	contracts/catzc/0.1.0/pwsh.base.quality_gates/export_spelling_triage.command.yml			export-spelling-triage	dry-run	Export-SpellingTriage	DryRun
export_world_map_pdf	view	string	1	0	0	contracts/catzc/0.1.0/pwsh.base.maps/export_world_map_pdf.command.yml		plain	export-world-map-pdf	view	Export-WorldMapPdf	View
export_world_map_pdf	adr	string	1	1	0	contracts/catzc/0.1.0/pwsh.base.maps/export_world_map_pdf.command.yml	adr	plain	export-world-map-pdf	adr	Export-WorldMapPdf	Adr
export_world_map_pdf	path	string	1	1	0	contracts/catzc/0.1.0/pwsh.base.maps/export_world_map_pdf.command.yml	path	plain	export-world-map-pdf	path	Export-WorldMapPdf	Path
format_markdown_title	path	string	1	0	0	contracts/catzc/0.1.0/pwsh.base.quality_gates/format_markdown_title.command.yml			format-markdown-title	path	Format-MarkdownTitle	Path
format_markdown_title	repository_root	string	0	0	0	contracts/catzc/0.1.0/pwsh.base.quality_gates/format_markdown_title.command.yml			format-markdown-title	repository-root	Format-MarkdownTitle	RepositoryRoot
format_markdown_title	dry_run	switch	0	0	0	contracts/catzc/0.1.0/pwsh.base.quality_gates/format_markdown_title.command.yml			format-markdown-title	dry-run	Format-MarkdownTitle	DryRun
format_markdown_title	pass_thru	switch	0	0	0	contracts/catzc/0.1.0/pwsh.base.quality_gates/format_markdown_title.command.yml			format-markdown-title	pass-thru	Format-MarkdownTitle	PassThru
get_accosted_file	path	string	0	1	0	contracts/catzc/0.1.0/pwsh.base.contracts/get_accosted_file.command.yml			get-accosted-file	path	Get-AccostedFile	Path
get_accosted_file	repository_root	string	0	0	0	contracts/catzc/0.1.0/pwsh.base.contracts/get_accosted_file.command.yml			get-accosted-file	repository-root	Get-AccostedFile	RepositoryRoot
get_accosted_fragment	path	string	0	1	0	contracts/catzc/0.1.0/pwsh.base.contracts/get_accosted_fragment.command.yml			get-accosted-fragment	path	Get-AccostedFragment	Path
get_accosted_fragment	run_number	int	0	0	0	contracts/catzc/0.1.0/pwsh.base.contracts/get_accosted_fragment.command.yml			get-accosted-fragment	run-number	Get-AccostedFragment	RunNumber
get_accosted_fragment	command_number	int	0	0	0	contracts/catzc/0.1.0/pwsh.base.contracts/get_accosted_fragment.command.yml			get-accosted-fragment	command-number	Get-AccostedFragment	CommandNumber
get_accosted_fragment	repository_root	string	0	0	0	contracts/catzc/0.1.0/pwsh.base.contracts/get_accosted_fragment.command.yml			get-accosted-fragment	repository-root	Get-AccostedFragment	RepositoryRoot
get_bicep_parameter_model	template	string	0	1	0	contracts/catzc/0.1.0/pwsh.azure.templates/get_bicep_parameter_model.command.yml			get-bicep-parameter-model	template	Get-BicepParameterModel	Template
get_bicep_template_names			0	0	0	contracts/catzc/0.1.0/pwsh.azure.templates/get_bicep_template_names.command.yml			get-bicep-template-names		Get-BicepTemplateNames	
get_command_contract	name	string	1	0	0	contracts/catzc/0.1.0/pwsh.base.contracts/get_command_contract.command.yml			get-command-contract	name	Get-CommandContract	Name
get_command_contract	module	string	1	0	0	contracts/catzc/0.1.0/pwsh.base.contracts/get_command_contract.command.yml			get-command-contract	module	Get-CommandContract	Module
get_command_contract	root	string	1	0	0	contracts/catzc/0.1.0/pwsh.base.contracts/get_command_contract.command.yml			get-command-contract	root	Get-CommandContract	Root
get_command_contract	version	string	1	0	0	contracts/catzc/0.1.0/pwsh.base.contracts/get_command_contract.command.yml			get-command-contract	version	Get-CommandContract	Version
get_command_contract	repository_root	string	0	0	0	contracts/catzc/0.1.0/pwsh.base.contracts/get_command_contract.command.yml			get-command-contract	repository-root	Get-CommandContract	RepositoryRoot
get_contract_check_results	asset	catzc.base.contracts.contract_asset	1	0	1	contracts/catzc/0.1.0/pwsh.base.contracts/get_contract_check_results.command.yml			get-contract-check-results	asset	Get-ContractCheckResults	Asset
get_contract_check_results	repository_root	string	0	0	0	contracts/catzc/0.1.0/pwsh.base.contracts/get_contract_check_results.command.yml			get-contract-check-results	repository-root	Get-ContractCheckResults	RepositoryRoot
get_file_language	name	string	1	1	0	contracts/catzc/0.1.0/pwsh.base.languages/get_file_language.command.yml	name	all	get-file-language	name	Get-FileLanguage	Name
get_file_language	path	string	0	1	0	contracts/catzc/0.1.0/pwsh.base.languages/get_file_language.command.yml	path	all	get-file-language	path	Get-FileLanguage	Path
get_inspiration	id	string	0	1	0	contracts/catzc/0.1.0/pwsh.tooling.inspiration/get_inspiration.command.yml	id	all	get-inspiration	id	Get-Inspiration	Id
get_inspiration	count	int	0	1	0	contracts/catzc/0.1.0/pwsh.tooling.inspiration/get_inspiration.command.yml	random	all	get-inspiration	count	Get-Inspiration	Count
get_inspiration	seed	int	0	0	0	contracts/catzc/0.1.0/pwsh.tooling.inspiration/get_inspiration.command.yml	random	all	get-inspiration	seed	Get-Inspiration	Seed
get_inspiration	include_unavailable	switch	0	0	0	contracts/catzc/0.1.0/pwsh.tooling.inspiration/get_inspiration.command.yml	all,random	all	get-inspiration	include-unavailable	Get-Inspiration	IncludeUnavailable
get_path_file_type	path	string	0	1	0	contracts/catzc/0.1.0/pwsh.base.languages/get_path_file_type.command.yml			get-path-file-type	path	Get-PathFileType	Path
get_repository_file	path	string	0	1	0	contracts/catzc/0.1.0/pwsh.base.repository/get_repository_file.command.yml			get-repository-file	path	Get-RepositoryFile	Path
install_az_cli	version	string	0	0	0	contracts/catzc/0.1.0/pwsh.tooling.toolchain/install_az_cli.command.yml			install-az-cli	version	Install-AzCli	Version
install_az_cli	force	switch	0	0	0	contracts/catzc/0.1.0/pwsh.tooling.toolchain/install_az_cli.command.yml			install-az-cli	force	Install-AzCli	Force
install_bicep	version	string	0	0	0	contracts/catzc/0.1.0/pwsh.tooling.toolchain/install_bicep.command.yml			install-bicep	version	Install-Bicep	Version
install_bicep	force	switch	0	0	0	contracts/catzc/0.1.0/pwsh.tooling.toolchain/install_bicep.command.yml			install-bicep	force	Install-Bicep	Force
install_cspell	version	string	0	0	0	contracts/catzc/0.1.0/pwsh.tooling.node/install_cspell.command.yml			install-cspell	version	Install-Cspell	Version
install_cspell	force	switch	0	0	0	contracts/catzc/0.1.0/pwsh.tooling.node/install_cspell.command.yml			install-cspell	force	Install-Cspell	Force
install_dev_box_tools	force	switch	0	0	0	contracts/catzc/0.1.0/pwsh.tooling.provisioning/install_dev_box_tools.command.yml			install-dev-box-tools	force	Install-DevBoxTools	Force
install_dotnet	version	string	0	0	0	contracts/catzc/0.1.0/pwsh.tooling.toolchain/install_dotnet.command.yml			install-dotnet	version	Install-Dotnet	Version
install_dotnet	force	switch	0	0	0	contracts/catzc/0.1.0/pwsh.tooling.toolchain/install_dotnet.command.yml			install-dotnet	force	Install-Dotnet	Force
install_go	version	string	0	0	0	contracts/catzc/0.1.0/pwsh.tooling.toolchain/install_go.command.yml			install-go	version	Install-Go	Version
install_go	force	switch	0	0	0	contracts/catzc/0.1.0/pwsh.tooling.toolchain/install_go.command.yml			install-go	force	Install-Go	Force
install_java	version	string	0	0	0	contracts/catzc/0.1.0/pwsh.tooling.toolchain/install_java.command.yml			install-java	version	Install-Java	Version
install_java	force	switch	0	0	0	contracts/catzc/0.1.0/pwsh.tooling.toolchain/install_java.command.yml			install-java	force	Install-Java	Force
install_markdownlint	version	string	0	0	0	contracts/catzc/0.1.0/pwsh.tooling.node/install_markdownlint.command.yml			install-markdownlint	version	Install-Markdownlint	Version
install_markdownlint	force	switch	0	0	0	contracts/catzc/0.1.0/pwsh.tooling.node/install_markdownlint.command.yml			install-markdownlint	force	Install-Markdownlint	Force
install_node_js	version	string	0	0	0	contracts/catzc/0.1.0/pwsh.tooling.node/install_node_js.command.yml			install-node-js	version	Install-NodeJs	Version
install_node_js	force	switch	0	0	0	contracts/catzc/0.1.0/pwsh.tooling.node/install_node_js.command.yml			install-node-js	force	Install-NodeJs	Force
install_poetry	version	string	0	0	0	contracts/catzc/0.1.0/pwsh.tooling.python/install_poetry.command.yml			install-poetry	version	Install-Poetry	Version
install_poetry	force	switch	0	0	0	contracts/catzc/0.1.0/pwsh.tooling.python/install_poetry.command.yml			install-poetry	force	Install-Poetry	Force
install_prettier	version	string	0	0	0	contracts/catzc/0.1.0/pwsh.tooling.node/install_prettier.command.yml			install-prettier	version	Install-Prettier	Version
install_prettier	force	switch	0	0	0	contracts/catzc/0.1.0/pwsh.tooling.node/install_prettier.command.yml			install-prettier	force	Install-Prettier	Force
install_py_spark	version	string	0	0	0	contracts/catzc/0.1.0/pwsh.tooling.python/install_py_spark.command.yml			install-py-spark	version	Install-PySpark	Version
install_py_spark	force	switch	0	0	0	contracts/catzc/0.1.0/pwsh.tooling.python/install_py_spark.command.yml			install-py-spark	force	Install-PySpark	Force
install_python	version	string	0	0	0	contracts/catzc/0.1.0/pwsh.tooling.python/install_python.command.yml			install-python	version	Install-Python	Version
install_python	force	switch	0	0	0	contracts/catzc/0.1.0/pwsh.tooling.python/install_python.command.yml			install-python	force	Install-Python	Force
install_shellcheck	version	string	0	0	0	contracts/catzc/0.1.0/pwsh.tooling.toolchain/install_shellcheck.command.yml			install-shellcheck	version	Install-Shellcheck	Version
install_shellcheck	force	switch	0	0	0	contracts/catzc/0.1.0/pwsh.tooling.toolchain/install_shellcheck.command.yml			install-shellcheck	force	Install-Shellcheck	Force
install_terraform	version	string	0	0	0	contracts/catzc/0.1.0/pwsh.tooling.toolchain/install_terraform.command.yml			install-terraform	version	Install-Terraform	Version
install_terraform	force	switch	0	0	0	contracts/catzc/0.1.0/pwsh.tooling.toolchain/install_terraform.command.yml			install-terraform	force	Install-Terraform	Force
install_uv	version	string	0	0	0	contracts/catzc/0.1.0/pwsh.tooling.toolchain/install_uv.command.yml			install-uv	version	Install-Uv	Version
install_uv	force	switch	0	0	0	contracts/catzc/0.1.0/pwsh.tooling.toolchain/install_uv.command.yml			install-uv	force	Install-Uv	Force
invoke_accosted	path	string	0	1	0	contracts/catzc/0.1.0/pwsh.base.contracts/invoke_accosted.command.yml			invoke-accosted	path	Invoke-Accosted	Path
invoke_accosted	engine	string	1	0	0	contracts/catzc/0.1.0/pwsh.base.contracts/invoke_accosted.command.yml			invoke-accosted	engine	Invoke-Accosted	Engine
invoke_accosted	repository_root	string	0	0	0	contracts/catzc/0.1.0/pwsh.base.contracts/invoke_accosted.command.yml			invoke-accosted	repository-root	Invoke-Accosted	RepositoryRoot
invoke_bash_test	module	string	0	1	0	contracts/catzc/0.1.0/pwsh.base.languages/invoke_bash_test.command.yml			invoke-bash-test	module	Invoke-BashTest	Module
invoke_bash_test	entry_script	string	0	0	0	contracts/catzc/0.1.0/pwsh.base.languages/invoke_bash_test.command.yml			invoke-bash-test	entry-script	Invoke-BashTest	EntryScript
invoke_bash_test	engine_executable	string	0	0	0	contracts/catzc/0.1.0/pwsh.base.languages/invoke_bash_test.command.yml			invoke-bash-test	engine-executable	Invoke-BashTest	EngineExecutable
invoke_bash_test	folder	string	0	0	0	contracts/catzc/0.1.0/pwsh.base.languages/invoke_bash_test.command.yml			invoke-bash-test	folder	Invoke-BashTest	Folder
invoke_go_test	module	string	0	1	0	contracts/catzc/0.1.0/pwsh.base.languages/invoke_go_test.command.yml			invoke-go-test	module	Invoke-GoTest	Module
invoke_go_test	entry_script	string	0	0	0	contracts/catzc/0.1.0/pwsh.base.languages/invoke_go_test.command.yml			invoke-go-test	entry-script	Invoke-GoTest	EntryScript
invoke_go_test	go_executable	string	0	0	0	contracts/catzc/0.1.0/pwsh.base.languages/invoke_go_test.command.yml			invoke-go-test	go-executable	Invoke-GoTest	GoExecutable
invoke_go_test	engine	string	0	0	0	contracts/catzc/0.1.0/pwsh.base.languages/invoke_go_test.command.yml			invoke-go-test	engine	Invoke-GoTest	Engine
invoke_go_test	engine_executable	string	0	0	0	contracts/catzc/0.1.0/pwsh.base.languages/invoke_go_test.command.yml			invoke-go-test	engine-executable	Invoke-GoTest	EngineExecutable
invoke_go_test	folder	string	0	0	0	contracts/catzc/0.1.0/pwsh.base.languages/invoke_go_test.command.yml			invoke-go-test	folder	Invoke-GoTest	Folder
invoke_poetry	arguments	string	0	1	0	contracts/catzc/0.1.0/pwsh.tooling.python/invoke_poetry.command.yml			invoke-poetry	arguments	Invoke-Poetry	Arguments
invoke_poetry	pass_thru	switch	0	0	0	contracts/catzc/0.1.0/pwsh.tooling.python/invoke_poetry.command.yml			invoke-poetry	pass-thru	Invoke-Poetry	PassThru
invoke_poetry	no_assert	switch	0	0	0	contracts/catzc/0.1.0/pwsh.tooling.python/invoke_poetry.command.yml			invoke-poetry	no-assert	Invoke-Poetry	NoAssert
invoke_poetry	silent	switch	0	0	0	contracts/catzc/0.1.0/pwsh.tooling.python/invoke_poetry.command.yml			invoke-poetry	silent	Invoke-Poetry	Silent
invoke_poetry	dry_run	switch	0	0	0	contracts/catzc/0.1.0/pwsh.tooling.python/invoke_poetry.command.yml			invoke-poetry	dry-run	Invoke-Poetry	DryRun
invoke_python_test	module	string	0	1	0	contracts/catzc/0.1.0/pwsh.base.languages/invoke_python_test.command.yml			invoke-python-test	module	Invoke-PythonTest	Module
invoke_python_test	entry_script	string	0	0	0	contracts/catzc/0.1.0/pwsh.base.languages/invoke_python_test.command.yml			invoke-python-test	entry-script	Invoke-PythonTest	EntryScript
invoke_python_test	uv_executable	string	0	0	0	contracts/catzc/0.1.0/pwsh.base.languages/invoke_python_test.command.yml			invoke-python-test	uv-executable	Invoke-PythonTest	UvExecutable
invoke_python_test	engine	string	0	0	0	contracts/catzc/0.1.0/pwsh.base.languages/invoke_python_test.command.yml			invoke-python-test	engine	Invoke-PythonTest	Engine
invoke_python_test	engine_executable	string	0	0	0	contracts/catzc/0.1.0/pwsh.base.languages/invoke_python_test.command.yml			invoke-python-test	engine-executable	Invoke-PythonTest	EngineExecutable
invoke_python_test	folder	string	0	0	0	contracts/catzc/0.1.0/pwsh.base.languages/invoke_python_test.command.yml			invoke-python-test	folder	Invoke-PythonTest	Folder
new_go_workspace	target	string	0	0	0	contracts/catzc/0.1.0/pwsh.base.languages/new_go_workspace.command.yml			new-go-workspace	target	New-GoWorkspace	Target
new_python_project	line_length	int	0	1	0	contracts/catzc/0.1.0/pwsh.base.languages/new_python_project.command.yml			new-python-project	line-length	New-PythonProject	LineLength
new_python_project	target	string	0	0	0	contracts/catzc/0.1.0/pwsh.base.languages/new_python_project.command.yml			new-python-project	target	New-PythonProject	Target
publish_contract_release	root	string	0	1	0	contracts/catzc/0.1.0/pwsh.base.contracts/publish_contract_release.command.yml			publish-contract-release	root	Publish-ContractRelease	Root
publish_contract_release	version	string	0	1	0	contracts/catzc/0.1.0/pwsh.base.contracts/publish_contract_release.command.yml			publish-contract-release	version	Publish-ContractRelease	Version
publish_contract_release	repository_root	string	0	0	0	contracts/catzc/0.1.0/pwsh.base.contracts/publish_contract_release.command.yml			publish-contract-release	repository-root	Publish-ContractRelease	RepositoryRoot
register_ado_build_validation	glob_set	string	0	1	0	contracts/catzc/0.1.0/pwsh.azure.dev_ops.build_validation/register_ado_build_validation.command.yml			register-ado-build-validation	glob-set	Register-AdoBuildValidation	GlobSet
register_ado_build_validation	pipeline	string	0	0	0	contracts/catzc/0.1.0/pwsh.azure.dev_ops.build_validation/register_ado_build_validation.command.yml			register-ado-build-validation	pipeline	Register-AdoBuildValidation	Pipeline
register_ado_build_validation	branch	string	0	0	0	contracts/catzc/0.1.0/pwsh.azure.dev_ops.build_validation/register_ado_build_validation.command.yml			register-ado-build-validation	branch	Register-AdoBuildValidation	Branch
register_ado_build_validation	project	string	0	0	0	contracts/catzc/0.1.0/pwsh.azure.dev_ops.build_validation/register_ado_build_validation.command.yml			register-ado-build-validation	project	Register-AdoBuildValidation	Project
register_ado_build_validation	organization	string	0	0	0	contracts/catzc/0.1.0/pwsh.azure.dev_ops.build_validation/register_ado_build_validation.command.yml			register-ado-build-validation	organization	Register-AdoBuildValidation	Organization
register_ado_build_validation	repository_name	string	0	0	0	contracts/catzc/0.1.0/pwsh.azure.dev_ops.build_validation/register_ado_build_validation.command.yml			register-ado-build-validation	repository-name	Register-AdoBuildValidation	RepositoryName
register_ado_build_validation	dry_run	switch	0	0	0	contracts/catzc/0.1.0/pwsh.azure.dev_ops.build_validation/register_ado_build_validation.command.yml			register-ado-build-validation	dry-run	Register-AdoBuildValidation	DryRun
remove_az_cli	install_dir	string	0	0	0	contracts/catzc/0.1.0/pwsh.tooling.toolchain/remove_az_cli.command.yml			remove-az-cli	install-dir	Remove-AzCli	InstallDir
remove_az_cli	force	switch	0	0	0	contracts/catzc/0.1.0/pwsh.tooling.toolchain/remove_az_cli.command.yml			remove-az-cli	force	Remove-AzCli	Force
remove_dotnet	install_dir	string	0	0	0	contracts/catzc/0.1.0/pwsh.tooling.toolchain/remove_dotnet.command.yml			remove-dotnet	install-dir	Remove-Dotnet	InstallDir
remove_dotnet	force	switch	0	0	0	contracts/catzc/0.1.0/pwsh.tooling.toolchain/remove_dotnet.command.yml			remove-dotnet	force	Remove-Dotnet	Force
remove_java	install_dir	string	0	0	0	contracts/catzc/0.1.0/pwsh.tooling.toolchain/remove_java.command.yml			remove-java	install-dir	Remove-Java	InstallDir
remove_java	force	switch	0	0	0	contracts/catzc/0.1.0/pwsh.tooling.toolchain/remove_java.command.yml			remove-java	force	Remove-Java	Force
remove_node_js	install_dir	string	0	0	0	contracts/catzc/0.1.0/pwsh.tooling.node/remove_node_js.command.yml			remove-node-js	install-dir	Remove-NodeJs	InstallDir
remove_node_js	force	switch	0	0	0	contracts/catzc/0.1.0/pwsh.tooling.node/remove_node_js.command.yml			remove-node-js	force	Remove-NodeJs	Force
remove_python	install_dir	string	0	0	0	contracts/catzc/0.1.0/pwsh.tooling.python/remove_python.command.yml			remove-python	install-dir	Remove-Python	InstallDir
remove_python	force	switch	0	0	0	contracts/catzc/0.1.0/pwsh.tooling.python/remove_python.command.yml			remove-python	force	Remove-Python	Force
remove_token_from_history	token	string	0	1	0	contracts/catzc/0.1.0/pwsh.tooling.github/remove_token_from_history.command.yml			remove-token-from-history	token	Remove-TokenFromHistory	Token
remove_token_from_history	replace_with	string	0	0	0	contracts/catzc/0.1.0/pwsh.tooling.github/remove_token_from_history.command.yml			remove-token-from-history	replace-with	Remove-TokenFromHistory	ReplaceWith
remove_token_from_history	skip_messages	switch	0	0	0	contracts/catzc/0.1.0/pwsh.tooling.github/remove_token_from_history.command.yml			remove-token-from-history	skip-messages	Remove-TokenFromHistory	SkipMessages
remove_token_from_history	repository_path	string	0	0	0	contracts/catzc/0.1.0/pwsh.tooling.github/remove_token_from_history.command.yml			remove-token-from-history	repository-path	Remove-TokenFromHistory	RepositoryPath
remove_token_from_history	dry_run	switch	0	0	0	contracts/catzc/0.1.0/pwsh.tooling.github/remove_token_from_history.command.yml			remove-token-from-history	dry-run	Remove-TokenFromHistory	DryRun
start_claude_drone	skill	string	0	1	0	contracts/catzc/0.1.0/pwsh.tooling.claude/start_claude_drone.command.yml			start-claude-drone	skill	Start-ClaudeDrone	Skill
start_claude_drone	model	string	0	0	0	contracts/catzc/0.1.0/pwsh.tooling.claude/start_claude_drone.command.yml			start-claude-drone	model	Start-ClaudeDrone	Model
start_claude_drone	prompt	string	0	0	0	contracts/catzc/0.1.0/pwsh.tooling.claude/start_claude_drone.command.yml			start-claude-drone	prompt	Start-ClaudeDrone	Prompt
start_claude_drone	count	int	0	0	0	contracts/catzc/0.1.0/pwsh.tooling.claude/start_claude_drone.command.yml			start-claude-drone	count	Start-ClaudeDrone	Count
start_claude_drone	launcher	string	0	0	0	contracts/catzc/0.1.0/pwsh.tooling.claude/start_claude_drone.command.yml			start-claude-drone	launcher	Start-ClaudeDrone	Launcher
start_claude_drone	pass_thru	switch	0	0	0	contracts/catzc/0.1.0/pwsh.tooling.claude/start_claude_drone.command.yml			start-claude-drone	pass-thru	Start-ClaudeDrone	PassThru
start_claude_drone	dry_run	switch	0	0	0	contracts/catzc/0.1.0/pwsh.tooling.claude/start_claude_drone.command.yml			start-claude-drone	dry-run	Start-ClaudeDrone	DryRun
test_accosted_command	call	string	0	1	0	contracts/catzc/0.1.0/pwsh.base.contracts/test_accosted_command.command.yml			test-accosted-command	call	Test-AccostedCommand	Call
test_accosted_command	where	string	0	1	0	contracts/catzc/0.1.0/pwsh.base.contracts/test_accosted_command.command.yml			test-accosted-command	where	Test-AccostedCommand	Where
test_accosted_command	repository_root	string	0	0	0	contracts/catzc/0.1.0/pwsh.base.contracts/test_accosted_command.command.yml			test-accosted-command	repository-root	Test-AccostedCommand	RepositoryRoot
test_ado_pipeline_trigger_glob	name	string	1	0	0	contracts/catzc/0.1.0/pwsh.base.globs/test_ado_pipeline_trigger_glob.command.yml			test-ado-pipeline-trigger-glob	name	Test-AdoPipelineTriggerGlob	Name
test_ado_pipeline_trigger_glob	output_folder	string	0	0	0	contracts/catzc/0.1.0/pwsh.base.globs/test_ado_pipeline_trigger_glob.command.yml			test-ado-pipeline-trigger-glob	output-folder	Test-AdoPipelineTriggerGlob	OutputFolder
test_ado_pipeline_trigger_glob	pass_thru	switch	0	0	0	contracts/catzc/0.1.0/pwsh.base.globs/test_ado_pipeline_trigger_glob.command.yml			test-ado-pipeline-trigger-glob	pass-thru	Test-AdoPipelineTriggerGlob	PassThru
test_agent_definitions	output_folder	string	0	0	0	contracts/catzc/0.1.0/pwsh.base.docs/test_agent_definitions.command.yml			test-agent-definitions	output-folder	Test-AgentDefinitions	OutputFolder
test_agent_definitions	pass_thru	switch	0	0	0	contracts/catzc/0.1.0/pwsh.base.docs/test_agent_definitions.command.yml			test-agent-definitions	pass-thru	Test-AgentDefinitions	PassThru
test_analyzer_drs_map	output_folder	string	0	0	0	contracts/catzc/0.1.0/pwsh.base.quality_gates/test_analyzer_drs_map.command.yml			test-analyzer-drs-map	output-folder	Test-AnalyzerDrsMap	OutputFolder
test_analyzer_drs_map	pass_thru	switch	0	0	0	contracts/catzc/0.1.0/pwsh.base.quality_gates/test_analyzer_drs_map.command.yml			test-analyzer-drs-map	pass-thru	Test-AnalyzerDrsMap	PassThru
test_automation	min_level	int	0	0	0	contracts/catzc/0.1.0/pwsh.base.quality_gates/test_automation.command.yml			test-automation	min-level	Test-Automation	MinLevel
test_automation	max_level	int	0	0	0	contracts/catzc/0.1.0/pwsh.base.quality_gates/test_automation.command.yml			test-automation	max-level	Test-Automation	MaxLevel
test_automation	modules	string	1	0	0	contracts/catzc/0.1.0/pwsh.base.quality_gates/test_automation.command.yml			test-automation	modules	Test-Automation	Modules
test_automation	category	string	0	0	0	contracts/catzc/0.1.0/pwsh.base.quality_gates/test_automation.command.yml			test-automation	category	Test-Automation	Category
test_automation	workers	int	0	0	0	contracts/catzc/0.1.0/pwsh.base.quality_gates/test_automation.command.yml			test-automation	workers	Test-Automation	Workers
test_automation	greedy_group_size	int	0	0	0	contracts/catzc/0.1.0/pwsh.base.quality_gates/test_automation.command.yml			test-automation	greedy-group-size	Test-Automation	GreedyGroupSize
test_automation	timeout_seconds	int	0	0	0	contracts/catzc/0.1.0/pwsh.base.quality_gates/test_automation.command.yml			test-automation	timeout-seconds	Test-Automation	TimeoutSeconds
test_automation	output	string	0	0	0	contracts/catzc/0.1.0/pwsh.base.quality_gates/test_automation.command.yml			test-automation	output	Test-Automation	Output
test_automation	pass_thru	switch	0	0	0	contracts/catzc/0.1.0/pwsh.base.quality_gates/test_automation.command.yml			test-automation	pass-thru	Test-Automation	PassThru
test_automation	enforce_timings	switch	0	0	0	contracts/catzc/0.1.0/pwsh.base.quality_gates/test_automation.command.yml			test-automation	enforce-timings	Test-Automation	EnforceTimings
test_automation	rule	string	1	0	0	contracts/catzc/0.1.0/pwsh.base.quality_gates/test_automation.command.yml			test-automation	rule	Test-Automation	Rule
test_automation	suite	string	0	0	0	contracts/catzc/0.1.0/pwsh.base.quality_gates/test_automation.command.yml			test-automation	suite	Test-Automation	Suite
test_automation	output_folder	string	0	0	0	contracts/catzc/0.1.0/pwsh.base.quality_gates/test_automation.command.yml			test-automation	output-folder	Test-Automation	OutputFolder
test_automation	isolated	switch	0	0	0	contracts/catzc/0.1.0/pwsh.base.quality_gates/test_automation.command.yml			test-automation	isolated	Test-Automation	Isolated
test_automation	keep_sandbox	switch	0	0	0	contracts/catzc/0.1.0/pwsh.base.quality_gates/test_automation.command.yml			test-automation	keep-sandbox	Test-Automation	KeepSandbox
test_azure_network_plan	output_folder	string	0	0	0	contracts/catzc/0.1.0/pwsh.azure/test_azure_network_plan.command.yml			test-azure-network-plan	output-folder	Test-AzureNetworkPlan	OutputFolder
test_azure_network_plan	pass_thru	switch	0	0	0	contracts/catzc/0.1.0/pwsh.azure/test_azure_network_plan.command.yml			test-azure-network-plan	pass-thru	Test-AzureNetworkPlan	PassThru
test_build_artifact	module	string	1	0	0	contracts/catzc/0.1.0/pwsh.base.quality_gates/test_build_artifact.command.yml			test-build-artifact	module	Test-BuildArtifact	Module
test_build_artifact	module_profile	string	0	0	0	contracts/catzc/0.1.0/pwsh.base.quality_gates/test_build_artifact.command.yml			test-build-artifact	module-profile	Test-BuildArtifact	ModuleProfile
test_build_artifact	facet	string	1	0	0	contracts/catzc/0.1.0/pwsh.base.quality_gates/test_build_artifact.command.yml			test-build-artifact	facet	Test-BuildArtifact	Facet
test_build_artifact	output_folder	string	0	0	0	contracts/catzc/0.1.0/pwsh.base.quality_gates/test_build_artifact.command.yml			test-build-artifact	output-folder	Test-BuildArtifact	OutputFolder
test_build_artifact	pass_thru	switch	0	0	0	contracts/catzc/0.1.0/pwsh.base.quality_gates/test_build_artifact.command.yml			test-build-artifact	pass-thru	Test-BuildArtifact	PassThru
test_catzc_build	module	string	1	0	0	contracts/catzc/0.1.0/pwsh.base.quality_gates/test_catzc_build.command.yml			test-catzc-build	module	Test-CatzcBuild	Module
test_catzc_build	module_profile	string	0	0	0	contracts/catzc/0.1.0/pwsh.base.quality_gates/test_catzc_build.command.yml			test-catzc-build	module-profile	Test-CatzcBuild	ModuleProfile
test_catzc_build	min_level	int	0	0	0	contracts/catzc/0.1.0/pwsh.base.quality_gates/test_catzc_build.command.yml			test-catzc-build	min-level	Test-CatzcBuild	MinLevel
test_catzc_build	max_level	int	0	0	0	contracts/catzc/0.1.0/pwsh.base.quality_gates/test_catzc_build.command.yml			test-catzc-build	max-level	Test-CatzcBuild	MaxLevel
test_catzc_build	category	string	0	0	0	contracts/catzc/0.1.0/pwsh.base.quality_gates/test_catzc_build.command.yml			test-catzc-build	category	Test-CatzcBuild	Category
test_catzc_build	workers	int	0	0	0	contracts/catzc/0.1.0/pwsh.base.quality_gates/test_catzc_build.command.yml			test-catzc-build	workers	Test-CatzcBuild	Workers
test_catzc_build	output	string	0	0	0	contracts/catzc/0.1.0/pwsh.base.quality_gates/test_catzc_build.command.yml			test-catzc-build	output	Test-CatzcBuild	Output
test_catzc_build	pass_thru	switch	0	0	0	contracts/catzc/0.1.0/pwsh.base.quality_gates/test_catzc_build.command.yml			test-catzc-build	pass-thru	Test-CatzcBuild	PassThru
test_change	path	string	1	0	0	contracts/catzc/0.1.0/pwsh.base.quality_gates/test_change.command.yml			test-change	path	Test-Change	Path
test_change	whole_module	switch	0	0	0	contracts/catzc/0.1.0/pwsh.base.quality_gates/test_change.command.yml			test-change	whole-module	Test-Change	WholeModule
test_change	dry_run	switch	0	0	0	contracts/catzc/0.1.0/pwsh.base.quality_gates/test_change.command.yml			test-change	dry-run	Test-Change	DryRun
test_change	output_folder	string	0	0	0	contracts/catzc/0.1.0/pwsh.base.quality_gates/test_change.command.yml			test-change	output-folder	Test-Change	OutputFolder
test_change	pass_thru	switch	0	0	0	contracts/catzc/0.1.0/pwsh.base.quality_gates/test_change.command.yml			test-change	pass-thru	Test-Change	PassThru
test_checked_in_binaries	output_folder	string	0	0	0	contracts/catzc/0.1.0/pwsh.base.module_system/test_checked_in_binaries.command.yml			test-checked-in-binaries	output-folder	Test-CheckedInBinaries	OutputFolder
test_checked_in_binaries	pass_thru	switch	0	0	0	contracts/catzc/0.1.0/pwsh.base.module_system/test_checked_in_binaries.command.yml			test-checked-in-binaries	pass-thru	Test-CheckedInBinaries	PassThru
test_config_identity_hygiene	path	string	1	0	0	contracts/catzc/0.1.0/pwsh.base.quality_gates/test_config_identity_hygiene.command.yml			test-config-identity-hygiene	path	Test-ConfigIdentityHygiene	Path
test_config_identity_hygiene	output_folder	string	0	0	0	contracts/catzc/0.1.0/pwsh.base.quality_gates/test_config_identity_hygiene.command.yml			test-config-identity-hygiene	output-folder	Test-ConfigIdentityHygiene	OutputFolder
test_config_identity_hygiene	pass_thru	switch	0	0	0	contracts/catzc/0.1.0/pwsh.base.quality_gates/test_config_identity_hygiene.command.yml			test-config-identity-hygiene	pass-thru	Test-ConfigIdentityHygiene	PassThru
test_config_validators	output_folder	string	0	0	0	contracts/catzc/0.1.0/pwsh.base.config_extensions/test_config_validators.command.yml			test-config-validators	output-folder	Test-ConfigValidators	OutputFolder
test_config_validators	pass_thru	switch	0	0	0	contracts/catzc/0.1.0/pwsh.base.config_extensions/test_config_validators.command.yml			test-config-validators	pass-thru	Test-ConfigValidators	PassThru
test_contracts	version	string	0	0	0	contracts/catzc/0.1.0/pwsh.base.contracts/test_contracts.command.yml			test-contracts	version	Test-Contracts	Version
test_contracts	repository_root	string	0	0	0	contracts/catzc/0.1.0/pwsh.base.contracts/test_contracts.command.yml			test-contracts	repository-root	Test-Contracts	RepositoryRoot
test_contracts	output_folder	string	0	0	0	contracts/catzc/0.1.0/pwsh.base.contracts/test_contracts.command.yml			test-contracts	output-folder	Test-Contracts	OutputFolder
test_contracts	pass_thru	switch	0	0	0	contracts/catzc/0.1.0/pwsh.base.contracts/test_contracts.command.yml			test-contracts	pass-thru	Test-Contracts	PassThru
test_drs_engine_neutrality	output_folder	string	0	0	0	contracts/catzc/0.1.0/pwsh.base.drs/test_drs_engine_neutrality.command.yml			test-drs-engine-neutrality	output-folder	Test-DrsEngineNeutrality	OutputFolder
test_drs_engine_neutrality	pass_thru	switch	0	0	0	contracts/catzc/0.1.0/pwsh.base.drs/test_drs_engine_neutrality.command.yml			test-drs-engine-neutrality	pass-thru	Test-DrsEngineNeutrality	PassThru
test_drs_registry	output_folder	string	0	0	0	contracts/catzc/0.1.0/pwsh.base.drs/test_drs_registry.command.yml			test-drs-registry	output-folder	Test-DrsRegistry	OutputFolder
test_drs_registry	pass_thru	switch	0	0	0	contracts/catzc/0.1.0/pwsh.base.drs/test_drs_registry.command.yml			test-drs-registry	pass-thru	Test-DrsRegistry	PassThru
test_file_meta_processors	config	catzc.base.quality_gates.file_meta_config	0	0	0	contracts/catzc/0.1.0/pwsh.base.quality_gates/test_file_meta_processors.command.yml			test-file-meta-processors	config	Test-FileMetaProcessors	Config
test_file_meta_processors	output_folder	string	0	0	0	contracts/catzc/0.1.0/pwsh.base.quality_gates/test_file_meta_processors.command.yml			test-file-meta-processors	output-folder	Test-FileMetaProcessors	OutputFolder
test_file_meta_processors	pass_thru	switch	0	0	0	contracts/catzc/0.1.0/pwsh.base.quality_gates/test_file_meta_processors.command.yml			test-file-meta-processors	pass-thru	Test-FileMetaProcessors	PassThru
test_folder_conventions	output_folder	string	0	0	0	contracts/catzc/0.1.0/pwsh.base.module_system/test_folder_conventions.command.yml			test-folder-conventions	output-folder	Test-FolderConventions	OutputFolder
test_folder_conventions	pass_thru	switch	0	0	0	contracts/catzc/0.1.0/pwsh.base.module_system/test_folder_conventions.command.yml			test-folder-conventions	pass-thru	Test-FolderConventions	PassThru
test_formatting	language	string	1	0	0	contracts/catzc/0.1.0/pwsh.base.quality_gates/test_formatting.command.yml			test-formatting	language	Test-Formatting	Language
test_formatting	path	string	1	0	0	contracts/catzc/0.1.0/pwsh.base.quality_gates/test_formatting.command.yml			test-formatting	path	Test-Formatting	Path
test_formatting	output_folder	string	0	0	0	contracts/catzc/0.1.0/pwsh.base.quality_gates/test_formatting.command.yml			test-formatting	output-folder	Test-Formatting	OutputFolder
test_formatting	pass_thru	switch	0	0	0	contracts/catzc/0.1.0/pwsh.base.quality_gates/test_formatting.command.yml			test-formatting	pass-thru	Test-Formatting	PassThru
test_function_dependency	modules_root	string	0	0	0	contracts/catzc/0.1.0/pwsh.base.module_system/test_function_dependency.command.yml			test-function-dependency	modules-root	Test-FunctionDependency	ModulesRoot
test_function_dependency	output_folder	string	0	0	0	contracts/catzc/0.1.0/pwsh.base.module_system/test_function_dependency.command.yml			test-function-dependency	output-folder	Test-FunctionDependency	OutputFolder
test_function_dependency	pass_thru	switch	0	0	0	contracts/catzc/0.1.0/pwsh.base.module_system/test_function_dependency.command.yml			test-function-dependency	pass-thru	Test-FunctionDependency	PassThru
test_generated_files	generator	string	1	0	0	contracts/catzc/0.1.0/pwsh.base.quality_gates/test_generated_files.command.yml	writers	writers	test-generated-files	generator	Test-GeneratedFiles	Generator
test_generated_files	changed	switch	0	0	0	contracts/catzc/0.1.0/pwsh.base.quality_gates/test_generated_files.command.yml		writers	test-generated-files	changed	Test-GeneratedFiles	Changed
test_generated_files	stamp_only	switch	0	0	0	contracts/catzc/0.1.0/pwsh.base.quality_gates/test_generated_files.command.yml	stamp	writers	test-generated-files	stamp-only	Test-GeneratedFiles	StampOnly
test_generated_files	output_folder	string	0	0	0	contracts/catzc/0.1.0/pwsh.base.quality_gates/test_generated_files.command.yml		writers	test-generated-files	output-folder	Test-GeneratedFiles	OutputFolder
test_generated_files	pass_thru	switch	0	0	0	contracts/catzc/0.1.0/pwsh.base.quality_gates/test_generated_files.command.yml		writers	test-generated-files	pass-thru	Test-GeneratedFiles	PassThru
test_generated_readmes	output_folder	string	0	0	0	contracts/catzc/0.1.0/pwsh.base.docs/test_generated_readmes.command.yml			test-generated-readmes	output-folder	Test-GeneratedReadmes	OutputFolder
test_generated_readmes	pass_thru	switch	0	0	0	contracts/catzc/0.1.0/pwsh.base.docs/test_generated_readmes.command.yml			test-generated-readmes	pass-thru	Test-GeneratedReadmes	PassThru
test_git_hub_workflow_trigger_glob	name	string	0	1	0	contracts/catzc/0.1.0/pwsh.base.globs/test_git_hub_workflow_trigger_glob.command.yml			test-git-hub-workflow-trigger-glob	name	Test-GitHubWorkflowTriggerGlob	Name
test_git_hub_workflow_trigger_glob	workflow_path	string	0	1	0	contracts/catzc/0.1.0/pwsh.base.globs/test_git_hub_workflow_trigger_glob.command.yml			test-git-hub-workflow-trigger-glob	workflow-path	Test-GitHubWorkflowTriggerGlob	WorkflowPath
test_git_hub_workflow_trigger_glob	output_folder	string	0	0	0	contracts/catzc/0.1.0/pwsh.base.globs/test_git_hub_workflow_trigger_glob.command.yml			test-git-hub-workflow-trigger-glob	output-folder	Test-GitHubWorkflowTriggerGlob	OutputFolder
test_git_hub_workflow_trigger_glob	pass_thru	switch	0	0	0	contracts/catzc/0.1.0/pwsh.base.globs/test_git_hub_workflow_trigger_glob.command.yml			test-git-hub-workflow-trigger-glob	pass-thru	Test-GitHubWorkflowTriggerGlob	PassThru
test_glob_set_affected	name	string	0	1	0	contracts/catzc/0.1.0/pwsh.base.globs/test_glob_set_affected.command.yml			test-glob-set-affected	name	Test-GlobSetAffected	Name
test_glob_set_independence	output_folder	string	0	0	0	contracts/catzc/0.1.0/pwsh.base.globs/test_glob_set_independence.command.yml			test-glob-set-independence	output-folder	Test-GlobSetIndependence	OutputFolder
test_glob_set_independence	pass_thru	switch	0	0	0	contracts/catzc/0.1.0/pwsh.base.globs/test_glob_set_independence.command.yml			test-glob-set-independence	pass-thru	Test-GlobSetIndependence	PassThru
test_glob_set_trigger_coverage	output_folder	string	0	0	0	contracts/catzc/0.1.0/pwsh.base.globs/test_glob_set_trigger_coverage.command.yml			test-glob-set-trigger-coverage	output-folder	Test-GlobSetTriggerCoverage	OutputFolder
test_glob_set_trigger_coverage	pass_thru	switch	0	0	0	contracts/catzc/0.1.0/pwsh.base.globs/test_glob_set_trigger_coverage.command.yml			test-glob-set-trigger-coverage	pass-thru	Test-GlobSetTriggerCoverage	PassThru
test_glossary	output_folder	string	0	0	0	contracts/catzc/0.1.0/pwsh.base.docs/test_glossary.command.yml			test-glossary	output-folder	Test-Glossary	OutputFolder
test_glossary	pass_thru	switch	0	0	0	contracts/catzc/0.1.0/pwsh.base.docs/test_glossary.command.yml			test-glossary	pass-thru	Test-Glossary	PassThru
test_in_isolation	module_profile	string	0	0	0	contracts/catzc/0.1.0/pwsh.base.quality_gates/test_in_isolation.command.yml	module_profile	module_profile	test-in-isolation	module-profile	Test-InIsolation	ModuleProfile
test_in_isolation	modules	string	1	1	0	contracts/catzc/0.1.0/pwsh.base.quality_gates/test_in_isolation.command.yml	modules	module_profile	test-in-isolation	modules	Test-InIsolation	Modules
test_in_isolation	isolation	string	0	0	0	contracts/catzc/0.1.0/pwsh.base.quality_gates/test_in_isolation.command.yml		module_profile	test-in-isolation	isolation	Test-InIsolation	Isolation
test_in_isolation	category	string	0	0	0	contracts/catzc/0.1.0/pwsh.base.quality_gates/test_in_isolation.command.yml		module_profile	test-in-isolation	category	Test-InIsolation	Category
test_in_isolation	max_level	int	0	0	0	contracts/catzc/0.1.0/pwsh.base.quality_gates/test_in_isolation.command.yml		module_profile	test-in-isolation	max-level	Test-InIsolation	MaxLevel
test_in_isolation	min_level	int	0	0	0	contracts/catzc/0.1.0/pwsh.base.quality_gates/test_in_isolation.command.yml		module_profile	test-in-isolation	min-level	Test-InIsolation	MinLevel
test_in_isolation	destination	string	0	0	0	contracts/catzc/0.1.0/pwsh.base.quality_gates/test_in_isolation.command.yml		module_profile	test-in-isolation	destination	Test-InIsolation	Destination
test_in_isolation	keep_sandbox	switch	0	0	0	contracts/catzc/0.1.0/pwsh.base.quality_gates/test_in_isolation.command.yml		module_profile	test-in-isolation	keep-sandbox	Test-InIsolation	KeepSandbox
test_in_isolation	pass_thru	switch	0	0	0	contracts/catzc/0.1.0/pwsh.base.quality_gates/test_in_isolation.command.yml		module_profile	test-in-isolation	pass-thru	Test-InIsolation	PassThru
test_link_directions	path	string	1	0	0	contracts/catzc/0.1.0/pwsh.base.quality_gates/test_link_directions.command.yml			test-link-directions	path	Test-LinkDirections	Path
test_link_directions	repository_root	string	0	0	0	contracts/catzc/0.1.0/pwsh.base.quality_gates/test_link_directions.command.yml			test-link-directions	repository-root	Test-LinkDirections	RepositoryRoot
test_link_directions	output_folder	string	0	0	0	contracts/catzc/0.1.0/pwsh.base.quality_gates/test_link_directions.command.yml			test-link-directions	output-folder	Test-LinkDirections	OutputFolder
test_link_directions	pass_thru	switch	0	0	0	contracts/catzc/0.1.0/pwsh.base.quality_gates/test_link_directions.command.yml			test-link-directions	pass-thru	Test-LinkDirections	PassThru
test_links	path	string	1	0	0	contracts/catzc/0.1.0/pwsh.base.quality_gates/test_links.command.yml			test-links	path	Test-Links	Path
test_links	kind	catzc.base.quality_gates.link_kind	0	0	0	contracts/catzc/0.1.0/pwsh.base.quality_gates/test_links.command.yml			test-links	kind	Test-Links	Kind
test_links	repository_root	string	0	0	0	contracts/catzc/0.1.0/pwsh.base.quality_gates/test_links.command.yml			test-links	repository-root	Test-Links	RepositoryRoot
test_links	output_folder	string	0	0	0	contracts/catzc/0.1.0/pwsh.base.quality_gates/test_links.command.yml			test-links	output-folder	Test-Links	OutputFolder
test_links	pass_thru	switch	0	0	0	contracts/catzc/0.1.0/pwsh.base.quality_gates/test_links.command.yml			test-links	pass-thru	Test-Links	PassThru
test_logic_test_identity	path	string	1	0	0	contracts/catzc/0.1.0/pwsh.base.quality_gates/test_logic_test_identity.command.yml			test-logic-test-identity	path	Test-LogicTestIdentity	Path
test_logic_test_identity	output_folder	string	0	0	0	contracts/catzc/0.1.0/pwsh.base.quality_gates/test_logic_test_identity.command.yml			test-logic-test-identity	output-folder	Test-LogicTestIdentity	OutputFolder
test_logic_test_identity	pass_thru	switch	0	0	0	contracts/catzc/0.1.0/pwsh.base.quality_gates/test_logic_test_identity.command.yml			test-logic-test-identity	pass-thru	Test-LogicTestIdentity	PassThru
test_managed_guids	output_folder	string	0	0	0	contracts/catzc/0.1.0/pwsh.base.quality_gates/test_managed_guids.command.yml			test-managed-guids	output-folder	Test-ManagedGuids	OutputFolder
test_managed_guids	pass_thru	switch	0	0	0	contracts/catzc/0.1.0/pwsh.base.quality_gates/test_managed_guids.command.yml			test-managed-guids	pass-thru	Test-ManagedGuids	PassThru
test_markdown_title	path	string	1	0	0	contracts/catzc/0.1.0/pwsh.base.quality_gates/test_markdown_title.command.yml			test-markdown-title	path	Test-MarkdownTitle	Path
test_markdown_title	repository_root	string	0	0	0	contracts/catzc/0.1.0/pwsh.base.quality_gates/test_markdown_title.command.yml			test-markdown-title	repository-root	Test-MarkdownTitle	RepositoryRoot
test_markdown_title	output_folder	string	0	0	0	contracts/catzc/0.1.0/pwsh.base.quality_gates/test_markdown_title.command.yml			test-markdown-title	output-folder	Test-MarkdownTitle	OutputFolder
test_markdown_title	pass_thru	switch	0	0	0	contracts/catzc/0.1.0/pwsh.base.quality_gates/test_markdown_title.command.yml			test-markdown-title	pass-thru	Test-MarkdownTitle	PassThru
test_markdownlint	path	string	1	0	0	contracts/catzc/0.1.0/pwsh.base.quality_gates/test_markdownlint.command.yml			test-markdownlint	path	Test-Markdownlint	Path
test_markdownlint	output_folder	string	0	0	0	contracts/catzc/0.1.0/pwsh.base.quality_gates/test_markdownlint.command.yml			test-markdownlint	output-folder	Test-Markdownlint	OutputFolder
test_markdownlint	pass_thru	switch	0	0	0	contracts/catzc/0.1.0/pwsh.base.quality_gates/test_markdownlint.command.yml			test-markdownlint	pass-thru	Test-Markdownlint	PassThru
test_module_cycles	output_folder	string	0	0	0	contracts/catzc/0.1.0/pwsh.base.module_system/test_module_cycles.command.yml			test-module-cycles	output-folder	Test-ModuleCycles	OutputFolder
test_module_cycles	pass_thru	switch	0	0	0	contracts/catzc/0.1.0/pwsh.base.module_system/test_module_cycles.command.yml			test-module-cycles	pass-thru	Test-ModuleCycles	PassThru
test_module_dependency	output_folder	string	0	0	0	contracts/catzc/0.1.0/pwsh.base.module_system/test_module_dependency.command.yml			test-module-dependency	output-folder	Test-ModuleDependency	OutputFolder
test_module_dependency	pass_thru	switch	0	0	0	contracts/catzc/0.1.0/pwsh.base.module_system/test_module_dependency.command.yml			test-module-dependency	pass-thru	Test-ModuleDependency	PassThru
test_parameter_consistency	output_folder	string	0	0	0	contracts/catzc/0.1.0/pwsh.base.quality_gates/test_parameter_consistency.command.yml			test-parameter-consistency	output-folder	Test-ParameterConsistency	OutputFolder
test_parameter_consistency	pass_thru	switch	0	0	0	contracts/catzc/0.1.0/pwsh.base.quality_gates/test_parameter_consistency.command.yml			test-parameter-consistency	pass-thru	Test-ParameterConsistency	PassThru
test_pipelines	path	string	0	0	0	contracts/catzc/0.1.0/pwsh.azure.dev_ops/test_pipelines.command.yml			test-pipelines	path	Test-Pipelines	Path
test_pipelines	output_folder	string	0	0	0	contracts/catzc/0.1.0/pwsh.azure.dev_ops/test_pipelines.command.yml			test-pipelines	output-folder	Test-Pipelines	OutputFolder
test_pipelines	pass_thru	switch	0	0	0	contracts/catzc/0.1.0/pwsh.azure.dev_ops/test_pipelines.command.yml			test-pipelines	pass-thru	Test-Pipelines	PassThru
test_python_lint	output_folder	string	0	0	0	contracts/catzc/0.1.0/pwsh.base.quality_gates/test_python_lint.command.yml			test-python-lint	output-folder	Test-PythonLint	OutputFolder
test_python_lint	pass_thru	switch	0	0	0	contracts/catzc/0.1.0/pwsh.base.quality_gates/test_python_lint.command.yml			test-python-lint	pass-thru	Test-PythonLint	PassThru
test_python_types	output_folder	string	0	0	0	contracts/catzc/0.1.0/pwsh.base.quality_gates/test_python_types.command.yml			test-python-types	output-folder	Test-PythonTypes	OutputFolder
test_python_types	pass_thru	switch	0	0	0	contracts/catzc/0.1.0/pwsh.base.quality_gates/test_python_types.command.yml			test-python-types	pass-thru	Test-PythonTypes	PassThru
test_root_analyzer_settings	output_folder	string	0	0	0	contracts/catzc/0.1.0/pwsh.base.root_config/test_root_analyzer_settings.command.yml			test-root-analyzer-settings	output-folder	Test-RootAnalyzerSettings	OutputFolder
test_root_analyzer_settings	pass_thru	switch	0	0	0	contracts/catzc/0.1.0/pwsh.base.root_config/test_root_analyzer_settings.command.yml			test-root-analyzer-settings	pass-thru	Test-RootAnalyzerSettings	PassThru
test_root_config_files	output_folder	string	0	0	0	contracts/catzc/0.1.0/pwsh.base.root_config/test_root_config_files.command.yml			test-root-config-files	output-folder	Test-RootConfigFiles	OutputFolder
test_root_config_files	pass_thru	switch	0	0	0	contracts/catzc/0.1.0/pwsh.base.root_config/test_root_config_files.command.yml			test-root-config-files	pass-thru	Test-RootConfigFiles	PassThru
test_script_analyzer	path	string	1	0	0	contracts/catzc/0.1.0/pwsh.base.quality_gates/test_script_analyzer.command.yml			test-script-analyzer	path	Test-ScriptAnalyzer	Path
test_script_analyzer	output_folder	string	0	0	0	contracts/catzc/0.1.0/pwsh.base.quality_gates/test_script_analyzer.command.yml			test-script-analyzer	output-folder	Test-ScriptAnalyzer	OutputFolder
test_script_analyzer	no_cache	switch	0	0	0	contracts/catzc/0.1.0/pwsh.base.quality_gates/test_script_analyzer.command.yml			test-script-analyzer	no-cache	Test-ScriptAnalyzer	NoCache
test_script_analyzer	pass_thru	switch	0	0	0	contracts/catzc/0.1.0/pwsh.base.quality_gates/test_script_analyzer.command.yml			test-script-analyzer	pass-thru	Test-ScriptAnalyzer	PassThru
test_shell_scripts	shell_check_exclude	string	1	0	0	contracts/catzc/0.1.0/pwsh.base.quality_gates/test_shell_scripts.command.yml			test-shell-scripts	shell-check-exclude	Test-ShellScripts	ShellCheckExclude
test_shell_scripts	output_folder	string	0	0	0	contracts/catzc/0.1.0/pwsh.base.quality_gates/test_shell_scripts.command.yml			test-shell-scripts	output-folder	Test-ShellScripts	OutputFolder
test_shell_scripts	pass_thru	switch	0	0	0	contracts/catzc/0.1.0/pwsh.base.quality_gates/test_shell_scripts.command.yml			test-shell-scripts	pass-thru	Test-ShellScripts	PassThru
test_shipped_configs	output_folder	string	0	0	0	contracts/catzc/0.1.0/pwsh.base.quality_gates/test_shipped_configs.command.yml			test-shipped-configs	output-folder	Test-ShippedConfigs	OutputFolder
test_shipped_configs	pass_thru	switch	0	0	0	contracts/catzc/0.1.0/pwsh.base.quality_gates/test_shipped_configs.command.yml			test-shipped-configs	pass-thru	Test-ShippedConfigs	PassThru
test_shipped_types	output_folder	string	0	0	0	contracts/catzc/0.1.0/pwsh.base.types_system/test_shipped_types.command.yml			test-shipped-types	output-folder	Test-ShippedTypes	OutputFolder
test_shipped_types	pass_thru	switch	0	0	0	contracts/catzc/0.1.0/pwsh.base.types_system/test_shipped_types.command.yml			test-shipped-types	pass-thru	Test-ShippedTypes	PassThru
test_spelling	path	string	1	0	0	contracts/catzc/0.1.0/pwsh.base.quality_gates/test_spelling.command.yml			test-spelling	path	Test-Spelling	Path
test_spelling	exclude	string	1	0	0	contracts/catzc/0.1.0/pwsh.base.quality_gates/test_spelling.command.yml			test-spelling	exclude	Test-Spelling	Exclude
test_spelling	output_folder	string	0	0	0	contracts/catzc/0.1.0/pwsh.base.quality_gates/test_spelling.command.yml			test-spelling	output-folder	Test-Spelling	OutputFolder
test_spelling	pass_thru	switch	0	0	0	contracts/catzc/0.1.0/pwsh.base.quality_gates/test_spelling.command.yml			test-spelling	pass-thru	Test-Spelling	PassThru
test_terminology	output_folder	string	0	0	0	contracts/catzc/0.1.0/pwsh.base.quality_gates/test_terminology.command.yml			test-terminology	output-folder	Test-Terminology	OutputFolder
test_terminology	pass_thru	switch	0	0	0	contracts/catzc/0.1.0/pwsh.base.quality_gates/test_terminology.command.yml			test-terminology	pass-thru	Test-Terminology	PassThru
test_value_chain_map	output_folder	string	0	0	0	contracts/catzc/0.1.0/pwsh.base.maps/test_value_chain_map.command.yml			test-value-chain-map	output-folder	Test-ValueChainMap	OutputFolder
test_value_chain_map	pass_thru	switch	0	0	0	contracts/catzc/0.1.0/pwsh.base.maps/test_value_chain_map.command.yml			test-value-chain-map	pass-thru	Test-ValueChainMap	PassThru
test_world_map	output_folder	string	0	0	0	contracts/catzc/0.1.0/pwsh.base.maps/test_world_map.command.yml			test-world-map	output-folder	Test-WorldMap	OutputFolder
test_world_map	pass_thru	switch	0	0	0	contracts/catzc/0.1.0/pwsh.base.maps/test_world_map.command.yml			test-world-map	pass-thru	Test-WorldMap	PassThru
uninstall_az_cli	remove	switch	0	0	0	contracts/catzc/0.1.0/pwsh.tooling.toolchain/uninstall_az_cli.command.yml			uninstall-az-cli	remove	Uninstall-AzCli	Remove
uninstall_az_cli	force	switch	0	0	0	contracts/catzc/0.1.0/pwsh.tooling.toolchain/uninstall_az_cli.command.yml			uninstall-az-cli	force	Uninstall-AzCli	Force
uninstall_bicep	version	string	0	0	0	contracts/catzc/0.1.0/pwsh.tooling.toolchain/uninstall_bicep.command.yml			uninstall-bicep	version	Uninstall-Bicep	Version
uninstall_chocolatey			0	0	0	contracts/catzc/0.1.0/pwsh.tooling.provisioning/uninstall_chocolatey.command.yml			uninstall-chocolatey		Uninstall-Chocolatey	
uninstall_cspell			0	0	0	contracts/catzc/0.1.0/pwsh.tooling.node/uninstall_cspell.command.yml			uninstall-cspell		Uninstall-Cspell	
uninstall_dev_box_tools			0	0	0	contracts/catzc/0.1.0/pwsh.tooling.provisioning/uninstall_dev_box_tools.command.yml			uninstall-dev-box-tools		Uninstall-DevBoxTools	
uninstall_dotnet	remove	switch	0	0	0	contracts/catzc/0.1.0/pwsh.tooling.toolchain/uninstall_dotnet.command.yml			uninstall-dotnet	remove	Uninstall-Dotnet	Remove
uninstall_dotnet	force	switch	0	0	0	contracts/catzc/0.1.0/pwsh.tooling.toolchain/uninstall_dotnet.command.yml			uninstall-dotnet	force	Uninstall-Dotnet	Force
uninstall_git			0	0	0	contracts/catzc/0.1.0/pwsh.tooling.provisioning/uninstall_git.command.yml			uninstall-git		Uninstall-Git	
uninstall_go	remove	switch	0	0	0	contracts/catzc/0.1.0/pwsh.tooling.toolchain/uninstall_go.command.yml			uninstall-go	remove	Uninstall-Go	Remove
uninstall_go	force	switch	0	0	0	contracts/catzc/0.1.0/pwsh.tooling.toolchain/uninstall_go.command.yml			uninstall-go	force	Uninstall-Go	Force
uninstall_java	version	string	0	0	0	contracts/catzc/0.1.0/pwsh.tooling.toolchain/uninstall_java.command.yml			uninstall-java	version	Uninstall-Java	Version
uninstall_java	remove	switch	0	0	0	contracts/catzc/0.1.0/pwsh.tooling.toolchain/uninstall_java.command.yml			uninstall-java	remove	Uninstall-Java	Remove
uninstall_java	force	switch	0	0	0	contracts/catzc/0.1.0/pwsh.tooling.toolchain/uninstall_java.command.yml			uninstall-java	force	Uninstall-Java	Force
uninstall_markdownlint			0	0	0	contracts/catzc/0.1.0/pwsh.tooling.node/uninstall_markdownlint.command.yml			uninstall-markdownlint		Uninstall-Markdownlint	
uninstall_node_js	version	string	0	0	0	contracts/catzc/0.1.0/pwsh.tooling.node/uninstall_node_js.command.yml			uninstall-node-js	version	Uninstall-NodeJs	Version
uninstall_node_js	remove	switch	0	0	0	contracts/catzc/0.1.0/pwsh.tooling.node/uninstall_node_js.command.yml			uninstall-node-js	remove	Uninstall-NodeJs	Remove
uninstall_node_js	force	switch	0	0	0	contracts/catzc/0.1.0/pwsh.tooling.node/uninstall_node_js.command.yml			uninstall-node-js	force	Uninstall-NodeJs	Force
uninstall_poetry			0	0	0	contracts/catzc/0.1.0/pwsh.tooling.python/uninstall_poetry.command.yml			uninstall-poetry		Uninstall-Poetry	
uninstall_postman			0	0	0	contracts/catzc/0.1.0/pwsh.tooling.provisioning/uninstall_postman.command.yml			uninstall-postman		Uninstall-Postman	
uninstall_prettier			0	0	0	contracts/catzc/0.1.0/pwsh.tooling.node/uninstall_prettier.command.yml			uninstall-prettier		Uninstall-Prettier	
uninstall_py_spark			0	0	0	contracts/catzc/0.1.0/pwsh.tooling.python/uninstall_py_spark.command.yml			uninstall-py-spark		Uninstall-PySpark	
uninstall_python	version	string	0	0	0	contracts/catzc/0.1.0/pwsh.tooling.python/uninstall_python.command.yml			uninstall-python	version	Uninstall-Python	Version
uninstall_shellcheck	version	string	0	0	0	contracts/catzc/0.1.0/pwsh.tooling.toolchain/uninstall_shellcheck.command.yml			uninstall-shellcheck	version	Uninstall-Shellcheck	Version
uninstall_terraform	version	string	0	0	0	contracts/catzc/0.1.0/pwsh.tooling.toolchain/uninstall_terraform.command.yml			uninstall-terraform	version	Uninstall-Terraform	Version
uninstall_uv	version	string	0	0	0	contracts/catzc/0.1.0/pwsh.tooling.toolchain/uninstall_uv.command.yml			uninstall-uv	version	Uninstall-Uv	Version
uninstall_zsh			0	0	0	contracts/catzc/0.1.0/pwsh.tooling.provisioning/uninstall_zsh.command.yml			uninstall-zsh		Uninstall-Zsh	
'
