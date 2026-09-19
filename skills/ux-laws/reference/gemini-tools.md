# Gemini CLI Tool Mapping

| Action | Gemini CLI equivalent |
|---|---|
| Read a file | `read_file` |
| Read several files | `read_many_files` |
| Create a file | `write_file` |
| Edit a file | `replace` |
| Run a shell command | `run_shell_command` |
| Search file contents | `grep_search` |
| Find files by name | `glob` |
| List a directory | `list_directory` |
| Fetch a URL | `web_fetch` |
| Invoke a skill | `activate_skill` |
| Dispatch a subagent | `invoke_agent` with `agent_name: "generalist"` |

## Extension skill discovery

Gemini CLI discovers an extension's skills **by convention** at
`<extension>/skills/`. No manifest field is needed, and none is used: our
`gemini-extension.json` carries only `name`, `description`, and `version`.

Verified 2026-08-15 against gemini-cli 0.32.1:

- `skillManager.js` iterates installed extensions and pulls `extension.skills`,
  so extensions do contribute skills to the session.
- `extension-manager-hydration.test.js` creates
  `<extensionPath>/skills/my-skill/SKILL.md` with no manifest `skills` field
  and asserts the extension loads exactly one skill.
- Note for anyone re-checking this: `gemini extensions validate` accepts a
  manifest containing arbitrary unknown keys, so a passing validate proves
  nothing about field support. The convention evidence above is what settles it.

This plugin therefore ships no `GEMINI.md`. If a future Gemini release stops
discovering extension skills by convention, the fix is additive: a `GEMINI.md`
at the repo root containing the single line `@./skills/ux-laws/SKILL.md`.

## Role dispatch

Gemini exposes only built-in agent names — `generalist`, `cli_help`,
`codebase_investigator`, `browser_agent`. A plugin cannot register its own. Fill
the matching `reference/*-prompt.md` template and pass it to `invoke_agent` with
`agent_name: "generalist"`.

The researcher's and critic's read-only discipline is therefore **not enforced
by the platform here** — it is carried by the prompt text. Preserve it verbatim.

Parallel dispatch is supported: issue multiple `invoke_agent` calls in one
response for independent work. Keep the research → critique → fix stages
sequential; each consumes the previous stage's output.
