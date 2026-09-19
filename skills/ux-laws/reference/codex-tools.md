# Codex CLI Tool Mapping

| Action | Codex CLI equivalent |
|---|---|
| Read a file | `read_file` (Codex exposes a largely Claude-Code-compatible tool surface here; exact name not independently verified against a specific Codex build) |
| Edit a file | `apply_patch` (Codex's patch-application mechanism; not a single-file "replace" tool) |
| Create a file | `apply_patch` (same mechanism as edit — a patch that adds a new file) |
| Run a shell command | `shell` (Codex's sandboxed shell-exec tool) |
| Search file contents | no confirmed dedicated tool name — Codex typically greps via `shell`; trust your actual tool list |
| Find files by name | no confirmed dedicated tool name — Codex typically finds via `shell`; trust your actual tool list |
| List a directory | no confirmed dedicated tool name — Codex typically lists via `shell`; trust your actual tool list |
| Dispatch a subagent | `spawn_agent` (see Role dispatch below; requires `multi_agent = true`) |

Codex's shell-exec tool covers several of the above indirectly (search, find,
list) rather than exposing them as their own named tools the way Claude Code
does — don't invent separate tool names for those rows.

## Subagent dispatch requires multi-agent support

Add to `~/.codex/config.toml`:

```toml
[features]
multi_agent = true
```

Without it, Codex has no subagent dispatch and this skill runs all three phases
inline in one conversation — which is a supported path, not a degraded one. Do
not fabricate a dispatch call that the tool list does not offer.

With it, spawn children with `spawn_agent {fork_turns: "none"}` to give them a
clean context; the default `"all"` copies the entire transcript. Fill the
matching `reference/*-prompt.md` template and pass it as the child's prompt.

Trust your actual tool list over this table when they disagree.

## Role dispatch

Codex 0.145+ supports role files under `~/.codex/agents/` attached via
`agent_type`. Those live in the **user's** home directory, so this plugin cannot
install them. Dispatch generic children with a filled prompt template instead —
the template carries the role, the scope discipline, and the output format.

This means the researcher's and critic's read-only discipline is **not enforced
by the platform here**. It is carried by the prompt text. Preserve that text
verbatim when filling templates.
