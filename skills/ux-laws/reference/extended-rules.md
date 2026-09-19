# Extended UX Rules — Reference

Principles that are **not** part of the lawsofux.com collection but are
established practice. Every entry carries its source.

A finding citing anything in this file MUST set `source: extended`, never
`source: lawsofux`. Keeping these separate is the point of the file: it lets us
grow the ruleset without diluting what "Laws of UX" means.

Adding an entry needs no design change — append it with the same schema and a
real source link.

### Internal vs external spacing

**Source.** [cetera.ru — Правило внутреннего и внешнего в UX/UI дизайне](https://cetera.ru/about/articles/pravilo-vnutrennego-i-vneshnego-v-ux-ui-dizajne/)

**What it says.** An element's own internal padding should be larger than the
gap separating it from its siblings — «внешние отступы не должны быть больше
внутренних». That ratio is what makes a card read as one contained thing rather
than as loose content floating near other content. The article states the card
case directly: «в карточках товара внутренний отступ (от краев до контента)
должен быть больше, чем расстояние между самими карточками». Separately, across
levels of nesting, spacing grows with hierarchy: the gap between two groups
should exceed the gap between members of one group.

**Violation signal.** Card padding of 12px with a 24px gap between cards — the
padding is tighter than the separation, so content reads as belonging to the
grid rather than to its card; a button whose internal label padding is tighter
than the margin around it; form fields spaced as far apart as the groups they
belong to (`gap` between fields ≥ `gap` between fieldsets), which flattens the
grouping.

**Fix pattern.** For an element against its siblings, compare internal padding
to the gap between them and raise the padding until containment reads — cards:
inner padding > gap between cards. For nesting levels, compare like with like:
field-to-field gap < group-to-group gap. Related to Law of Proximity, but
distinct — proximity is about which things read as grouped, this is about the
spacing ratio that makes containment legible.

### Visibility of system status

**Source.** [Nielsen Norman Group — 10 Usability Heuristics for User Interface Design](https://www.nngroup.com/articles/ten-usability-heuristics/)
(heuristics 1, "Visibility of system status," and 9, "Help users recognize,
diagnose, and recover from errors.")

**What it says.** The system should always keep users informed about what is
going on, through appropriate feedback within reasonable time — including
whether an action actually succeeded or failed. When something goes wrong, the
interface must surface it in plain language, not swallow it silently and leave
the UI looking as if nothing happened.

**Violation signal.** An async call fired without being awaited, or awaited
with no `try`/`catch` or `.catch` around it, so a rejection has nowhere to go;
a UI that resets, closes, or advances (e.g. a confirm step collapsing back to
its default state) unconditionally in the same tick the call is fired, instead
of after the call resolves; an `error` value the component's state layer
already captures but the component never reads or renders; a request that can
fail with no visible message, toast, or inline state anywhere in the render
tree; a long-running operation with no pending/loading/disabled state between
the click and the resolution.

**Fix pattern.** Await the call and branch on its outcome. Gate the optimistic
UI transition (closing a confirm step, clearing a form, navigating away) on
success, not on the call merely being fired. Render the error state the hook
or store already exposes. For operations users perceive as slow, show a
pending state from click to resolution, and, on failure, a recoverable message
rather than a return to the pre-action UI with no explanation.
