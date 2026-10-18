# automation/Catzc.Tooling.Core/Get-ToolVersion.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Runs a tool's version command and extracts the installed version string.

### description

Executes the version_command from tools.yml, matches against version_pattern, and returns the captured version string. Returns $null if the
command fails or the pattern does not match. Uses .Full (stdout + stderr merged) to catch tools like java that write version info to stderr.

### parameter Config

The tool configuration hashtable from Get-ToolConfig.

### example 1

```powershell
$config = Get-ToolConfig -Tool 'python'
$version = Get-ToolVersion -Config $config
# Returns '3.11.9' or $null
```
