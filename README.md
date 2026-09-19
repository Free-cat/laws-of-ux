# Laws of UX

Reviews and fixes frontend UI against the 30 Laws of UX from
[lawsofux.com](https://lawsofux.com/), plus a small set of curated extended
rules. The work is split across three strictly separated roles — a researcher
who gathers facts, a critic who judges them against the laws, and a fixer who
changes code — and only the fixer ever edits a file.

## Install

### Claude Code

Install from a marketplace, or point at a local path. Claude Code discovers
this plugin's `skills/` and `agents/` directories by convention, so no
additional wiring is needed once the plugin is installed. This is also the
only harness where the researcher, critic, and fixer roles run as separately
registered subagents (`laws-of-ux:ux-researcher`, `laws-of-ux:ux-critic`,
`laws-of-ux:ux-fixer`) with platform-enforced tool allowlists — see
[Tool enforcement varies by harness](#tool-enforcement-varies-by-harness)
below.

### Cursor

Install the plugin by pointing Cursor at this repository. `.cursor-plugin/plugin.json`
declares `"skills": "./skills/"`, which tells Cursor where to find the skill.
Cursor auto-discovers the plugin's `agents/` directory too, but it does not
honor a `tools:` allowlist in agent frontmatter — the only restriction it
supports is `readonly: true`. The read-only discipline for the researcher and
critic therefore rests on prompt text, and the `agents/*.md` files here use
Claude Code's `tools:` field, which Cursor ignores: on Cursor those agents run
with write capability, so treat any `critique`/`research` output from Cursor as
coming from an agent that *chose* not to write, not one that *cannot*.

### Codex CLI

Codex has no "point it at a repo" install — it needs a marketplace manifest,
which this repo does not ship. Register a personal marketplace entry instead:

```bash
codex plugin marketplace add <path-to-this-repo>
codex plugin add laws-of-ux --marketplace <marketplace-name-from-previous-command>
```

`.codex-plugin/plugin.json` declares the same `"skills": "./skills/"` pointer
as the other manifests (its `"hooks": {}` entry exists only to suppress Claude
Code's hook auto-discovery). Subagent dispatch requires `multi_agent = true` in
`~/.codex/config.toml`. Without that setting, Codex has no subagent dispatch,
and the skill runs its three phases inline in one conversation instead — that
is a supported path, not a degraded one.

### Gemini CLI

Install with:

```bash
gemini extensions install <path-to-this-repo>
```

Gemini CLI discovers an extension's skills by convention at
`<extension>/skills/`; no manifest field is required, and `gemini-extension.json`
carries none. That is also why this plugin ships no `GEMINI.md` — the skill is
found without it.

### Tool enforcement varies by harness

Only Claude Code enforces these tool allowlists at the platform level, via the
`tools:` field in `agents/ux-researcher.md` and `agents/ux-critic.md`. The
critic's allowlist (`Read, Grep, Glob`) is genuinely read-only. The
researcher's allowlist also includes `Bash`, which is not read-only in
principle — so the platform enforces the researcher against `Edit` and
`Write` specifically, with `Bash` available for read-only inspection and for
running the app to observe real behavior, never for modifying files.

On Cursor, the plugin's `agents/` directory is auto-discovered, but Cursor does
not support a `tools:` allowlist (only `readonly: true`, which these agent
files don't set), so the read-only roles run with write capability and the
discipline is carried by prompt text. On Codex CLI and Gemini CLI the plugin
cannot register scoped subagents at all — dispatch a generic child filled from
the `reference/*-prompt.md` templates, which carry the read-only discipline in
the prompt text. On all three, preserve that prompt text verbatim when
adapting the skill.

## Commands

| Command | Pipeline |
|---|---|
| `research [target]` | researcher only — a neutral context brief, no verdicts |
| `critique [target]` | researcher → critic — read-only findings. **Default when the request is ambiguous.** |
| `fix [target]` | fixer, against an approved findings list |
| `audit [target]` | researcher → critic → present findings → user picks → fixer |

`audit` never auto-applies everything it finds — it presents findings and the
user picks which to act on. `fix` requires an approved findings list; without
one, run `critique` first and get approval.

## What findings look like

Every finding uses the schema in `skills/ux-laws/reference/rubric.md`: `file`,
`line`, `law`, `source`, `summary`, `failure_scenario`, `severity`. A finding
must name a mechanism — why this specific property costs a real user something
specific — not just cite a law name and assert "best practice."

A worked example:

```
file: src/components/CheckoutForm.tsx
line: 112
law: Doherty Threshold
source: lawsofux
summary: The submit button shows no pressed or loading state while the order request is in flight.
failure_scenario: The checkout POST averages 1200ms, but the button gives no visual acknowledgment of the click. Unsure whether the first click registered, users click it two or three more times; because the button is never disabled client-side, the extra clicks reach the API before the first response returns and produce duplicate orders.
severity: major
```

`severity` is one of `blocker`, `major`, `minor`, or `nit`; `source` is
`lawsofux` for anything from `reference/laws.md` or `extended` for anything
from `reference/extended-rules.md` — the two are never blurred.

## Extending

To add a new principle that isn't part of the lawsofux.com collection, append
an entry to `skills/ux-laws/reference/extended-rules.md` with the same shape as
the existing entries: what it says, a violation signal, a fix pattern, and a
real source link. Adding an entry needs no design change — it's an append, not
a restructuring — but any finding that cites it must set `source: extended`,
never `source: lawsofux`, to keep the two collections distinct.

`skills/ux-laws/reference/laws.md` tracks lawsofux.com itself — currently 30
laws, verified 2026-08-15. The site can add, remove, or rename laws over time,
so that count and date should be re-verified periodically against the source
rather than assumed correct indefinitely. The five-theme grouping in that file
is this plugin's own organization for faster retrieval, not something
lawsofux.com provides — the site presents a flat, uncategorized list.

## Releasing

Bumping the version means editing **all four** manifests in the same commit:

- `.claude-plugin/plugin.json`
- `.cursor-plugin/plugin.json`
- `.codex-plugin/plugin.json`
- `gemini-extension.json`

Then run `bash scripts/validate.sh` — it fails if the four versions disagree.
