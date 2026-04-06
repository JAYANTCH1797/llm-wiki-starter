# LLM Wiki Starter

A starter kit for building personal knowledge bases using LLMs. Based on [Andrej Karpathy's LLM Wiki pattern](https://github.com/karpathy/llm-wiki) — raw sources compiled by an LLM into a persistent, interlinked markdown wiki.

## Why this exists

Most AI + documents workflows look like RAG: upload files, retrieve chunks at query time, generate answers from scratch. Nothing compounds. Ask a subtle question requiring five documents, and the LLM re-discovers the answer every time.

This is different. Instead of retrieving at query time, the LLM **compiles at ingest time** — reading sources, writing summaries, updating entity pages, flagging contradictions, adding cross-references. The wiki is a persistent, compounding artifact. Every source you add and every question you ask makes it richer.

**You never write the wiki.** The LLM writes and maintains all of it. You curate sources, ask questions, and think about what it means.

## Architecture

Three layers:

| Layer | Owner | Purpose |
|-------|-------|---------|
| `raw/` | You | Immutable source documents. Articles, papers, images, data files. |
| `wiki/` | LLM | Structured markdown wiki. Summaries, entity pages, concept pages, cross-references. |
| `CLAUDE.md` | You + LLM | Schema file that defines wiki conventions and workflows. Co-evolved over time. |

Three operations:

| Operation | What happens |
|-----------|-------------|
| **Ingest** | Drop a source in `raw/`, tell the LLM to process it. One source touches 10-15 wiki pages. |
| **Query** | Ask questions against the wiki. Good answers get filed back as new pages. |
| **Lint** | Periodic health check — contradictions, stale claims, orphan pages, data gaps. |

## Quick start (60 seconds)

### Option A: Scaffold script

```bash
git clone https://github.com/JAYANTCH1797/llm-wiki-starter.git
cd llm-wiki-starter
chmod +x scaffold.sh
./scaffold.sh ~/Documents/llm-wiki
```

This creates a ready-to-use wiki at `~/Documents/llm-wiki/`.

### Option B: Manual setup

```bash
mkdir -p ~/Documents/llm-wiki/raw/assets
mkdir -p ~/Documents/llm-wiki/wiki/{entities,concepts,topics,queries}
mkdir -p ~/Documents/llm-wiki/tools
```

Then copy `CLAUDE.md`, `wiki/*`, `tools/search.py`, and `.gitignore` into your wiki directory.

### Then:

```bash
cd ~/Documents/llm-wiki
git init && git add . && git commit -m "init: empty wiki scaffold"
claude  # or your preferred LLM agent
```

Tell the LLM:

```
ingest raw/your-first-file.md
```

## Using with Obsidian (optional)

Obsidian works well as a viewer but is not required. Any markdown editor works.

If using Obsidian:

1. Open folder as vault → select your `llm-wiki/` directory
2. Settings → Files and links → "Default location for new attachments" → "In the folder specified below" → `raw/assets`
3. Settings → Files and links → "New link format" → "Shortest path when possible"
4. Settings → Files and links → "Automatically update internal links" → ON
5. Install [Obsidian Web Clipper](https://obsidian.md/clipper) to save web articles directly to `raw/`

## Using with different LLM agents

The schema file (`CLAUDE.md`) works with any LLM agent that can read/write local files:

| Agent | Schema file | Notes |
|-------|------------|-------|
| Claude Code | `CLAUDE.md` | Reads automatically from project root |
| OpenAI Codex | `AGENTS.md` | Rename `CLAUDE.md` → `AGENTS.md` |
| Cursor | `.cursorrules` | Copy schema content into `.cursorrules` |
| Windsurf | `.windsurfrules` | Copy schema content into `.windsurfrules` |

## File structure

```
llm-wiki/
├── CLAUDE.md              ← Schema: tells the LLM how to maintain the wiki
├── raw/                   ← Your sources (immutable, LLM reads only)
│   ├── assets/            ← Downloaded images
│   └── [your files]
├── wiki/                  ← LLM's workspace (you read, LLM writes)
│   ├── index.md           ← Content catalog (LLM reads first on every query)
│   ├── log.md             ← Chronological operation record
│   ├── overview.md        ← High-level synthesis
│   ├── entities/          ← People, tools, companies, papers
│   ├── concepts/          ← Ideas, frameworks, patterns
│   ├── topics/            ← Broader topic summaries
│   └── queries/           ← Filed-back Q&A outputs
└── tools/
    └── search.py          ← Simple CLI search (for when wiki outgrows index.md)
```

## How it compounds

```
Add source → LLM updates 10-15 pages → wiki gets richer
                                             ↓
Ask question → LLM synthesizes from wiki → file answer back
                                             ↓
                                        wiki gets richer
                                             ↓
Lint → fix contradictions, fill gaps → wiki gets healthier
                                             ↓
                                        repeat forever
```

## Tips

- **Start slow.** Ingest sources one at a time for the first 5. Guide the LLM on what to emphasize. After that, it has the pattern.
- **File back aggressively.** Every good query answer should become a wiki page. Explorations compound.
- **Lint monthly.** Ask the LLM to health-check the wiki for contradictions, orphans, and gaps.
- **Git commit often.** The wiki is just a folder of markdown files. You get version history for free.
- **Skip fancy tooling.** At <100 sources, `index.md` + the LLM is all you need. Add `search.py` or [qmd](https://github.com/tobi/qmd) when you outgrow it.

## Credits

Pattern by [Andrej Karpathy](https://x.com/karpathy) ([original post](https://x.com/karpathy/status/1907534867856990619), [full write-up](https://github.com/karpathy/llm-wiki)).
Starter kit by [Jayant Chaudhary](https://github.com/JAYANTCH1797).

## License

MIT
