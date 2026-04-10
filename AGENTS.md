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
