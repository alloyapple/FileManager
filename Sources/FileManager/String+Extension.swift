extension String {


  public init?(data: [Int8]) {
    if let string = String.fromCString(data + [0]) {
      self.init(string)
    } else {
      return nil
    }
  }

  public init?(data: [UInt8]) {
    var string = ""
    var decoder = UTF8()
    var generator = data.generate()
    var finished = false

    while !finished {
      let decodingResult = decoder.decode(&generator)
      switch decodingResult {
        case .Result(let char): string.append(char)
        case .EmptyInput: finished = true
        case .Error: return nil
      }
    }

    self.init(string)
  }
}

///use string with this way
///let helloWorld = "Hello, world!"
///var hello      = helloWorld[0...4]
///print(hello)
extension String {
  subscript (r: Range<Int>) -> String {
    get {
      let startIndex = self.startIndex.advancedBy(r.startIndex)
      let endIndex   = self.startIndex.advancedBy(r.endIndex)

      return self[Range(start: startIndex, end: endIndex)]
    }
  }
}
