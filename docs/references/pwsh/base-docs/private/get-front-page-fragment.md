# pwsh/Base.Docs/private/Get-FrontPageFragment.ps1

Reads a `fragment` section's article for the front page: its level-one title becomes the section heading, and its body moves under it.

## help

### synopsis

Returns an article's title and its body, headings moved down one level and links rebased to the front page.

### description

Strips the front matter, takes the level-one title the article must open with, moves every heading of the body down one level outside fences
(the page owns the one `#` title), and rebases the body's links from the article to the page's folder. An article that does not open with
its title throws.

### parameter `Source`

The article, relative to the repository root.

### parameter `Folder`

The front page's folder, relative to the repository root, that the links are rebased to.

### outputs

`[pscustomobject]` @{ Title; Body }.
