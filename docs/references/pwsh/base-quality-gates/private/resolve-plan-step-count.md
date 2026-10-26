# pwsh/Base.QualityGates/private/Resolve-PlanStepCount.ps1

Reads the step count a text states ("three steps", "one step left"), or writes the phrase for a count. It is the one vocabulary of a stated
step count, shared by the check and the rewrite.

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
