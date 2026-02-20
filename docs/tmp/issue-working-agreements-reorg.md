# Reorganize CLAUDE/Codex guidance into working-agreements

## Background
Current `templates/CLAUDE.md` mixes Claude-specific instructions and shared team operating rules.

## Goal
Separate guidance into:
1. Claude-specific instructions (`templates/CLAUDE.md`)
2. Shared working agreements (`templates/docs/working-agreements/*`)
3. Codex-specific instructions (`templates/AGENTS.md`)

## Tasks
- [ ] Create `templates/docs/working-agreements/README.md` with scope boundaries
- [ ] Move shared operational rules from `templates/CLAUDE.md` into `working-agreements` docs
- [ ] Update `templates/CLAUDE.md` to reference shared docs
- [ ] Add `templates/AGENTS.md` with Codex-specific guidance and links to shared docs
- [ ] Keep `plans`/`notes` positioning clear in docs structure

## Done Criteria
- CLAUDE and AGENTS each contain only agent-specific instructions
- Shared rules are centralized under `docs/working-agreements`
- References between docs are explicit and easy to follow
