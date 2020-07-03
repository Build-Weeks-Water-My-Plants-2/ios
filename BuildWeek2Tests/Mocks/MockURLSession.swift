import Foundation
@testable import BuildWeek2

class MockURLSession: URLSessionProtocol {
   var lastRequest: URLRequest?
   
   func testableDataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol {
      lastRequest = request
      completionHandler(nil, nil, nil)
      return MockURLSessionDataTask()
   }
}
