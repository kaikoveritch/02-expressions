import XCTest
@testable import _2_expressions

import LogicKit

class _2_expressionsTests: XCTestCase {
    func testExample() {
      let t = minus (constant (1), plus (constant (2), constant (3)))
      let v = Variable (named: "v")
      let goal = eval (t, v)
      for r in solve (goal) {
        print (r.reified () [v])
      }
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
