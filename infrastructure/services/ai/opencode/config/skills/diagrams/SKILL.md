---
name: Diagrams
description: Timing diagrams, register maps, frame layouts, PlantUML, Graphviz or D2 diagrams, rendered to SVG or PNG with Kroki. For Mermaid, use the mermaid skill.
---

Write the diagram in a text file, then render it with Kroki:

```bash
curl -sS --fail-with-body --data-binary @timing.json -o timing.svg http://kroki:8000/wavedrom/svg || head -c 1000 timing.svg
```

If the command fails, the output file contains the error: fix the diagram and render again. `png` instead of `svg` for a PNG.

| Need | Kroki type | File |
| --- | --- | --- |
| Flowchart, sequence, class, state | `mermaid` | `mermaid` skill |
| Signal timing (SPI, I2C, UART, GPIO) | `wavedrom` | `.json` |
| Register bit fields | `wavedrom` | `.json` |
| Frame or packet layout in bytes | `bytefield` | `.edn` |
| UML when the project already uses PlantUML | `plantuml` | `.puml` |
| Dependency graphs, generated graphs | `graphviz` | `.dot` |
| Architecture with nested boxes | `d2` | `.d2` |

Graphviz attributes and node shapes: ZIM file `/data/devdocs_en_graphviz.zim`.

## Examples

Signal timing:

```json
{ signal: [
  { name: "clk",  wave: "p......." },
  { name: "cs",   wave: "10....1." },
  { name: "mosi", wave: "x.345x..", data: ["cmd", "addr", "data"] }
]}
```

Register, bit 0 first:

```json
{ reg: [
  { bits: 1, name: "EN" },
  { bits: 3, name: "MODE" },
  { bits: 4 },
  { bits: 8, name: "DIV" }
]}
```

Frame, one box per byte:

```clojure
(draw-column-headers)
(draw-box "SOF")
(draw-box "LEN")
(draw-box "Payload" {:span 12})
(draw-box "CRC16" {:span 2})
```
