import Glibc
import Foundation

let PATH_MAX = 4096

public typealias FileDate = (accessDate: time_t, modifyDate: time_t, createDate: time_t)
public typealias FileSize = (fileWithBytes: __off_t, fileWithK: Double, fileWithM: Double, fileWithG: Double)

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

  public func HomeDir() -> String {

    let home = getenv("HOME")
    let homeString = String.fromCString(home)

    if let homeString = homeString {
      return homeString
    } else {
      return ""
    }
  }

  public func FileIsExists(fileName: String) -> Bool {
    return access(fileName, F_OK) != -1

  }

  public func CreateFile(filePath: String) -> Bool {
    let fileId = creat(filePath, S_IRWXG)
    guard fileId != -1 else { return false }
    close(fileId)
    return true
  }

  public func RenameFile(oldName: String, newName: String) -> Bool {
    let retValue = rename(oldName, newName)

    return retValue != -1
  }

  public func RemoveFile(filePath: String) -> Bool {
    let retValue = remove(filePath)

    return retValue != -1
  }

  //access date, modify date, create date
  public func GetFileDate(filePath: String) -> FileDate? {

    guard FileIsExists(filePath) else { return nil }

    var stat_struct = stat()
    stat(filePath, &stat_struct)

    return (accessDate: stat_struct.st_atim.tv_sec, modifyDate: stat_struct.st_mtim.tv_sec, createDate: stat_struct.st_ctim.tv_sec)
  }


  public func CanExecute(filePath: String) -> Bool {
    return access(filePath, X_OK) != -1
  }

  ///TODO:
  public func SetExecute(filePath: String, canexe: Bool) -> Bool {
    return false
  }


  public func CanRead(filePath: String) -> Bool {
    return access(filePath, R_OK) != -1
  }

  ///TODO:
  public func SetRead(filePath: String, canexe: Bool) -> Bool {
    return false
  }

  public func CanWrite(filePath: String) -> Bool {
    return access(filePath, W_OK) != -1
  }

  ///TODO:
  public func SetWrite(filePath: String, canexe: Bool) -> Bool {
    return false
  }

  public func IsDirectory(filePath: String) -> Bool {
    guard FileIsExists(filePath) else { return false }

    var stat_struct = stat()
    stat(filePath, &stat_struct)

    return (stat_struct.st_mode & 61440 == 16384)
  }

  public func IsFile(filePath: String) -> Bool {
    guard FileIsExists(filePath) else { return false }

    var stat_struct = stat()
    stat(filePath, &stat_struct)

    return (stat_struct.st_mode & 61440 == 32768)
  }


  public func IsHidden(filePath: String) -> Bool {
    guard filePath.characters.count > 0 else { return false }

    if filePath.characters.first == "." {
      return true
    } else {
      return false
    }
  }

  public func GetFileSize(filePath: String) -> FileSize? {
    guard FileIsExists(filePath) else { return nil }

    var stat_struct = stat()
    stat(filePath, &stat_struct)


    return (fileWithBytes: stat_struct.st_size,
            fileWithK: Double(stat_struct.st_size) / 1024,
            fileWithM: Double(stat_struct.st_size) / (1024 * 1024),
            fileWithG: Double(stat_struct.st_size) / (1024 * 1024 * 1024))
  }



}
