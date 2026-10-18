# .claude/slides/slides.yml

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its
comment sat above (Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `token:`, written with `#`.

```text
The slides kit's sensible defaults, declared once ([ADR-REPO-SLIDES#2](/docs/adr/repository/slides-as-markdown.md#rule-adr-repo-slides2));
a pattern reads them as {{@token.*}}, {{@face.*}}, {{@scale.*}}
and {{@layout.*}} placeholders, and a slide file never repeats them. Two-level mapping only: a section, then key: value.
```
