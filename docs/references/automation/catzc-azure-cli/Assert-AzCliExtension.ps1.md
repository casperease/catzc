# docs/references/automation/catzc-azure-cli/Assert-AzCliExtension.ps1.md

`automation/Catzc.Azure.Cli/Assert-AzCliExtension.ps1`

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
Throws a remediation-bearing error when the named extension is missing, so a command that depends on
it fails fast with a clear message instead of a cryptic argument error (az exit code 2) or — with
dynamic install disabled in Invoke-AzCli — a hang on the install prompt. Asserts only; it never
installs the extension, mirroring how Assert-AzCliConnected asserts rather than logging in.

Guard an extension-dependent call by asserting immediately before it:

    Assert-AzCliExtension 'ip-group'
    Invoke-AzCli "network ip-group list --resource-group $rg -o json" -PassThru
```
