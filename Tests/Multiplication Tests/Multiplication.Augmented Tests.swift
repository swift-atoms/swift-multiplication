import Multiplication
import Testing

@Suite struct AugmentedMultiplicationTests {
    @Test func residualPreservesExactProduct() {
        let result = Multiplication.augmented(1 + Double.ulpOfOne, 1 - Double.ulpOfOne)
        #expect(result.head == 1)
        #expect(result.tail == -Double.ulpOfOne * Double.ulpOfOne)
    }

    @Test func underflowAndOverflowHaveExplicitLimits() {
        let tiny = Multiplication.augmented(Double.leastNonzeroMagnitude, 0.5)
        #expect(tiny.head == 0 && tiny.tail == 0)
        let huge = Multiplication.augmented(Double.greatestFiniteMagnitude, 2)
        #expect(huge.head.isInfinite)
        #expect(!huge.tail.isFinite)
    }
}
