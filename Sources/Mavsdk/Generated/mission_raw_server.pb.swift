// DO NOT EDIT.
// swift-format-ignore-file
//
// Generated by the Swift generator plugin for the protocol buffer compiler.
// Source: mission_raw_server.proto
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

struct Mavsdk_Rpc_MissionRawServer_SubscribeIncomingMissionRequest {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  var unknownFields = SwiftProtobuf.UnknownStorage()

  init() {}
}

struct Mavsdk_Rpc_MissionRawServer_IncomingMissionResponse {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  var missionRawServerResult: Mavsdk_Rpc_MissionRawServer_MissionRawServerResult {
    get {return _missionRawServerResult ?? Mavsdk_Rpc_MissionRawServer_MissionRawServerResult()}
    set {_missionRawServerResult = newValue}
  }
  /// Returns true if `missionRawServerResult` has been explicitly set.
  var hasMissionRawServerResult: Bool {return self._missionRawServerResult != nil}
  /// Clears the value of `missionRawServerResult`. Subsequent reads from it will return its default value.
  mutating func clearMissionRawServerResult() {self._missionRawServerResult = nil}

  /// The mission plan
  var missionPlan: Mavsdk_Rpc_MissionRawServer_MissionPlan {
    get {return _missionPlan ?? Mavsdk_Rpc_MissionRawServer_MissionPlan()}
    set {_missionPlan = newValue}
  }
  /// Returns true if `missionPlan` has been explicitly set.
  var hasMissionPlan: Bool {return self._missionPlan != nil}
  /// Clears the value of `missionPlan`. Subsequent reads from it will return its default value.
  mutating func clearMissionPlan() {self._missionPlan = nil}

  var unknownFields = SwiftProtobuf.UnknownStorage()

  init() {}

  fileprivate var _missionRawServerResult: Mavsdk_Rpc_MissionRawServer_MissionRawServerResult? = nil
  fileprivate var _missionPlan: Mavsdk_Rpc_MissionRawServer_MissionPlan? = nil
}

struct Mavsdk_Rpc_MissionRawServer_SubscribeCurrentItemChangedRequest {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  var unknownFields = SwiftProtobuf.UnknownStorage()

  init() {}
}

struct Mavsdk_Rpc_MissionRawServer_CurrentItemChangedResponse {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  var missionItem: Mavsdk_Rpc_MissionRawServer_MissionItem {
    get {return _missionItem ?? Mavsdk_Rpc_MissionRawServer_MissionItem()}
    set {_missionItem = newValue}
  }
  /// Returns true if `missionItem` has been explicitly set.
  var hasMissionItem: Bool {return self._missionItem != nil}
  /// Clears the value of `missionItem`. Subsequent reads from it will return its default value.
  mutating func clearMissionItem() {self._missionItem = nil}

  var unknownFields = SwiftProtobuf.UnknownStorage()

  init() {}

  fileprivate var _missionItem: Mavsdk_Rpc_MissionRawServer_MissionItem? = nil
}

struct Mavsdk_Rpc_MissionRawServer_SubscribeClearAllRequest {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  var unknownFields = SwiftProtobuf.UnknownStorage()

  init() {}
}

struct Mavsdk_Rpc_MissionRawServer_ClearAllResponse {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  var clearType_p: UInt32 = 0

  var unknownFields = SwiftProtobuf.UnknownStorage()

  init() {}
}

struct Mavsdk_Rpc_MissionRawServer_SetCurrentItemCompleteRequest {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  var unknownFields = SwiftProtobuf.UnknownStorage()

  init() {}
}

struct Mavsdk_Rpc_MissionRawServer_SetCurrentItemCompleteResponse {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  var unknownFields = SwiftProtobuf.UnknownStorage()

  init() {}
}

/// Mission item exactly identical to MAVLink MISSION_ITEM_INT.
struct Mavsdk_Rpc_MissionRawServer_MissionItem {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  /// Sequence (uint16_t)
  var seq: UInt32 = 0

  /// The coordinate system of the waypoint (actually uint8_t)
  var frame: UInt32 = 0

  /// The scheduled action for the waypoint (actually uint16_t)
  var command: UInt32 = 0

  /// false:0, true:1 (actually uint8_t)
  var current: UInt32 = 0

  /// Autocontinue to next waypoint (actually uint8_t)
  var autocontinue: UInt32 = 0

  /// PARAM1, see MAV_CMD enum
  var param1: Float = 0

  /// PARAM2, see MAV_CMD enum
  var param2: Float = 0

  /// PARAM3, see MAV_CMD enum
  var param3: Float = 0

  /// PARAM4, see MAV_CMD enum
  var param4: Float = 0

  /// PARAM5 / local: x position in meters * 1e4, global: latitude in degrees * 10^7
  var x: Int32 = 0

  /// PARAM6 / y position: local: x position in meters * 1e4, global: longitude in degrees *10^7
  var y: Int32 = 0

  /// PARAM7 / local: Z coordinate, global: altitude (relative or absolute, depending on frame)
  var z: Float = 0

  /// Mission type (actually uint8_t)
  var missionType: UInt32 = 0

  var unknownFields = SwiftProtobuf.UnknownStorage()

  init() {}
}

/// Mission plan type
struct Mavsdk_Rpc_MissionRawServer_MissionPlan {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  /// The mission items
  var missionItems: [Mavsdk_Rpc_MissionRawServer_MissionItem] = []

  var unknownFields = SwiftProtobuf.UnknownStorage()

  init() {}
}

/// Mission progress type.
struct Mavsdk_Rpc_MissionRawServer_MissionProgress {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  /// Current mission item index (0-based), if equal to total, the mission is finished
  var current: Int32 = 0

  /// Total number of mission items
  var total: Int32 = 0

  var unknownFields = SwiftProtobuf.UnknownStorage()

  init() {}
}

/// Result type.
struct Mavsdk_Rpc_MissionRawServer_MissionRawServerResult {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  /// Result enum value
  var result: Mavsdk_Rpc_MissionRawServer_MissionRawServerResult.Result = .unknown

  /// Human-readable English string describing the result
  var resultStr: String = String()

  var unknownFields = SwiftProtobuf.UnknownStorage()

  /// Possible results returned for action requests.
  enum Result: SwiftProtobuf.Enum {
    typealias RawValue = Int

    /// Unknown result
    case unknown // = 0

    /// Request succeeded
    case success // = 1

    /// Error
    case error // = 2

    /// Too many mission items in the mission
    case tooManyMissionItems // = 3

    /// Vehicle is busy
    case busy // = 4

    /// Request timed out
    case timeout // = 5

    /// Invalid argument
    case invalidArgument // = 6

    /// Mission downloaded from the system is not supported
    case unsupported // = 7

    /// No mission available on the system
    case noMissionAvailable // = 8

    /// Unsupported mission command
    case unsupportedMissionCmd // = 11

    /// Mission transfer (upload or download) has been cancelled
    case transferCancelled // = 12

    /// No system connected
    case noSystem // = 13

    /// Intermediate message showing progress or instructions on the next steps
    case next // = 14
    case UNRECOGNIZED(Int)

    init() {
      self = .unknown
    }

    init?(rawValue: Int) {
      switch rawValue {
      case 0: self = .unknown
      case 1: self = .success
      case 2: self = .error
      case 3: self = .tooManyMissionItems
      case 4: self = .busy
      case 5: self = .timeout
      case 6: self = .invalidArgument
      case 7: self = .unsupported
      case 8: self = .noMissionAvailable
      case 11: self = .unsupportedMissionCmd
      case 12: self = .transferCancelled
      case 13: self = .noSystem
      case 14: self = .next
      default: self = .UNRECOGNIZED(rawValue)
      }
    }

    var rawValue: Int {
      switch self {
      case .unknown: return 0
      case .success: return 1
      case .error: return 2
      case .tooManyMissionItems: return 3
      case .busy: return 4
      case .timeout: return 5
      case .invalidArgument: return 6
      case .unsupported: return 7
      case .noMissionAvailable: return 8
      case .unsupportedMissionCmd: return 11
      case .transferCancelled: return 12
      case .noSystem: return 13
      case .next: return 14
      case .UNRECOGNIZED(let i): return i
      }
    }

  }

  init() {}
}

#if swift(>=4.2)

extension Mavsdk_Rpc_MissionRawServer_MissionRawServerResult.Result: CaseIterable {
  // The compiler won't synthesize support with the UNRECOGNIZED case.
  static var allCases: [Mavsdk_Rpc_MissionRawServer_MissionRawServerResult.Result] = [
    .unknown,
    .success,
    .error,
    .tooManyMissionItems,
    .busy,
    .timeout,
    .invalidArgument,
    .unsupported,
    .noMissionAvailable,
    .unsupportedMissionCmd,
    .transferCancelled,
    .noSystem,
    .next,
  ]
}

#endif  // swift(>=4.2)

// MARK: - Code below here is support for the SwiftProtobuf runtime.

fileprivate let _protobuf_package = "mavsdk.rpc.mission_raw_server"

extension Mavsdk_Rpc_MissionRawServer_SubscribeIncomingMissionRequest: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  static let protoMessageName: String = _protobuf_package + ".SubscribeIncomingMissionRequest"
  static let _protobuf_nameMap = SwiftProtobuf._NameMap()

  mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let _ = try decoder.nextFieldNumber() {
    }
  }

  func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    try unknownFields.traverse(visitor: &visitor)
  }

  static func ==(lhs: Mavsdk_Rpc_MissionRawServer_SubscribeIncomingMissionRequest, rhs: Mavsdk_Rpc_MissionRawServer_SubscribeIncomingMissionRequest) -> Bool {
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}

extension Mavsdk_Rpc_MissionRawServer_IncomingMissionResponse: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  static let protoMessageName: String = _protobuf_package + ".IncomingMissionResponse"
  static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .standard(proto: "mission_raw_server_result"),
    2: .standard(proto: "mission_plan"),
  ]

  mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      // The use of inline closures is to circumvent an issue where the compiler
      // allocates stack space for every case branch when no optimizations are
      // enabled. https://github.com/apple/swift-protobuf/issues/1034
      switch fieldNumber {
      case 1: try { try decoder.decodeSingularMessageField(value: &self._missionRawServerResult) }()
      case 2: try { try decoder.decodeSingularMessageField(value: &self._missionPlan) }()
      default: break
      }
    }
  }

  func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    // The use of inline closures is to circumvent an issue where the compiler
    // allocates stack space for every if/case branch local when no optimizations
    // are enabled. https://github.com/apple/swift-protobuf/issues/1034 and
    // https://github.com/apple/swift-protobuf/issues/1182
    try { if let v = self._missionRawServerResult {
      try visitor.visitSingularMessageField(value: v, fieldNumber: 1)
    } }()
    try { if let v = self._missionPlan {
      try visitor.visitSingularMessageField(value: v, fieldNumber: 2)
    } }()
    try unknownFields.traverse(visitor: &visitor)
  }

  static func ==(lhs: Mavsdk_Rpc_MissionRawServer_IncomingMissionResponse, rhs: Mavsdk_Rpc_MissionRawServer_IncomingMissionResponse) -> Bool {
    if lhs._missionRawServerResult != rhs._missionRawServerResult {return false}
    if lhs._missionPlan != rhs._missionPlan {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}

extension Mavsdk_Rpc_MissionRawServer_SubscribeCurrentItemChangedRequest: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  static let protoMessageName: String = _protobuf_package + ".SubscribeCurrentItemChangedRequest"
  static let _protobuf_nameMap = SwiftProtobuf._NameMap()

  mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let _ = try decoder.nextFieldNumber() {
    }
  }

  func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    try unknownFields.traverse(visitor: &visitor)
  }

  static func ==(lhs: Mavsdk_Rpc_MissionRawServer_SubscribeCurrentItemChangedRequest, rhs: Mavsdk_Rpc_MissionRawServer_SubscribeCurrentItemChangedRequest) -> Bool {
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}

extension Mavsdk_Rpc_MissionRawServer_CurrentItemChangedResponse: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  static let protoMessageName: String = _protobuf_package + ".CurrentItemChangedResponse"
  static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .standard(proto: "mission_item"),
  ]

  mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      // The use of inline closures is to circumvent an issue where the compiler
      // allocates stack space for every case branch when no optimizations are
      // enabled. https://github.com/apple/swift-protobuf/issues/1034
      switch fieldNumber {
      case 1: try { try decoder.decodeSingularMessageField(value: &self._missionItem) }()
      default: break
      }
    }
  }

  func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    // The use of inline closures is to circumvent an issue where the compiler
    // allocates stack space for every if/case branch local when no optimizations
    // are enabled. https://github.com/apple/swift-protobuf/issues/1034 and
    // https://github.com/apple/swift-protobuf/issues/1182
    try { if let v = self._missionItem {
      try visitor.visitSingularMessageField(value: v, fieldNumber: 1)
    } }()
    try unknownFields.traverse(visitor: &visitor)
  }

  static func ==(lhs: Mavsdk_Rpc_MissionRawServer_CurrentItemChangedResponse, rhs: Mavsdk_Rpc_MissionRawServer_CurrentItemChangedResponse) -> Bool {
    if lhs._missionItem != rhs._missionItem {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}

extension Mavsdk_Rpc_MissionRawServer_SubscribeClearAllRequest: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  static let protoMessageName: String = _protobuf_package + ".SubscribeClearAllRequest"
  static let _protobuf_nameMap = SwiftProtobuf._NameMap()

  mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let _ = try decoder.nextFieldNumber() {
    }
  }

  func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    try unknownFields.traverse(visitor: &visitor)
  }

  static func ==(lhs: Mavsdk_Rpc_MissionRawServer_SubscribeClearAllRequest, rhs: Mavsdk_Rpc_MissionRawServer_SubscribeClearAllRequest) -> Bool {
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}

extension Mavsdk_Rpc_MissionRawServer_ClearAllResponse: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  static let protoMessageName: String = _protobuf_package + ".ClearAllResponse"
  static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .standard(proto: "clear_type"),
  ]

  mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      // The use of inline closures is to circumvent an issue where the compiler
      // allocates stack space for every case branch when no optimizations are
      // enabled. https://github.com/apple/swift-protobuf/issues/1034
      switch fieldNumber {
      case 1: try { try decoder.decodeSingularUInt32Field(value: &self.clearType_p) }()
      default: break
      }
    }
  }

  func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    if self.clearType_p != 0 {
      try visitor.visitSingularUInt32Field(value: self.clearType_p, fieldNumber: 1)
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  static func ==(lhs: Mavsdk_Rpc_MissionRawServer_ClearAllResponse, rhs: Mavsdk_Rpc_MissionRawServer_ClearAllResponse) -> Bool {
    if lhs.clearType_p != rhs.clearType_p {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}

extension Mavsdk_Rpc_MissionRawServer_SetCurrentItemCompleteRequest: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  static let protoMessageName: String = _protobuf_package + ".SetCurrentItemCompleteRequest"
  static let _protobuf_nameMap = SwiftProtobuf._NameMap()

  mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let _ = try decoder.nextFieldNumber() {
    }
  }

  func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    try unknownFields.traverse(visitor: &visitor)
  }

  static func ==(lhs: Mavsdk_Rpc_MissionRawServer_SetCurrentItemCompleteRequest, rhs: Mavsdk_Rpc_MissionRawServer_SetCurrentItemCompleteRequest) -> Bool {
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}

extension Mavsdk_Rpc_MissionRawServer_SetCurrentItemCompleteResponse: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  static let protoMessageName: String = _protobuf_package + ".SetCurrentItemCompleteResponse"
  static let _protobuf_nameMap = SwiftProtobuf._NameMap()

  mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let _ = try decoder.nextFieldNumber() {
    }
  }

  func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    try unknownFields.traverse(visitor: &visitor)
  }

  static func ==(lhs: Mavsdk_Rpc_MissionRawServer_SetCurrentItemCompleteResponse, rhs: Mavsdk_Rpc_MissionRawServer_SetCurrentItemCompleteResponse) -> Bool {
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}

extension Mavsdk_Rpc_MissionRawServer_MissionItem: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  static let protoMessageName: String = _protobuf_package + ".MissionItem"
  static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .same(proto: "seq"),
    2: .same(proto: "frame"),
    3: .same(proto: "command"),
    4: .same(proto: "current"),
    5: .same(proto: "autocontinue"),
    6: .same(proto: "param1"),
    7: .same(proto: "param2"),
    8: .same(proto: "param3"),
    9: .same(proto: "param4"),
    10: .same(proto: "x"),
    11: .same(proto: "y"),
    12: .same(proto: "z"),
    13: .standard(proto: "mission_type"),
  ]

  mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      // The use of inline closures is to circumvent an issue where the compiler
      // allocates stack space for every case branch when no optimizations are
      // enabled. https://github.com/apple/swift-protobuf/issues/1034
      switch fieldNumber {
      case 1: try { try decoder.decodeSingularUInt32Field(value: &self.seq) }()
      case 2: try { try decoder.decodeSingularUInt32Field(value: &self.frame) }()
      case 3: try { try decoder.decodeSingularUInt32Field(value: &self.command) }()
      case 4: try { try decoder.decodeSingularUInt32Field(value: &self.current) }()
      case 5: try { try decoder.decodeSingularUInt32Field(value: &self.autocontinue) }()
      case 6: try { try decoder.decodeSingularFloatField(value: &self.param1) }()
      case 7: try { try decoder.decodeSingularFloatField(value: &self.param2) }()
      case 8: try { try decoder.decodeSingularFloatField(value: &self.param3) }()
      case 9: try { try decoder.decodeSingularFloatField(value: &self.param4) }()
      case 10: try { try decoder.decodeSingularInt32Field(value: &self.x) }()
      case 11: try { try decoder.decodeSingularInt32Field(value: &self.y) }()
      case 12: try { try decoder.decodeSingularFloatField(value: &self.z) }()
      case 13: try { try decoder.decodeSingularUInt32Field(value: &self.missionType) }()
      default: break
      }
    }
  }

  func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    if self.seq != 0 {
      try visitor.visitSingularUInt32Field(value: self.seq, fieldNumber: 1)
    }
    if self.frame != 0 {
      try visitor.visitSingularUInt32Field(value: self.frame, fieldNumber: 2)
    }
    if self.command != 0 {
      try visitor.visitSingularUInt32Field(value: self.command, fieldNumber: 3)
    }
    if self.current != 0 {
      try visitor.visitSingularUInt32Field(value: self.current, fieldNumber: 4)
    }
    if self.autocontinue != 0 {
      try visitor.visitSingularUInt32Field(value: self.autocontinue, fieldNumber: 5)
    }
    if self.param1 != 0 {
      try visitor.visitSingularFloatField(value: self.param1, fieldNumber: 6)
    }
    if self.param2 != 0 {
      try visitor.visitSingularFloatField(value: self.param2, fieldNumber: 7)
    }
    if self.param3 != 0 {
      try visitor.visitSingularFloatField(value: self.param3, fieldNumber: 8)
    }
    if self.param4 != 0 {
      try visitor.visitSingularFloatField(value: self.param4, fieldNumber: 9)
    }
    if self.x != 0 {
      try visitor.visitSingularInt32Field(value: self.x, fieldNumber: 10)
    }
    if self.y != 0 {
      try visitor.visitSingularInt32Field(value: self.y, fieldNumber: 11)
    }
    if self.z != 0 {
      try visitor.visitSingularFloatField(value: self.z, fieldNumber: 12)
    }
    if self.missionType != 0 {
      try visitor.visitSingularUInt32Field(value: self.missionType, fieldNumber: 13)
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  static func ==(lhs: Mavsdk_Rpc_MissionRawServer_MissionItem, rhs: Mavsdk_Rpc_MissionRawServer_MissionItem) -> Bool {
    if lhs.seq != rhs.seq {return false}
    if lhs.frame != rhs.frame {return false}
    if lhs.command != rhs.command {return false}
    if lhs.current != rhs.current {return false}
    if lhs.autocontinue != rhs.autocontinue {return false}
    if lhs.param1 != rhs.param1 {return false}
    if lhs.param2 != rhs.param2 {return false}
    if lhs.param3 != rhs.param3 {return false}
    if lhs.param4 != rhs.param4 {return false}
    if lhs.x != rhs.x {return false}
    if lhs.y != rhs.y {return false}
    if lhs.z != rhs.z {return false}
    if lhs.missionType != rhs.missionType {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}

extension Mavsdk_Rpc_MissionRawServer_MissionPlan: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  static let protoMessageName: String = _protobuf_package + ".MissionPlan"
  static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .standard(proto: "mission_items"),
  ]

  mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      // The use of inline closures is to circumvent an issue where the compiler
      // allocates stack space for every case branch when no optimizations are
      // enabled. https://github.com/apple/swift-protobuf/issues/1034
      switch fieldNumber {
      case 1: try { try decoder.decodeRepeatedMessageField(value: &self.missionItems) }()
      default: break
      }
    }
  }

  func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    if !self.missionItems.isEmpty {
      try visitor.visitRepeatedMessageField(value: self.missionItems, fieldNumber: 1)
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  static func ==(lhs: Mavsdk_Rpc_MissionRawServer_MissionPlan, rhs: Mavsdk_Rpc_MissionRawServer_MissionPlan) -> Bool {
    if lhs.missionItems != rhs.missionItems {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}

extension Mavsdk_Rpc_MissionRawServer_MissionProgress: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  static let protoMessageName: String = _protobuf_package + ".MissionProgress"
  static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .same(proto: "current"),
    2: .same(proto: "total"),
  ]

  mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      // The use of inline closures is to circumvent an issue where the compiler
      // allocates stack space for every case branch when no optimizations are
      // enabled. https://github.com/apple/swift-protobuf/issues/1034
      switch fieldNumber {
      case 1: try { try decoder.decodeSingularInt32Field(value: &self.current) }()
      case 2: try { try decoder.decodeSingularInt32Field(value: &self.total) }()
      default: break
      }
    }
  }

  func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    if self.current != 0 {
      try visitor.visitSingularInt32Field(value: self.current, fieldNumber: 1)
    }
    if self.total != 0 {
      try visitor.visitSingularInt32Field(value: self.total, fieldNumber: 2)
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  static func ==(lhs: Mavsdk_Rpc_MissionRawServer_MissionProgress, rhs: Mavsdk_Rpc_MissionRawServer_MissionProgress) -> Bool {
    if lhs.current != rhs.current {return false}
    if lhs.total != rhs.total {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}

extension Mavsdk_Rpc_MissionRawServer_MissionRawServerResult: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  static let protoMessageName: String = _protobuf_package + ".MissionRawServerResult"
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

  static func ==(lhs: Mavsdk_Rpc_MissionRawServer_MissionRawServerResult, rhs: Mavsdk_Rpc_MissionRawServer_MissionRawServerResult) -> Bool {
    if lhs.result != rhs.result {return false}
    if lhs.resultStr != rhs.resultStr {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}

extension Mavsdk_Rpc_MissionRawServer_MissionRawServerResult.Result: SwiftProtobuf._ProtoNameProviding {
  static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    0: .same(proto: "RESULT_UNKNOWN"),
    1: .same(proto: "RESULT_SUCCESS"),
    2: .same(proto: "RESULT_ERROR"),
    3: .same(proto: "RESULT_TOO_MANY_MISSION_ITEMS"),
    4: .same(proto: "RESULT_BUSY"),
    5: .same(proto: "RESULT_TIMEOUT"),
    6: .same(proto: "RESULT_INVALID_ARGUMENT"),
    7: .same(proto: "RESULT_UNSUPPORTED"),
    8: .same(proto: "RESULT_NO_MISSION_AVAILABLE"),
    11: .same(proto: "RESULT_UNSUPPORTED_MISSION_CMD"),
    12: .same(proto: "RESULT_TRANSFER_CANCELLED"),
    13: .same(proto: "RESULT_NO_SYSTEM"),
    14: .same(proto: "RESULT_NEXT"),
  ]
}