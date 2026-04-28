# CommentPrimitive Working Guide

## Purpose
CommentPrimitive owns portable review comments, typed anchors, quote selectors, reply threads, status transitions, and observable comment mutations.

## Key Directories
- `Sources/CommentPrimitive`: Comment models, anchors, quote selector, and `CommentStore`.
- `Tests/CommentPrimitiveTests`: Model, selector, and store behavior tests.

## Architecture Rules
- Keep anchors serializable through `AnyCommentAnchor`; add new anchor types without breaking existing encoded documents.
- Use `TextQuoteSelector` for resilient text anchoring when offsets drift.
- Route mutations through `CommentStore` so observers receive `CommentMutation` events.
- Keep this package independent from rich text block models. Consumers bridge IDs and ranges.

## Testing
- Run `swift test` before committing.
- Add store mutation coverage in `CommentStoreTests`.
- Add selector drift/fallback cases in `TextQuoteSelectorTests`.
- Add Codable coverage in `ModelTests` when changing comments or anchors.

---

## Family Membership — Document Editor

This primitive is a member of the Document Editor primitive family. It participates in shared conventions and consumes or publishes cross-primitive types used by the rich-text / document / editor stack.

**Before modifying public API, shared conventions, or cross-primitive types, consult:**
- `../RichTextEditorKit/docs/plans/2026-04-19-document-editor-dependency-audit.md` — who depends on whom, who uses which conventions
- `/Users/todd/Building - Apple/Packages/CONVENTIONS/` — shared patterns this primitive participates in
- `./MEMBERSHIP.md` in this primitive's root — specific list of conventions, shared types, and sibling consumers

**Changes that alter public API, shared type definitions, or convention contracts MUST include a ripple-analysis section in the commit or PR description** identifying which siblings could be affected and how.

Standalone consumers (apps just importing this primitive) are unaffected by this discipline — it applies only to modifications to the primitive itself.
