import Foundation
import Testing
@testable import CommentPrimitive

@Suite("TextQuoteSelector Tests")
struct TextQuoteSelectorTests {
    let sampleText = "The quick brown fox jumps over the lazy dog. The quick brown fox rests."

    @Test func resolveExactMatchUnique() {
        let selector = TextQuoteSelector(exact: "lazy dog")
        let result = selector.resolve(in: sampleText)
        #expect(result != nil)
        #expect(String(sampleText[result!]) == "lazy dog")
    }

    @Test func resolveWithContextDisambiguates() {
        let selector = TextQuoteSelector(exact: "quick brown fox", prefix: "The ", suffix: " rests")
        let result = selector.resolve(in: sampleText)
        #expect(result != nil)
        #expect(String(sampleText[result!]) == "quick brown fox")
        let offset = sampleText.distance(from: sampleText.startIndex, to: result!.lowerBound)
        #expect(offset > 20)
    }

    @Test func resolveWithHintOffset() {
        let selector = TextQuoteSelector(exact: "quick brown fox")
        let result = selector.resolve(in: sampleText, hintOffset: 49)
        #expect(result != nil)
    }

    @Test func resolveNoMatchReturnsNil() {
        let selector = TextQuoteSelector(exact: "purple elephant")
        let result = selector.resolve(in: sampleText)
        #expect(result == nil)
    }

    @Test func buildFromTextRange() {
        let text = "Hello beautiful world of Swift programming"
        let start = text.index(text.startIndex, offsetBy: 6)
        let end = text.index(start, offsetBy: 9)
        let range = start..<end
        let selector = TextQuoteSelector.from(text: text, range: range, contextLength: 10)
        #expect(selector.exact == "beautiful")
        #expect(selector.prefix != nil)
        #expect(selector.suffix != nil)
    }

    @Test func codableRoundTrip() throws {
        let selector = TextQuoteSelector(exact: "test", prefix: "pre", suffix: "suf")
        let data = try JSONEncoder().encode(selector)
        let decoded = try JSONDecoder().decode(TextQuoteSelector.self, from: data)
        #expect(decoded == selector)
    }
}
