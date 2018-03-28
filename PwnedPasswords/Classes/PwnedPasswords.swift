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

  /// Internal initializer used only for testing
  ///
  /// - Parameter apiClient: Either a real or a mock api client
  internal init(apiClient: Api) {
    self.apiClient = apiClient
    super.init()
  }
  
  /// This method will check a given password - the input against the haveibeenpwned 'Passwords' api. If an occurence of a password the completion handler will return the amount of times the password has occured in breaches. If the occurance count is 0 the password was not found in the breach data.
  ///
  /// - Parameters:
  ///   - input: A string representation of the password
  ///   - completion: An optional count 'occurences' and an optional error
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
  
  /// Will hash the password using the sha1 algorithm
  ///
  /// - Parameter string: The input to hash
  /// - Returns: An uppercased string representing the sha1 hash
  internal func sha1(_ string: String) -> String {
    return string.sha1().uppercased()
  }
  
  /// Gets the first 5 characters of a given string
  ///
  /// - Parameter string: The hashed password
  /// - Returns: The first 5 characters of the input
  internal func prefix(_ string: String) -> String {
    return string.slice(to: 5)
  }
  
  /// Gets the remaining characters after index 5 of a given string
  ///
  /// - Parameter string: The hashed password
  /// - Returns: The characters of the input from index 5 and forward
  internal func suffix(_ string: String) -> String {
    return string.slice(from: 5)
  }
  
  /// Parses a response string from the API into a dictionary of suffixes and occurences
  ///
  /// - Parameter string: The raw string response from the api
  /// - Returns: A dictionary with suffixes and occurences
  /// - Throws: An error if the response string was malformed
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

