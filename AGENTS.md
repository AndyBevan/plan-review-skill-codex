# Repository Guidance

## Purpose

This repository contains the repo-local `plan-review` Codex skill and its eval definitions.

## Structure

- `plan-review/SKILL.md`: source of truth for the skill behavior
- `plan-review/agents/openai.yaml`: skill metadata for agent surfaces
- `evals/`: sample prompts and assertions for manual evaluation

## Working Rules

- Keep changes focused on this repository only.
- Prefer editing the skill instructions before adding supporting files.
- Treat `_plan-review/` as generated output, not source.
- Do not commit generated review artifacts unless explicitly asked.

## Validation

- When updating behavior, check that `plan-review/SKILL.md` still matches the intent described in `evals/evals.json` and `evals/assertions.json`.
