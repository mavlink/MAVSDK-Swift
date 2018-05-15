import Foundation
import RxBlocking
import RxSwift
import RxTest
import XCTest
@testable import Dronecode_SDK_Swift

class CameraTest: XCTestCase {
    func testTakePhoto() {
        let core = Core()
        core.connect().toBlocking().materialize()
        let mission = Camera(address: "localhost", port: 50051)
        
        mission.takePhoto()
            .do(onError: { error in XCTFail("\(error)") })
            .subscribe()
    }
}
