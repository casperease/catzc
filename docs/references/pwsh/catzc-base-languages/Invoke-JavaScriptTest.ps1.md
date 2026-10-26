# pwsh/Catzc.Base.Languages/Invoke-JavaScriptTest.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its
comment sat above (Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `$relative = if ($Folder) {`, written with `#`.

```text
The test folder: the one named, else the module's own tests/ (a js module is its kebab folder, js/<module>/tests), else the module's
folder under the root's test holder.
```
