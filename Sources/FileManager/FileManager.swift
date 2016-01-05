import Glibc
import Foundation

let PATH_MAX = 4096

public class GFileManager {

  public static let defaultFileManager = GFileManager()

  public func GetCwd() -> String? {
    let cwd = getcwd(nil, Int(PATH_MAX))

    guard cwd != nil else { return nil }

    defer {
      free(cwd)
    }

    guard let path = String.fromCString(cwd) else { return nil }

    return path
  }

  public func ListFiles(filePath: String) -> [String] {
    let dir = opendir(filePath)
    guard dir != nil else { return [] }

    var result: [String] = []

    defer {
      closedir(dir)
    }

    var file = readdir(dir)
    while (file != nil) {
      let fileName = withUnsafePointer(&file.memory.d_name, { (ptr) -> String? in

        let int8Ptr = unsafeBitCast(ptr, UnsafePointer<Int8>.self)
        return String.fromCString(int8Ptr)
      })

      if let fileName = fileName {
        result.append(fileName)
      }


      file = readdir(dir)
    }

    return result
  }

  public func TmpFile() -> UnsafeMutablePointer<FILE> {
    let retValue = tmpfile()

    return retValue
  }

  public func TmpNam() -> String? {
    let name = tmpnam(nil)
    let newName = unsafeBitCast(name, UnsafePointer<Int8>.self)

    return String.fromCString(newName)
  }

}
