# pwsh/Catzc.Base.Maps/configs/maps.yml

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `{}`, written with `#`.

```text
maps.yml — the map settings: the palette, the limits, the printed labels of the world map and the value-chain map,
the reviewed highlight pins and exceptions, and the folder under the output root the PDFs are written to
([ADR-REPO-OUTDIR#2](/docs/adr/repository/dedicated-output-directory.md#rule-adr-repo-outdir2)). Every key has a
sensible default, declared once on Catzc.Base.Maps.MapsConfig and the section types it holds
([ADR-AUTO-DEFAULT#6](/docs/adr/automation/sensible-defaults.md#rule-adr-auto-default6)); set a key only to change
it. Loaded via Get-Config -Config maps.

  palette:                        # colours, each '#' and six hex digits
    background: '#1E2430'         #   the whole page, drawn first (the diagram kit's dark page; reads in any viewer)
    row: '#262E3B'                #   a track's row header
    column: '#262E3B'             #   a file language's column header
    cell: '#262E3B'               #   an empty cell, the idle end of the file-count scale
    shade: '#DDE2E9'              #   the fullest cell, the top of the file-count scale (the kit's title ink; a lit outline stays distinct)
    line: '#3A4555'               #   the grid lines
    text: '#CDD3DC'               #   titles, headers and counts
    violation: '#E57373'          #   the mark of a cell that breaks its track's tech-stack (the kit's only red)
    highlight: '#E6EAF0'          #   the outline of a lit cell; the slide minimaps fill a lit cell with it
  limits:                         # each a positive number
    page_width: 842               #   PDF points (A4 landscape)
    page_height: 595
    min_font_size: 6              #   the smallest a label may shrink to
    max_row_label: 24             #   characters a track name prints (whole number)
    max_column_label: 16          #   characters a file-language name prints (whole number)
  labels:                         # WinAnsi text only: the base-14 PDF fonts show nothing else; each names a defined
                                  #   term in its head, the text before its first ':'
                                  #   ([ADR-DSGN-TRACK#13](/docs/adr/design/tracks.md#rule-adr-dsgn-track13))
    grid_title: 'World map: tracks × file languages'
    tree_title: 'World map: repository tree'
    row_axis: Track               #   at most max_row_label characters
    column_axis: File language    #   at most max_column_label characters
    root_files: Root files        #   the row of the root files; at most max_row_label
                                  #   ([ADR-DSGN-TRACK#7](/docs/adr/design/tracks.md#rule-adr-dsgn-track7))
    unlisted_files: Unlisted files #  the column of the unlisted files; at most max_column_label
                                  #   ([ADR-DSGN-TRACK#8](/docs/adr/design/tracks.md#rule-adr-dsgn-track8))
    legend_files: 'Cell: files'
    legend_violation: Stack violation
    legend_highlight: Lit cell
    # the value-chain map's labels, checked by Test-ValueChainMap; no length limit
    #   ([ADR-DSGN-TRACK#16](/docs/adr/design/tracks.md#rule-adr-dsgn-track16))
    value_chain_title: 'Value-chain map: value-chain stack × value-chain concerns'
    value_chain_row_axis: Value-chain stack
    value_chain_column_axis: Value-chain concern
    value_chain_legend_adrs: 'Cell: ADRs'
    value_chain_legend_highlight: Lit cell
  highlight:                     # reviewed overrides of the derived highlight
    pins: []                      #   cells an ADR always lights
    exceptions: []                #   cells an ADR never lights (a passing mention)
      # each: { adr: <ADR code, optionally #n>, track: <track>, file_language: <file language>, reason: <why> }
    citation_exclude:             #   globs of files whose citations light nothing; each still sits in its cell
      - docs/.assets/**           #   the generated slide descriptions, so a minimap never lights its own description
      - docs/explanation/**       #   the explanation articles the slides illustrate
      - .claude/drawio/**         #   the drawing tooling
  output_folder: world-map        # one folder name under the output root
```
