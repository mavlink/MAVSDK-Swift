//
// DO NOT EDIT.
//
// Generated by the protocol buffer compiler.
// Source: calibration.proto
//

//
// Copyright 2018, gRPC Authors All rights reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//
import GRPC
import NIO
import SwiftProtobuf


/// Enable to calibrate sensors of a drone such as gyro, accelerometer, and magnetometer.
///
/// Usage: instantiate `Mavsdk_Rpc_Calibration_CalibrationServiceClient`, then call methods of this protocol to make API calls.
internal protocol Mavsdk_Rpc_Calibration_CalibrationServiceClientProtocol: GRPCClient {
  var serviceName: String { get }
  var interceptors: Mavsdk_Rpc_Calibration_CalibrationServiceClientInterceptorFactoryProtocol? { get }

  func subscribeCalibrateGyro(
    _ request: Mavsdk_Rpc_Calibration_SubscribeCalibrateGyroRequest,
    callOptions: CallOptions?,
    handler: @escaping (Mavsdk_Rpc_Calibration_CalibrateGyroResponse) -> Void
  ) -> ServerStreamingCall<Mavsdk_Rpc_Calibration_SubscribeCalibrateGyroRequest, Mavsdk_Rpc_Calibration_CalibrateGyroResponse>

  func subscribeCalibrateAccelerometer(
    _ request: Mavsdk_Rpc_Calibration_SubscribeCalibrateAccelerometerRequest,
    callOptions: CallOptions?,
    handler: @escaping (Mavsdk_Rpc_Calibration_CalibrateAccelerometerResponse) -> Void
  ) -> ServerStreamingCall<Mavsdk_Rpc_Calibration_SubscribeCalibrateAccelerometerRequest, Mavsdk_Rpc_Calibration_CalibrateAccelerometerResponse>

  func subscribeCalibrateMagnetometer(
    _ request: Mavsdk_Rpc_Calibration_SubscribeCalibrateMagnetometerRequest,
    callOptions: CallOptions?,
    handler: @escaping (Mavsdk_Rpc_Calibration_CalibrateMagnetometerResponse) -> Void
  ) -> ServerStreamingCall<Mavsdk_Rpc_Calibration_SubscribeCalibrateMagnetometerRequest, Mavsdk_Rpc_Calibration_CalibrateMagnetometerResponse>

  func subscribeCalibrateLevelHorizon(
    _ request: Mavsdk_Rpc_Calibration_SubscribeCalibrateLevelHorizonRequest,
    callOptions: CallOptions?,
    handler: @escaping (Mavsdk_Rpc_Calibration_CalibrateLevelHorizonResponse) -> Void
  ) -> ServerStreamingCall<Mavsdk_Rpc_Calibration_SubscribeCalibrateLevelHorizonRequest, Mavsdk_Rpc_Calibration_CalibrateLevelHorizonResponse>

  func subscribeCalibrateGimbalAccelerometer(
    _ request: Mavsdk_Rpc_Calibration_SubscribeCalibrateGimbalAccelerometerRequest,
    callOptions: CallOptions?,
    handler: @escaping (Mavsdk_Rpc_Calibration_CalibrateGimbalAccelerometerResponse) -> Void
  ) -> ServerStreamingCall<Mavsdk_Rpc_Calibration_SubscribeCalibrateGimbalAccelerometerRequest, Mavsdk_Rpc_Calibration_CalibrateGimbalAccelerometerResponse>

  func cancel(
    _ request: Mavsdk_Rpc_Calibration_CancelRequest,
    callOptions: CallOptions?
  ) -> UnaryCall<Mavsdk_Rpc_Calibration_CancelRequest, Mavsdk_Rpc_Calibration_CancelResponse>
}

extension Mavsdk_Rpc_Calibration_CalibrationServiceClientProtocol {
  internal var serviceName: String {
    return "mavsdk.rpc.calibration.CalibrationService"
  }

  /// Perform gyro calibration.
  ///
  /// - Parameters:
  ///   - request: Request to send to SubscribeCalibrateGyro.
  ///   - callOptions: Call options.
  ///   - handler: A closure called when each response is received from the server.
  /// - Returns: A `ServerStreamingCall` with futures for the metadata and status.
  internal func subscribeCalibrateGyro(
    _ request: Mavsdk_Rpc_Calibration_SubscribeCalibrateGyroRequest,
    callOptions: CallOptions? = nil,
    handler: @escaping (Mavsdk_Rpc_Calibration_CalibrateGyroResponse) -> Void
  ) -> ServerStreamingCall<Mavsdk_Rpc_Calibration_SubscribeCalibrateGyroRequest, Mavsdk_Rpc_Calibration_CalibrateGyroResponse> {
    return self.makeServerStreamingCall(
      path: "/mavsdk.rpc.calibration.CalibrationService/SubscribeCalibrateGyro",
      request: request,
      callOptions: callOptions ?? self.defaultCallOptions,
      interceptors: self.interceptors?.makeSubscribeCalibrateGyroInterceptors() ?? [],
      handler: handler
    )
  }

  /// Perform accelerometer calibration.
  ///
  /// - Parameters:
  ///   - request: Request to send to SubscribeCalibrateAccelerometer.
  ///   - callOptions: Call options.
  ///   - handler: A closure called when each response is received from the server.
  /// - Returns: A `ServerStreamingCall` with futures for the metadata and status.
  internal func subscribeCalibrateAccelerometer(
    _ request: Mavsdk_Rpc_Calibration_SubscribeCalibrateAccelerometerRequest,
    callOptions: CallOptions? = nil,
    handler: @escaping (Mavsdk_Rpc_Calibration_CalibrateAccelerometerResponse) -> Void
  ) -> ServerStreamingCall<Mavsdk_Rpc_Calibration_SubscribeCalibrateAccelerometerRequest, Mavsdk_Rpc_Calibration_CalibrateAccelerometerResponse> {
    return self.makeServerStreamingCall(
      path: "/mavsdk.rpc.calibration.CalibrationService/SubscribeCalibrateAccelerometer",
      request: request,
      callOptions: callOptions ?? self.defaultCallOptions,
      interceptors: self.interceptors?.makeSubscribeCalibrateAccelerometerInterceptors() ?? [],
      handler: handler
    )
  }

  /// Perform magnetometer calibration.
  ///
  /// - Parameters:
  ///   - request: Request to send to SubscribeCalibrateMagnetometer.
  ///   - callOptions: Call options.
  ///   - handler: A closure called when each response is received from the server.
  /// - Returns: A `ServerStreamingCall` with futures for the metadata and status.
  internal func subscribeCalibrateMagnetometer(
    _ request: Mavsdk_Rpc_Calibration_SubscribeCalibrateMagnetometerRequest,
    callOptions: CallOptions? = nil,
    handler: @escaping (Mavsdk_Rpc_Calibration_CalibrateMagnetometerResponse) -> Void
  ) -> ServerStreamingCall<Mavsdk_Rpc_Calibration_SubscribeCalibrateMagnetometerRequest, Mavsdk_Rpc_Calibration_CalibrateMagnetometerResponse> {
    return self.makeServerStreamingCall(
      path: "/mavsdk.rpc.calibration.CalibrationService/SubscribeCalibrateMagnetometer",
      request: request,
      callOptions: callOptions ?? self.defaultCallOptions,
      interceptors: self.interceptors?.makeSubscribeCalibrateMagnetometerInterceptors() ?? [],
      handler: handler
    )
  }

  /// Perform board level horizon calibration.
  ///
  /// - Parameters:
  ///   - request: Request to send to SubscribeCalibrateLevelHorizon.
  ///   - callOptions: Call options.
  ///   - handler: A closure called when each response is received from the server.
  /// - Returns: A `ServerStreamingCall` with futures for the metadata and status.
  internal func subscribeCalibrateLevelHorizon(
    _ request: Mavsdk_Rpc_Calibration_SubscribeCalibrateLevelHorizonRequest,
    callOptions: CallOptions? = nil,
    handler: @escaping (Mavsdk_Rpc_Calibration_CalibrateLevelHorizonResponse) -> Void
  ) -> ServerStreamingCall<Mavsdk_Rpc_Calibration_SubscribeCalibrateLevelHorizonRequest, Mavsdk_Rpc_Calibration_CalibrateLevelHorizonResponse> {
    return self.makeServerStreamingCall(
      path: "/mavsdk.rpc.calibration.CalibrationService/SubscribeCalibrateLevelHorizon",
      request: request,
      callOptions: callOptions ?? self.defaultCallOptions,
      interceptors: self.interceptors?.makeSubscribeCalibrateLevelHorizonInterceptors() ?? [],
      handler: handler
    )
  }

  /// Perform gimbal accelerometer calibration.
  ///
  /// - Parameters:
  ///   - request: Request to send to SubscribeCalibrateGimbalAccelerometer.
  ///   - callOptions: Call options.
  ///   - handler: A closure called when each response is received from the server.
  /// - Returns: A `ServerStreamingCall` with futures for the metadata and status.
  internal func subscribeCalibrateGimbalAccelerometer(
    _ request: Mavsdk_Rpc_Calibration_SubscribeCalibrateGimbalAccelerometerRequest,
    callOptions: CallOptions? = nil,
    handler: @escaping (Mavsdk_Rpc_Calibration_CalibrateGimbalAccelerometerResponse) -> Void
  ) -> ServerStreamingCall<Mavsdk_Rpc_Calibration_SubscribeCalibrateGimbalAccelerometerRequest, Mavsdk_Rpc_Calibration_CalibrateGimbalAccelerometerResponse> {
    return self.makeServerStreamingCall(
      path: "/mavsdk.rpc.calibration.CalibrationService/SubscribeCalibrateGimbalAccelerometer",
      request: request,
      callOptions: callOptions ?? self.defaultCallOptions,
      interceptors: self.interceptors?.makeSubscribeCalibrateGimbalAccelerometerInterceptors() ?? [],
      handler: handler
    )
  }

  /// Cancel ongoing calibration process.
  ///
  /// - Parameters:
  ///   - request: Request to send to Cancel.
  ///   - callOptions: Call options.
  /// - Returns: A `UnaryCall` with futures for the metadata, status and response.
  internal func cancel(
    _ request: Mavsdk_Rpc_Calibration_CancelRequest,
    callOptions: CallOptions? = nil
  ) -> UnaryCall<Mavsdk_Rpc_Calibration_CancelRequest, Mavsdk_Rpc_Calibration_CancelResponse> {
    return self.makeUnaryCall(
      path: "/mavsdk.rpc.calibration.CalibrationService/Cancel",
      request: request,
      callOptions: callOptions ?? self.defaultCallOptions,
      interceptors: self.interceptors?.makeCancelInterceptors() ?? []
    )
  }
}

internal protocol Mavsdk_Rpc_Calibration_CalibrationServiceClientInterceptorFactoryProtocol {

  /// - Returns: Interceptors to use when invoking 'subscribeCalibrateGyro'.
  func makeSubscribeCalibrateGyroInterceptors() -> [ClientInterceptor<Mavsdk_Rpc_Calibration_SubscribeCalibrateGyroRequest, Mavsdk_Rpc_Calibration_CalibrateGyroResponse>]

  /// - Returns: Interceptors to use when invoking 'subscribeCalibrateAccelerometer'.
  func makeSubscribeCalibrateAccelerometerInterceptors() -> [ClientInterceptor<Mavsdk_Rpc_Calibration_SubscribeCalibrateAccelerometerRequest, Mavsdk_Rpc_Calibration_CalibrateAccelerometerResponse>]

  /// - Returns: Interceptors to use when invoking 'subscribeCalibrateMagnetometer'.
  func makeSubscribeCalibrateMagnetometerInterceptors() -> [ClientInterceptor<Mavsdk_Rpc_Calibration_SubscribeCalibrateMagnetometerRequest, Mavsdk_Rpc_Calibration_CalibrateMagnetometerResponse>]

  /// - Returns: Interceptors to use when invoking 'subscribeCalibrateLevelHorizon'.
  func makeSubscribeCalibrateLevelHorizonInterceptors() -> [ClientInterceptor<Mavsdk_Rpc_Calibration_SubscribeCalibrateLevelHorizonRequest, Mavsdk_Rpc_Calibration_CalibrateLevelHorizonResponse>]

  /// - Returns: Interceptors to use when invoking 'subscribeCalibrateGimbalAccelerometer'.
  func makeSubscribeCalibrateGimbalAccelerometerInterceptors() -> [ClientInterceptor<Mavsdk_Rpc_Calibration_SubscribeCalibrateGimbalAccelerometerRequest, Mavsdk_Rpc_Calibration_CalibrateGimbalAccelerometerResponse>]

  /// - Returns: Interceptors to use when invoking 'cancel'.
  func makeCancelInterceptors() -> [ClientInterceptor<Mavsdk_Rpc_Calibration_CancelRequest, Mavsdk_Rpc_Calibration_CancelResponse>]
}

internal final class Mavsdk_Rpc_Calibration_CalibrationServiceClient: Mavsdk_Rpc_Calibration_CalibrationServiceClientProtocol {
  internal let channel: GRPCChannel
  internal var defaultCallOptions: CallOptions
  internal var interceptors: Mavsdk_Rpc_Calibration_CalibrationServiceClientInterceptorFactoryProtocol?

  /// Creates a client for the mavsdk.rpc.calibration.CalibrationService service.
  ///
  /// - Parameters:
  ///   - channel: `GRPCChannel` to the service host.
  ///   - defaultCallOptions: Options to use for each service call if the user doesn't provide them.
  ///   - interceptors: A factory providing interceptors for each RPC.
  internal init(
    channel: GRPCChannel,
    defaultCallOptions: CallOptions = CallOptions(),
    interceptors: Mavsdk_Rpc_Calibration_CalibrationServiceClientInterceptorFactoryProtocol? = nil
  ) {
    self.channel = channel
    self.defaultCallOptions = defaultCallOptions
    self.interceptors = interceptors
  }
}

/// Enable to calibrate sensors of a drone such as gyro, accelerometer, and magnetometer.
///
/// To build a server, implement a class that conforms to this protocol.
internal protocol Mavsdk_Rpc_Calibration_CalibrationServiceProvider: CallHandlerProvider {
  var interceptors: Mavsdk_Rpc_Calibration_CalibrationServiceServerInterceptorFactoryProtocol? { get }

  /// Perform gyro calibration.
  func subscribeCalibrateGyro(request: Mavsdk_Rpc_Calibration_SubscribeCalibrateGyroRequest, context: StreamingResponseCallContext<Mavsdk_Rpc_Calibration_CalibrateGyroResponse>) -> EventLoopFuture<GRPCStatus>

  /// Perform accelerometer calibration.
  func subscribeCalibrateAccelerometer(request: Mavsdk_Rpc_Calibration_SubscribeCalibrateAccelerometerRequest, context: StreamingResponseCallContext<Mavsdk_Rpc_Calibration_CalibrateAccelerometerResponse>) -> EventLoopFuture<GRPCStatus>

  /// Perform magnetometer calibration.
  func subscribeCalibrateMagnetometer(request: Mavsdk_Rpc_Calibration_SubscribeCalibrateMagnetometerRequest, context: StreamingResponseCallContext<Mavsdk_Rpc_Calibration_CalibrateMagnetometerResponse>) -> EventLoopFuture<GRPCStatus>

  /// Perform board level horizon calibration.
  func subscribeCalibrateLevelHorizon(request: Mavsdk_Rpc_Calibration_SubscribeCalibrateLevelHorizonRequest, context: StreamingResponseCallContext<Mavsdk_Rpc_Calibration_CalibrateLevelHorizonResponse>) -> EventLoopFuture<GRPCStatus>

  /// Perform gimbal accelerometer calibration.
  func subscribeCalibrateGimbalAccelerometer(request: Mavsdk_Rpc_Calibration_SubscribeCalibrateGimbalAccelerometerRequest, context: StreamingResponseCallContext<Mavsdk_Rpc_Calibration_CalibrateGimbalAccelerometerResponse>) -> EventLoopFuture<GRPCStatus>

  /// Cancel ongoing calibration process.
  func cancel(request: Mavsdk_Rpc_Calibration_CancelRequest, context: StatusOnlyCallContext) -> EventLoopFuture<Mavsdk_Rpc_Calibration_CancelResponse>
}

extension Mavsdk_Rpc_Calibration_CalibrationServiceProvider {
  internal var serviceName: Substring { return "mavsdk.rpc.calibration.CalibrationService" }

  /// Determines, calls and returns the appropriate request handler, depending on the request's method.
  /// Returns nil for methods not handled by this service.
  internal func handle(
    method name: Substring,
    context: CallHandlerContext
  ) -> GRPCServerHandlerProtocol? {
    switch name {
    case "SubscribeCalibrateGyro":
      return ServerStreamingServerHandler(
        context: context,
        requestDeserializer: ProtobufDeserializer<Mavsdk_Rpc_Calibration_SubscribeCalibrateGyroRequest>(),
        responseSerializer: ProtobufSerializer<Mavsdk_Rpc_Calibration_CalibrateGyroResponse>(),
        interceptors: self.interceptors?.makeSubscribeCalibrateGyroInterceptors() ?? [],
        userFunction: self.subscribeCalibrateGyro(request:context:)
      )

    case "SubscribeCalibrateAccelerometer":
      return ServerStreamingServerHandler(
        context: context,
        requestDeserializer: ProtobufDeserializer<Mavsdk_Rpc_Calibration_SubscribeCalibrateAccelerometerRequest>(),
        responseSerializer: ProtobufSerializer<Mavsdk_Rpc_Calibration_CalibrateAccelerometerResponse>(),
        interceptors: self.interceptors?.makeSubscribeCalibrateAccelerometerInterceptors() ?? [],
        userFunction: self.subscribeCalibrateAccelerometer(request:context:)
      )

    case "SubscribeCalibrateMagnetometer":
      return ServerStreamingServerHandler(
        context: context,
        requestDeserializer: ProtobufDeserializer<Mavsdk_Rpc_Calibration_SubscribeCalibrateMagnetometerRequest>(),
        responseSerializer: ProtobufSerializer<Mavsdk_Rpc_Calibration_CalibrateMagnetometerResponse>(),
        interceptors: self.interceptors?.makeSubscribeCalibrateMagnetometerInterceptors() ?? [],
        userFunction: self.subscribeCalibrateMagnetometer(request:context:)
      )

    case "SubscribeCalibrateLevelHorizon":
      return ServerStreamingServerHandler(
        context: context,
        requestDeserializer: ProtobufDeserializer<Mavsdk_Rpc_Calibration_SubscribeCalibrateLevelHorizonRequest>(),
        responseSerializer: ProtobufSerializer<Mavsdk_Rpc_Calibration_CalibrateLevelHorizonResponse>(),
        interceptors: self.interceptors?.makeSubscribeCalibrateLevelHorizonInterceptors() ?? [],
        userFunction: self.subscribeCalibrateLevelHorizon(request:context:)
      )

    case "SubscribeCalibrateGimbalAccelerometer":
      return ServerStreamingServerHandler(
        context: context,
        requestDeserializer: ProtobufDeserializer<Mavsdk_Rpc_Calibration_SubscribeCalibrateGimbalAccelerometerRequest>(),
        responseSerializer: ProtobufSerializer<Mavsdk_Rpc_Calibration_CalibrateGimbalAccelerometerResponse>(),
        interceptors: self.interceptors?.makeSubscribeCalibrateGimbalAccelerometerInterceptors() ?? [],
        userFunction: self.subscribeCalibrateGimbalAccelerometer(request:context:)
      )

    case "Cancel":
      return UnaryServerHandler(
        context: context,
        requestDeserializer: ProtobufDeserializer<Mavsdk_Rpc_Calibration_CancelRequest>(),
        responseSerializer: ProtobufSerializer<Mavsdk_Rpc_Calibration_CancelResponse>(),
        interceptors: self.interceptors?.makeCancelInterceptors() ?? [],
        userFunction: self.cancel(request:context:)
      )

    default:
      return nil
    }
  }
}

internal protocol Mavsdk_Rpc_Calibration_CalibrationServiceServerInterceptorFactoryProtocol {

  /// - Returns: Interceptors to use when handling 'subscribeCalibrateGyro'.
  ///   Defaults to calling `self.makeInterceptors()`.
  func makeSubscribeCalibrateGyroInterceptors() -> [ServerInterceptor<Mavsdk_Rpc_Calibration_SubscribeCalibrateGyroRequest, Mavsdk_Rpc_Calibration_CalibrateGyroResponse>]

  /// - Returns: Interceptors to use when handling 'subscribeCalibrateAccelerometer'.
  ///   Defaults to calling `self.makeInterceptors()`.
  func makeSubscribeCalibrateAccelerometerInterceptors() -> [ServerInterceptor<Mavsdk_Rpc_Calibration_SubscribeCalibrateAccelerometerRequest, Mavsdk_Rpc_Calibration_CalibrateAccelerometerResponse>]

  /// - Returns: Interceptors to use when handling 'subscribeCalibrateMagnetometer'.
  ///   Defaults to calling `self.makeInterceptors()`.
  func makeSubscribeCalibrateMagnetometerInterceptors() -> [ServerInterceptor<Mavsdk_Rpc_Calibration_SubscribeCalibrateMagnetometerRequest, Mavsdk_Rpc_Calibration_CalibrateMagnetometerResponse>]

  /// - Returns: Interceptors to use when handling 'subscribeCalibrateLevelHorizon'.
  ///   Defaults to calling `self.makeInterceptors()`.
  func makeSubscribeCalibrateLevelHorizonInterceptors() -> [ServerInterceptor<Mavsdk_Rpc_Calibration_SubscribeCalibrateLevelHorizonRequest, Mavsdk_Rpc_Calibration_CalibrateLevelHorizonResponse>]

  /// - Returns: Interceptors to use when handling 'subscribeCalibrateGimbalAccelerometer'.
  ///   Defaults to calling `self.makeInterceptors()`.
  func makeSubscribeCalibrateGimbalAccelerometerInterceptors() -> [ServerInterceptor<Mavsdk_Rpc_Calibration_SubscribeCalibrateGimbalAccelerometerRequest, Mavsdk_Rpc_Calibration_CalibrateGimbalAccelerometerResponse>]

  /// - Returns: Interceptors to use when handling 'cancel'.
  ///   Defaults to calling `self.makeInterceptors()`.
  func makeCancelInterceptors() -> [ServerInterceptor<Mavsdk_Rpc_Calibration_CancelRequest, Mavsdk_Rpc_Calibration_CancelResponse>]
}
