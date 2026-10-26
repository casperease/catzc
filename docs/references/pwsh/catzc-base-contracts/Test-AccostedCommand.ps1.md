# pwsh/Base.Contracts/Test-AccostedCommand.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Lists the faults of one accosted-form call against its command contract, through the one contract reader.

### description

The call is a one-key map of a command name to its arguments, the form an accosted file holds. The command must be a contracted command,
every argument must name a parameter of its contract and fit the parameter's type (Assert-AccostedArgument), and every mandatory parameter
outside a parameter set must be given. Whether the command is harmless is not asked, so a mutating command passes: that is the difference
from Get-AccostedFile, which holds a call to the harmless verbs.

### parameter `Call`

The call as yaml or json text, for example `{"get_widget": {"path": "widgets/a.wdg"}}`.

### parameter `Where`

Where the call is written, for the text of each finding.

### parameter `RepositoryRoot`

The root the command contracts resolve against. Default: the repository root.

### outputs

`[string[]]` One finding per fault; nothing when the call fits its contract.

### example 1

```powershell
Test-AccostedCommand -Call '{"get_widget": {"path": "widgets/a.wdg"}}' -Where 'widget-act: action.call'
```

## comment:1

Above `foreach ($argument in $command.arguments.Keys) {`, written with `#`.

```text
Each fault is one finding: the check is what Assert-AccostedArgument already is, caught so a gate can list them
all.
```
