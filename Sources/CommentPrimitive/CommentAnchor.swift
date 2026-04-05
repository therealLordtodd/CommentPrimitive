import Foundation

public protocol CommentAnchor: Codable, Sendable, Equatable {
    static var anchorType: String { get }
}

public struct AnyCommentAnchor: Codable, Sendable, Equatable {
    public let anchorType: String
    private let storage: Data

    public init<T: CommentAnchor>(_ anchor: T) throws {
        self.anchorType = T.anchorType
        self.storage = try JSONEncoder().encode(anchor)
    }

    public func resolve<T: CommentAnchor>(_ type: T.Type) throws -> T {
        guard anchorType == T.anchorType else {
            throw DecodingError.typeMismatch(
                T.self,
                DecodingError.Context(
                    codingPath: [],
                    debugDescription: "Stored anchor type \(anchorType) does not match \(T.anchorType)"
                )
            )
        }

        return try JSONDecoder().decode(T.self, from: storage)
    }
}

public struct TextCommentAnchor: CommentAnchor {
    public static let anchorType = "text"

    public var blockID: String
    public var offset: Int
    public var length: Int
    public var selector: TextQuoteSelector

    public init(blockID: String, offset: Int, length: Int, selector: TextQuoteSelector) {
        self.blockID = blockID
        self.offset = offset
        self.length = length
        self.selector = selector
    }
}

public struct CellCommentAnchor: CommentAnchor {
    public static let anchorType = "cell"

    public var cellAddress: String

    public init(cellAddress: String) {
        self.cellAddress = cellAddress
    }
}

public struct ObjectCommentAnchor: CommentAnchor {
    public static let anchorType = "object"

    public var objectID: String

    public init(objectID: String) {
        self.objectID = objectID
    }
}
