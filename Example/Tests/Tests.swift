// https://github.com/Quick/Quick

import Quick
import Nimble
@testable import PwnedPasswords


class MockApiClient: Api {
  
  func getResponse(forPrefix prefix: String, completion: @escaping (String, Error?) -> Void) {
    if #available(iOS 10.0, *) {
      Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) {_ in
        completion(testResponse, nil)
      }
    } else {
      completion(testResponse, nil)
    }
  }
}


class TableOfContentsSpec: QuickSpec {
  
  override func spec() {
    describe("Client") {
      var client: PwnedPasswords!
      var apiClient: MockApiClient!
      
      let plainPassword = "P@ssw0rd"
      let hashedPassword = "21BD12DC183F740EE76F27B78EB39C8AD972A757"
      let prefix = "21BD1"
      let suffix = "2DC183F740EE76F27B78EB39C8AD972A757"
      
      beforeEach {
        
        apiClient = MockApiClient()
        client = PwnedPasswords(apiClient: apiClient)
      }
      context("it instantiates correctly") {
        it("with with defaults when no params is passed") {
          let pollRate = PollRate.none
          expect(client.pollRate).to(equal(pollRate))
        }
        it("with params when passed in") {
          let pollRate = PollRate.high
          let clientHighPollRate = PwnedPasswords(pollRate: pollRate)
          expect(clientHighPollRate.pollRate).to(equal(pollRate))
        }
      }
      
      context("it hashes a string correctly") {
        it("returns the correct hash for \(plainPassword)") {
          let hash = client.sha1(plainPassword).uppercased()
          expect(hash).to(equal(hashedPassword))
        }
        it("returns the correct prefix") {
          let clientPrefix = client.prefix(hashedPassword)
          expect(clientPrefix).to(equal(prefix))
          expect(clientPrefix.count).to(equal(5))
        }
        it("returns the correct suffix") {
          let clientSuffix = client.suffix(hashedPassword)
          expect(clientSuffix).to(equal(suffix))
        }
      }
      
      context("the public method checks the password") {
        it("takes an input of type string of more than 0 characters") {
          let input = ""
          var error: PwnedError?
          client.check(input) { _, e in
            if let e = e as? PwnedError {
              error = e
            }
          }
          expect(error).toNot(beNil())
          expect(error).to(equal(PwnedError.noEmpty))
        }
        it("return a reponse given a correct prefix") {
          var occurences: Int?
          var error: Error?
          client.check(plainPassword, completion: { (o, e) in
            occurences = o
            error = e
          })
          expect(error).toEventually(beNil())
          expect(occurences).toEventuallyNot(beNil())
          expect(occurences).toEventuallyNot(beGreaterThan(0))
        }
      }
      
      context("it parses the string response") {
        it("parses the string as a dictionary") {
          let dict = client.parseResponse(testResponse)
          expect(dict).to(beAnInstanceOf(Dictionary<String, Int>.self))
          expect(dict[suffix]).to(beGreaterThan(1))
        }
      }
      
      describe("ApiClient") {
        it("returns a string response in the completion handler") {
          var response: String?
          apiClient.getResponse(forPrefix: prefix) { r, error in
            response = r
          }
          expect(response).toEventually(equal(testResponse))
        }
        it("returns the correct respons from the actual api") {
          let realApiCLient = ApiClient()
          var response = ""
          realApiCLient.getResponse(forPrefix: prefix, completion: { (res, error) in
            response = res
          })
          expect(response).toEventually(beAnInstanceOf(String.self), timeout: 5)
          expect(client.parseResponse(response)).toEventually(beAnInstanceOf(Dictionary<String, Int>.self), timeout:5)
        }
      }
    }
    
  }
}
