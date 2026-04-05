import Foundation
import Observation

public enum CommentMutation: Sendable, Equatable {
    case added(CommentID)
    case removed(CommentID)
    case updated(CommentID)
    case replied(CommentID)
    case statusChanged(CommentID, CommentStatus)
}

@MainActor
@Observable
public final class CommentStore {
    public var comments: [Comment]
    public var activeCommentID: CommentID?

    private var observers: [UUID: @MainActor (CommentMutation) -> Void] = [:]

    public init(comments: [Comment] = []) {
        self.comments = comments
    }

    public func add(_ comment: Comment) {
        comments.append(comment)
        notify(.added(comment.id))
    }

    public func remove(_ id: CommentID) {
        comments.removeAll { $0.id == id }
        if activeCommentID == id {
            activeCommentID = nil
        }
        notify(.removed(id))
    }

    public func update(_ id: CommentID, body: String) {
        guard let index = comments.firstIndex(where: { $0.id == id }) else { return }
        comments[index].body = body
        comments[index].modifiedAt = Date()
        notify(.updated(id))
    }

    public func resolve(_ id: CommentID) {
        setStatus(id, status: .resolved)
    }

    public func reopen(_ id: CommentID) {
        setStatus(id, status: .open)
    }

    public func setStatus(_ id: CommentID, status: CommentStatus) {
        guard let index = comments.firstIndex(where: { $0.id == id }) else { return }
        comments[index].status = status
        comments[index].modifiedAt = Date()
        notify(.statusChanged(id, status))
    }

    public func reply(to id: CommentID, reply: CommentReply) {
        guard let index = comments.firstIndex(where: { $0.id == id }) else { return }
        comments[index].replies.append(reply)
        comments[index].modifiedAt = Date()
        notify(.replied(id))
    }

    public func comment(for id: CommentID) -> Comment? {
        comments.first { $0.id == id }
    }

    public func comments(withAnchorType type: String) -> [Comment] {
        comments.filter { $0.anchor.anchorType == type }
    }

    public var openComments: [Comment] {
        comments.filter { $0.status == .open }
    }

    public var resolvedComments: [Comment] {
        comments.filter { $0.status == .resolved }
    }

    public func addObserver(_ observer: @escaping @MainActor (CommentMutation) -> Void) -> UUID {
        let id = UUID()
        observers[id] = observer
        return id
    }

    public func removeObserver(_ id: UUID) {
        observers.removeValue(forKey: id)
    }

    private func notify(_ mutation: CommentMutation) {
        for observer in observers.values {
            observer(mutation)
        }
    }
}
