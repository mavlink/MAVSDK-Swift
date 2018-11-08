# Dronecode-SDK-Swift

## Use framework in iOS application

### Get framework using carthage

To use this framework, add the following to your `Cartfile`:

```
github "Dronecode/DronecodeSDK-Swift" == 0.1.6
```

And then get the framework using:
```
carthage bootstrap --platform ios
```

### First steps to use framework

The steps below assume that your iOS device has a network connection to the drone, e.g. using WiFi.

By default, the backend will connect using MAVLink on UDP port 14540 which is running by default when PX4 is run in SITL (software in the loop simulation).
To change the connection port, check [this line in the backend](https://github.com/Dronecode/DronecodeSDK/blob/d4fb6ca56f8e4ce01252ed498835c500e477d2d2/backend/src/backend.cpp#L19). For now, the backend is limited to UDP even though the core supports UDP, TCP, and serial.

One way to start is to add a CoreManager to your iOS application:

```
import Foundation
import Dronecode_SDK_Swift
import RxSwift

class CoreManager {

    static let shared = CoreManager()

    let disposeBag = DisposeBag()

    let core = Core()
    let telemetry = Telemetry(address: "localhost", port: 50051)
    let action = Action(address: "localhost", port: 50051)
    let mission = Mission(address: "localhost", port: 50051)
    let camera = Camera(address: "localhost", port: 50051)

    private init() {}

    lazy var startCompletable = createStartCompletable()

    private func createStartCompletable() -> Observable<Never> {
        let startCompletable = core.connect().asObservable().replay(1)
        startCompletable.connect().disposed(by: disposeBag)
        
        return startCompletable.asObservable()
    }
}
```

Then, use the `CoreManager` in your view controller like this:

```
import Dronecode_SDK_Swift
import RxSwift

class MyViewController: UIViewController {

    @IBOutlet weak var armButton: UIButton!
    @IBOutlet weak var feedbackLabel: UILabel!

    private let disposeBag = DisposeBag()

    @IBAction func armPressed(_ sender: Any) {
        CoreManager.shared.action.arm()
            .do(onError: { error in self.feedbackLabel.text = "Arming failed : \(error.localizedDescription)" },
                onCompleted: { self.feedbackLabel.text = "Arming succeeded" })
            .subscribe()
            .disposed(by: disposeBag)
}
```

### Example of iOS application

Check out the [iOS example application](https://github.com/Dronecode/DronecodeSDK-Swift-Example) for a complete example project using this framework.

## Develop for this framework

For instructions how to develop on the Swift wrappers and contribute, please check out:
[CONTRIBUTING.md](https://github.com/Dronecode/DronecodeSDK-Swift/blob/master/CONTRIBUTING.md).

