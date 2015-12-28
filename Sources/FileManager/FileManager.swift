import Glibc

public class FileManager {

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




  public func close() {
    if fp != nil {
      fclose(fp)
    }
  }

  deinit {
    close()
  }

}
