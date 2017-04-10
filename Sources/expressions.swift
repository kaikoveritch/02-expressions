import LogicKit

func constant (_ n : Int) -> Term {
  return Value (n)
}

func plus (_ lhs : Term, _ rhs : Term) -> Map {
  return [
    "op"  : Value ("+"),
    "lhs" : lhs,
    "rhs" : rhs,
  ]
}

func minus (_ lhs : Term, _ rhs : Term) -> Map {
  return [
    "op"  : Value ("-"),
    "lhs" : lhs,
    "rhs" : rhs,
  ]
}

// Addition on naturals:
// l -> lv, r -> rv
// -------------------
// l + r -> lv +Nat rv
//
// Subtraction on naturals:
// l -> lv, r -> rv, lv >= rv
// --------------------------
// l - r -> lv -Nat rv
//
// Anything on naturals:
// ...
func eval (_ input: Term, _ output: Term) -> Goal {
  func binary (op: @escaping (Term, Term) -> Term, semantics: @escaping (Term, Term) -> Term) -> Goal {
    return freshn { g in
      let l  = g ["l"]
      let r  = g ["r"]
      let lv = g ["lv"]
      let rv = g ["rv"]
      return input === op (l, r) &&
             eval (l, lv) &&
             eval (r, rv) &&
             inEnvironment { s in
               return output === semantics (s [lv], s [rv])
             }
    }
  }
  return
    (isValue (input, Int.self) && input === output)
    ||
    binary (op: plus, semantics: { lhs, rhs in
      switch (lhs, rhs) {
      case let (lhs, rhs) as (Value<Int>, Value<Int>):
        return Value (lhs.wrapped + rhs.wrapped)
      default:
        assert (false)
      }
    })
    ||
    binary (op: minus, semantics: { lhs, rhs in
      switch (lhs, rhs) {
      case let (lhs, rhs) as (Value<Int>, Value<Int>):
        return Value (lhs.wrapped - rhs.wrapped)
      default:
        assert (false)
      }
    })
}
