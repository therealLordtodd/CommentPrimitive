# CommentPrimitive — Document Editor Family Membership

This primitive is a member of the Document Editor primitive family. It provides review-comment model and UI support with typed anchors, quote selectors, threads, and status transitions.

**Note:** CommentPrimitive is one of three primitives (with TrackChangesPrimitive and BookmarkPrimitive) that independently implement an **anchor pattern** — a typed anchor + quote selector used to pin review annotations to document positions. Whether these three should converge on a shared `AnchorKit` or remain parallel by design is a [pending family-level decision](../docs/plans/2026-04-19-document-editor-dependency-audit.md#6-pending-coordinated-changes).

## Conventions This Primitive Participates In

- [x] [shared-types](../CONVENTIONS/shared-types-convention.md) — defines own anchor model (parallel to TrackChanges/Bookmark)
- [ ] [typed-static-constants](../CONVENTIONS/typed-static-constants-convention.md) — not participating
- [x] [document-editor-family-membership](../CONVENTIONS/document-editor-family-membership.md)

## Shared Types This Primitive Defines

- Typed anchors + quote selectors for comment pinning
- Comment thread model, status transitions
- Consumed by: `DocumentPrimitive`, `RichTextEditorKit`, hosts

## Shared Types This Primitive Imports

- (none from the family — Foundation only)

## Siblings That Hard-Depend on This Primitive

- `DocumentPrimitive` — composes comments into the document review surface
- `RichTextEditorKit` — re-exports comment surface

## Ripple-Analysis Checklist Before Modifying Public API

1. **Anchor model changes**: also consider whether the change should unify with TrackChangesPrimitive's and BookmarkPrimitive's anchor models (family convergence question — §6 of dep audit).
2. Changes to thread/status model: affects DocumentPrimitive + hosts rendering review state.
3. Consult [dependency audit](../docs/plans/2026-04-19-document-editor-dependency-audit.md).
4. Document ripple impact in the commit/PR.

## Scope of Membership

Applies to modifications of CommentPrimitive's own code. Consumers just importing for their own app are unaffected.
