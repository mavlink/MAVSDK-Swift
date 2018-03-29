import backend
import Foundation
import gRPC
import RxSwift

public class Core {
    init() {
        gRPC.initialize()
    }
    
    public func connect() {
        DispatchQueue.global(qos: .background).async {
            print("Running backend in background (MAVLink port: 14540)")
            runBackend(14540)
        }
    }
}
