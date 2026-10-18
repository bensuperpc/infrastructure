---
name: Documents (PDF, datasheets)
description: Read a PDF, datasheet, reference manual, Word, PowerPoint, Excel, HTML or image file. Converts it to Markdown with Docling first.
---

Never read a PDF or Office file directly. Convert it to Markdown with Docling, 10 pages at a time, next to the original. Give each conversion command a shell `timeout` of 600000:

```bash
curl -sS --fail-with-body -F files=@datasheet.pdf -F page_range=1 -F page_range=10 -F md_compact_tables=true \
  http://docling:5001/v1/convert/file | jq -r .document.md_content > datasheet-p1-10.md
```

Then search the Markdown instead of reading it all: `rg -n -i 'keyword' datasheet-p1-10.md`, then read only the matching part.

## Rules

- 10 pages take about 1 minute. Pages 1 to 10 usually hold the summary, the pinout, the absolute maximum ratings and the table of contents: convert them first, then only the pages you need (`page_range=31`, `page_range=40`...).
- A conversion that timed out keeps running in Docling and delays the next ones: never send the same command again, use a smaller page range.
- Same command, without `page_range`, for `.docx`, `.pptx`, `.xlsx`, `.html` and images. Scanned pages are read with OCR.
- Tables become Markdown tables. Figures become `<!-- image -->`: pinouts, timing diagrams and graphs drawn as pictures are lost. Say so instead of guessing their content.
- Empty file: check the response with `jq '.status, .errors'` instead of `jq -r .document.md_content`.
- Never write into `/docs`: it is read-only.
