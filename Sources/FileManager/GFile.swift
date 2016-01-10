import Glibc
import Foundation

public enum FileSeparator: String {
  case pathSeparator = "/"
  case separator = ":"
}


public class GFile {

  public enum Error: ErrorType {
    case OpenError(String)
    case ReadError(String)
    case WriteError(String)
  }


  public enum Mode: String {
    case Read = "r"
    case Write = "w"
    case Append = "a"
    case ReadUpdate = "r+"
    case WriteUpdate = "w+"
    case AppendUpdate = "a+"
  }

  private let fp: UnsafeMutablePointer<FILE>
  private let _filePath: String
  public var filePath: String {
    get {
      return self._filePath
    }

    // set(newValue) {
    //
    // }
  }


  public init?(path: String, mode: Mode = .ReadUpdate) {
    self._filePath = path
    self.fp = fopen(self._filePath, mode.rawValue)

    guard self.fp != nil else { return nil }
  }

  public func Write(data: Data) -> Int {
    let count = fwrite(data.uBytes, 1, data.length, fp)

    return count
  }


  public func Read(length length: Int = Int.max) -> Data? {
    var bytes: [UInt8] = []
    var remaining = length
    let buffer = UnsafeMutablePointer<UInt8>.alloc(1024)
    defer {
      buffer.dealloc(1024)
    }

    repeat {
      let count = fread(buffer, 1, min(remaining, 1024), fp)
      guard ferror(fp) == 0 else { return nil }
      guard count > 0 else { continue }
      bytes += Array(UnsafeBufferPointer(start: buffer, count: count).generate()).prefix(count)
      remaining -= count
    } while remaining > 0 && feof(fp) == 0

    return Data(uBytes: bytes)

  }

  public func ReadString(length length: Int = Int.max) -> String? {
    let data = Read(length: length)

    guard data != nil else { return nil }
    guard data?.string != nil else { return nil }

    return data?.string

  }

  public func CreateFile(filePath: String) -> Bool {
    let ceate_file = creat(filePath, UInt32(O_RDWR | O_CREAT))
    if ceate_file != -1 {
      close(ceate_file)
      return true
    } else {
      return false
    }
  }

  public func CanExecute() -> Bool {
    let fileManager = GFileManager.defaultFileManager

    return fileManager.CanExecute(self.filePath)
  }


  public func SetExecute(canexe: Bool) -> Bool {
    let fileManager = GFileManager.defaultFileManager

    return fileManager.SetExecute(self.filePath, canexe: canexe)
  }


  public func CanRead(filePath: String) -> Bool {
    let fileManager = GFileManager.defaultFileManager
    return fileManager.CanRead(self.filePath)
  }


  public func SetRead(canexe: Bool) -> Bool {
    let fileManager = GFileManager.defaultFileManager
    return fileManager.SetRead(self.filePath, canexe: canexe)

  }

  public func CanWrite() -> Bool {
    let fileManager = GFileManager.defaultFileManager
    return fileManager.CanWrite(self.filePath)
  }


  public func SetWrite(canexe: Bool) -> Bool {
    let fileManager = GFileManager.defaultFileManager
    return fileManager.SetWrite(self.filePath, canexe: canexe)
  }

  public func IsDirectory() -> Bool {
    let fileManager = GFileManager.defaultFileManager
    return fileManager.IsDirectory(self.filePath)
  }

  public func IsFile() -> Bool {
    let fileManager = GFileManager.defaultFileManager
    return fileManager.IsFile(self.filePath)
  }


  public func IsHidden() -> Bool {
    let fileManager = GFileManager.defaultFileManager
    return fileManager.IsHidden(self.filePath)
  }

  public func GetFileSize() -> FileSize? {
    let fileManager = GFileManager.defaultFileManager
    return fileManager.GetFileSize(self.filePath)
  }

  deinit {
    if fp != nil {
      fclose(fp)
    }
  }
}
