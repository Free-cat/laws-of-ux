---
name: ux-laws
description: Use when reviewing, critiquing, auditing, or fixing the UX of a frontend interface against the Laws of UX. Covers usability heuristics, visual hierarchy, cognitive load, choice overload, hit-target sizing, spacing and grouping, feedback and latency, form and navigation structure, onboarding and empty states. Triggers on the law names themselves — Fitts's Law, Hick's Law, Jakob's Law, Miller's Law, Peak-End Rule, Von Restorff Effect, Zeigarnik Effect, Doherty Threshold, Tesler's Law, Postel's Law, Occam's Razor, Aesthetic-Usability Effect, Serial Position Effect, Goal-Gradient Effect, Choice Overload, Cognitive Load, Law of Proximity, Law of Common Region — and on plain questions like "is this button too small", "does this form ask too much", or "critique this screen".
---

# Laws of UX

Review and fix frontend UI against the Laws of UX. Three roles, strictly
separated: a researcher gathers facts, a critic judges them, a fixer changes
code — and only the fixer edits anything.

## Commands

These are pipeline names you ask for in plain language (`critique src/App.tsx`),
not registered slash commands. On Claude Code the skill is invoked as
`/laws-of-ux:ux-laws` (plugin `laws-of-ux`, skill `ux-laws`) followed by the
command and target.

| Command | Pipeline |
|---|---|
| `research [target]` | researcher only — a neutral context brief, no verdicts |
| `critique [target]` | researcher → critic — read-only findings. **Default when the request is ambiguous.** |
| `fix [target]` | fixer, against an approved findings list |
| `audit [target]` | researcher → critic → present findings → user picks → fixer |

`audit` never auto-applies everything it finds. Present the findings, let the
user choose, then fix only the chosen ones. `fix` requires an approved list; if
you do not have one, run `critique` first and get approval.

## References

Load `reference/laws.md` and `reference/extended-rules.md` for any command.
Load `reference/rubric.md` before the critic stage, `reference/fix-guardrails.md`
before the fixer stage.

## Dispatch

If this harness has subagent dispatch, use it:

- **Claude Code** — dispatch the named agent types `laws-of-ux:ux-researcher`,
  `laws-of-ux:ux-critic`, `laws-of-ux:ux-fixer`. Their tool allowlists enforce
  the read-only discipline. Hand the researcher's context brief to the critic
  as its input.
- **Other harnesses** — copy the role's `reference/*-prompt.md` template and
  fill it before dispatching. Two slots are required and are **not** pre-filled
  in the template: the target surface (path or description), and the previous
  stage's output — the researcher's context brief for the critic, the approved
  findings list for the fixer. Without them the child has nothing to work from;
  do not dispatch until they are filled in. On Codex, spawn with
  `fork_turns: "none"` so the child starts clean rather than inheriting the
  whole transcript — that makes filling the slots mandatory, not optional.
  The scope discipline travels in the prompt text; preserve it verbatim.

If this harness has no subagent dispatch, or it is gated off, run the three
phases inline in this conversation, following the same prompt files as internal
steps. Never fabricate a dispatch call the tool list does not offer.

## Platform Adaptation

If your harness appears here, read its reference file before proceeding:

- Codex CLI — `reference/codex-tools.md`
- Gemini CLI — `reference/gemini-tools.md`

Cursor uses Claude Code's tool surface, so no mapping file is needed, but it
does not honor a `tools:` allowlist in agent frontmatter — only `readonly`.
See README for what that means for the read-only roles.

## Findings

Findings use the schema in `reference/rubric.md`: `file`, `line`, `law`,
`source`, `summary`, `failure_scenario`, `severity`. Every finding names a law
that exists in the reference files and states a mechanism — why that specific
property costs a real user something specific. A finding that only cites a law
name and asserts "best practice" does not ship.
