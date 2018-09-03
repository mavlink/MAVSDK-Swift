# Dronecode-SDK-Swift

## Use framework in iOS application

### Get framework using carthage

To use this framework, add this to your `Cartfile`:

```
github "Dronecode/DronecodeSDK-Swift" "master"
```

And then get the framework using:
```
carthage bootstrap --platform ios
```

### First steps to use framework

**Note:** The steps below assume that your iOS device has a network connection to the drone, e.g. using WiFi.

To connect to the drone, add a CoreManager to your iOS application:

```
import Foundation
import Dronecode_SDK_Swift
import MFiAdapter
import RxSwift

class CoreManager {
    let disposeBag = DisposeBag()

    let core: Core

    let telemetry = Telemetry(address: "localhost", port: 50051)
    let action = Action(address: "localhost", port: 50051)
    let mission = Mission(address: "localhost", port: 50051)
    let camera = Camera(address: "localhost", port: 50051)

    private static var sharedCoreManager: CoreManager = {
        let coreManager = CoreManager()
        return coreManager
    }()

    private init() {
        core = Core()
    }

    class func shared() -> CoreManager {
        return sharedCoreManager
    }

    public func start() -> Void {
        core.connect()
            .subscribe(onCompleted: {
                print("Core connected")
            }) { (error) in
                print("Failed connect to core with error: \(error.localizedDescription)")
            }
            .disposed(by: disposeBag)
    }
}
```

Then, you can for instance use the `CoreManager` in your view controller like this:
```
import Dronecode_SDK_Swift
import RxSwift

class MyViewController: UIViewController {

    @IBOutlet weak var armButton: UIButton!
    @IBOutlet weak var feedbackLabel: UILabel!

    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func armPressed(_ sender: Any) {
        CoreManager.shared().action.arm()
            .do(onError: { error in
                self.feedbackLabel.text = "Arming failed : \(error.localizedDescription)"
            }, onCompleted: {
                self.feedbackLabel.text = "Arming succeeded"
            })
            .subscribe()
            .disposed(by: disposeBag)
}
```

### Example of iOS application

Check out the [iOS example application](https://github.com/Dronecode/DronecodeSDK-Swift-Example) for a complete example project using this framework.

## Develop for this framework

For instructions how to develop on the Swift wrappers and contribute, please check out:
[CONTRIBUTING.md](CONTRIBUTING.md).

