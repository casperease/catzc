# ADR: Function help — the help of a PowerShell file is the help section of its comment page

## Rules: ADR-REPO-HELP

### Rule ADR-REPO-HELP-HELPONCOMMENTPAGE

The help of a PowerShell function file or script is the `## help` section of the file's comment page
([ADR-REPO-COMMENTS-COMMENTPAGEPLACE](comments-in-docs.md#rule-adr-repo-comments-commentpageplace)), the page the `comment-pages` config
names for the file's path. The file itself carries no help: no comment-based help block (no `.SYNOPSIS`, `.DESCRIPTION`, `.PARAMETER`,
`.INPUTS`, `.OUTPUTS`, `.EXAMPLE` or `.NOTES` section anywhere) and no help in a head. The section comes first after the page's opening line
and holds, in this order, `### synopsis`, `### description`, one ``### parameter `<Name>` `` for each parameter, its name written as code,
`### inputs`, `### outputs`, one `### example <n>` for each example, and `### notes`. Every subsection but the synopsis is present only when
it has text.

- [The page holds the help](#the-page-holds-the-help)

### Rule ADR-REPO-HELP-MARKDOWNASWRITTEN

The text of a subsection is Markdown, kept as the author wrote it. The synopsis is one line. The parameter subsections follow the order of
the `param` block, and an example is one fenced `powershell` block. The tooling reads the section and never writes prose into it, and
`Export-Comments`, which appends the page's `## comment:<n>` sections, never writes, moves or reorders it.

- [Text as written](#text-as-written)

### Rule ADR-REPO-HELP-CITATIONINSENTENCE

A citation may stand inside a help sentence, where it names the rule the sentence rests on. The ADR codes a function rests on are derived
from the file and its page ([ADR-REPO-FILEMETA-NOREADBACK](file-meta.md#rule-adr-repo-filemeta-noreadback)), so the help never lists them. A
line of the text made of nothing but a citation is reported.

- [Citations are derived](#citations-are-derived)

### Rule ADR-REPO-HELP-FIVEFAULTSREPORTED

Five faults are reported and never rewritten: a file with no page or a page with no synopsis, a subsection the shape does not name or one
out of order, a parameter with no subsection, a subsection for a name the function does not declare, and an `outputs` text whose first type
differs from `[OutputType]`.

- [Mismatches are reported](#mismatches-are-reported)

### Rule ADR-REPO-HELP-IMPRINTSTEP

`Format-Code` checks rules 1 to 4 as an imprint step of the PowerShell language
([ADR-REPO-FORMAT-CONFIGUREDFORMATTERS](uniform-formatting.md#rule-adr-repo-format-configuredformatters)), and `Test-Formatting` fails a
file the step reports. No command and no check names the step. The step reads the file with the language's own parser, so a comment inside a
string or a here-string is never mistaken for help, and reads the page with the Markdown parser.

- [Hosted by Format-Code](#hosted-by-format-code)

## Context

A function's help is prose an author writes: a synopsis, a description, a sentence per parameter, examples. A comment block in the file is
text a tool finds only by its position in a comment, the one part of a file no parser owns, and a head is the picture of a file's derived
facts, which no command reads back ([file-meta](file-meta.md)). A code file already has one place for its prose that outgrew a line, its
comment page ([comments-in-docs](comments-in-docs.md)), found from the file's path alone and read by a Markdown parser.

## Decision

The help is one section of the comment page, with one shape, and a check reads it by its headings.

### The page holds the help

`One place for the prose a file has`

The synopsis, the description, the parameters, the outputs and the examples are subsections of the page's `## help`, so a reader who opens
the page finds the function's help and its long comments together, and a tool finds the page from the path without reading the code. An
authored code file carries no head, so the help cannot live in one, and a comment block would be a second place a person keeps in step with
the page. `Get-Help` is not the way to read a catzc function.

### Text as written

`The author's Markdown, in a fixed order`

A subsection is ordinary Markdown, so a description with a list or a table stays as it was written and renders where the page renders. The
fixed headings and their order are the shape a check reads, and they keep the page's own sections apart: the exporter owns the
`## comment:<n>` sections and only appends them, and the help section is the author's.

### Citations are derived

`The tooling already finds them`

The citations a function rests on are found from the file and its page every time they are needed, so a second copy in the help would drift
from them.

### Mismatches are reported

`A check, never a guess`

A missing subsection, a subsection for a name that is gone and a type that disagrees with `[OutputType]` each need a sentence only an author
can write, so they are findings. A file with no page has no help at all, which is the same kind of fault: the finding names the file and the
page it expects, so the whole run never stops on one file.

### Hosted by Format-Code

`A configured step, not a new command`

The step is one line in the file-language registry, as the namespace step is ([code-file-meta](code-file-meta.md)). It runs after the
formatter.

### How this is enforced

- **`Format-Code`** checks the help through the `ps-help` step, and **`Test-Formatting`** fails any file it reports.
- **`Test-Comments`** fails a page whose `## comment:<n>` sections no longer match the file, and leaves the help section alone.
- **`PSProvideCommentHelp`** is off in the analyzer settings, because no function carries a comment-based help block.

## Consequences

- A function's help is read where its long comments are, as Markdown, and a diff of it shows only the text that changed.
- A parameter is described once, and a difference between the declaration and the description is a finding.
- A code file holds only code and one-line comments.
- `Get-Help` shows no catzc help, so the help is read from the comment page.
