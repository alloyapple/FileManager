extension String {

  public init?(data: [UInt8]) {

  }

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
    var generator = decoder.generate()
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
