# python/diagrams/assets/slides/slides.yml

The slides kit's sensible defaults, declared once: the colour tokens, the type faces and the type scale and layout sizes that every slide
pattern draws from.

## How a pattern reads it

A pattern reads the values as `{{@token.*}}`, `{{@face.*}}`, `{{@scale.*}}` and `{{@layout.*}}` placeholders, and a slide file never repeats
them ([ADR-REPO-SLIDES-PATTERN](../../../../../drs/repository/slides-as-markdown.md#rule-adr-repo-slides-pattern)). A change here restyles
every slide at the next render.

## Shape

The file is a two-level mapping only: a section, then `key: value`. Its sections are `token` (the dark theme), `token-light` (the light
theme), `face`, `scale`, `layout`, `render`, `fact` and `strip`; the last two hold the sizes that `slide_png.py` uses for the fact picture and the
ladder strip.
