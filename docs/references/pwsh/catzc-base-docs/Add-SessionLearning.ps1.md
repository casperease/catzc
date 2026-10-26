# pwsh/Base.Docs/Add-SessionLearning.ps1

The one writer of the rolling logs: it appends dated one-line sentences to the newest file of a log's folder and starts a new file when the
newest is full, so a log stays a few markdown files of bounded length. Each log is a `LearningsConfig` instance, see
[LearningsConfig](types/LearningsConfig.cs.md).

## Line shape

A line is wrapped the way the markdown formatter wraps a list item (prettier, 140 columns), so formatting never rewrites the log. A `<`
outside a code span would read as inline HTML to the lint (MD033), so it is escaped there.

## File order

The files are ordered by each file's `Started <time>.` line, never by its name or its file time, so the order survives a clone.

## help

### synopsis

Appends dated sentences to a rolling log: a few markdown files of bounded length, first in first out; the learnings log by default.

### description

A learning is a forward memory for the next agents that work the same material: it completes "In hindsight I wish I knew this fact: …", and
states what is true of the repository now, never the story of the session that found it. The session-finalize skill calls this with the
lines of its "What I learned" section. Each sentence becomes one line, `- <yyyy-MM-dd>: <sentence>`, appended to the newest file in the
log's folder; a file that holds lines_per_file lines is full, so the next line starts a new file, `<prefix><sha>.md`, `<sha>` the first six
hex of a SHA-256 of the folder and its start time, headed `# <title> <sha>` and then `Started <time>.`, the start time the files are ordered
by. A long line is wrapped at 140 columns as the markdown formatter wraps a list item (Format-MarkdownParagraph), so the log passes the
markdown lint as written; a line is counted by the line that starts it. When a new file would make more than `files` files, the oldest is
deleted: git keeps it once committed. Lines are never edited and a repeat across calls is kept, since a line that recurs shows what keeps
mattering; only a sentence given twice in one call (a relayed batch) is written once, and each skip is reported with a warning. Every log is
one LearningsConfig instance, registered in configs.yml under its own name: the learnings log (`learned<sha>.md`, "Session learnings") and
the hindsight log the 2020-hindsight robot keeps (`hindsight<sha>.md`, "Hindsight", in .claude/hindsight). The defaults (5 files of 50
lines) are declared once on LearningsConfig.

### parameter `Learning`

The sentences, one line each; a sentence holds no line break.

### parameter `Log`

The config name of the log to append to, a LearningsConfig in configs.yml. Default: learnings.

### parameter `Author`

The person name of the robot writing the lines, its persona in agents.yml (Jack, Susan from HR); the line then reads
`- <yyyy-MM-dd> <Author>: <sentence>`, so a log says who wrote what. Default: none, the line carries the date only.

### parameter `Date`

The date written on each line. Default: today.

### outputs

`[string]` each file written to, in order.

### example 1

```powershell
Add-SessionLearning 'Get-Widget reads its defaults from the WidgetConfig type, not from widget.yml.'
```

### example 2

```powershell
Add-SessionLearning -Log hindsight -Author Jack 'If only Get-Widget had a default declared once: none in the tree.'
```
