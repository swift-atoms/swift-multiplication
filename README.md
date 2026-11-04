# swift-multiplication

Use this package when you need to multiply two values and decide what happens when the product does not fit. This applies to fixed-width integers, to sign-magnitude integers stored as a `Polarity` and an unsigned magnitude, and to floating-point values whose rounding error must be kept. Start from `Multiplication`, and from `Multiplication.Signed` for sign-magnitude operands. For the other operations, use the sibling packages swift-addition, swift-subtraction and swift-division.

## Laws

- `Multiplication.reporting` returns the wrapping product (`lhs &* rhs`) together with the overflow flag. The other integer kernels are defined in terms of it.
- `Multiplication.exact` throws exactly when `Multiplication.reporting` reports overflow. Otherwise it returns the true product.
- When the product overflows, `Multiplication.saturating` returns the extreme value that has the sign of the true product. For signed values that is `.min` when the operand signs differ and `.max` otherwise. For unsigned values it is always `.max`. Without overflow it returns the true product.
- In `Multiplication.Signed`, the result's polarity is positive when the two polarities are equal and negative when they differ. Overflow is judged on the magnitude alone, so the full `Storage` range is usable for both signs (a magnitude of `Storage.max` is valid with negative polarity). `Multiplication.Signed.saturating` clamps the magnitude to `Storage.max` and keeps the product's polarity.
- `Multiplication.Signed` never returns negative zero: a zero magnitude always comes back with positive polarity.
- `Multiplication.augmented` returns `head`, the rounded product, and `tail`, the rounding error, computed with one fused multiply-add. `head + tail` equals the exact product only while that product is in the normal range. If the product rounds to zero, both `head` and `tail` are zero and the residual is lost. If it overflows, `head` is infinite and `tail` is not finite.
