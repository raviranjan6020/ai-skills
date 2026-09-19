# Agent instructions

Tool-agnostic rules for any coding agent (Claude Code, Codex, Cursor, Kiro).
Sections 1-4 adapted from [andrej-karpathy-skills](https://github.com/multica-ai/andrej-karpathy-skills) (MIT).
Topic rules live in `rules/`. Workflows live in `skills/`.

**Tradeoff:** These bias toward caution over speed. For trivial tasks, use judgment.

## 1. Think before coding

**Don't assume. Don't hide confusion. Surface tradeoffs.**

- State assumptions explicitly. If uncertain, ask.
- If multiple interpretations exist, present them; don't pick silently.
- If a simpler approach exists, say so. Push back when warranted.
- If something is unclear, stop. Name what's confusing. Ask.

## 2. Simplicity first

**Minimum code that solves the problem. Nothing speculative.**

- No features beyond what was asked.
- No abstractions for single-use code.
- No "flexibility" or "configurability" that wasn't requested.
- No error handling for impossible scenarios.
- If you write 200 lines and it could be 50, rewrite it.

Ask: "Would a senior engineer say this is overcomplicated?" If yes, simplify.

## 3. Surgical changes

**Touch only what you must. Clean up only your own mess.**

- Don't "improve" adjacent code, comments, or formatting.
- Don't refactor things that aren't broken.
- Match existing style, even if you'd do it differently.
- Unrelated dead code: mention it, don't delete it.
- Remove imports/variables/functions that YOUR change made unused. Leave pre-existing dead code.

Test: every changed line traces directly to the request.

## 4. Goal-driven execution

**Define success criteria. Loop until verified.**

- "Add validation" → write tests for invalid inputs, make them pass.
- "Fix the bug" → write a test that reproduces it, make it pass.
- "Refactor X" → tests pass before and after.

For multi-step tasks, state a brief plan: `step → verify: check`.

## 5. Verify, don't guess

See `rules/verification.md`. Short version: every factual claim in code comments,
commit messages, and PR descriptions must come from something you ran or read this session.
Say "unverified" when it didn't.

## 6. Security and permissions

See `rules/security.md`. Short version: never read or write secrets, never run
destructive or irreversible commands without explicit confirmation, never weaken
a test or a security control to make something pass.
