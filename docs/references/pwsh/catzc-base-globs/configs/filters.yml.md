# pwsh/Catzc.Base.Globs/configs/filters.yml

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its
comment sat above (Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `filters:`, written with `#`.

```text
The repository's filters: named views over the hard model, in lamp order. A filter is the union of its selectors and may claim files
another filter claims; the view is the union of the lit lamps (DDR-FILTER-TOTALUNION), and every file on disk is claimed by one at least.
Selectors: aspect.<aspect>, track.<track>, track_type.<type> (snake form of the type), glob.<pattern>, generated, root_config.
```
