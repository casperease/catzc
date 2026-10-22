# pwsh/Catzc.Tooling.Listen/Complete-DocNote.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Records that the processor has processed one note: one line in the session's ledger, processed.md.

### description

The ledger is the processor's own file, as the notes are the listener's: one writer per file, so neither waits on the other. A line reads
`- <id> | fact-check: <verdict> | because: <reason> | pattern: <name> | plan: <plan file>`; a note is completed once, and a note the session
does not hold is refused.

A fact-check never stands alone: the verdict is always written with the reason that supports it (what in the reference holds or breaks, with
its path:line), so a reader of the ledger can check the verdict without running the fact-checker again. A reason that only repeats the
verdict is refused, and so is a value holding a `|` or a line break, which the ledger line cannot carry.

### parameter `Session`

The session folder. Default: the newest session.

### parameter `Id`

The note's four-digit id.

### parameter `FactCheck`

The fact-checker's verdict on the repository against the note: holds, partly, or does not hold.

### parameter `FactCheckReason`

Why the verdict is what it is: the fact-checker's reasoning, with the path:line it rests on. Required with every verdict, and more than the
verdict itself.

### parameter `Pattern`

The pattern the note was folded into.

### parameter `Plan`

The plan file the pattern lives in, or 'none' when the note restated existing truth.
