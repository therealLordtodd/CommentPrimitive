# CommentPrimitive — Project Constitution

**Created:** 2026-04-16
**Authors:** Todd Cowing + Claude (Opus 4.7)

This document records the *why* behind foundational decisions. It is written for future collaborators — human and AI — who weren't in the room when these choices were made. The development plan tells you what we're building. AGENTS.md tells you how to build it. This document tells you why we made the decisions we made, and where we believe this is going.

Fill in the project-specific sections as decisions are made. The **Founding Principles** apply to every project in the portfolio without exception — they are the intent behind the work. The **Portfolio-Wide Decisions** are pre-filled conventional choices that follow from those principles; they apply unless explicitly overridden here with a documented reason.

---

## What CommentPrimitive Is Trying to Be

CommentPrimitive is a portable comment and review-thread model for apps. It provides `Comment`, `CommentReply`, `CommentStatus`, typed anchors (`TextCommentAnchor`, `CellCommentAnchor`, `ObjectCommentAnchor`), a resilient `TextQuoteSelector` for anchoring that survives moderate text edits, and a small `@MainActor` observable `CommentStore` with mutation callbacks. It deliberately does not render comments, sync them to a server, or mutate documents — this is the review-state layer; host apps own the document, the UI, and any persistence or collaboration orchestration. It is the right layer when an app needs annotation and review state without coupling that logic to one specific editor.

---

## Foundational Decisions

### Shared Portfolio Doctrine

The shared founding principles and portfolio-wide defaults now live in the Foundation Libraries wiki:

- `/Users/todd/Library/CloudStorage/GoogleDrive-todd@cowingfamily.com/My Drive/The Commons/Libraries/Foundation Libraries/operations/portfolio-doctrine.md`

Use this local constitution for project-specific decisions, not copied portfolio boilerplate.

---

### Project-Specific Decisions

*Add an entry here for every significant architectural, tooling, or directional decision made for this project. Write it at decision time, not retroactively. Future collaborators need to understand the reasoning, not just the outcome.*

*Template for each entry:*

#### [Decision Title]

**Decision:** [One sentence stating what was decided.]

**Why:** [The reasoning. What alternatives were considered? What made this the right call for this project at this time? What would cause us to revisit it?]

**Trade-offs accepted:** [What are we giving up? What assumptions does this depend on?]

---

*Add more entries as decisions are made.*

---

## Tech Stack and Platform Choices

**Platform:** macOS 15+, iOS 17+
**Primary language:** Swift 6.0
**UI framework:** None — thread lists, gutter markers, popovers, and "jump to comment" live in consumers
**Data layer:** Codable value types; `AnyCommentAnchor` as the serialization boundary; `@MainActor` observable `CommentStore`

**Why this stack:** Comments are review state, not document state. One portable model serves text, spreadsheet, and object-based surfaces through typed anchors, and `TextQuoteSelector` gives the host a better-than-raw-offset fallback when the document changes underneath a comment. The package stays small and dependency-free so host apps keep ownership of persistence, sync, and presentation.

---

## Who This Is Built For

*Who are the primary users or operators of this software? Humans, AI agents, or both? This shapes everything from UI density to conductorship defaults.*

[ ] Primarily humans
[ ] Primarily AI agents
[ ] Both, roughly equally
[ ] Both — humans build it, AIs operate it
[X] Both — AIs build it, humans operate it

**Notes:** A developer-facing primitive for editors, spreadsheets, and object-based tools. AI agents can be first-class authors of comments and replies inside consuming apps via the same `CommentStore` surface humans use.

---

## Where This Is Going

[To be filled in as project direction crystallizes.]

---

## Open Questions

*None recorded yet.*

---

## Amendment Process

Use this process whenever a foundational decision changes or a new decision is added.

1. Update the relevant section in this constitution in the same change as the code/docs that motivated the update.
2. For each new or changed decision entry, include:
   - **Decision**
   - **Why**
   - **Trade-offs accepted**
   - **Revisit trigger** (what condition should cause reconsideration)
3. Add a matching row in the **Decision Log** with date and a concise summary.
4. If the amendment changes implementation rules, update `AGENTS.md` and any affected style guide files in the same change.
5. Record who approved the amendment (human + AI collaborator when applicable).

Minor wording clarifications that do not change meaning do not require a new decision entry, but should still be noted in the Decision Log.

---

## Decision Log

*Brief chronological record of significant decisions. Add an entry whenever a non-trivial decision is made that isn't already captured in the sections above.*

| Date | Decision | Decided by |
|------|----------|------------|
| 2026-04-16 | Constitution created and Founding Principles established | Both |
