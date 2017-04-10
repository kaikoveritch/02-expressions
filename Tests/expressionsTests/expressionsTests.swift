import XCTest
@testable import expressions

import LogicKit

class expressionsTests: XCTestCase {
    func testExample() {

      print("\n[tests]\n")

      let t = and(True, not(or(implies(True, False), equiv(False, True))))
      let v = Variable (named: "v")
      let goal = eval (t, v)
      for r in solve (goal) {
        print (r.reified () [v])
      }

      print("\n[fin]\n")

    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
