import Foundation

public struct CommentID: RawRepresentable, Hashable, Codable, Sendable, ExpressibleByStringLiteral {
    public let rawValue: String

    public init(rawValue: String) {
        self.rawValue = rawValue
    }

    public init(stringLiteral value: String) {
        self.rawValue = value
    }

    public init() {
        self.rawValue = UUID().uuidString
    }
}

public struct AuthorID: RawRepresentable, Hashable, Codable, Sendable, ExpressibleByStringLiteral {
    public let rawValue: String

    public init(rawValue: String) {
        self.rawValue = rawValue
    }

    public init(stringLiteral value: String) {
        self.rawValue = value
    }
}

public enum CommentStatus: String, Codable, Sendable {
    case open
    case resolved
    case wontFix
}

public struct CommentReply: Identifiable, Codable, Sendable, Equatable {
    public let id: UUID
    public var author: AuthorID
    public var body: String
    public var createdAt: Date

    public init(
        id: UUID = UUID(),
        author: AuthorID,
        body: String,
        createdAt: Date = Date()
    ) {
        self.id = id
        self.author = author
        self.body = body
        self.createdAt = createdAt
    }
}

public struct Comment: Identifiable, Codable, Sendable, Equatable {
    public let id: CommentID
    public var anchor: AnyCommentAnchor
    public var author: AuthorID
    public var body: String
    public var createdAt: Date
    public var modifiedAt: Date
    public var status: CommentStatus
    public var replies: [CommentReply]

    public init(
        id: CommentID = CommentID(),
        anchor: AnyCommentAnchor,
        author: AuthorID,
        body: String,
        createdAt: Date = Date(),
        status: CommentStatus = .open,
        replies: [CommentReply] = []
    ) {
        self.id = id
        self.anchor = anchor
        self.author = author
        self.body = body
        self.createdAt = createdAt
        self.modifiedAt = createdAt
        self.status = status
        self.replies = replies
    }
}
