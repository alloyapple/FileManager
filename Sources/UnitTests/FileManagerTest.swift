import XCTest
import FileManager

class FileManagerTest: XCTestCase {
  var allTests: [(String, Void -> Void)] {
    return [
      ("FileManagerTest", test),
      ("testTempFile", testTempFile)
    ]
  }

  func test() {

    let fileManager = GFileManager.defaultFileManager
    let curPath = fileManager.GetCwd()
    let fileList = fileManager.ListFiles(curPath!)
    let homeDir = fileManager.HomeDir()

    print("curPath is \(curPath)")
    print("file list is \(fileList)")
    print("home dir is \(homeDir)")


    XCTAssert(curPath != nil, "curPath is \(curPath)")
    XCTAssert(fileList.count > 0, "file count is zero")
    XCTAssert(!homeDir.isEmpty, "home dir is empty")

    //let fileManager: FileManager? = FileManager(path: "/home/mac/swiftdev/testlib/Package.swift")
    //let data: Data? = fileManager?.Read()
    //print("data is \(data?.string)")
  //  XCTAssert(data != nil)
  //  XCTAssert(data?.string != nil)
  }


  func testTempFile() {
//    let name = FileManager.TmpNam()

//    if let name = name {
//      print("name is \(name)")
//    }

//    XCTAssert(name != nil)
  }
}
