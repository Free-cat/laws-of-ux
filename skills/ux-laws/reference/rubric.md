# Finding Rubric

## Schema

Every finding carries exactly these fields:

| Field | Meaning |
|---|---|
| `file` | Repo-relative path |
| `line` | 1-indexed line the finding anchors to, or `absent` — see below |
| `law` | The law or rule name, matching a heading in `laws.md` or `extended-rules.md` exactly |
| `source` | `lawsofux` or `extended` — never blur the two |
| `summary` | One sentence stating the defect |
| `failure_scenario` | Concrete user impact: what someone does, and what goes wrong |
| `severity` | `blocker`, `major`, `minor`, or `nit` |

On harnesses without a structured-output mechanism, render each finding as a
plain block with one `field: value` per line, findings separated by a blank line.

## Severity

- **blocker** — users cannot complete the task, or complete it wrongly. Targets
  too small to hit reliably; a destructive action needs at least one of
  confirmation or undo — having neither is the blocker; a flow that loses
  entered data.
- **major** — the task completes but costs real, measurable extra effort or
  error risk. Choice overload at a decision point; a form that dumps twenty
  fields with no grouping; no feedback on an action that takes seconds.
- **minor** — friction a user absorbs without failing. Inconsistent spacing that
  weakens grouping; a weak empty state; an unremarkable primary action.
- **nit** — genuine but small. One-off spacing that misses the scale by a step.

## Admission standard

A finding must state the **mechanism** — why this specific property produces
this specific outcome for a user. Citing a law name is not a mechanism.

- Rejected: "Violates Fitts's Law — button too small. Best practice is larger."
- Admitted: "Icon button renders 28×28px with 2px of margin (`Toolbar.tsx:47`),
  adjacent to the destructive Delete control; the two hit areas are closer
  together than a thumb contact patch is wide, so mobile taps aimed at Edit land
  on Delete."

Note what the admitted example rests on: the geometry between two controls and
the consequence of getting it wrong. The size alone is not the finding — a
28×28px control with generous spacing and no dangerous neighbor may be fine.

A `[heuristic]` figure in `laws.md` is this plugin's working number, not a
lawsofux.com claim. It may appear as supporting detail, never as the mechanism
itself, and never phrased as though the source states it. If removing the number
leaves no defect, there is no finding.

Reject a finding if you cannot say what a user concretely loses. Taste
disagreements are not findings.

## Findings with no line

Some real defects are absences — no progress indicator in a five-step checkout,
no empty state, no loading feedback anywhere in a component. These have no line
to point at, and the researcher is explicitly told to record such gaps.

For these, set `line: absent` and use `file` to name the file where the missing
element belongs. `summary` must state what is missing and where it would go, so
the fixer has an anchor. Do not invent an unrelated line number to satisfy the
schema, and do not file the defect under `## Not assessed` — that heading is for
laws you lacked evidence to judge, not for defects you are confident about.

## Ordering

Sort most severe first. Within a severity, group by file.

## Not assessed

Some laws need evidence a source-only pass doesn't have — usage telemetry,
analytics, or user research. When that's the case, don't force a finding and
don't guess. Note it under a `## Not assessed` heading, placed after the
findings list: one line per law, naming the law and the reason it couldn't be
assessed.

## Scope of "one law per finding"

The critic prompt's "one law per finding" rule governs one defect that
implicates two laws — pick the one, mention the other in `summary`. It does
not apply across defects: two independent defects that happen to sit in the
same file or component are two separate findings, not one. Give each its own
entry even when they share a location.
