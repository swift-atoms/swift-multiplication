import Multiplication
import Testing

@Suite struct `Augmented multiplication preserves rounding residuals` {
    @Test func `The multiplication residual preserves the exact product`() {
        let result = Multiplication.augmented(1 + Double.ulpOfOne, 1 - Double.ulpOfOne)
        #expect(result.head == 1)
        #expect(result.tail == -Double.ulpOfOne * Double.ulpOfOne)
    }

    @Test func `Underflow and overflow have explicit residual limits`() {
        let tiny = Multiplication.augmented(Double.leastNonzeroMagnitude, 0.5)
        #expect(tiny.head == 0 && tiny.tail == 0)
        let huge = Multiplication.augmented(Double.greatestFiniteMagnitude, 2)
        #expect(huge.head.isInfinite)
        #expect(!huge.tail.isFinite)
    }
}
