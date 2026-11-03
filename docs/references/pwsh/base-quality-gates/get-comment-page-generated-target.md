# pwsh/Base.QualityGates/Get-CommentPageGeneratedTarget.ps1

The generated-target expander of the comment-page writer, which answers no target because a comment page is authored.

## help

### synopsis

Returns no generated target for the comment-page writer.

### description

Every generated-target expander takes the writer row's name and class. A comment page is authored, so the writer that moves comments onto it
leaves no generated target, and this expander returns nothing for any name and class.

### parameter `Name`

The writer row's name, which this expander does not use.

### parameter `Class`

The writer row's class, which this expander does not use.

### example 1

```powershell
Get-CommentPageGeneratedTarget -Name Export-Comments -Class docs
```

## comment:1

Above `}`, written with `#`.

```text
A comment page is authored
([ADR-REPO-COMMENTS-PAGEISAUTHORED](/docs/drs/repository/comments-in-docs.md#rule-adr-repo-comments-pageisauthored)), so the writer that moves comments onto it leaves no generated target.
```
