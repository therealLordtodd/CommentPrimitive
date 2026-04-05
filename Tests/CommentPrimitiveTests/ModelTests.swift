import Foundation
import Testing
@testable import CommentPrimitive

@Suite("CommentPrimitive Model Tests")
struct ModelTests {
    @Test func commentIDExpressibleByStringLiteral() {
        let id: CommentID = "test-comment-1"
        #expect(id.rawValue == "test-comment-1")
    }

    @Test func textCommentAnchorRoundTrip() throws {
        let selector = TextQuoteSelector(exact: "hello world", prefix: "say ", suffix: " today")
        let anchor = TextCommentAnchor(blockID: "block-1", offset: 4, length: 11, selector: selector)
        let any = try AnyCommentAnchor(anchor)
        #expect(any.anchorType == "text")
        let resolved = try any.resolve(TextCommentAnchor.self)
        #expect(resolved == anchor)
    }

    @Test func cellCommentAnchorRoundTrip() throws {
        let anchor = CellCommentAnchor(cellAddress: "A1")
        let any = try AnyCommentAnchor(anchor)
        #expect(any.anchorType == "cell")
        let resolved = try any.resolve(CellCommentAnchor.self)
        #expect(resolved == anchor)
    }

    @Test func objectCommentAnchorRoundTrip() throws {
        let anchor = ObjectCommentAnchor(objectID: "obj-123")
        let any = try AnyCommentAnchor(anchor)
        #expect(any.anchorType == "object")
        let resolved = try any.resolve(ObjectCommentAnchor.self)
        #expect(resolved == anchor)
    }

    @Test func commentCodableRoundTrip() throws {
        let anchor = try AnyCommentAnchor(CellCommentAnchor(cellAddress: "B2"))
        let reply = CommentReply(author: "reviewer", body: "Good point")
        let comment = CommentPrimitive.Comment(anchor: anchor, author: "author1", body: "Check this", replies: [reply])
        let data = try JSONEncoder().encode(comment)
        let decoded = try JSONDecoder().decode(CommentPrimitive.Comment.self, from: data)
        #expect(decoded.body == "Check this")
        #expect(decoded.replies.count == 1)
        #expect(decoded.status == CommentStatus.open)
    }

    @Test func commentStatusValues() {
        #expect(CommentStatus.open.rawValue == "open")
        #expect(CommentStatus.resolved.rawValue == "resolved")
        #expect(CommentStatus.wontFix.rawValue == "wontFix")
    }
}
