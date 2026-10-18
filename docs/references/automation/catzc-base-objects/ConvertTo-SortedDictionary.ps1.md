# automation/Catzc.Base.Objects/ConvertTo-SortedDictionary.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Recursively converts dictionaries to ordered form for stable output.

### description

OrderedDictionaries keep their original key order. Plain Hashtables get their keys sorted alphabetically. Nested dictionaries are processed
recursively.

### parameter Dictionary

The dictionary to process.
