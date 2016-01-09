import Glibc
import Foundation


public class GTime {

public static func FormatTime(time: time_t) -> String {

  var curTime = time
  let timeinfo = localtime (&curTime);

  var buffer = [Int8](count: 80, repeatedValue: 0)

  strftime (&buffer,buffer.capacity,"%F %T",timeinfo);

  let retValue = String.fromCString(buffer)

  if let retValue = retValue {
    return retValue
  } else {
    return ""
  }

}

}
