extension Multiplication {
    /// Returns the rounded product and a residual computed with fused multiply-add.
    ///
    /// For finite binary operands in round-to-nearest arithmetic, the pair is
    /// exact when the product does not overflow and the residual is representable.
    /// Underflow can lose residual bits. Nonfinite inputs or overflow may produce
    /// an infinite or NaN residual; the pair is not an arbitrary-precision representation.
    @inlinable
    public static func augmented<T: FloatingPoint>(_ lhs: T, _ rhs: T) -> (head: T, tail: T) {
        let head = lhs * rhs
        return (head, (-head).addingProduct(lhs, rhs))
    }
}
