import Foundation

/// W3C Text Quote Selector.
public struct TextQuoteSelector: Codable, Sendable, Equatable {
    public var exact: String
    public var prefix: String?
    public var suffix: String?

    public init(exact: String, prefix: String? = nil, suffix: String? = nil) {
        self.exact = exact
        self.prefix = prefix
        self.suffix = suffix
    }

    public static func from(
        text: String,
        range: Range<String.Index>,
        contextLength: Int = 32
    ) -> TextQuoteSelector {
        let exact = String(text[range])

        let prefixStart = text.index(
            range.lowerBound,
            offsetBy: -contextLength,
            limitedBy: text.startIndex
        ) ?? text.startIndex
        let suffixEnd = text.index(
            range.upperBound,
            offsetBy: contextLength,
            limitedBy: text.endIndex
        ) ?? text.endIndex

        let prefix = range.lowerBound > text.startIndex ? String(text[prefixStart..<range.lowerBound]) : nil
        let suffix = range.upperBound < text.endIndex ? String(text[range.upperBound..<suffixEnd]) : nil
        return TextQuoteSelector(exact: exact, prefix: prefix, suffix: suffix)
    }

    public func resolve(in text: String, hintOffset: Int? = nil) -> Range<String.Index>? {
        if let hintOffset,
           let startIndex = text.index(text.startIndex, offsetBy: hintOffset, limitedBy: text.endIndex),
           let endIndex = text.index(startIndex, offsetBy: exact.count, limitedBy: text.endIndex),
           String(text[startIndex..<endIndex]) == exact,
           verifyContext(in: text, at: startIndex..<endIndex) {
            return startIndex..<endIndex
        }

        var bestMatch: Range<String.Index>?
        var bestScore = -1
        var searchStart = text.startIndex

        while let range = text.range(of: exact, range: searchStart..<text.endIndex) {
            let score = contextScore(in: text, at: range)
            if score > bestScore {
                bestScore = score
                bestMatch = range
            }

            guard range.upperBound < text.endIndex else { break }
            searchStart = text.index(after: range.lowerBound)
        }

        return bestMatch
    }

    private func verifyContext(in text: String, at range: Range<String.Index>) -> Bool {
        contextScore(in: text, at: range) >= 2
    }

    private func contextScore(in text: String, at range: Range<String.Index>) -> Int {
        var score = 0

        if let prefix {
            let prefixStart = text.index(
                range.lowerBound,
                offsetBy: -prefix.count,
                limitedBy: text.startIndex
            ) ?? text.startIndex
            let actualPrefix = String(text[prefixStart..<range.lowerBound])
            if actualPrefix.hasSuffix(prefix) {
                score += 1
            }
        } else {
            score += 1
        }

        if let suffix {
            let suffixEnd = text.index(
                range.upperBound,
                offsetBy: suffix.count,
                limitedBy: text.endIndex
            ) ?? text.endIndex
            let actualSuffix = String(text[range.upperBound..<suffixEnd])
            if actualSuffix.hasPrefix(suffix) {
                score += 1
            }
        } else {
            score += 1
        }

        return score
    }
}
