# Fix Guardrails

## The approved list is the whole mandate

You fix the findings you were given. Not the ones you notice on the way. A
finding the user did not approve is out of scope even if it is real, even if it
is one line, even if you are already in the file.

Spotting something new is not a reason to fix it — record it under
`## Noticed, not fixed` in your report and move on.

## Scope of an individual fix

Change the narrowest thing that resolves the finding.

- A hit-target finding is fixed by giving that control a larger hit area — not
  by restyling every button.
- A spacing finding is fixed by correcting that relationship — not by
  introducing a spacing scale the project does not have.
- A grouping finding is fixed by adjusting that group's spacing or container —
  not by restructuring the component.

## When to stop and ask

Stop and report `needs-decision` rather than proceeding when a correct fix
would:

- change or add user-visible copy, claims, or labels
- alter behavior beyond presentation (submit logic, validation, navigation)
- introduce or restructure design tokens, themes, or shared primitives
- touch a shared component used by surfaces outside the reviewed scope
- require a judgement the finding does not settle (which of two plans is
  "recommended", what an empty state should say)

Explain the options and what each costs. Do not pick for the user.

## Respect the incumbent system

Use the project's existing tokens, spacing scale, and component primitives. If a
value has to be hardcoded because no token exists, say so in the report — that
absence is itself worth knowing.

## Verify before reporting

If the project has tests, a typecheck, or a build, run them after your changes
and report the result. A fix that breaks the build is not a fix. If none exist,
say that rather than implying you verified something.
