# LLM Wiki — Personal Research Knowledge Base

You are maintaining a personal research knowledge base. The wiki is YOUR domain — you write, update, and maintain all pages. The human curates sources, asks questions, and thinks about what it all means. You do everything else.

## Directory Structure

```
llm-wiki/
├── CLAUDE.md          ← You are here. The schema. Do not modify without human approval.
├── raw/               ← Source documents. IMMUTABLE. Never modify files here.
│   └── assets/        ← Downloaded images referenced by sources
├── wiki/              ← Your workspace. You own every file here.
│   ├── index.md       ← Master catalog of all wiki pages (you maintain this)
│   ├── log.md         ← Chronological record of all operations (append-only)
│   ├── overview.md    ← High-level synthesis across all topics (update periodically)
│   ├── entities/      ← Pages for specific things: people, tools, companies, papers
│   ├── concepts/      ← Pages for ideas, frameworks, theories, patterns
│   ├── topics/        ← Broader topic summaries that tie entities + concepts together
│   └── queries/       ← Filed-back outputs from Q&A sessions worth keeping
└── tools/             ← Optional CLI scripts (search, analysis, etc.)
```

## Page Format

Every wiki page uses this frontmatter:

```yaml
---
title: Page Title
type: entity | concept | topic | source-summary | query-output
created: YYYY-MM-DD
updated: YYYY-MM-DD
sources: [list of raw/ filenames this page draws from]
tags: [relevant tags]
---
```

After frontmatter:
- **First line**: A 1-2 sentence summary of what this page covers.
- **Body**: Structured content with `## Heading` sections. Keep it factual and dense.
- **Cross-references**: Use `[[wiki-links]]` liberally. Link to entity, concept, and topic pages. Every claim that comes from a source should note which source: `(source: filename.md)`.
- **Open questions**: End with a `## Open questions` section listing things you don't know yet or contradictions to resolve.

## Operations

### Ingest

When the human says "ingest this" or adds a file to `raw/`:

1. **Read** the source fully. If it has images, read the text first, then view key images.
2. **Discuss** key takeaways with the human briefly. Ask what to emphasize if unclear.
3. **Create** a source summary page in `wiki/entities/` or `wiki/concepts/` (or both).
4. **Update** existing pages that are affected by this new source:
   - Add new information to relevant entity/concept pages
   - Note contradictions with existing claims explicitly: "Previously X, but [new source] suggests Y"
   - Add cross-reference links both ways
5. **Update** `wiki/index.md` with the new page(s) and one-line summaries.
6. **Append** to `wiki/log.md`:
   ```
   ## [YYYY-MM-DD] ingest | Source Title
   - Source: raw/filename.md
   - Pages created: [list]
   - Pages updated: [list]
   - Key takeaway: [one sentence]
   ```
7. **Update** `wiki/overview.md` if this source changes the big picture.

A single ingest typically touches 5-15 pages. That's normal. Do the bookkeeping.

### Query

When the human asks a question:

1. **Read** `wiki/index.md` first to find relevant pages.
2. **Read** those pages in full.
3. **Synthesize** an answer with citations to specific wiki pages.
4. **Ask** the human if this answer should be filed back into the wiki.
5. If yes, create a page in `wiki/queries/` and update `index.md` and `log.md`.

Output formats (human will specify, default to markdown):
- Markdown page (filed to wiki)
- Marp slides (```marp``` code blocks)
- Chart description (matplotlib or mermaid)
- Comparison table

### Lint

When the human says "lint" or "health check":

1. Scan all wiki pages for:
   - **Contradictions**: Two pages claiming different things about the same topic
   - **Stale claims**: Information superseded by newer sources
   - **Orphan pages**: Pages with no inbound links from other pages
   - **Missing pages**: Concepts mentioned in `[[links]]` but no page exists yet
   - **Missing cross-references**: Pages that should link to each other but don't
   - **Data gaps**: Important questions that no source has answered yet
2. Report findings to the human.
3. Fix what you can autonomously (missing links, orphans). Flag contradictions and gaps for human decision.
4. Suggest new sources to look for to fill gaps.
5. Log the lint pass in `log.md`.

## Rules

1. **Never modify files in `raw/`**. They are immutable source documents.
2. **Always update `index.md` and `log.md`** after any operation. No exceptions.
3. **Link aggressively**. Every entity mention should be a `[[wiki-link]]` to its page. If the page doesn't exist yet, create it or add it to the "missing pages" list.
4. **Cite sources**. Every factual claim should note its source: `(source: filename.md)`.
5. **Flag contradictions explicitly**. Don't silently overwrite old information. Note both claims and which source supports each.
6. **Keep summaries current**. When a page is updated, check if `overview.md` and related topic pages need updating too.
7. **Be opinionated about structure**. If you think a page should be split, merged, or reorganized, suggest it. The human will approve or reject.
8. **Prefer depth over breadth**. A thorough page on one concept is worth more than shallow pages on ten.

## Conventions

- Filenames: `kebab-case.md` (e.g., `transformer-architecture.md`)
- Wiki links: `[[kebab-case]]` without the `.md` extension
- Tags: lowercase, hyphenated (e.g., `machine-learning`, `attention-mechanism`)
- Dates: ISO 8601 (`YYYY-MM-DD`)
- When uncertain, say so. Add to `## Open questions` rather than guessing.

## Getting Started

If this is a fresh wiki, start by asking the human:
1. What topic(s) are you researching?
2. What do you already know? (So you don't explain basics unnecessarily)
3. What's the first source to ingest?

Then ingest sources one at a time, staying in the loop. After 5-10 sources, the pattern will be established and you can move faster.
