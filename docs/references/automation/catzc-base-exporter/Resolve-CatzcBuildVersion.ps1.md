# docs/references/automation/catzc-base-exporter/Resolve-CatzcBuildVersion.ps1.md

`automation/Catzc.Base.Exporter/Resolve-CatzcBuildVersion.ps1`

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
The one place a build version is decided
([ADR-AUTO-BUNDLE#7](/docs/adr/automation/platform-bundle.md#rule-adr-auto-bundle7)); every value comes from
configs/exporter.yml
(Get-Config -Config exporter):

  -Version auto, on a devbox    the fixed direct_install_version placeholder (6.6.666), announced by a yellow
                                Write-Message notice — never Write-Warning, which terminates under the catzc
                                session's preferences
                                ([ADR-PWSH-ERROR#2](/docs/adr/pwsh/error-handling.md#rule-adr-pwsh-error2)). A rebuild overwrites it in place.
  -Version auto, in a pipeline  <the bundle's MAJOR.MINOR (exporter.yml bundles.<name>.version)>.<first-parent
                                commit count of HEAD>, so the same commit always gets the same version and
                                versions rise along main. Each bundle has its own MAJOR.MINOR line. Needs the full
                                history; a shallow clone throws instead of miscounting.
  -Version <x.y.z>              honoured as given once asserted numeric MAJOR.MINOR.PATCH (a valid module
                                version); a pipeline build naming the placeholder throws — it never leaves a
                                devbox.
```

## comment:2

Section `.PARAMETER Bundle` of the comment-based help.

```text
The bundle whose version line a pipeline build follows (an exporter.yml bundles key). Defaults to
default_bundle.
```
