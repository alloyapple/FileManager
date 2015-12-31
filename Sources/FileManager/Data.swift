
public struct Data: ArrayLiteralConvertible, StringLiteralConvertible {
  private enum Storage {
    case Bytes([Int8])
    case Text(String)
  }

  private var raw: Storage

  public init(bytes: [Int8]) {
    self.raw = .Bytes(bytes)
  }

  public init(uBytes: [UInt8]) {
    self.raw = .Bytes(unsafeBitCast(uBytes, [Int8].self))
  }

  public init(string: String) {
    self.raw = .Text(string)
  }

  public init(arrayLiteral elements: UInt8...) {
    self.init(uBytes: elements)
  }

  public init(stringLiteral value: StringLiteralType) {
    self.init(string: value)
  }

  public init(extendedGraphemeClusterLiteral value: String) {
    self.init(string: value)
  }

  public init(unicodeScalarLiteral value: String) {
		self.init(string: value)
	}

  public var length: Int {
    switch raw {
      case .Bytes(let bytes):
        return bytes.count
      case .Text(let string):
        return string.nulTerminatedUTF8.count
    }
  }

  public var bytes: [Int8] {
    switch raw {
      case .Bytes(let bytes):
        return bytes
      case .Text(let string):
        return unsafeBitCast(string.nulTerminatedUTF8, [Int8].self)
    }
  }

  public var uBytes: [UInt8] {
    switch raw {
      case .Bytes(let bytes):
        return unsafeBitCast(bytes, [UInt8].self)
      case .Text(let string):
        return Array(string.nulTerminatedUTF8)
    }
  }

  public var string: String? {
    switch raw {
      case .Bytes(let bytes):
        
        return String(data: unsafeBitCast(bytes, [UInt8].self))

      case .Text(let string):
        return string
    }
  }

}
