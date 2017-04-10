import LogicKit


// ----------
// True in B
let False = Value(false)

// -----------
// False in B
let True = Value(true)

// b in B
// -----------
// not(b) in B
func not (_ term: Term) -> Map {
   return [
      "op"  : Value("not"),
      "rhs" : term
   ]
}

// b,p in B
// -------------
// and(b,p) in B
func and (_ lhs : Term, _ rhs : Term) -> Map {
  return [
    "op"  : Value ("and"),
    "lhs" : lhs,
    "rhs" : rhs
  ]
}

// b,p in B
// ------------
// or(b,p) in B
func or (_ lhs : Term, _ rhs : Term) -> Map {
  return [
    "op"  : Value ("or"),
    "lhs" : lhs,
    "rhs" : rhs
  ]
}

// b,p in B
// -----------------
// implies(b,p) in B
func implies (_ lhs : Term, _ rhs : Term) -> Map {
  return [
    "op"  : Value ("=>"),
    "lhs" : lhs,
    "rhs" : rhs
  ]
}

// b,p in B
// ---------------
// equiv(b,p) in B
func equiv (_ lhs : Term, _ rhs : Term) -> Map {
  return [
    "op"  : Value ("<=>"),
    "lhs" : lhs,
    "rhs" : rhs
  ]
}

// Evaluation
func eval (_ input: Term, _ output: Term) -> Goal {
   return
      //
      // --------------
      // True -B-> true
      (input === True && output === True)
      ||
      //
      // ----------------
      // False -B-> false
      (input === False && output === False)
      ||
      // b -B-> eb
      // -----------------------
      // not(b) -B-> not{Bool}eb
      delayed(freshn{v in
         let t = v ["t"]
         let et = v ["et"]
         return (
            input === not(t) && eval(t,et) &&
            ((et === True && output === False) ||
            (et === False && output === True))
         )
      })
      ||
      // b -B-> eb, p -B-> ep
      // ---------------------------
      // and(b,p) -B-> b and{Bool} p
      delayed(freshn{v in
         let l = v ["l"]
         let r = v ["r"]
         let el = v ["el"]
         let er = v ["er"]
         return
            (input === and(l, r)) &&
            eval(l, el) && eval(r, er) &&
            (
               (el === True && er === True && output === True) ||
               (el === False && output === False) ||
               (er === False && output === False)
            )
      })
      ||
      // b -B-> eb, p -B-> ep
      // -------------------------
      // or(b,p) -B-> b or{Bool} p
      delayed(freshn{v in
         let l = v ["l"]
         let r = v ["r"]
         let el = v ["el"]
         let er = v ["er"]
         return
            (input === or(l, r)) &&
            eval(l, el) && eval(r, er) &&
            (
               (el === False && er === False && output === False) ||
               (el === True && output === True) ||
               (er === True && output === True)
            )
      })
      ||
      // b -B-> eb, p -B-> ep
      // ------------------------------
      // implies(b,p) -B-> b =>{Bool} p
      delayed(freshn{v in
         let l = v ["l"]
         let r = v ["r"]
         let el = v ["el"]
         let er = v ["er"]
         return
            (input === implies(l, r)) &&
            eval(l, el) && eval(r, er) &&
            (
               (el === True && er === False && output === False) ||
               (el === False && output === True) ||
               (el === True && er === True && output === True)
            )
      })
      ||
      // b -B-> eb, p -B-> ep
      // -----------------------------
      // equiv(b,p) -B-> b <=>{Bool} p
      delayed(freshn{v in
         let l = v ["l"]
         let r = v ["r"]
         let el = v ["el"]
         let er = v ["er"]
         return
            (input === equiv(l, r)) &&
            eval(l, el) && eval(r, er) &&
            (
               (el === True && er === False && output === False) ||
               (el === False && er === True && output === False) ||
               (el === er && output === True)
            )
      })
}
