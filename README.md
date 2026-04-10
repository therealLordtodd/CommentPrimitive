# CommentPrimitive

CommentPrimitive provides the comment and anchoring model used by review surfaces.

## Quick Start

```swift
import CommentPrimitive

let text = "The quick brown fox"
let start = text.index(text.startIndex, offsetBy: 4)
let end = text.index(text.startIndex, offsetBy: 9)
let selector = TextQuoteSelector.from(text: text, range: start..<end)
let anchor = TextCommentAnchor(
    blockID: "intro",
    offset: 4,
    length: 5,
    selector: selector
)

let comment = Comment(
    anchor: AnyCommentAnchor(anchor),
    author: "author-1",
    body: "Tighten this phrase."
)

let store = CommentStore()
store.add(comment)
store.resolve(comment.id)
```

## Key Types
- `Comment`: Comment body, author, status, timestamps, anchor, and replies.
- `CommentReply`: Reply content and author metadata.
- `CommentStatus`: Open or resolved.
- `CommentAnchor` and `AnyCommentAnchor`: Typed anchor protocol and erased Codable wrapper.
- `TextCommentAnchor`, `CellCommentAnchor`, and `ObjectCommentAnchor`: Built-in anchor forms.
- `TextQuoteSelector`: Exact/prefix/suffix selector with `resolve(in:hintOffset:)`.
- `CommentStore`: Observable store with add, update, reply, resolve, reopen, and filter operations.

## Common Operations
- Use `AnyCommentAnchor.resolve(_:)` when a consumer needs a concrete anchor type.
- Use `CommentStore.comments(withAnchorType:)` to build sidebars for text, cell, or object comments.
- Register observers with `addObserver(_:)` when UI must react to store mutations.

## Testing

Run:

```bash
swift test
```
