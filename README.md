# plan-review-skill-codex

A Codex skill that generates visual, browser-viewable review artifacts from a plan before implementation begins.

See the proposed build before implementation starts.

## What it generates

After planning a feature or app, this skill produces a single-page review app (`_plan-review/index.html`) with up to four tabs. Only applicable tabs are shown, so an API-only plan skips Mockups automatically.

### Mockups

High-fidelity HTML/CSS screens intended to set implementation expectations early.

![Dashboard with project cards, progress bars, and sidebar navigation](docs/screenshots/mockups-dashboard.png)

![Kanban board with four columns and task cards](docs/screenshots/mockups-kanban.png)

<details>
<summary>More mockup examples</summary>

**Task Detail Modal** - full task view with comments, labels, priority, and assignee:

![Task detail modal with comments and metadata](docs/screenshots/mockups-task-detail.png)

**Project Settings** - member management and project metadata:

![Project settings with members table and project details](docs/screenshots/mockups-settings.png)

**Analytics Dashboard** - KPI cards, charts, and recent activity:

![Analytics dashboard with KPI cards and charts](docs/screenshots/mockups-analytics.png)

</details>

### Data Models

Mermaid-style ER overviews, dense entity cards, enums, indexes, lifecycle flows, and design notes.

![Data models overview with ER diagram and index table](docs/screenshots/data-models.png)

![Entity cards with field tables and constraint badges](docs/screenshots/data-models-entities.png)

### Architecture

Annotated folder structure, module relationship diagrams, and pattern cards explaining the reasoning behind structural choices.

![Architecture overview with folder tree and module relationships](docs/screenshots/architecture.png)

### Concerns

An interactive checklist of risks, gaps, and tradeoffs, organized by severity and intended for review before implementation starts.

![Plan concerns with severity badges and review tracking](docs/screenshots/concerns.png)

## Installation

Install this repo as a local Codex skill in your Codex skills directory using the files under `plan-review/`.

## Usage

Trigger the skill explicitly:

```text
$plan-review
```

Or ask naturally:

- "review the plan"
- "show me what we're building"
- "let me see the mockups"
- "hold on, let me see this first"

## How it works

```text
Plan a feature      Run $plan-review      Review in browser      Iterate
with Codex     ->   generates index.html -> mockups, models, -> give feedback,
                                           architecture,       update review
                                           concerns
```

1. Plan the feature in conversation.
2. Run `$plan-review` and let the skill generate `_plan-review/index.html`.
3. Review the output in a browser and iterate on the design.
4. Start implementation only after the review looks right.

The `_plan-review/` directory is intended for generated artifacts and is ignored by git in this repository.

## What makes the output good

- Realistic content instead of placeholders
- Complete data-model coverage with fields, types, constraints, enums, and indexes
- Browser-viewable review artifacts in a single file
- Actionable concerns that surface likely rework before implementation starts
- Dense, developer-friendly presentation instead of presentation-deck styling

## Repository Layout

- `plan-review/SKILL.md`: source of truth for the skill behavior
- `plan-review/agents/openai.yaml`: skill metadata
- `evals/evals.json`: example prompts
- `evals/assertions.json`: shared and scenario-specific checks
- `docs/demo/index.html`: local demo artifact used to capture README screenshots
- `docs/capture-screenshots.ps1`: Playwright capture script for regenerating screenshots

## Refreshing screenshots

The screenshots in `docs/screenshots/` are generated locally from `docs/demo/index.html` with Playwright.

```powershell
powershell -ExecutionPolicy Bypass -File .\docs\capture-screenshots.ps1
```

## Credits

This Codex adaptation is based on the original Claude version `plan-review` project by [Joel Brinkley](https://github.com/joelbrinkley) (`@joelbrinkley`).

Original repository: https://github.com/joelbrinkley/plan-review-skill
