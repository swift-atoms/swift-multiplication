extension Multiplication {






    @inlinable
    public static func augmented<T: FloatingPoint>(_ lhs: T, _ rhs: T) -> (head: T, tail: T) {
        let head = lhs * rhs
        return (head, (-head).addingProduct(lhs, rhs))
    }
}
