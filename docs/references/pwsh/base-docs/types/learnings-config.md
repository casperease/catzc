# pwsh/Base.Docs/types/LearningsConfig.cs

A rolling log of dated lines: a few markdown files of bounded length, first in first out (`Add-SessionLearning`). One instance per log. The
learnings log is the default, and another log (hindsight) differs only in its folder, prefix and title; every other key takes the default
declared once here.

## Keys

- **`folder`** — the repository-relative folder the log's files live in.
- **`prefix`** — the file-name prefix: a file is `<prefix><sha>.md`, lowercase letters only.
- **`title`** — the words a file's heading opens with, `# <title> <sha>`.
- **`files`** — how many files are kept; the oldest is dropped when a new one would exceed it.
- **`lines_per_file`** — how many lines one file holds before the next file starts.
