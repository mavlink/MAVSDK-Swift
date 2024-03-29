// DO NOT EDIT.
// swift-format-ignore-file
//
// Generated by the Swift generator plugin for the protocol buffer compiler.
// Source: failure.proto
//
// For information on using the generated types, please see the documentation:
//   https://github.com/apple/swift-protobuf/

import Foundation
import SwiftProtobuf

// If the compiler emits an error on this type, it is because this file
// was generated by a version of the `protoc` Swift plug-in that is
// incompatible with the version of SwiftProtobuf to which you are linking.
// Please ensure that you are building against the same version of the API
// that was used to generate this file.
fileprivate struct _GeneratedWithProtocGenSwiftVersion: SwiftProtobuf.ProtobufAPIVersionCheck {
  struct _2: SwiftProtobuf.ProtobufAPIVersion_2 {}
  typealias Version = _2
}

/// A failure unit.
enum Mavsdk_Rpc_Failure_FailureUnit: SwiftProtobuf.Enum {
  typealias RawValue = Int

  /// Gyro
  case sensorGyro // = 0

  /// Accelerometer
  case sensorAccel // = 1

  /// Magnetometer
  case sensorMag // = 2

  /// Barometer
  case sensorBaro // = 3

  /// GPS
  case sensorGps // = 4

  /// Optical flow
  case sensorOpticalFlow // = 5

  /// Visual inertial odometry
  case sensorVio // = 6

  /// Distance sensor
  case sensorDistanceSensor // = 7

  /// Airspeed
  case sensorAirspeed // = 8

  /// Battery
  case systemBattery // = 100

  /// Motor
  case systemMotor // = 101

  /// Servo
  case systemServo // = 102

  /// Avoidance
  case systemAvoidance // = 103

  /// RC signal
  case systemRcSignal // = 104

  /// MAVLink signal
  case systemMavlinkSignal // = 105
  case UNRECOGNIZED(Int)

  init() {
    self = .sensorGyro
  }

  init?(rawValue: Int) {
    switch rawValue {
    case 0: self = .sensorGyro
    case 1: self = .sensorAccel
    case 2: self = .sensorMag
    case 3: self = .sensorBaro
    case 4: self = .sensorGps
    case 5: self = .sensorOpticalFlow
    case 6: self = .sensorVio
    case 7: self = .sensorDistanceSensor
    case 8: self = .sensorAirspeed
    case 100: self = .systemBattery
    case 101: self = .systemMotor
    case 102: self = .systemServo
    case 103: self = .systemAvoidance
    case 104: self = .systemRcSignal
    case 105: self = .systemMavlinkSignal
    default: self = .UNRECOGNIZED(rawValue)
    }
  }

  var rawValue: Int {
    switch self {
    case .sensorGyro: return 0
    case .sensorAccel: return 1
    case .sensorMag: return 2
    case .sensorBaro: return 3
    case .sensorGps: return 4
    case .sensorOpticalFlow: return 5
    case .sensorVio: return 6
    case .sensorDistanceSensor: return 7
    case .sensorAirspeed: return 8
    case .systemBattery: return 100
    case .systemMotor: return 101
    case .systemServo: return 102
    case .systemAvoidance: return 103
    case .systemRcSignal: return 104
    case .systemMavlinkSignal: return 105
    case .UNRECOGNIZED(let i): return i
    }
  }

}

#if swift(>=4.2)

extension Mavsdk_Rpc_Failure_FailureUnit: CaseIterable {
  // The compiler won't synthesize support with the UNRECOGNIZED case.
  static let allCases: [Mavsdk_Rpc_Failure_FailureUnit] = [
    .sensorGyro,
    .sensorAccel,
    .sensorMag,
    .sensorBaro,
    .sensorGps,
    .sensorOpticalFlow,
    .sensorVio,
    .sensorDistanceSensor,
    .sensorAirspeed,
    .systemBattery,
    .systemMotor,
    .systemServo,
    .systemAvoidance,
    .systemRcSignal,
    .systemMavlinkSignal,
  ]
}

#endif  // swift(>=4.2)

/// A failure type
enum Mavsdk_Rpc_Failure_FailureType: SwiftProtobuf.Enum {
  typealias RawValue = Int

  /// No failure injected, used to reset a previous failure
  case ok // = 0

  /// Sets unit off, so completely non-responsive
  case off // = 1

  /// Unit is stuck e.g. keeps reporting the same value
  case stuck // = 2

  /// Unit is reporting complete garbage
  case garbage // = 3

  /// Unit is consistently wrong
  case wrong // = 4

  /// Unit is slow, so e.g. reporting at slower than expected rate
  case slow // = 5

  /// Data of unit is delayed in time
  case delayed // = 6

  /// Unit is sometimes working, sometimes not
  case intermittent // = 7
  case UNRECOGNIZED(Int)

  init() {
    self = .ok
  }

  init?(rawValue: Int) {
    switch rawValue {
    case 0: self = .ok
    case 1: self = .off
    case 2: self = .stuck
    case 3: self = .garbage
    case 4: self = .wrong
    case 5: self = .slow
    case 6: self = .delayed
    case 7: self = .intermittent
    default: self = .UNRECOGNIZED(rawValue)
    }
  }

  var rawValue: Int {
    switch self {
    case .ok: return 0
    case .off: return 1
    case .stuck: return 2
    case .garbage: return 3
    case .wrong: return 4
    case .slow: return 5
    case .delayed: return 6
    case .intermittent: return 7
    case .UNRECOGNIZED(let i): return i
    }
  }

}

#if swift(>=4.2)

extension Mavsdk_Rpc_Failure_FailureType: CaseIterable {
  // The compiler won't synthesize support with the UNRECOGNIZED case.
  static let allCases: [Mavsdk_Rpc_Failure_FailureType] = [
    .ok,
    .off,
    .stuck,
    .garbage,
    .wrong,
    .slow,
    .delayed,
    .intermittent,
  ]
}

#endif  // swift(>=4.2)

struct Mavsdk_Rpc_Failure_InjectRequest {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  /// The failure unit to send
  var failureUnit: Mavsdk_Rpc_Failure_FailureUnit = .sensorGyro

  /// The failure type to send
  var failureType: Mavsdk_Rpc_Failure_FailureType = .ok

  /// Instance to affect (0 for all)
  var instance: Int32 = 0

  var unknownFields = SwiftProtobuf.UnknownStorage()

  init() {}
}

struct Mavsdk_Rpc_Failure_InjectResponse {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  var failureResult: Mavsdk_Rpc_Failure_FailureResult {
    get {return _failureResult ?? Mavsdk_Rpc_Failure_FailureResult()}
    set {_failureResult = newValue}
  }
  /// Returns true if `failureResult` has been explicitly set.
  var hasFailureResult: Bool {return self._failureResult != nil}
  /// Clears the value of `failureResult`. Subsequent reads from it will return its default value.
  mutating func clearFailureResult() {self._failureResult = nil}

  var unknownFields = SwiftProtobuf.UnknownStorage()

  init() {}

  fileprivate var _failureResult: Mavsdk_Rpc_Failure_FailureResult? = nil
}

struct Mavsdk_Rpc_Failure_FailureResult {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  /// Result enum value
  var result: Mavsdk_Rpc_Failure_FailureResult.Result = .unknown

  /// Human-readable English string describing the result
  var resultStr: String = String()

  var unknownFields = SwiftProtobuf.UnknownStorage()

  /// Possible results returned for failure requests.
  enum Result: SwiftProtobuf.Enum {
    typealias RawValue = Int

    /// Unknown result
    case unknown // = 0

    /// Request succeeded
    case success // = 1

    /// No system is connected
    case noSystem // = 2

    /// Connection error
    case connectionError // = 3

    /// Failure not supported
    case unsupported // = 4

    /// Failure injection denied
    case denied // = 5

    /// Failure injection is disabled
    case disabled // = 6

    /// Request timed out
    case timeout // = 7
    case UNRECOGNIZED(Int)

    init() {
      self = .unknown
    }

    init?(rawValue: Int) {
      switch rawValue {
      case 0: self = .unknown
      case 1: self = .success
      case 2: self = .noSystem
      case 3: self = .connectionError
      case 4: self = .unsupported
      case 5: self = .denied
      case 6: self = .disabled
      case 7: self = .timeout
      default: self = .UNRECOGNIZED(rawValue)
      }
    }

    var rawValue: Int {
      switch self {
      case .unknown: return 0
      case .success: return 1
      case .noSystem: return 2
      case .connectionError: return 3
      case .unsupported: return 4
      case .denied: return 5
      case .disabled: return 6
      case .timeout: return 7
      case .UNRECOGNIZED(let i): return i
      }
    }

  }

  init() {}
}

#if swift(>=4.2)

extension Mavsdk_Rpc_Failure_FailureResult.Result: CaseIterable {
  // The compiler won't synthesize support with the UNRECOGNIZED case.
  static let allCases: [Mavsdk_Rpc_Failure_FailureResult.Result] = [
    .unknown,
    .success,
    .noSystem,
    .connectionError,
    .unsupported,
    .denied,
    .disabled,
    .timeout,
  ]
}

#endif  // swift(>=4.2)

#if swift(>=5.5) && canImport(_Concurrency)
extension Mavsdk_Rpc_Failure_FailureUnit: @unchecked Sendable {}
extension Mavsdk_Rpc_Failure_FailureType: @unchecked Sendable {}
extension Mavsdk_Rpc_Failure_InjectRequest: @unchecked Sendable {}
extension Mavsdk_Rpc_Failure_InjectResponse: @unchecked Sendable {}
extension Mavsdk_Rpc_Failure_FailureResult: @unchecked Sendable {}
extension Mavsdk_Rpc_Failure_FailureResult.Result: @unchecked Sendable {}
#endif  // swift(>=5.5) && canImport(_Concurrency)

// MARK: - Code below here is support for the SwiftProtobuf runtime.

fileprivate let _protobuf_package = "mavsdk.rpc.failure"

extension Mavsdk_Rpc_Failure_FailureUnit: SwiftProtobuf._ProtoNameProviding {
  static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    0: .same(proto: "FAILURE_UNIT_SENSOR_GYRO"),
    1: .same(proto: "FAILURE_UNIT_SENSOR_ACCEL"),
    2: .same(proto: "FAILURE_UNIT_SENSOR_MAG"),
    3: .same(proto: "FAILURE_UNIT_SENSOR_BARO"),
    4: .same(proto: "FAILURE_UNIT_SENSOR_GPS"),
    5: .same(proto: "FAILURE_UNIT_SENSOR_OPTICAL_FLOW"),
    6: .same(proto: "FAILURE_UNIT_SENSOR_VIO"),
    7: .same(proto: "FAILURE_UNIT_SENSOR_DISTANCE_SENSOR"),
    8: .same(proto: "FAILURE_UNIT_SENSOR_AIRSPEED"),
    100: .same(proto: "FAILURE_UNIT_SYSTEM_BATTERY"),
    101: .same(proto: "FAILURE_UNIT_SYSTEM_MOTOR"),
    102: .same(proto: "FAILURE_UNIT_SYSTEM_SERVO"),
    103: .same(proto: "FAILURE_UNIT_SYSTEM_AVOIDANCE"),
    104: .same(proto: "FAILURE_UNIT_SYSTEM_RC_SIGNAL"),
    105: .same(proto: "FAILURE_UNIT_SYSTEM_MAVLINK_SIGNAL"),
  ]
}

extension Mavsdk_Rpc_Failure_FailureType: SwiftProtobuf._ProtoNameProviding {
  static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    0: .same(proto: "FAILURE_TYPE_OK"),
    1: .same(proto: "FAILURE_TYPE_OFF"),
    2: .same(proto: "FAILURE_TYPE_STUCK"),
    3: .same(proto: "FAILURE_TYPE_GARBAGE"),
    4: .same(proto: "FAILURE_TYPE_WRONG"),
    5: .same(proto: "FAILURE_TYPE_SLOW"),
    6: .same(proto: "FAILURE_TYPE_DELAYED"),
    7: .same(proto: "FAILURE_TYPE_INTERMITTENT"),
  ]
}

extension Mavsdk_Rpc_Failure_InjectRequest: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  static let protoMessageName: String = _protobuf_package + ".InjectRequest"
  static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .standard(proto: "failure_unit"),
    2: .standard(proto: "failure_type"),
    3: .same(proto: "instance"),
  ]

  mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      // The use of inline closures is to circumvent an issue where the compiler
      // allocates stack space for every case branch when no optimizations are
      // enabled. https://github.com/apple/swift-protobuf/issues/1034
      switch fieldNumber {
      case 1: try { try decoder.decodeSingularEnumField(value: &self.failureUnit) }()
      case 2: try { try decoder.decodeSingularEnumField(value: &self.failureType) }()
      case 3: try { try decoder.decodeSingularInt32Field(value: &self.instance) }()
      default: break
      }
    }
  }

  func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    if self.failureUnit != .sensorGyro {
      try visitor.visitSingularEnumField(value: self.failureUnit, fieldNumber: 1)
    }
    if self.failureType != .ok {
      try visitor.visitSingularEnumField(value: self.failureType, fieldNumber: 2)
    }
    if self.instance != 0 {
      try visitor.visitSingularInt32Field(value: self.instance, fieldNumber: 3)
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  static func ==(lhs: Mavsdk_Rpc_Failure_InjectRequest, rhs: Mavsdk_Rpc_Failure_InjectRequest) -> Bool {
    if lhs.failureUnit != rhs.failureUnit {return false}
    if lhs.failureType != rhs.failureType {return false}
    if lhs.instance != rhs.instance {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}

extension Mavsdk_Rpc_Failure_InjectResponse: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  static let protoMessageName: String = _protobuf_package + ".InjectResponse"
  static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .standard(proto: "failure_result"),
  ]

  mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      // The use of inline closures is to circumvent an issue where the compiler
      // allocates stack space for every case branch when no optimizations are
      // enabled. https://github.com/apple/swift-protobuf/issues/1034
      switch fieldNumber {
      case 1: try { try decoder.decodeSingularMessageField(value: &self._failureResult) }()
      default: break
      }
    }
  }

  func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    // The use of inline closures is to circumvent an issue where the compiler
    // allocates stack space for every if/case branch local when no optimizations
    // are enabled. https://github.com/apple/swift-protobuf/issues/1034 and
    // https://github.com/apple/swift-protobuf/issues/1182
    try { if let v = self._failureResult {
      try visitor.visitSingularMessageField(value: v, fieldNumber: 1)
    } }()
    try unknownFields.traverse(visitor: &visitor)
  }

  static func ==(lhs: Mavsdk_Rpc_Failure_InjectResponse, rhs: Mavsdk_Rpc_Failure_InjectResponse) -> Bool {
    if lhs._failureResult != rhs._failureResult {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}

extension Mavsdk_Rpc_Failure_FailureResult: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  static let protoMessageName: String = _protobuf_package + ".FailureResult"
  static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .same(proto: "result"),
    2: .standard(proto: "result_str"),
  ]

  mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      // The use of inline closures is to circumvent an issue where the compiler
      // allocates stack space for every case branch when no optimizations are
      // enabled. https://github.com/apple/swift-protobuf/issues/1034
      switch fieldNumber {
      case 1: try { try decoder.decodeSingularEnumField(value: &self.result) }()
      case 2: try { try decoder.decodeSingularStringField(value: &self.resultStr) }()
      default: break
      }
    }
  }

  func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    if self.result != .unknown {
      try visitor.visitSingularEnumField(value: self.result, fieldNumber: 1)
    }
    if !self.resultStr.isEmpty {
      try visitor.visitSingularStringField(value: self.resultStr, fieldNumber: 2)
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  static func ==(lhs: Mavsdk_Rpc_Failure_FailureResult, rhs: Mavsdk_Rpc_Failure_FailureResult) -> Bool {
    if lhs.result != rhs.result {return false}
    if lhs.resultStr != rhs.resultStr {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}

extension Mavsdk_Rpc_Failure_FailureResult.Result: SwiftProtobuf._ProtoNameProviding {
  static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    0: .same(proto: "RESULT_UNKNOWN"),
    1: .same(proto: "RESULT_SUCCESS"),
    2: .same(proto: "RESULT_NO_SYSTEM"),
    3: .same(proto: "RESULT_CONNECTION_ERROR"),
    4: .same(proto: "RESULT_UNSUPPORTED"),
    5: .same(proto: "RESULT_DENIED"),
    6: .same(proto: "RESULT_DISABLED"),
    7: .same(proto: "RESULT_TIMEOUT"),
  ]
}
