# pwsh/Tooling.Listen/private/Get-ListenTier.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Names a repository-relative path's file kind (Get-FileKind) and the listen tier that kind sits in.

### description

The kind is the role Get-FileKind matches, or none for a path no kind matches; listen.yml's TierOf places the kind, and a kind no tier names
falls in its rest tier.

### parameter `Path`

The repository-relative path.

### outputs

`[pscustomobject]` with Kind and Tier.
