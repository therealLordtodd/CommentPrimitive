import Foundation
import Testing
@testable import CommentPrimitive

@MainActor
@Suite("CommentStore Tests")
struct CommentStoreTests {
    func makeComment(body: String = "Test comment") throws -> CommentPrimitive.Comment {
        let anchor = try AnyCommentAnchor(CellCommentAnchor(cellAddress: "A1"))
        return CommentPrimitive.Comment(anchor: anchor, author: "user1", body: body)
    }

    @Test func addAndRetrieveComment() throws {
        let store = CommentStore()
        let comment = try makeComment()
        store.add(comment)
        #expect(store.comments.count == 1)
        #expect(store.comment(for: comment.id)?.body == "Test comment")
    }

    @Test func removeComment() throws {
        let store = CommentStore()
        let comment = try makeComment()
        store.add(comment)
        store.remove(comment.id)
        #expect(store.comments.isEmpty)
    }

    @Test func updateCommentBody() throws {
        let store = CommentStore()
        let comment = try makeComment()
        store.add(comment)
        store.update(comment.id, body: "Updated text")
        #expect(store.comment(for: comment.id)?.body == "Updated text")
    }

    @Test func resolveComment() throws {
        let store = CommentStore()
        let comment = try makeComment()
        store.add(comment)
        store.resolve(comment.id)
        #expect(store.comment(for: comment.id)?.status == .resolved)
    }

    @Test func reopenComment() throws {
        let store = CommentStore()
        let comment = try makeComment()
        store.add(comment)
        store.resolve(comment.id)
        store.reopen(comment.id)
        #expect(store.comment(for: comment.id)?.status == .open)
    }

    @Test func replyToComment() throws {
        let store = CommentStore()
        let comment = try makeComment()
        store.add(comment)
        let reply = CommentReply(author: "reviewer", body: "Good point")
        store.reply(to: comment.id, reply: reply)
        #expect(store.comment(for: comment.id)?.replies.count == 1)
        #expect(store.comment(for: comment.id)?.replies[0].body == "Good point")
    }

    @Test func openAndResolvedFilters() throws {
        let store = CommentStore()
        let c1 = try makeComment(body: "Open one")
        let c2 = try makeComment(body: "To resolve")
        store.add(c1)
        store.add(c2)
        store.resolve(c2.id)
        #expect(store.openComments.count == 1)
        #expect(store.resolvedComments.count == 1)
    }

    @Test func filterByAnchorType() throws {
        let store = CommentStore()
        let cellAnchor = try AnyCommentAnchor(CellCommentAnchor(cellAddress: "A1"))
        let objectAnchor = try AnyCommentAnchor(ObjectCommentAnchor(objectID: "obj-1"))
        store.add(CommentPrimitive.Comment(anchor: cellAnchor, author: "u1", body: "cell comment"))
        store.add(CommentPrimitive.Comment(anchor: objectAnchor, author: "u1", body: "object comment"))
        #expect(store.comments(withAnchorType: "cell").count == 1)
        #expect(store.comments(withAnchorType: "object").count == 1)
    }

    @Test func observerNotifiedOnAdd() throws {
        let store = CommentStore()
        var received: CommentMutation?
        _ = store.addObserver { mutation in received = mutation }
        let comment = try makeComment()
        store.add(comment)

        if case .added(let id) = received {
            #expect(id == comment.id)
        } else {
            #expect(Bool(false), "Expected .added mutation")
        }
    }

    @Test func removeActiveCommentClearsSelection() throws {
        let store = CommentStore()
        let comment = try makeComment()
        store.add(comment)
        store.activeCommentID = comment.id
        store.remove(comment.id)
        #expect(store.activeCommentID == nil)
    }

    @Test func removeObserver() throws {
        let store = CommentStore()
        var callCount = 0
        let observerID = store.addObserver { _ in callCount += 1 }
        store.add(try makeComment())
        #expect(callCount == 1)
        store.removeObserver(observerID)
        store.add(try makeComment())
        #expect(callCount == 1)
    }
}
