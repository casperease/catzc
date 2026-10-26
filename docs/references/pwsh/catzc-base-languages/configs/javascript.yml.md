# pwsh/Base.Languages/configs/javascript.yml

The JavaScript settings of the js track.

## Keys

- **`root`** — the JavaScript root. It is the js track when the repository has `js/`, else `.js`; declare `root:` only to move it.
- **`strict`** — the modules the types gate checks strictly, one line per module as each is raised with its JSDoc. `New-JsConfig` renders
  them into `jsconfig.json`, and the modules still off the list into `jsconfig.lenient.json`.
