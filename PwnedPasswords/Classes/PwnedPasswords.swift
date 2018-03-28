import Foundation
import CryptoSwift

public enum PollRate: Int {
  case none = 0
  case low = 1000
  case high = 200
}

public enum PwnedError: Error {
  case noEmpty
}

public class PwnedPasswords: NSObject {
  let pollRate: PollRate
  let apiClient: Api
  
  public init(pollRate: PollRate = .none) {
    self.pollRate = pollRate
    self.apiClient = ApiClient()
    super.init()
  }

  internal init(pollRate: PollRate = .none, apiClient: Api) {
    self.pollRate = pollRate
    self.apiClient = apiClient
    super.init()
  }
  
  public func check(_ input: String, completion: @escaping(Int?, Error?) -> Void) {
    guard input.count > 0 else {
      completion(nil, PwnedError.noEmpty)
      return
    }
    let hash = sha1(input)
    let p = prefix(hash)
    let s = suffix(hash)
    
    apiClient.getResponse(forPrefix: p) { string, error in
      let response = self.parseResponse(string)
      guard error == nil else {
        completion(nil, error)
        return
      }
      
      if let occurences = response[s] {
        completion(occurences, nil)
      } else {
        completion(0, nil)
      }
    }
  }
  
  internal func sha1(_ string: String) -> String {
  return string.sha1()
  }
  
  internal func prefix(_ string: String) -> String {
    let idx = string.index(string.startIndex, offsetBy: 5)
    return String(string[..<idx])
  }
  
  internal func suffix(_ string: String) -> String {
    let idx = string.index(string.startIndex, offsetBy: 5)
    return String(string[idx...])
  }
  
  internal func parseResponse(_ string: String) -> Dictionary<String, Int> {
    let arr = string.split(separator: "\n")
    var dict: Dictionary<String, Int> = [:]
    for responseString in arr {
      //Convert our string with the format 'suffix:occurences' to an arr
      let responseArr = responseString.split(separator: ":")
      //If we have less or more than 2 entries something is wrong
      if responseArr.count != 2 { continue }
      
      let suffix = String(responseArr[0])
      let occurences = Int(responseArr[1])
      dict[suffix] = occurences
    }
    return dict
  }
}

