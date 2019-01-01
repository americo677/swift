// RUN: %target-swift-frontend -parse -verify %s

/// Good

@differentiable(adjoint: foo(_:_:)) // okay
func bar(_ x: Float, _: Float) -> Float {
  return 1 + x
}

@differentiable(adjoint: foo(_:_:) where T : FloatingPoint) // okay
func bar<T : Numeric>(_ x: T, _: T) -> T {
    return 1 + x
}

@differentiable(wrt: (self, .0, .1), adjoint: foo(_:_:)) // okay
func bar(_ x: Float, _: Float) -> Float {
  return 1 + x
}

@differentiable(wrt: (self, .0, .1), primal: bar, adjoint: foo(_:_:)) // okay
func bar(_ x: Float, _: Float) -> Float {
  return 1 + x
}

@differentiable // okay
func bar(_ x: Float, _: Float) -> Float {
  return 1 + x
}

@_transparent
@differentiable // okay
@inlinable
func playWellWithOtherAttrs(_ x: Float, _: Float) -> Float {
  return 1 + x
}

@_transparent
@differentiable(wrt: (self), adjoint: _adjointSquareRoot) // okay
public func squareRoot() -> Self {
  var lhs = self
  lhs.formSquareRoot()
  return lhs
}

/// Bad

@differentiable(3) // expected-error {{expected a function specifier label, e.g. 'wrt:', 'primal:', 'adjoint:', 'jvp:', or 'vjp:'}}
func bar(_ x: Float, _: Float) -> Float {
  return 1 + x
}

@differentiable(foo(_:_:)) // expected-error {{expected a function specifier label, e.g. 'wrt:', 'primal:', 'adjoint:', 'jvp:', or 'vjp:'}}
func bar(_ x: Float, _: Float) -> Float {
  return 1 + x
}

@differentiable(vjp: foo(_:_:), 3) // expected-error {{expected a function specifier label, e.g. 'wrt:', 'primal:', 'adjoint:', 'jvp:', or 'vjp:'}}
func bar(_ x: Float, _: Float) -> Float {
  return 1 + x
}

@differentiable(wrt: (.0), foo(_:_:)) // expected-error {{expected a function specifier label, e.g. 'wrt:', 'primal:', 'adjoint:', 'jvp:', or 'vjp:'}}
func bar(_ x: Float, _: Float) -> Float {
  return 1 + x
}

@differentiable(wrt: (1), adjoint: foo(_:_:)) // expected-error {{expected a parameter, which can be the index of a function parameter with a leading dot (e.g. '.0'), or 'self'}}
func bar(_ x: Float, _: Float) -> Float {
  return 1 + x
}

@differentiable(adjoint: foo(_:_:) // expected-error {{expected ')' in 'differentiable' attribute}}
func bar(_ x: Float, _: Float) -> Float {
  return 1 + x
}

@differentiable(adjoint: foo(_:_:) where T) // expected-error {{expected ':' or '==' to indicate a conformance or same-type requirement}}
func bar<T : Numeric>(_ x: T, _: T) -> T {
    return 1 + x
}

@differentiable(,) // expected-error {{expected a function specifier label, e.g. 'wrt:', 'primal:', 'adjoint:', 'jvp:', or 'vjp:'}}
func bar(_ x: Float, _: Float) -> Float {
  return 1 + x
}

@differentiable(vjp: foo(_:_:),) // expected-error {{unexpected ',' separator}}
func bar(_ x: Float, _: Float) -> Float {
  return 1 + x
}

@differentiable(adjoint: foo(_:_:), where T) // expected-error {{unexpected ',' separator}}
func bar<T : Numeric>(_ x: T, _: T) -> T {
    return 1 + x
}
