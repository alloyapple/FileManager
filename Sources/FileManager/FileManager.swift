import Glibc

public class FileManager {

  public static func GetCwd() -> String? {
    let cwd = getcwd(nil, Int(PATH_MAX))

    guard cwd != nil else { return nil }

    defer {
      free(cwd)
    }

    guard let path = String.fromCString(cwd) else { return nil }


    return path
  }

  public static func ListFiles(filePath: String) -> [String] {
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

  public init?(path: String, mode: Mode = .ReadUpdate) {
    fp = fopen(path, mode.rawValue)

    guard fp != nil else { return nil }
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




  public func close() {
    if fp != nil {
      fclose(fp)
    }
  }

  deinit {
    close()
  }

}
