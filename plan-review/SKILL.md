---
name: plan-review
description: Generates visual, browser-viewable review artifacts from a plan before implementation begins. Creates a single `_plan-review/index.html` review app with high-fidelity HTML/CSS mockups of UI screens, comprehensive data model references (entity cards, Mermaid ER diagrams, enums, indexes, lifecycle flows), architecture visualizations (folder structure, module relationships, key patterns), and an interactive plan concerns checklist highlighting risks, gaps, and tradeoffs. Use this skill whenever the user wants to review or visualize a plan before coding starts, asks to preview planned work visually, or says things like "review the plan", "show me what we're building", "let me see the mockups", "visualize the architecture", "what will this look like", "let me review before we start", or "hold on, let me see this first". Also use when the user explicitly invokes `$plan-review`.
---

# Plan Review

Generate visual, browser-viewable artifacts from the current plan so the user can review and iterate on the design before any implementation begins. The goal is to catch architectural mistakes, misaligned UI expectations, and data model issues early, when they are still cheap to fix.

Read the current plan from the conversation context, including any plan blocks, decisions, and constraints already discussed. If no plan exists, ask the user to describe it first. Then generate only the artifacts that apply to the plan. Not every plan needs every artifact.

Stay in review mode while using this skill. Generate and iterate on the review artifacts, but do not start implementing the planned feature itself until the user confirms the review looks right.

## Which artifacts to generate

| Artifact | Generate when... |
|----------|-----------------|
| UI Mockups | The plan includes any user-facing screens, pages, views, dashboards, or visual interfaces |
| Data Model Reference | The plan involves databases, entities, models, schemas, or structured data with relationships |
| Architecture Overview | Always — every plan has code organization decisions worth reviewing |
| Plan Concerns | Always — review the plan for risks, gaps, and tradeoffs the user should address |

## Output: Single-page review app

Generate everything into a single `_plan-review/index.html` file. Add `_plan-review/` to `.gitignore` if it exists and doesn't already include it — these are review artifacts, not documentation.

### Navigation

The page has a fixed top navigation bar with tabs for each applicable artifact. Only show tabs for artifacts that were generated (e.g., skip "Mockups" if the plan has no UI). Clicking a tab shows that section and hides the others.

If the plan has **multiple mockup screens**, add a secondary sub-navigation (e.g., horizontal pills or a sidebar) within the Mockups tab so the user can switch between screens without leaving the tab.

Navigation structure:
- **Mockups** (with sub-nav for each screen if multiple)
- **Data Models**
- **Architecture**
- **Concerns**

Use JavaScript to handle tab switching — show/hide sections by toggling a class. Keep it simple. Highlight the active tab. Default to the first available tab on load.

**Critical: Mermaid + hidden tabs.** Mermaid cannot render diagrams inside `display: none` containers. The Mermaid `<pre>` blocks are in the Data Models and Architecture tabs, which are hidden on page load. To fix this, call `mermaid.run()` whenever a tab containing Mermaid diagrams becomes visible. Example:

```js
btn.addEventListener('click', () => {
  // ... show/hide tab logic ...
  // Re-render any Mermaid diagrams in the newly visible tab
  const activeSection = document.getElementById(btn.dataset.tab);
  const mermaidBlocks = activeSection.querySelectorAll('.mermaid[data-processed]');
  if (mermaidBlocks.length > 0) {
    // Already processed but may not have rendered — re-run
    mermaid.run({ querySelector: '#' + btn.dataset.tab + ' .mermaid' });
  }
});
```

Do not eagerly call `mermaid.run()` for hidden Mermaid sections during initial page load. Only render the default active tab on load, and render Mermaid for Data Models or Architecture when those tabs are activated.

Alternatively, use `visibility: hidden` + `position: absolute` + `height: 0; overflow: hidden` instead of `display: none` for hidden sections — this lets Mermaid render on page load since elements exist in the layout. Then switch to normal visibility when the tab is active. This is the simpler approach and avoids needing to re-trigger Mermaid.

Because these review artifacts are usually opened from `file://`, initialize Mermaid with `securityLevel: 'loose'` so local previews do not trip sandbox or unique-origin browser restrictions.

The nav bar should be clean, minimal, and fixed to the top so it's always accessible while scrolling through content.

After generating, open `_plan-review/index.html` in the default browser when the environment allows it. If automatic opening is not available, tell the user the exact file path and continue with the review summary.

---

## 1. UI Mockups

These must be **high fidelity**. The user expects the final implementation to closely match what they see here. These are not wireframes or sketches — they should look like a real app.

### How to build them

Generate standalone HTML files with embedded CSS. One file per screen or major view. No external CSS frameworks — write the CSS directly so you have full control.

**Design system to follow:**
- Define CSS custom properties at `:root` for colors, spacing, and typography so the whole mockup feels cohesive
- Font stack: `-apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif`
- Spacing scale based on 4px increments (4, 8, 12, 16, 24, 32, 48, 64)
- Use subtle shadows (`box-shadow: 0 1px 3px rgba(0,0,0,0.1)`) and border-radius (6-8px) for a modern feel
- Interactive elements should have `:hover` and `:focus` states via CSS
- Use CSS grid and flexbox for layout

**Content must be realistic:**
- Use plausible names, dates, numbers, and text — not "Lorem ipsum" or "User 1"
- Tables should have 4-6 rows of believable data
- Forms should have proper labels, placeholders, and field types
- Show realistic states: populated dashboards, filled forms, lists with items

**Each mockup must include:**
- Navigation/header if the app has one (keep consistent across screens)
- All UI elements described in the plan for that screen
- Proper visual hierarchy — headings, sections, whitespace
- Responsive considerations via media queries if the plan mentions mobile/responsive

**Keep it focused:**
- Only mock up what the plan describes — don't invent extra features
- JavaScript is optional — only include it if it helps communicate the design (e.g., tab switching, modal toggling, sidebar collapse)
- The goal is visual communication, not a working prototype

### Template

```html
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>[Screen Name] — Plan Review</title>
  <style>
    :root {
      --color-primary: #2563eb;
      --color-primary-hover: #1d4ed8;
      --color-bg: #f8fafc;
      --color-surface: #ffffff;
      --color-text: #1e293b;
      --color-text-secondary: #64748b;
      --color-border: #e2e8f0;
      --color-success: #16a34a;
      --color-warning: #d97706;
      --color-danger: #dc2626;
      --radius: 8px;
      --shadow: 0 1px 3px rgba(0,0,0,0.1);
      --shadow-lg: 0 4px 12px rgba(0,0,0,0.1);
    }

    *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }

    body {
      font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
      background: var(--color-bg);
      color: var(--color-text);
      line-height: 1.6;
    }

    /* Build the rest of the mockup styles here */
  </style>
</head>
<body>
  <!-- Mockup content here -->
</body>
</html>
```

---

## 2. Data Model Reference

Build a comprehensive, single-page data model reference. This is not just a diagram — it's a full visual specification of every entity, field, relationship, enum, index, and design decision. The page has multiple sections, each serving a different purpose during review.

### Page sections (in order)

1. **Header** — Title, subtitle with entity/enum counts and database technology, and a compact legend for field badges (PK, FK, Req, UQ, Idx).
2. **Mermaid ER Diagram** — A Mermaid `erDiagram` for visual overview of entity relationships and cardinality. Only key fields in the diagram — full details are in the entity cards.
3. **Entity Cards** — One compact card per entity in a 2-column grid. Each card has a header row (entity name, description, role badge) and a dense fields table (Field, Type, Constraints, Notes). The primary entity spans full width. Include seed data previews as their own card if the plan specifies seed data.
4. **Enumerations** — A 3-4 column grid of compact enum cards with values and numeric assignments.
5. **Indexes** — A single card with dense rows listing all planned database indexes.
6. **Lifecycle / State Flows** — If any entity has state transitions (e.g., Draft → Active → Archived), show a compact horizontal flow with labeled arrows.
7. **Design Notes** — A tight bulleted list of non-obvious decisions, constraints, and discussion points.

### Mermaid ER diagram

Include this near the top of the page inside a clean container. It gives a quick visual overview of how entities relate.

**Critical Mermaid syntax rules** — these cause silent render failures if violated:
- **No duplicate relationship pairs.** Mermaid does not allow two relationship lines between the same two entities. If Entity A relates to Entity B in multiple ways (e.g., Task has both `assigneeId` and `createdById` pointing to User), only draw ONE line and combine the labels: `USER ||--o{ TASK : assignee_creator`. Do NOT write two separate lines like `USER ||--o{ TASK : assigns` and `USER ||--o{ TASK : creates` — this will cause a syntax error.
- **No circular pairs.** If you already have `A ||--o{ B`, do not also add `B }o--|| A`. One line per pair, period.
- **Keep relationship labels short and plain** — prefer a single bare word or snake_case token such as `owns`, `contains`, or `assignee_creator`. Avoid quoted labels, slashes, parentheses, and other punctuation in relationship labels.
- **Use simple entity names** — `PascalCase` or `UPPER_SNAKE_CASE`, no spaces, no hyphens.
- **Only include key fields** in the Mermaid entity blocks (PK, FK, and 2-3 important domain fields). The full field list goes in the entity cards below, not in the diagram.

```
erDiagram
    USER ||--o{ ORDER : places
    ORDER ||--|{ LINE_ITEM : contains
    PRODUCT ||--o{ LINE_ITEM : ordered_as
    USER {
        uuid id PK
        string email
        string name
    }
    ORDER {
        uuid id PK
        uuid user_id FK
        string status
    }
```

### Entity card design

Each entity gets a compact card with:
- **Header row**: Entity name (monospace, bold), one-line description, and a small role badge (Core, Ref, Tenant, Join, Owned, Seed)
- **Fields table**: Four tight columns — Field (monospace), Type (monospace, muted), Constraints (tiny badges: PK, FK, Req, UQ, Idx), and Notes (brief)
- Use monospace for field names and types (`'JetBrains Mono', Consolas, monospace`)
- Color-code badges by type: PK = indigo, FK = amber, Req = green, UQ = pink, Idx = gray

The primary entity (central to the feature) spans the full grid width (`grid-column: span 2`). All other entities fit in a 2-column grid.

### Enum cards

Display in a 3-4 column grid. Compact cards — enum name in monospace header, values listed tightly with numeric assignment and optional inline note.

### Index listing

Use a proper `<table>` with fixed column widths so everything aligns cleanly. Columns: Type (badge, narrow), Index Name (monospace, fixed width), Columns (monospace), and Description. Use `table-layout: fixed` and explicit column widths to prevent content from pushing columns out of alignment. Every row must line up — misaligned tables are hard to scan.

```html
<table class="index-table" style="table-layout:fixed; width:100%;">
  <colgroup>
    <col style="width:70px">   <!-- Type badge -->
    <col style="width:40%">    <!-- Index name -->
    <col style="width:25%">    <!-- Columns -->
    <col>                      <!-- Description -->
  </colgroup>
  <thead><tr><th>Type</th><th>Index Name</th><th>Columns</th><th>Description</th></tr></thead>
  <tbody><!-- rows --></tbody>
</table>
```

### Styling guidelines

Design for **information density** — this is a developer reference tool, not a marketing page. Think VS Code sidebar, pgAdmin, or a database management UI. Every pixel should earn its place.

**Density principles:**
- Small font sizes: 13px body, 12px table cells, 11px badges, 10px muted labels
- Tight padding: 8-12px card padding, 4-6px table cell padding, 2px badge padding
- Minimal border-radius: 4px cards, 3px badges — not bubbly
- No decorative shadows — use 1px borders instead (`border: 1px solid #e2e8f0`)
- No hover animations or transitions — static and fast
- Compact spacing between sections: 12-16px gaps, not 24-32px
- Tables should feel like a database viewer — tight rows, alternating subtle background optional

**Color palette (cool, muted, functional):**
- Background: `#f8fafc`
- Surface/cards: `#fff` with `border: 1px solid #e2e8f0`
- Text: `#1e293b` primary, `#64748b` secondary, `#94a3b8` muted
- Primary accent: `#6366f1` (indigo)
- Use monospace font stack for all data: field names, types, index names, enum values

**Font stack:**
```html
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=JetBrains+Mono:wght@400;500&display=swap" rel="stylesheet">
```
Inter for headings/labels, JetBrains Mono for all data content.

### What to include

- Every entity/model/table from the plan — nothing omitted
- All fields with their types, constraints, and brief notes
- All relationships with cardinality and cascade behavior
- All enums with their values
- All indexes the plan specifies or implies
- State/lifecycle transitions if any entity has them
- Seed data if the plan specifies initial records
- Design notes covering non-obvious decisions, implementation constraints, and discussion points

Load Mermaid from CDN for the ER diagram:
```html
<script src="https://cdn.jsdelivr.net/npm/mermaid@11/dist/mermaid.min.js"></script>
<script>mermaid.initialize({ startOnLoad: false, theme: 'neutral', securityLevel: 'loose' });</script>
```

---

## 3. Architecture Overview

This artifact visualizes code organization decisions. It has three sections, each in a collapsible `<details>` block.

### Section A: Folder Structure

Show the planned directory layout as a visual tree with brief annotations explaining what each directory is responsible for. This helps the user see at a glance whether responsibilities are grouped logically.

```
src/
├── components/        # Reusable UI components
│   ├── common/        # Shared across features (Button, Modal, Input)
│   └── features/      # Feature-specific component groups
├── hooks/             # Custom hooks
├── services/          # API clients and external integrations
├── models/            # Data models and type definitions
├── utils/             # Pure utility functions
└── pages/             # Route-level page components
```

### Section B: Module Relationships

Use a Mermaid flowchart to show how major modules or layers depend on each other. This reveals dependency direction and helps catch circular dependencies or misplaced responsibilities.

```
graph TD
    Pages --> Components
    Pages --> Hooks
    Hooks --> Services
    Services --> Models
    Components --> Models
```

Use clear, readable labels. Color-code by concern if there are many nodes (use Mermaid's `style` or `classDef`).

### Section C: Key Patterns & Decisions

For each significant architectural decision in the plan, present a "pattern card" explaining:
- **What**: The pattern or approach being used
- **Why**: The rationale — why this over alternatives
- **In practice**: What this means concretely for how code should be written

These cards are the most important part of the architecture review. They surface the thinking behind the structure so the user can challenge or refine it before implementation locks it in.

### Template

```html
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Architecture — Plan Review</title>
  <style>
    body {
      font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
      max-width: 1000px;
      margin: 0 auto;
      padding: 2rem;
      background: #f8fafc;
      color: #1e293b;
    }
    h1 { margin-bottom: 0.25rem; }
    .subtitle { color: #64748b; margin-bottom: 2rem; font-size: 1.05rem; }
    details {
      background: white;
      border-radius: 8px;
      padding: 1.5rem 2rem;
      margin-bottom: 1rem;
      box-shadow: 0 1px 3px rgba(0,0,0,0.1);
    }
    summary {
      font-size: 1.15rem;
      font-weight: 600;
      cursor: pointer;
      padding: 0.25rem 0;
      user-select: none;
    }
    summary:hover { color: #2563eb; }
    details[open] summary { margin-bottom: 1rem; }
    .folder-tree {
      font-family: 'Cascadia Code', 'Fira Code', 'Consolas', monospace;
      font-size: 0.9rem;
      line-height: 1.9;
      background: #f1f5f9;
      padding: 1.5rem;
      border-radius: 6px;
      overflow-x: auto;
      white-space: pre;
    }
    .folder-tree .annotation {
      color: #64748b;
      font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif;
      font-size: 0.85rem;
    }
    .pattern-card {
      border-left: 3px solid #2563eb;
      padding: 1rem 1.5rem;
      margin: 1rem 0;
      background: #f1f5f9;
      border-radius: 0 8px 8px 0;
    }
    .pattern-card h3 {
      margin: 0 0 0.5rem 0;
      font-size: 1.05rem;
      color: #1e293b;
    }
    .pattern-card p {
      margin: 0.3rem 0;
      color: #475569;
      font-size: 0.95rem;
      line-height: 1.6;
    }
    .pattern-card .label {
      font-weight: 600;
      color: #334155;
    }
  </style>
</head>
<body>
  <h1>Architecture Overview</h1>
  <p class="subtitle">Code organization, module relationships, and key patterns</p>

  <details open>
    <summary>Folder Structure</summary>
    <div class="folder-tree">
      <!-- Annotated folder tree here -->
    </div>
  </details>

  <details open>
    <summary>Module Relationships</summary>
    <pre class="mermaid">
      graph TD
        %% Module dependency diagram here
    </pre>
  </details>

  <details open>
    <summary>Key Patterns &amp; Decisions</summary>
    <!-- One pattern-card per decision -->
    <div class="pattern-card">
      <h3>Pattern Name</h3>
      <p><span class="label">What:</span> Description of the pattern or approach</p>
      <p><span class="label">Why:</span> Rationale and what alternatives were considered</p>
      <p><span class="label">In practice:</span> What this means concretely for implementation</p>
    </div>
  </details>

  <script src="https://cdn.jsdelivr.net/npm/mermaid@11/dist/mermaid.min.js"></script>
  <script>mermaid.initialize({ startOnLoad: false, theme: 'neutral', securityLevel: 'loose' });</script>
</body>
</html>
```

---

## 4. Plan Concerns

Critically review the plan and surface anything the user should think about, decide on, or be aware of before implementation begins. This is an interactive HTML checklist — the user can mark each concern as reviewed as they work through them.

### What to look for

Analyze the plan with an architect's eye. Look for:

- **Missing requirements**: Features referenced but not specified, edge cases not handled, error states not defined
- **Data model risks**: Missing indexes for likely query patterns, no soft delete strategy, ambiguous relationships, potential N+1 query patterns, missing audit fields
- **Security gaps**: Missing auth/authorization checks, unvalidated inputs, sensitive data without encryption, missing rate limiting
- **Scalability concerns**: Unbounded queries, missing pagination, no caching strategy for hot paths, synchronous operations that should be async
- **API design issues**: Inconsistent naming, missing versioning, no error response format defined, overfetching/underfetching
- **Ambiguities**: Places where the plan could be interpreted multiple ways, decisions that seem implicit but should be explicit
- **Missing infrastructure**: No migration strategy, no rollback plan, no feature flags, no monitoring/logging plan
- **Dependency risks**: External services without fallback, tight coupling between modules, circular dependencies

Don't be pedantic — focus on things that would actually cause problems or significant rework. Each concern should be actionable.

### Severity levels

Categorize each concern:
- **Critical** (red) — Must be resolved before implementation. Would cause data loss, security vulnerabilities, or fundamental architecture problems.
- **Important** (amber) — Should be addressed before implementation. Would cause significant rework if discovered later.
- **Consider** (blue) — Worth thinking about. May be fine as-is, but the tradeoffs should be consciously accepted.

### Interactive behavior

Each concern is a card that can be clicked/toggled to mark as "Reviewed". Use JavaScript to:
- Toggle a `.reviewed` class on click
- Show a checkmark and muted styling when reviewed
- Track how many concerns remain unreviewed (show count in header)
- Persist state in `localStorage` so the user can close and reopen the page without losing progress

### Page structure

- **Header**: Title, subtitle with total concern count, and a progress bar showing reviewed/total
- **Filter buttons**: All, Critical, Important, Consider, Unreviewed
- **Concern cards**: Each card has a visible **number** (e.g., #1, #2, #3), severity badge, title, description explaining the risk, and a suggestion for how to address it. Number concerns sequentially starting at 1 so the user and LLM can reference them easily (e.g., "resolve concern #4")
- **Summary footer**: "X of Y concerns reviewed" with a clear visual indicator when all are done

### Styling

Match the same design language as the other review artifacts (cool-toned, clean, modern). Concern cards should have a left border colored by severity. Reviewed cards should fade slightly (opacity or muted colors) so unreviewed ones stand out.

### Template structure

```html
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Plan Concerns — Plan Review</title>
  <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
  <style>
    /* Same design system as other artifacts */
    /* Severity colors: critical=#ef4444, important=#f59e0b, consider=#3b82f6 */
    /* .reviewed state: opacity 0.6, strikethrough on title, checkmark icon */
    /* Filter buttons: pill-shaped toggles */
    /* Progress bar: thin bar under header */
  </style>
</head>
<body>
  <header>
    <h1>Plan Concerns</h1>
    <p class="subtitle">Review these before implementation</p>
    <div class="progress-bar"><!-- JS-driven --></div>
    <div class="filters">
      <button class="filter active" data-filter="all">All</button>
      <button class="filter" data-filter="critical">Critical</button>
      <button class="filter" data-filter="important">Important</button>
      <button class="filter" data-filter="consider">Consider</button>
      <button class="filter" data-filter="unreviewed">Unreviewed</button>
    </div>
  </header>
  <main>
    <!-- Concern cards -->
    <div class="concern-card" data-severity="critical" data-id="1" onclick="toggleReviewed(this)">
      <div class="concern-header">
        <span class="concern-number">#1</span>
        <span class="severity-badge critical">Critical</span>
        <span class="review-check"><!-- checkmark when reviewed --></span>
      </div>
      <h3>Concern Title</h3>
      <p class="concern-desc">What the risk is and why it matters.</p>
      <p class="concern-suggestion"><strong>Suggestion:</strong> How to address it.</p>
    </div>
  </main>
  <script>
    // Toggle reviewed state, persist to localStorage, update progress bar and counts
    // Filter functionality for severity levels and unreviewed
  </script>
</body>
</html>
```

---

## Presenting to the user

After generating `_plan-review/index.html`:

1. Open it in the default browser if possible
2. Summarize what you generated: which tabs are available, which screens were mocked up, which entities are in the data model, and which patterns are documented
3. Ask the user to review and tell you what they'd like to change
4. Say: **"Let me know what changes you'd like before we start implementing."**

When the user provides feedback:
- Update the affected sections in `index.html`
- Re-open the file in the browser if possible, or restate the file path if not
- Repeat until the user approves

**Do not proceed with implementation until the user confirms the review artifacts look right.** The entire point of this skill is to iterate cheaply on design before writing real code.

## Quality checklist

Before presenting the review page, verify:
- [ ] Tab navigation works — clicking each tab shows the correct section and hides others
- [ ] Mockup sub-navigation works if there are multiple screens
- [ ] Mockups use realistic content (names, data, dates), not placeholder text
- [ ] Mockups cover every screen described in the plan, nothing added or omitted
- [ ] Data model includes ALL entities from the plan — every entity the plan will build, with all fields, relationships, enums, and indexes
- [ ] Architecture folder structure matches what the plan describes
- [ ] Pattern cards explain the *why*, not just the *what*
- [ ] Plan concerns are actionable and categorized by severity — not pedantic nitpicks
- [ ] Concern cards have working toggle/reviewed state with localStorage persistence
- [ ] Mermaid diagrams render correctly (CDN loads)
- [ ] Mermaid initializes safely for local `file://` viewing (`securityLevel: 'loose'`)
- [ ] The `_plan-review/` directory is added to `.gitignore`
