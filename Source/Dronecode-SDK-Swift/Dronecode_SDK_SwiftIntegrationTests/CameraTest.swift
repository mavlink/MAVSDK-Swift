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
        let camera = Camera(address: "localhost", port: 50051)
        
        camera.takePhoto()
            .do(onError: { error in XCTFail("\(error)") })
            .subscribe()
    }
}
