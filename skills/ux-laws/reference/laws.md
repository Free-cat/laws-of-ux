# Laws of UX — Reference

Source: [lawsofux.com](https://lawsofux.com/). 30 laws, verified 2026-08-15.

**The thematic grouping below is ours, not lawsofux.com's.** The site presents
a flat, uncategorized collection; we group the laws into five themes purely to
make retrieval and critique faster. Never cite the grouping as if it came from
the source. Individual law names and definitions do come from the source.

Each entry gives: what it says, how a violation shows up in real UI code, and
the shape of the fix.

**`[heuristic]` marks a number this plugin supplies, not lawsofux.com.** The
site states almost no thresholds; where a concrete figure makes a violation
signal usable, it is tagged `[heuristic]`. A finding may use one as supporting
detail, but must never rest on it alone and must never imply the source states
it. The mechanism — what the user concretely loses — has to hold without the
number. Unmarked figures (the Doherty Threshold's 400ms) do come from the
source.

## Perception & Grouping (Gestalt)

### Law of Common Region

**What it says.** Elements inside a shared boundary — a border, a card, a tinted
panel — are perceived as one group, and the boundary overrides proximity.

**Violation signal.** A card whose border encloses both the form and an unrelated
promo; a row's action buttons rendered outside the card they act on; a bordered
panel wrapping the section heading plus the first item of the next section;
zebra striping that shades across a logical group boundary.

**Fix pattern.** Draw the enclosure around exactly the set that belongs together
— no more, no less. If the border cannot be moved, move the content into it.
One region per group, and nothing homeless between two regions.

### Law of Proximity

**What it says.** Objects near each other are perceived as related. Spacing
communicates grouping before any border or color does.

**Violation signal.** A field's label equidistant from its own input and the
next field's; uniform margins between every element regardless of relationship;
help text floating closer to the following control than the one it explains.

**Fix pattern.** Make within-group spacing visibly tighter than between-group
spacing. Let the gap carry the grouping before reaching for a divider or box.

### Law of Prägnanz

**What it says.** The eye resolves complex or ambiguous forms into the simplest
shape it can. Simple forms are read faster and remembered longer.

**Violation signal.** Icons carrying enough interior detail that they turn to
mush at 16–20px; four different corner radii and three shadow depths in one
view; elements a few pixels off a shared baseline or edge; an SVG icon built
from a dozen overlapping paths whose meaning lives in the interior detail.

**Fix pattern.** Reduce each form to its simplest recognizable silhouette; test
icons at their smallest shipped size. Standardize radii, shadows, and stroke
weights into a small token set, and align to one grid so edges resolve cleanly.

### Law of Similarity

**What it says.** Elements sharing visual characteristics — color, shape, size,
weight — are perceived as related and as having the same function.

**Violation signal.** Body text styled in the link color, or links that look
exactly like body text; a submit and a cancel button rendered with identical
fills; static informational tiles styled the same as clickable ones; a disabled
control indistinguishable from an enabled secondary control.

**Fix pattern.** One visual treatment per role, applied consistently: everything
that looks clickable is clickable, everything clickable looks it. Reserve the
primary style for the primary action and give disabled states their own token.

### Law of Uniform Connectedness

**What it says.** Elements joined by a visible connector — a line, a rail, a
shared background — read as more related than elements merely placed nearby.
It is the strongest of the grouping cues.

**Violation signal.** Wizard step markers floating as unconnected circles with
no line between them; a segmented control whose segments have the same gap as
unrelated neighboring buttons; a chart legend detached from its series with no
shared color or leader line; grouped toolbar buttons with no shared container.

**Fix pattern.** Connect what is sequential or co-functional: a rail behind the
steps, one background behind a button group, leader lines or matching swatches
from legend to series. Reserve connectors for real relationships.

## Memory & Cognitive Load

### Chunking

**What it says.** Breaking content into small, meaningful units makes it easier
to scan, process, and recall than the same content delivered unbroken.

**Violation signal.** A 16-digit card number, IBAN, or phone number rendered as
one unbroken string in the input; 800 words of policy copy with no subheadings;
a 30-row settings table with no section rows; a changelog as a single
paragraph; an order confirmation with ID, date, and total run together.

**Fix pattern.** Format long strings into groups of three to four characters as
the user types; break prose with headings every few paragraphs ([heuristic]
roughly every 150 words is a reasonable working default, not a lawsofux.com
figure); give tables section headers and lists visual breaks. Chunk on meaning,
not just length.

### Cognitive Load

**What it says.** Every interface consumes some of the user's finite mental
resources. Load spent on the interface itself is load unavailable for the task.

**Violation signal.** A dashboard with a dozen widgets animating on load;
internal jargon as user-facing labels ("Ingress TTL", "Entity ID") with no
explanation; a form asking for a value the system already knows or could
compute; two navigation systems competing on one page; an error surfacing a raw
stack trace.

**Fix pattern.** Delete anything that does not serve the current task, compute
what can be computed, and name things in the user's vocabulary. Move rarely
used controls behind a disclosure rather than spending permanent attention.

### Miller's Law

**What it says.** The average person can hold only about seven (plus or minus
two) items in working memory. Design should not depend on that capacity.

**Violation signal.** A confirmation code shown on a screen the user must leave
to enter it; a reference number shown only in a toast that auto-dismisses; a
comparison that requires remembering values from the previous screen; a long
flat list with no chunking or labels, so nothing can be held as a group.

Miller's is about what the user must *carry in memory*, not about how many
things are on screen. If the complaint is that a long list slows a decision the
user makes with everything visible, that is Hick's Law. If the user must
remember something after it leaves the screen, it is Miller's. Never cite
Miller's for item count alone — the law's own takeaway is "don't use the
'magical number seven' to justify unnecessary design limitations."

**Fix pattern.** Keep values the user needs on screen while they need them; use
autofill for one-time codes; show comparisons side by side. Never treat "seven
items" as a hard cap on list length — chunk and label instead of truncating.

### Working Memory

**What it says.** Working memory is a small, fragile store that holds and
manipulates information for a few seconds. Anything displaced from it is gone.

**Violation signal.** A modal that covers the data needed to complete the
modal's own fields; a validation summary at the top of a long form while the
failing field is scrolled out of view; a multi-step form that clears entries on
Back; search results that drop the applied filters after opening one result; a
tooltip that disappears on mouse-out before the value can be typed.

**Fix pattern.** Show the reference material and the input at the same time;
put errors inline next to the field that failed; persist form and filter state
across navigation; make transient hints dismissible rather than hover-only.

### Zeigarnik Effect

**What it says.** People remember interrupted or incomplete tasks better than
completed ones, and an unfinished task creates tension that pulls them back.

**Violation signal.** A multi-step signup with no step counter or progress bar;
a profile with no indication of what is still missing; a cart that silently
empties between sessions; a draft that is discarded on navigation without
telling the user; a "complete your setup" badge with no way to see what remains
and no way to dismiss it.

**Fix pattern.** Make partial completion visible and resumable — "Step 2 of 4",
a percent-complete meter, a saved draft with a clear return path. Show what is
left, not just what is done, and let a finished user dismiss the nudge.

### Mental Model

**What it says.** Users arrive with a belief about how a system works, built
from every other system they have used. Mismatch with that belief causes error.

**Violation signal.** A trash icon that deletes permanently with no undo or
recoverable state; a "Save" that also publishes to the public; a toggle switch
that fires a long-running job rather than setting a state; a cart icon opening
a wishlist; browser Back exiting a multi-step flow and losing the entered data.

**Fix pattern.** Use conventional components for their conventional meaning —
toggles for state, buttons for actions, trash for recoverable deletion. When
behavior must differ from expectation, rename it and say what it will do.

## Decision-Making & Attention

### Choice Overload

**What it says.** A large set of comparable options makes people less likely to
choose at all, and less satisfied with what they do choose.

**Violation signal.** Nine pricing tiers rendered identically with nothing
marked recommended; an export dialog listing twelve formats with no default; a
first-run theme picker with thirty swatches; a product list with forty filter
facets and no default sort; a dropdown of every country with no detected
default.

**Fix pattern.** Preselect a sensible default, mark one option as recommended,
and narrow the visible set — top choices first, the rest behind "More options".
Where options are truly comparable, guide with a short decision aid.

### Cognitive Bias

**What it says.** Judgment deviates from rationality in systematic ways —
anchoring, defaults, loss aversion. Design can accommodate these or exploit them.

**Violation signal.** A struck-through "was" price that was never charged;
add-ons or marketing consent preselected on a checkout; a decline link worded to
shame ("No thanks, I like paying full price"); a scarcity counter or countdown
that resets on page reload; a "12 people are viewing this" number not backed by
real data.

**Fix pattern.** Anchor on real prices, make consequential options opt-in rather
than opt-out, and word the decline neutrally at the same visual weight as the
accept. Use urgency only when the deadline is real.

### Hick's Law

**What it says.** Decision time grows with the number and complexity of the
choices available. More options means slower decisions, not richer ones.

**Violation signal.** Navigation with a dozen-plus flat sibling links; settings
panes exposing every option at one level; a form asking for everything at once;
undifferentiated options at a decision point, with nothing marked recommended
and no grouping to compare across. [heuristic] Counts alone are not the signal —
a five-tier pricing table with one plan marked recommended and tiers ordered by
capability is doing the work Hick's Law asks for; five unlabeled, unordered
tiers is not. Cite the missing structure, not the number of items.

**Fix pattern.** Group and stage the choices — progressive disclosure, sensible
defaults, a recommended option marked as such. Cut options that exist only for
completeness.

### Selective Attention

**What it says.** People filter out what looks irrelevant to the current task,
including whole regions of a page that resemble advertising.

**Violation signal.** A required notice placed in a right rail, a top banner
strip, or any ad-shaped slot; a validation error at the top of the viewport
while the user's attention is on the submit button below; a critical message
styled like a promotion; an important state change announced only by a color
shift in the page chrome.

**Fix pattern.** Put messages in the path of the task — inline beside the
control they concern, or directly above the button that triggered them. Move
focus to the message when it is blocking, and avoid ad-like framing.

### Serial Position Effect

**What it says.** People best remember the first and last items in a series;
the middle is where recall falls off.

**Violation signal.** A nav bar where the highest-value destination sits fifth
of nine, between filler links; an onboarding sequence whose core value claim is
on slide three of five; a feature list burying the differentiator mid-list; a
toolbar where the most-used action is centered among eight equal icons.

**Fix pattern.** Put what matters most at the start and the end of any ordered
set — nav, lists, onboarding, form sections. Push low-value items into the
middle, or drop them.

### Von Restorff Effect

**What it says.** When several similar objects are present, the one that differs
is the one remembered. Also called the isolation effect.

**Violation signal.** Three equally weighted filled buttons in one view; a
pricing grid where every card has the same border and CTA color, including the
one meant to win; every alert severity rendered in the same neutral gray; a
"recommended" label set in small gray text next to the option it marks.

**Fix pattern.** Emphasize exactly one thing per view and let everything else
recede. Differentiate with more than hue — size, weight, position, and an
explicit label — so the distinction survives color-blindness and grayscale.

### Pareto Principle

**What it says.** Roughly 80% of effects come from 20% of causes. A small subset
of features and paths accounts for most of the actual use.

**Violation signal.** A top-level nav slot spent on a feature used by 1% of
sessions while the dominant task is two levels deep; a settings page where the
most-changed setting sits behind three disclosures; a toolbar with twenty
equal-weight buttons when analytics show three actions dominate; equal design
polish across a flagship flow and an edge-case admin screen.

**Fix pattern.** Instrument usage, then promote the top paths to the shortest
reach and demote the rest behind "Advanced". Spend design and performance
effort proportional to traffic, not to feature count.

## Interaction Effort & Speed

### Fitts's Law

**What it says.** The time to acquire a target is a function of the distance to
and size of the target. Small, far-away targets cost more time and more errors.

**Violation signal.** Icon-only buttons with no padding; primary actions placed
far from the natural cursor or thumb path; destructive and primary actions
adjacent with no separation. Tap targets small enough that neighboring controls
compete for the same thumb contact patch. [heuristic] ~44×44px is a useful
working floor on touch surfaces, but it is not a lawsofux.com figure and not a
pass/fail line: WCAG 2.2 SC 2.5.8 sets 24×24 CSS px with a spacing exemption, so
a smaller-but-well-spaced control can be correct. Judge the pairing of size and
spacing, not the number alone.

**Fix pattern.** Grow the hit area (padding or a pseudo-element) rather than the
visual glyph; move frequent actions closer to where the pointer already is;
put distance between confirm and destroy.

### Doherty Threshold

**What it says.** Productivity rises sharply when system and user respond to
each other inside about 400ms — fast enough that neither waits on the other.

**Violation signal.** A submit button with no pressed or loading state on a
request taking over a second; a spinner that appears only after several hundred
milliseconds of blank screen; filtering that triggers a full page reload;
search that fires only on Enter and returns after seconds; a list that pops
into place with no skeleton and shifts layout on arrival.

**Fix pattern.** Acknowledge every input within 100ms, even if the result is not
ready: pressed states, skeletons sized to the real content, optimistic updates
with rollback. Prefetch likely next data and debounce rather than block.

### Parkinson's Law

**What it says.** A task expands to fill the time allotted to it. Given a
generous or unbounded window, people take longer than the work requires.

**Violation signal.** A checkout requiring the full address to be typed when
address lookup or `autocomplete` attributes would fill it; `autocomplete="off"`
on name, address, or payment fields; no saved payment or shipping method for
returning users; a six-step wizard shown identically to a repeat customer; a
flow with no stated expected duration.

**Fix pattern.** Prefill everything known, enable browser and platform autofill,
and collapse steps for returning users. State the expected time up front
("about 2 minutes") and make the fast path the default one.

### Tesler's Law

**What it says.** Every system has an irreducible amount of complexity. The only
question is whether the system absorbs it or pushes it onto the user.

**Violation signal.** Asking the user to choose timezone, currency, or locale
the system can infer from context; a date field that rejects anything but one
format; requiring an image be cropped or resized before upload; making the user
merge duplicate records the system could match; asking for a value derivable
from another field already submitted.

**Fix pattern.** Move the complexity inside: infer, parse, transform, and
reconcile on the system's side, and expose an override only where the guess can
genuinely be wrong. Never simplify by deleting a step the user still must do.

### Occam's Razor

**What it says.** Among designs that accomplish the same thing, prefer the one
with the fewest elements and assumptions.

**Violation signal.** A list card carrying title, subtitle, badge, avatar,
timestamp, icon, and three actions when two fields drive every decision; a
confirmation modal wrapping a single reversible action; decorative dividers,
gradients, and shadows stacked on the same element; a two-click path where one
click suffices; a preference that duplicates an existing one.

**Fix pattern.** Remove elements one at a time until removing one breaks the
task, then stop. Justify each remaining element by the decision it supports.

### Postel's Law

**What it says.** Be liberal in what you accept, conservative in what you send.
Accept input in whatever shape it arrives; emit one clean, predictable form.

**Violation signal.** A phone field rejecting spaces, dashes, parentheses, or a
leading `+`; a card field rejecting the spaces pasted from a bank statement; a
date input demanding exactly `MM/DD/YYYY`; a coupon code that is case- or
whitespace-sensitive; a form that clears every field after one validation
failure.

**Fix pattern.** Normalize on the way in — trim, strip separators, case-fold,
parse several date formats — and render one canonical format on the way out.
Fail only when the input is genuinely unresolvable, and preserve what was typed.

## Motivation & Experience

### Aesthetic-Usability Effect

**What it says.** People perceive attractive designs as easier to use, and will
tolerate — and under-report — minor usability problems in a beautiful interface.

**Violation signal.** Browser-default `<select>` and `<input>` controls sitting
beside custom design-system components; five near-identical grays, three type
scales, and inconsistent radii inside one view; misaligned baselines across
adjacent cards. In research, the mirror signal: testers praising the visuals
while task-completion or error rates stay poor.

**Fix pattern.** Fund the visual pass — consistent tokens, aligned grid, styled
form controls — because it buys real goodwill. In testing, judge on completion
time and error count, never on how good participants say it looks.

### Flow

**What it says.** Flow is full immersion in a task, sustained when challenge and
skill stay balanced and nothing breaks concentration.

**Violation signal.** A newsletter, cookie, or survey modal firing mid-task; a
guided tour replayed on every visit; autosave or a websocket update stealing
focus out of the field being typed in; a session timeout that discards
in-progress work; a toast overlaying the input area; a mandatory step that
cannot be skipped by an expert user.

**Fix pattern.** Defer every interruption to a task boundary, and never move
focus the user did not ask to move. Autosave and restore work, keep expert
shortcuts open, and scale assistance down as the user gets faster.

### Goal-Gradient Effect

**What it says.** Motivation increases as the goal gets closer, and progress
already granted at the start pulls people further than a cold start does.

**Violation signal.** A five-step checkout with no progress indicator; a loyalty
card starting at 0 of 10 with no head start; a progress bar that moves backward
or gains steps mid-flow; "Step 1 of many"; a rewards screen showing points
earned but not the distance to the next tier; an upload bar stuck at 99%.

**Fix pattern.** Show progress and, above all, show what remains. Grant a head
start where honest (two stamps pre-filled on a twelve-stamp card), keep the
step count fixed once shown, and make the last stretch feel short.

### Peak-End Rule

**What it says.** People judge an experience by its most intense moment and its
ending, not by the average of every moment in it.

**Violation signal.** A polished purchase flow ending on a bare "Success." page
or an immediate redirect to the homepage with no receipt; a deletion that ends
with no undo window; an unexplained failure at the payment step as the sharpest
moment of the flow; onboarding that concludes on an empty dashboard with
nothing to do next.

**Fix pattern.** Invest disproportionately in the ending — confirmation with the
concrete detail, a receipt, an undo window, an obvious next action — and hunt
down the single worst moment (usually an error state) and soften it.

### Jakob's Law

**What it says.** Users spend most of their time on other products, so they
expect yours to work the way everything else they know already works.

**Violation signal.** A logo that does not link to home; a cart or account entry
point somewhere other than the top right; hijacked scrolling or a custom
scrollbar; a hamburger opening a full-screen carousel instead of a menu; a
search field with no recognizable affordance; a form's primary action placed
opposite the platform convention.

**Fix pattern.** Follow the platform and category conventions by default and
spend novelty only where it is the actual value proposition. When you must
break a convention, keep the conventional path working alongside the new one.

### Paradox of the Active User

**What it says.** Users never read the manual. They start acting immediately and
learn by doing, even when reading first would be faster.

**Violation signal.** A six-screen intro carousel gating first use; an empty
state whose only content is a link to documentation; help available solely
under a Help menu or in a separate docs site; a feature whose explanation lives
in a changelog entry; a first run that requires configuration before anything
works.

**Fix pattern.** Teach inside the task: contextual hints at the moment of need,
an empty state that offers a first concrete action or sample data, and defaults
that work without configuration. Let the user act first and explain in place.
