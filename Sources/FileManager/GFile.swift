import Glibc
import Foundation

class GFile {

  private let fp: UnsafeMutablePointer<FILE>

  init() {
    fp = nil
  }

  deinit {
    if fp != nil {
      close(fp)
    }
  }
}
