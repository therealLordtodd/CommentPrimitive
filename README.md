# CommentPrimitive

`CommentPrimitive` is a portable comment and review-thread model for apps.

It gives you comments, replies, statuses, typed anchors, a resilient text quote selector, and a small observable store. It is the right layer when your app needs annotation and review state without coupling that logic to one specific editor or UI.

Use it when you want comments anchored to text, cells, or objects inside your own product model.

Do not use it if you expect the package to render comments, sync them to a server, or mutate your document for you. This is a model/store primitive, not a full collaboration system.

## What The Package Gives You

- `Comment`, `CommentReply`, and `CommentStatus`
- `AnyCommentAnchor` plus typed anchors like `TextCommentAnchor`, `CellCommentAnchor`, and `ObjectCommentAnchor`
- `TextQuoteSelector` for resilient text anchoring after edits
- `CommentStore` as the main `@MainActor` observable store
- mutation callbacks for review UI or app-side integration

## When To Use It

- You need inline comments or review threads in an editor or structured tool
- You want comment anchors that survive moderate text changes better than raw offsets alone
- You want one comment model that can work across text, spreadsheet, and object-based surfaces

## When Not To Use It

- You want a full rich-text editor or commenting UI
- You need realtime sync, presence, or server authority built into the package
- You expect accept/reject semantics to rewrite your document; this package tracks comments, not edits

## Install

```swift
dependencies: [
    .package(path: "../CommentPrimitive"),
]
targets: [
    .target(
        name: "MyApp",
        dependencies: ["CommentPrimitive"]
    )
]
```

## Quick Start

```swift
import CommentPrimitive

let text = "The quick brown fox jumps over the lazy dog"
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
    anchor: try AnyCommentAnchor(anchor),
    author: "author-1",
    body: "Tighten this phrase."
)

let store = CommentStore()
store.add(comment)
```

## Concrete Examples

### 1. Create a text comment

```swift
let selector = TextQuoteSelector.from(text: blockText, range: selectionRange)

let anchor = TextCommentAnchor(
    blockID: blockID,
    offset: offset,
    length: length,
    selector: selector
)

let comment = Comment(
    anchor: try AnyCommentAnchor(anchor),
    author: "alice",
    body: "This sentence needs a source."
)

store.add(comment)
```

### 2. Reply to and resolve a thread

```swift
store.reply(
    to: comment.id,
    reply: CommentReply(author: "bob", body: "Agreed.")
)

store.resolve(comment.id)
store.reopen(comment.id)
store.setStatus(comment.id, status: .wontFix)
```

### 3. Filter comments for a sidebar or review panel

```swift
let textComments = store.comments(withAnchorType: "text")
let openComments = store.openComments
let resolvedComments = store.resolvedComments
```

### 4. Re-resolve a text anchor after edits

```swift
if let textAnchor = try? comment.anchor.resolve(TextCommentAnchor.self),
   let range = textAnchor.selector.resolve(in: editedText, hintOffset: textAnchor.offset) {
    // Highlight the updated range in your editor
}
```

That is the main reason `TextQuoteSelector` exists. It gives your app a better fallback than a raw integer offset alone.

### 5. Use non-text anchors

```swift
let cellComment = Comment(
    anchor: try AnyCommentAnchor(CellCommentAnchor(cellAddress: "B12")),
    author: "reviewer",
    body: "Check this formula."
)

let objectComment = Comment(
    anchor: try AnyCommentAnchor(ObjectCommentAnchor(objectID: "shape-42")),
    author: "reviewer",
    body: "Align this object with the grid."
)
```

### 6. Observe store mutations

```swift
let token = store.addObserver { mutation in
    switch mutation {
    case .added(let id):
        print("Added \(id)")
    case .replied(let id):
        print("Replied to \(id)")
    case .statusChanged(let id, let status):
        print("\(id) -> \(status)")
    default:
        break
    }
}

store.removeObserver(token)
```

## How To Wire It Into A Host App

### 1. Let the host app define what an anchor means

`TextCommentAnchor`, `CellCommentAnchor`, and `ObjectCommentAnchor` are deliberately thin. Your app still owns how block IDs, cell addresses, or object IDs map back to real UI.

### 2. Treat comments as review state, not document state

That separation helps a lot. Your document model should stay your source of truth. `CommentPrimitive` should track annotation and review metadata around it.

### 3. Re-resolve text comments when the document changes

For text comments, store enough context to rebuild highlights from `TextQuoteSelector`. That is one of the strongest integration patterns in the package.

### 4. Handle persistence and sync outside the package

The model types are `Codable`, which makes app-owned persistence or network serialization straightforward. The package stops there on purpose.

### 5. Build UI and navigation in the host app

Thread lists, gutter markers, popovers, badges, and “jump to comment” behaviors should all live in your app or editor package, not here.

## Important Constraints

- `CommentStore` is `@MainActor`
- `AnyCommentAnchor` is the serialization boundary for anchor types
- `TextQuoteSelector` helps re-find text, but it is still best-effort, not magic
- This package does not include rendering, networking, or collaboration orchestration

## Platform Support

| Platform | Minimum Version |
|----------|----------------|
| macOS | 15.0 |
| iOS | 17.0 |
