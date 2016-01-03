import XCTest
import FileManager

class DataTest: XCTestCase {
  var allTests: [(String, Void -> Void)] {
    return [
      ("DataTest", test)
    ]
  }

  func test() {
    let data = Data(string: "Hello")

    XCTAssert(data.string != nil)
    ///XCTAssert(data != nil)
  }
}
