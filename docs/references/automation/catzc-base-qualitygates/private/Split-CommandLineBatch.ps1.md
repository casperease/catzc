# automation/Catzc.Base.QualityGates/private/Split-CommandLineBatch.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its
comment sat above (Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Splits a list of command-line arguments into batches whose joined length stays under a limit.

### description

A formatter engine that takes files as arguments runs once per batch, so formatting every tracked file never
exceeds the command-line length. The binding limit is cmd.exe's 8 191 characters: npm installs tools such as
prettier as .cmd shims, which cmd.exe expands with the node path prepended, so the default leaves room for that.
Each item is counted with the quotes and the separating space it is written with. An item longer than the limit
is a batch of its own.

### parameter Item

The arguments, in order.

### parameter MaxLength

The longest joined batch, in characters.

### outputs

`[string[]]` One array per batch, in order.
