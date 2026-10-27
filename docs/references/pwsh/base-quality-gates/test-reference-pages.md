# pwsh/Base.QualityGates/Test-ReferencePages.ps1

The quality gate for reference pages: it fails on a page two sources render to, on a page under a pages folder that maps back to no source
and is no listed article, and on an article that is also a derived page.

## help

### synopsis

Checks that every reference page maps back to exactly one source file, or is an article that comment-pages.yml lists.

### description

Indexes the derived pages of the tracked files through comment-pages.yml, then reports each page of more than one source, each in-scope page
with no source that is not listed under articles, and each listed article that is a source's derived page. A quality gate: it ends through
Write-QualityGateReport, which writes out/reference-pages/, prints every issue, and throws once listing them all. It needs the source tree:
it throws in build mode.

### parameter `OutputFolder`

The report base folder. Defaults to `<out>/reference-pages`.

### parameter `PassThru`

Return a result object instead of throwing.

### outputs

Throws on any violation; with -PassThru, returns the `[Catzc.Base.Reports.QualityGateResult]`.

### example 1

```powershell
Test-ReferencePages
```
