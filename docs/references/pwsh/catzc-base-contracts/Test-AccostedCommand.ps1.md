# pwsh/Base.Contracts/Test-AccostedCommand.ps1

The finding-lister for one accosted-form call: it lists every way the call breaks its command contract and does not throw. It lets a gate
show all the faults of a call at once.

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

## findings

Each fault is one finding. The argument check is the one Assert-AccostedArgument already makes; its throw is caught here, so a gate can
list every fault instead of stopping at the first.
