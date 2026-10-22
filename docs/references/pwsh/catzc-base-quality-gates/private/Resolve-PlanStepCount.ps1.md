# pwsh/Catzc.Base.QualityGates/private/Resolve-PlanStepCount.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Reads the step count a text states ("three steps", "one step left"), or writes the phrase for a count.

### description

The one vocabulary of a stated step count, for the check and the rewrite alike: a count is written in words from one to twelve and in digits
otherwise, with "step" in the singular for one. Reading finds the first phrase, case-insensitive, in a word or in digits.

### parameter `Text`

The text to read, such as a chunk line or a value row's last cell.

### parameter `Count`

The count to write the phrase for.

### outputs

`[pscustomobject]` with Index, Length and Count of the first phrase, or nothing when the text states none; with -Count, the phrase as a
string.
