public import Polarity

/// The identity of multiplication, independent of its operands and result.
///
/// A domain supplies any constraints beyond the reusable fixed-width kernels.
public enum Multiplication {

    public enum Error: Swift.Error, Hashable, Sendable {
        case overflow
    }

    @inlinable
    public static func reporting<Value: FixedWidthInteger>(
        _ lhs: Value,
        _ rhs: Value
    ) -> (value: Value, overflow: Bool) {
        let result = lhs.multipliedReportingOverflow(by: rhs)
        return (result.partialValue, result.overflow)
    }

    @inlinable
    public static func exact<Value: FixedWidthInteger>(
        _ lhs: Value,
        _ rhs: Value
    ) throws(Error) -> Value {
        let result = reporting(lhs, rhs)
        guard !result.overflow else { throw .overflow }
        return result.value
    }

    @inlinable
    public static func saturating<Value: FixedWidthInteger>(
        _ lhs: Value,
        _ rhs: Value
    ) -> Value {
        let result = reporting(lhs, rhs)
        guard result.overflow else { return result.value }
        if Value.isSigned && ((lhs < .zero) != (rhs < .zero)) { return .min }
        return .max
    }
}

extension Multiplication {
    /// Multiplication for values represented by an unsigned magnitude and
    /// binary polarity.
    public enum Signed {}
}

extension Multiplication.Signed {

    @inlinable
    public static func exact<Storage: FixedWidthInteger & UnsignedInteger>(
        lhsMagnitude: Storage,
        lhsPolarity: Polarity,
        rhsMagnitude: Storage,
        rhsPolarity: Polarity
    ) throws(Multiplication.Error) -> (polarity: Polarity, magnitude: Storage) {
        let magnitude = try Multiplication.exact(lhsMagnitude, rhsMagnitude)
        return normalized(
            polarity: lhsPolarity == rhsPolarity ? .positive : .negative,
            magnitude: magnitude
        )
    }

    @inlinable
    public static func saturating<Storage: FixedWidthInteger & UnsignedInteger>(
        lhsMagnitude: Storage,
        lhsPolarity: Polarity,
        rhsMagnitude: Storage,
        rhsPolarity: Polarity
    ) -> (polarity: Polarity, magnitude: Storage) {
        normalized(
            polarity: lhsPolarity == rhsPolarity ? .positive : .negative,
            magnitude: Multiplication.saturating(lhsMagnitude, rhsMagnitude)
        )
    }

    @inlinable
    internal static func normalized<Storage: FixedWidthInteger & UnsignedInteger>(
        polarity: Polarity,
        magnitude: Storage
    ) -> (polarity: Polarity, magnitude: Storage) {
        (magnitude == .zero ? .positive : polarity, magnitude)
    }
}
