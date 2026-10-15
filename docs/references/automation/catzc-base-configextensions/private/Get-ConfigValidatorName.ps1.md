# docs/references/automation/catzc-base-configextensions/private/Get-ConfigValidatorName.ps1.md

`automation/Catzc.Base.ConfigExtensions/private/Get-ConfigValidatorName.ps1`

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
The one place the validator naming convention lives: each kebab-case segment of the config name is
title-cased (invariant culture) and joined, so 'widget' becomes Assert-WidgetConfig and 'widget-parts'
becomes Assert-WidgetPartsConfig.
```
