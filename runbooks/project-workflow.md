# ThinkingData Project Workflow

## One-Time Setup

1. Ensure the analyst can reach the ThinkingData admin/login page.
2. Ensure a reusable logged-in browser session exists.
3. Ensure the local skill and dossier directory exist.
4. Ensure Playwright CLI is available as the default browser executor.
5. Ensure Browser Use CLI is available only as fallback browser support.
5. Ensure SQL execution remains the main query path.

## Browser Tool Order In This Workflow

Use Playwright CLI first for:
- login-state check
- distinguishing default automation session from reusable real-browser session
- page open/recovery
- current page and project confirmation
- deterministic browser actions and debugging

Use Browser Use CLI only as fallback for:
- lightweight page-state confirmation
- quick recovery when Playwright is temporarily awkward or unstable

Do not use either browser tool for:
- replacing SQL/SPL execution
- estimating metric formulas
- solving slow server-side query runtime

## Operational Flow

### A. Entry

1. Reuse login state.
2. Open the ThinkingData environment.
3. Confirm the target project, subproject, and timezone.
4. Check whether a local dossier already covers this scope.

Playwright CLI is the default tool here because it can distinguish "default automation session not logged in" from "real reusable browser session exists but has not been attached yet". Browser Use CLI is fallback only.

If the live login state is invalid, stop here, open the real web login page for the user, and wait for login recovery. Do not continue into token-forensics or formal query prep unless the user explicitly asks for authentication debugging.

### A.1 Post-Login Decision

After login recovery:

1. Read the local dossier first.
2. Decide whether the project is query-ready, needs partial exploration, or needs full initialization.
3. Do not treat fresh login as a reason to redo full exploration.

Decision guide:
- Query-ready:
  - dossier exists
  - key fields are confirmed
  - needed metrics are already defined
  - reusable templates exist
- Partial exploration:
  - only some fields, mappings, or metrics remain unclear
- Full initialization:
  - project is new
  - dossier is broadly missing or stale
  - product logic has materially changed

### B. Initialization

Run this only when needed.

1. Record project basics.
2. Enumerate subprojects.
3. Confirm key event tables or event families.
4. Confirm platform, country, version, and user identity fields.
5. Confirm metric formulas and exclusions.
6. Save the findings to local dossier files.

Playwright CLI should do the primary page inspection here. Browser Use CLI can help with fallback page inspection, but the initialization output still must be written into the local dossier.

### C. Query

1. Start from a validated SQL/SPL template if available.
2. Adjust project ID, subproject conditions, timezone, and metric logic.
3. Execute through the SQL/WebSocket path.
4. Track execution progress explicitly.
5. Save the final SQL text if it becomes a reusable pattern.

Playwright CLI and Browser Use CLI are only helpers before or around this stage. Neither accelerates the ThinkingData backend execution itself.

### D. Output

1. Convert raw data into the agreed business template.
2. Add a short analysis line.
3. Flag any unresolved definition risks.
4. If the query revealed new knowledge, update the dossier immediately.

## What Is Cached Locally

- Project list and aliases
- Subproject list
- Common timezone and reporting date style
- Confirmed fields
- Confirmed metric definitions
- Reusable SQL/SPL snippets
- Product-specific output template
- Known exceptions and pitfalls

## What Should Not Be Repeated Every Time

These should be reused once confirmed:
- project and subproject mapping
- standard field mapping
- standard metric formulas
- standard output template
- proven SQL patterns

These should be rechecked when risk exists:
- newly added subprojects
- product logic changes
- conflicting results
- newly introduced custom fields
- requests involving previously unused metrics
- explicit user request to re-explore

## Common Failure Modes

- Using example project IDs as defaults
- Mixing project definitions across subprojects
- Reading dashboard numbers without validating metric logic
- Reinitializing everything every time
- Treating every fresh login as if the whole project must be re-explored
- Waiting on a stuck SQL page without progress checks
- Failing to write back confirmed definitions

## Recommended Response Style

- Give the exact date and timezone used
- Give the metric results in business wording
- Add a short analytical readout
- State assumptions plainly
- Mention whether the underlying query path was fully verified
