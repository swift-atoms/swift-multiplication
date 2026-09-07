# Multiplication

A shared multiplication symbol and namespace for exact, saturating, and
overflow-reporting fixed-width multiplication. `Multiplication.Signed` provides
the corresponding exact and saturating binary signed-magnitude kernels.

`Property<Multiplication, Ratio<From, To>>` retains the ratio's typed mapping.
The symbol does not declare every multiplication closed or commutative.

`augmented` returns a rounded product and its fused multiply-add residual. The pair is exact for finite binary inputs in round-to-nearest arithmetic when neither overflow nor unrepresentable residual bits intervene. Underflow can lose residual bits; this is not arbitrary-precision arithmetic.
