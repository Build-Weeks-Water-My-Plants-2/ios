import XCTest
@testable import BuildWeek2

class BuildWeek2Tests: XCTestCase {
   // 1
   func testSignInEmptyUser() {
      let session = MockURLSession()
      let controller = APIController(session: session)
      
      let userRepresentation = UserRepresentation(id: 1, username: "", password: "Password", phoneNumber: "123456789", avatarUrl: nil, bearer: nil)
      
      controller.signIn(with: userRepresentation) { result in
         do {
            _ = try result.get()
            XCTFail()
         } catch {
            XCTAssertEqual(error as? APIController.NetworkError, APIController.NetworkError.emptyUser)
         }
      }
   }
   
   // 2
   func testSignInEmptyPassword() {
      let session = MockURLSession()
      let controller = APIController(session: session)
      
      let userRepresentation = UserRepresentation(id: 1, username: "John", password: "", phoneNumber: "123456789", avatarUrl: nil, bearer: nil)
      
      controller.signIn(with: userRepresentation) { result in
         do {
            _ = try result.get()
            XCTFail()
         } catch {
            XCTAssertEqual(error as? APIController.NetworkError, APIController.NetworkError.emptyPassword)
         }
      }
   }
   
   // 3
   func testSignInHttpMethod() {
      let session = MockURLSession()
      let controller = APIController(session: session)
      
      let userRepresentation = UserRepresentation(id: 1, username: "John", password: "Password", phoneNumber: "123456789", avatarUrl: nil, bearer: nil)
      controller.signIn(with: userRepresentation) { _ in }
      
      guard let lastRequest = session.lastRequest else {
         XCTFail()
         return
      }
      
      XCTAssertEqual(lastRequest.httpMethod, APIController.HTTPMethod.post.rawValue)
   }
   
   // 4
   func testSignInContentType() {
      let session = MockURLSession()
      let controller = APIController(session: session)
      
      let userRepresentation = UserRepresentation(id: 1, username: "John", password: "Password", phoneNumber: "123456789", avatarUrl: nil, bearer: nil)
      controller.signIn(with: userRepresentation) { _ in }
      
      guard let lastRequest = session.lastRequest, let contentType = lastRequest.allHTTPHeaderFields?["Content-Type"] else {
         XCTFail()
         return
      }
            
      XCTAssertEqual(contentType, "application/json")
   }
   
   // 5
   func testAddPlantToDatabaseEmptyId() {
      let session = MockURLSession()
      let controller = APIController(session: session)
      
      let plantRepresentation = PlantRepresentation(id: 1,
                                                    nickname: "dasdasd",
                                                    species: "dasdasd",
                                                    h20Frequencey: 10,
                                                    userId: 10,
                                                    avatarUrl: "dasdad",
                                                    happiness: false,
                                                    lastWateredAt: Date())
      
      controller.addPlantToDatabase(plantRepresentation: plantRepresentation) { result in
         do {
            _ = try result.get()
            XCTFail()
         } catch {
            XCTAssertEqual(error as? APIController.NetworkError, APIController.NetworkError.idIsNotEmptyForNewPlant)
         }
      }
   }
   
   // 6
   func testAddPlantToDatabaseNoToken() {
      let session = MockURLSession()
      let controller = APIController(session: session)
      
      let plantRepresentation = PlantRepresentation(id: nil,
                                                    nickname: "dasdasd",
                                                    species: "dasdasd",
                                                    h20Frequencey: 10,
                                                    userId: 10,
                                                    avatarUrl: "dasdad",
                                                    happiness: false,
                                                    lastWateredAt: Date())
      
      controller.addPlantToDatabase(plantRepresentation: plantRepresentation) { result in
         do {
            _ = try result.get()
            XCTFail()
         } catch {
            XCTAssertEqual(error as? APIController.NetworkError, APIController.NetworkError.noToken)
         }
      }
   }
   
   // 7
   func testAddPlantToDatabaseContentType() {
      let session = MockURLSession()
      let controller = APIController(session: session)
      
      controller.bearer = Bearer(token: "ufhsaiuh")
      
      let plantRepresentation = PlantRepresentation(id: nil,
                                                    nickname: "dasdasd",
                                                    species: "dasdasd",
                                                    h20Frequencey: 10,
                                                    userId: 10,
                                                    avatarUrl: "dasdad",
                                                    happiness: false,
                                                    lastWateredAt: Date())
      
      controller.addPlantToDatabase(plantRepresentation: plantRepresentation)
      
      guard let lastRequest = session.lastRequest, let contentType = lastRequest.allHTTPHeaderFields?["Content-Type"] else {
         XCTFail()
         return
      }
      
      XCTAssertEqual(contentType, "application/json")
   }
   
   // 8
   func testDeletePlantsFromDatabaseEmptyId() {
      let session = MockURLSession()
      let controller = APIController(session: session)
      
      let plantRepresentation = PlantRepresentation(id: nil,
                                                    nickname: "dasdasd",
                                                    species: "dasdasd",
                                                    h20Frequencey: 10,
                                                    userId: 10,
                                                    avatarUrl: "dasdad",
                                                    happiness: false,
                                                    lastWateredAt: Date())
      
      controller.deletePlantsFromDatabase(plantRepresentation) { result in
         do {
            _ = try result.get()
            XCTFail()
         } catch {
            XCTAssertEqual(error as? APIController.NetworkError, APIController.NetworkError.noIdentifier)
         }
      }
   }
   
   // 9
   func testDeletePlantsFromDatabaseNoToken() {
      let session = MockURLSession()
      let controller = APIController(session: session)
      
      let plantRepresentation = PlantRepresentation(id: 1,
                                                    nickname: "dasdasd",
                                                    species: "dasdasd",
                                                    h20Frequencey: 10,
                                                    userId: 10,
                                                    avatarUrl: "dasdad",
                                                    happiness: false,
                                                    lastWateredAt: Date())
      
      controller.deletePlantsFromDatabase(plantRepresentation) { result in
         do {
            _ = try result.get()
            XCTFail()
         } catch {
            XCTAssertEqual(error as? APIController.NetworkError, APIController.NetworkError.noToken)
         }
      }
   }
   
   // 10
   func testDeletePlantsFromDatabaseHttpMethod() {
      let session = MockURLSession()
      let controller = APIController(session: session)
      
      controller.bearer = Bearer(token: "ufhsaiuh")
      
      let plantRepresentation = PlantRepresentation(id: 1,
                                                    nickname: "dasdasd",
                                                    species: "dasdasd",
                                                    h20Frequencey: 10,
                                                    userId: 10,
                                                    avatarUrl: "dasdad",
                                                    happiness: false,
                                                    lastWateredAt: Date())
      
      controller.deletePlantsFromDatabase(plantRepresentation)
      
      guard let lastRequest = session.lastRequest else {
         XCTFail()
         return
      }
      
      XCTAssertEqual(lastRequest.httpMethod, APIController.HTTPMethod.delete.rawValue)
   }
}
