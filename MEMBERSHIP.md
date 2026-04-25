# CommentPrimitive — Cross-Family Membership

This primitive is a **cross-family contract**. It is declared in:

- [Document Editor family](../CONVENTIONS/document-editor-family-membership.md) — provides review comments with typed anchors, quote selectors, threads, status transitions for document-style apps
- [ReaderKit family](../CONVENTIONS/readerkit-family-membership.md) — annotation source of truth for comments across all media types in reader sessions
- [TemporalMediaKit family](../CONVENTIONS/temporalmediakit-family-membership.md) — comments anchored to timestamps within audio/video runtime sessions

Public API changes follow the ripple checklist in **all three** families per the [Cross-Family Contracts Convention](../CONVENTIONS/cross-family-contracts-convention.md).

**Note:** CommentPrimitive is one of three primitives (with `TrackChangesPrimitive` and `BookmarkPrimitive`) that independently implement an **anchor pattern**. Whether they should converge on a shared `AnchorKit` or remain parallel is a [pending family-level decision](../RichTextEditorKit/docs/plans/2026-04-19-document-editor-dependency-audit.md#6-pending-coordinated-changes).

## Conventions This Primitive Participates In

- [x] [shared-types](../CONVENTIONS/shared-types-convention.md) — defines own anchor model (parallel to TrackChanges/Bookmark)
- [x] [cross-family-contracts](../CONVENTIONS/cross-family-contracts-convention.md)
- [x] [document-editor-family-membership](../CONVENTIONS/document-editor-family-membership.md)
- [x] [readerkit-family-membership](../CONVENTIONS/readerkit-family-membership.md)
- [x] [temporalmediakit-family-membership](../CONVENTIONS/temporalmediakit-family-membership.md)

## Cross-Family Role Notes

- **In Document Editor family**: comments are review threads pinned to ranges in a `DocumentPrimitive` document, consumed by `RichTextEditorKit` for review-mode rendering.
- **In ReaderKit family**: comments are user annotations on reader-session content, persisted as the canonical annotation record regardless of which renderer produced the anchor.
- **In TemporalMediaKit family**: comments anchor to timestamps within an `AudioTrack`. The same `CommentAnchor` and `TextQuoteSelector` shapes work across text and time-based anchors.

## Shared Types This Primitive Defines

- Typed anchors + `TextQuoteSelector` (resilient to offset drift)
- Comment thread model + status transitions
- `CommentStore` mutation surface with observable `CommentMutation` events
- Consumed by: `DocumentPrimitive`, `RichTextEditorKit`, ReaderKit hosts, TemporalMediaKit hosts

## Shared Types This Primitive Imports

- (none from any family — Foundation only)

## Siblings That Hard-Depend on This Primitive

In Document Editor family:
- `DocumentPrimitive` — composes comments into the document review surface
- `RichTextEditorKit` — re-exports comment surface

In ReaderKit family:
- ReaderKit hosts — persistent comment records across reader sessions

In TemporalMediaKit family:
- `AudiobookKit`, `PodcastKit` — timestamp-anchored comments

## Ripple-Analysis Checklist Before Modifying Public API

1. **Anchor model changes**: also consider whether the change should unify with `TrackChangesPrimitive`'s and `BookmarkPrimitive`'s anchor models (Document Editor family convergence question — §6 of dep audit).
2. **Run the [Document Editor ripple checklist](../CONVENTIONS/document-editor-family-membership.md)**.
3. **Run the [ReaderKit ripple checklist](../CONVENTIONS/readerkit-family-membership.md#readerkit-specific-ripple-checklist)**.
4. **Run the [TemporalMediaKit ripple checklist](../CONVENTIONS/temporalmediakit-family-membership.md#temporalmediakit-specific-ripple-checklist)**.
5. **Thread/status model changes** affect DocumentPrimitive + every host rendering review state.
6. **`TextQuoteSelector` drift behavior**: subtle semantic; document fallback rules explicitly when changing.
7. Consult [Document Editor dependency audit](../RichTextEditorKit/docs/plans/2026-04-19-document-editor-dependency-audit.md).
8. Document the union of family impacts in the commit/PR body.

## Scope of Membership

Applies to modifications of CommentPrimitive's own code. Consumers just importing for their own app are unaffected.
