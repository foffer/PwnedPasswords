import Foundation
import CryptoSwift

public enum PwnedError: Error {
  case noEmpty
  case responseMalformed
  
  var errorDescription: String? {
    switch self {
    case .noEmpty: return "The password provided is empty"
    case .responseMalformed: return "The response os malformed and cannot be parsed"
    }
  }
}

public class PwnedPasswords: NSObject {
  let apiClient: Api
  
  public override init() {
    self.apiClient = ApiClient()
    super.init()
  }

  internal init(apiClient: Api) {
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
      guard error == nil else {
        completion(nil, error)
        return
      }
      do {
        let response = try self.parseResponse(string)
        if let occurences = response[s] {
          completion(occurences, nil)
        } else {
          completion(0, nil)
        }
      } catch let error {
        completion(nil, error)
      }
      
    }
  }
  
  internal func sha1(_ string: String) -> String {
  return string.sha1().uppercased()
  }
  
  internal func prefix(_ string: String) -> String {
    let idx = string.index(string.startIndex, offsetBy: 5)
    return String(string[..<idx])
  }
  
  internal func suffix(_ string: String) -> String {
    let idx = string.index(string.startIndex, offsetBy: 5)
    return String(string[idx...])
  }
  
  internal func parseResponse(_ string: String) throws -> Dictionary<String, Int> {
    let arr = string.split(separator: "\r\n")
    guard arr.count > 1 else {
      throw PwnedError.responseMalformed
    }
    
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

