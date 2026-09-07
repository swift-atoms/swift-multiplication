import Multiplication
import Polarity
import Testing

@Suite
struct `Multiplication kernels implement checked exact and saturating arithmetic` {

    @Test
    func `UInt8 kernels agree with a UInt16 oracle exhaustively`() {
        for lhs in UInt8.min...UInt8.max {
            for rhs in UInt8.min...UInt8.max {
                let oracle = UInt16(lhs) * UInt16(rhs)
                let overflows = oracle > UInt16(UInt8.max)
                let reported = Multiplication.reporting(lhs, rhs)

                #expect(reported.overflow == overflows)
                #expect(reported.value == lhs &* rhs)
                #expect(
                    Multiplication.saturating(lhs, rhs)
                        == (overflows ? UInt8.max : UInt8(oracle))
                )

                do {
                    let exact = try Multiplication.exact(lhs, rhs)
                    #expect(!overflows)
                    if !overflows {
                        #expect(exact == UInt8(oracle))
                    }
                } catch {
                    #expect(overflows)
                    #expect(error == .overflow)
                }
            }
        }
    }

    @Test
    func `Int8 kernels agree with an Int16 oracle exhaustively`() {
        for rawLHS in UInt8.min...UInt8.max {
            for rawRHS in UInt8.min...UInt8.max {
                let lhs = Int8(bitPattern: rawLHS)
                let rhs = Int8(bitPattern: rawRHS)
                let oracle = Int16(lhs) * Int16(rhs)
                let overflows = oracle < Int16(Int8.min) || oracle > Int16(Int8.max)
                let saturated = min(Int16(Int8.max), max(Int16(Int8.min), oracle))
                let reported = Multiplication.reporting(lhs, rhs)

                #expect(reported.overflow == overflows)
                #expect(reported.value == lhs &* rhs)
                #expect(Multiplication.saturating(lhs, rhs) == Int8(saturated))

                do {
                    let exact = try Multiplication.exact(lhs, rhs)
                    #expect(!overflows)
                    if !overflows {
                        #expect(exact == Int8(oracle))
                    }
                } catch {
                    #expect(overflows)
                    #expect(error == .overflow)
                }
            }
        }
    }

    @Test
    func `signed saturation chooses the product-sign extreme`() {
        #expect(Multiplication.saturating(Int8.max, 2) == Int8.max)
        #expect(Multiplication.saturating(Int8.min, 2) == Int8.min)
        #expect(Multiplication.saturating(Int8.min, -2) == Int8.max)
        #expect(Multiplication.saturating(Int8.max, -2) == Int8.min)
        #expect(Multiplication.saturating(UInt8.max, 2) == UInt8.max)
    }

    @Test
    func `signed magnitude normal multiplication normalizes zero and preserves full width`() throws {
        let zero = try Multiplication.Signed.exact(
            lhsMagnitude: UInt.zero,
            lhsPolarity: .negative,
            rhsMagnitude: UInt.max,
            rhsPolarity: .positive
        )
        let negativeMaximum = try Multiplication.Signed.exact(
            lhsMagnitude: UInt.max,
            lhsPolarity: .negative,
            rhsMagnitude: 1,
            rhsPolarity: .positive
        )
        #expect(zero.polarity == .positive)
        #expect(zero.magnitude == 0)
        #expect(negativeMaximum.polarity == .negative)
        #expect(negativeMaximum.magnitude == .max)
        #expect(throws: Multiplication.Error.overflow) {
            try Multiplication.Signed.exact(
                lhsMagnitude: UInt.max,
                lhsPolarity: .negative,
                rhsMagnitude: 2,
                rhsPolarity: .negative
            )
        }

        let saturated = Multiplication.Signed.saturating(
            lhsMagnitude: UInt.max,
            lhsPolarity: .negative,
            rhsMagnitude: 2,
            rhsPolarity: .positive
        )
        #expect(saturated.polarity == .negative)
        #expect(saturated.magnitude == .max)
    }
}
