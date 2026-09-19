# Research Checklist

What a context brief must cover before any critique starts. Gather evidence;
record absence explicitly rather than silently skipping.

**Surfaces.** Which files render the target UI. Entry points, routes, and the
component tree down to the leaves that own real markup.

**Interactive elements.** Every control the user can act on: buttons, links,
inputs, selects, toggles, menus, dismissables. Record rendered size, spacing,
and label text where determinable.

**Flows.** The step sequence for each task the surface supports. Count the steps.
Note where state is saved, where it is lost, and where the user can reverse.

**Design system.** Tokens, theme files, spacing scales, typography ramps,
component primitives. Whether the target uses them or hand-rolls its own values.

**Observed behavior.** Only if the app is actually runnable and reachable:
rendered measurements, load and interaction latency, responsive behavior at
common breakpoints. Never fabricate a measurement — if it was not observed, say
so.
