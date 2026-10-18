# automation/Catzc.Base.QualityGates/private/Get-RelativeEdgesFileMetaFact.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its
comment sat above (Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

The relative-edges meta kind's fact: the few files a file points at, one edge per fixed name, each only when it exists.

### description

The kind's `relations` setting lists at most eight relations, each a name and rules, and the name is one of the kind's keys; a rule
applies to the files whose class its `classes` names (to every file when it names none) and names candidate `paths`, and the
first candidate that exists on disk becomes the edge's value. A path takes the tokens `{module}` (the module the
path is placed in, as Get-PathModule reads it), `{name}` (the file name without its last extension), `{stem}`
(the name without a trailing `.Tests`) and `{page}` (the file's comment page from comments.yml). An edge no
rule fills is empty, so it is left out of the block and a file with no relatives carries none.

It rests on [ADR-PRIN-CONFIG#1](../../../../adr/principles/configure-not-program.md#rule-adr-prin-config1) and [ADR-REPO-FILEMETA#10](../../../../adr/repository/file-meta.md#rule-adr-repo-filemeta10).

### parameter State

What the file's carrier reader returned.

### parameter Path

The file's repository-relative path.

### parameter Kind

The registry entry that subscribed this function.

### outputs

`[System.Collections.Specialized.OrderedDictionary]` one entry per key of the kind, the path of the relative or an empty string.
