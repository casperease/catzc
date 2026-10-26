# pwsh/Base.Languages/tests/Invoke-JavaScriptTest.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its
comment sat above (Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `$script:own = Join-Path $script:root 'js/catzc-widget/tests'`, written with `#`.

```text
A js module is its kebab folder with its own tests/; a module without one is looked for under the root's test
holder.
```
