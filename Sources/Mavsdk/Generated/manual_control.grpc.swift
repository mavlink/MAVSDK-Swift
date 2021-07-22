//
// DO NOT EDIT.
//
// Generated by the protocol buffer compiler.
// Source: manual_control.proto
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


/// Enable manual control using e.g. a joystick or gamepad.
///
/// Usage: instantiate `Mavsdk_Rpc_ManualControl_ManualControlServiceClient`, then call methods of this protocol to make API calls.
internal protocol Mavsdk_Rpc_ManualControl_ManualControlServiceClientProtocol: GRPCClient {
  var serviceName: String { get }
  var interceptors: Mavsdk_Rpc_ManualControl_ManualControlServiceClientInterceptorFactoryProtocol? { get }

  func startPositionControl(
    _ request: Mavsdk_Rpc_ManualControl_StartPositionControlRequest,
    callOptions: CallOptions?
  ) -> UnaryCall<Mavsdk_Rpc_ManualControl_StartPositionControlRequest, Mavsdk_Rpc_ManualControl_StartPositionControlResponse>

  func startAltitudeControl(
    _ request: Mavsdk_Rpc_ManualControl_StartAltitudeControlRequest,
    callOptions: CallOptions?
  ) -> UnaryCall<Mavsdk_Rpc_ManualControl_StartAltitudeControlRequest, Mavsdk_Rpc_ManualControl_StartAltitudeControlResponse>

  func setManualControlInput(
    _ request: Mavsdk_Rpc_ManualControl_SetManualControlInputRequest,
    callOptions: CallOptions?
  ) -> UnaryCall<Mavsdk_Rpc_ManualControl_SetManualControlInputRequest, Mavsdk_Rpc_ManualControl_SetManualControlInputResponse>
}

extension Mavsdk_Rpc_ManualControl_ManualControlServiceClientProtocol {
  internal var serviceName: String {
    return "mavsdk.rpc.manual_control.ManualControlService"
  }

  ///
  /// Start position control using e.g. joystick input.
  ///
  /// Requires manual control input to be sent regularly already.
  /// Requires a valid position using e.g. GPS, external vision, or optical flow.
  ///
  /// - Parameters:
  ///   - request: Request to send to StartPositionControl.
  ///   - callOptions: Call options.
  /// - Returns: A `UnaryCall` with futures for the metadata, status and response.
  internal func startPositionControl(
    _ request: Mavsdk_Rpc_ManualControl_StartPositionControlRequest,
    callOptions: CallOptions? = nil
  ) -> UnaryCall<Mavsdk_Rpc_ManualControl_StartPositionControlRequest, Mavsdk_Rpc_ManualControl_StartPositionControlResponse> {
    return self.makeUnaryCall(
      path: "/mavsdk.rpc.manual_control.ManualControlService/StartPositionControl",
      request: request,
      callOptions: callOptions ?? self.defaultCallOptions,
      interceptors: self.interceptors?.makeStartPositionControlInterceptors() ?? []
    )
  }

  ///
  /// Start altitude control
  ///
  /// Requires manual control input to be sent regularly already.
  /// Does not require a  valid position e.g. GPS.
  ///
  /// - Parameters:
  ///   - request: Request to send to StartAltitudeControl.
  ///   - callOptions: Call options.
  /// - Returns: A `UnaryCall` with futures for the metadata, status and response.
  internal func startAltitudeControl(
    _ request: Mavsdk_Rpc_ManualControl_StartAltitudeControlRequest,
    callOptions: CallOptions? = nil
  ) -> UnaryCall<Mavsdk_Rpc_ManualControl_StartAltitudeControlRequest, Mavsdk_Rpc_ManualControl_StartAltitudeControlResponse> {
    return self.makeUnaryCall(
      path: "/mavsdk.rpc.manual_control.ManualControlService/StartAltitudeControl",
      request: request,
      callOptions: callOptions ?? self.defaultCallOptions,
      interceptors: self.interceptors?.makeStartAltitudeControlInterceptors() ?? []
    )
  }

  ///
  /// Set manual control input
  ///
  /// The manual control input needs to be sent at a rate high enough to prevent
  /// triggering of RC loss, a good minimum rate is 10 Hz.
  ///
  /// - Parameters:
  ///   - request: Request to send to SetManualControlInput.
  ///   - callOptions: Call options.
  /// - Returns: A `UnaryCall` with futures for the metadata, status and response.
  internal func setManualControlInput(
    _ request: Mavsdk_Rpc_ManualControl_SetManualControlInputRequest,
    callOptions: CallOptions? = nil
  ) -> UnaryCall<Mavsdk_Rpc_ManualControl_SetManualControlInputRequest, Mavsdk_Rpc_ManualControl_SetManualControlInputResponse> {
    return self.makeUnaryCall(
      path: "/mavsdk.rpc.manual_control.ManualControlService/SetManualControlInput",
      request: request,
      callOptions: callOptions ?? self.defaultCallOptions,
      interceptors: self.interceptors?.makeSetManualControlInputInterceptors() ?? []
    )
  }
}

internal protocol Mavsdk_Rpc_ManualControl_ManualControlServiceClientInterceptorFactoryProtocol {

  /// - Returns: Interceptors to use when invoking 'startPositionControl'.
  func makeStartPositionControlInterceptors() -> [ClientInterceptor<Mavsdk_Rpc_ManualControl_StartPositionControlRequest, Mavsdk_Rpc_ManualControl_StartPositionControlResponse>]

  /// - Returns: Interceptors to use when invoking 'startAltitudeControl'.
  func makeStartAltitudeControlInterceptors() -> [ClientInterceptor<Mavsdk_Rpc_ManualControl_StartAltitudeControlRequest, Mavsdk_Rpc_ManualControl_StartAltitudeControlResponse>]

  /// - Returns: Interceptors to use when invoking 'setManualControlInput'.
  func makeSetManualControlInputInterceptors() -> [ClientInterceptor<Mavsdk_Rpc_ManualControl_SetManualControlInputRequest, Mavsdk_Rpc_ManualControl_SetManualControlInputResponse>]
}

internal final class Mavsdk_Rpc_ManualControl_ManualControlServiceClient: Mavsdk_Rpc_ManualControl_ManualControlServiceClientProtocol {
  internal let channel: GRPCChannel
  internal var defaultCallOptions: CallOptions
  internal var interceptors: Mavsdk_Rpc_ManualControl_ManualControlServiceClientInterceptorFactoryProtocol?

  /// Creates a client for the mavsdk.rpc.manual_control.ManualControlService service.
  ///
  /// - Parameters:
  ///   - channel: `GRPCChannel` to the service host.
  ///   - defaultCallOptions: Options to use for each service call if the user doesn't provide them.
  ///   - interceptors: A factory providing interceptors for each RPC.
  internal init(
    channel: GRPCChannel,
    defaultCallOptions: CallOptions = CallOptions(),
    interceptors: Mavsdk_Rpc_ManualControl_ManualControlServiceClientInterceptorFactoryProtocol? = nil
  ) {
    self.channel = channel
    self.defaultCallOptions = defaultCallOptions
    self.interceptors = interceptors
  }
}

/// Enable manual control using e.g. a joystick or gamepad.
///
/// To build a server, implement a class that conforms to this protocol.
internal protocol Mavsdk_Rpc_ManualControl_ManualControlServiceProvider: CallHandlerProvider {
  var interceptors: Mavsdk_Rpc_ManualControl_ManualControlServiceServerInterceptorFactoryProtocol? { get }

  ///
  /// Start position control using e.g. joystick input.
  ///
  /// Requires manual control input to be sent regularly already.
  /// Requires a valid position using e.g. GPS, external vision, or optical flow.
  func startPositionControl(request: Mavsdk_Rpc_ManualControl_StartPositionControlRequest, context: StatusOnlyCallContext) -> EventLoopFuture<Mavsdk_Rpc_ManualControl_StartPositionControlResponse>

  ///
  /// Start altitude control
  ///
  /// Requires manual control input to be sent regularly already.
  /// Does not require a  valid position e.g. GPS.
  func startAltitudeControl(request: Mavsdk_Rpc_ManualControl_StartAltitudeControlRequest, context: StatusOnlyCallContext) -> EventLoopFuture<Mavsdk_Rpc_ManualControl_StartAltitudeControlResponse>

  ///
  /// Set manual control input
  ///
  /// The manual control input needs to be sent at a rate high enough to prevent
  /// triggering of RC loss, a good minimum rate is 10 Hz.
  func setManualControlInput(request: Mavsdk_Rpc_ManualControl_SetManualControlInputRequest, context: StatusOnlyCallContext) -> EventLoopFuture<Mavsdk_Rpc_ManualControl_SetManualControlInputResponse>
}

extension Mavsdk_Rpc_ManualControl_ManualControlServiceProvider {
  internal var serviceName: Substring { return "mavsdk.rpc.manual_control.ManualControlService" }

  /// Determines, calls and returns the appropriate request handler, depending on the request's method.
  /// Returns nil for methods not handled by this service.
  internal func handle(
    method name: Substring,
    context: CallHandlerContext
  ) -> GRPCServerHandlerProtocol? {
    switch name {
    case "StartPositionControl":
      return UnaryServerHandler(
        context: context,
        requestDeserializer: ProtobufDeserializer<Mavsdk_Rpc_ManualControl_StartPositionControlRequest>(),
        responseSerializer: ProtobufSerializer<Mavsdk_Rpc_ManualControl_StartPositionControlResponse>(),
        interceptors: self.interceptors?.makeStartPositionControlInterceptors() ?? [],
        userFunction: self.startPositionControl(request:context:)
      )

    case "StartAltitudeControl":
      return UnaryServerHandler(
        context: context,
        requestDeserializer: ProtobufDeserializer<Mavsdk_Rpc_ManualControl_StartAltitudeControlRequest>(),
        responseSerializer: ProtobufSerializer<Mavsdk_Rpc_ManualControl_StartAltitudeControlResponse>(),
        interceptors: self.interceptors?.makeStartAltitudeControlInterceptors() ?? [],
        userFunction: self.startAltitudeControl(request:context:)
      )

    case "SetManualControlInput":
      return UnaryServerHandler(
        context: context,
        requestDeserializer: ProtobufDeserializer<Mavsdk_Rpc_ManualControl_SetManualControlInputRequest>(),
        responseSerializer: ProtobufSerializer<Mavsdk_Rpc_ManualControl_SetManualControlInputResponse>(),
        interceptors: self.interceptors?.makeSetManualControlInputInterceptors() ?? [],
        userFunction: self.setManualControlInput(request:context:)
      )

    default:
      return nil
    }
  }
}

internal protocol Mavsdk_Rpc_ManualControl_ManualControlServiceServerInterceptorFactoryProtocol {

  /// - Returns: Interceptors to use when handling 'startPositionControl'.
  ///   Defaults to calling `self.makeInterceptors()`.
  func makeStartPositionControlInterceptors() -> [ServerInterceptor<Mavsdk_Rpc_ManualControl_StartPositionControlRequest, Mavsdk_Rpc_ManualControl_StartPositionControlResponse>]

  /// - Returns: Interceptors to use when handling 'startAltitudeControl'.
  ///   Defaults to calling `self.makeInterceptors()`.
  func makeStartAltitudeControlInterceptors() -> [ServerInterceptor<Mavsdk_Rpc_ManualControl_StartAltitudeControlRequest, Mavsdk_Rpc_ManualControl_StartAltitudeControlResponse>]

  /// - Returns: Interceptors to use when handling 'setManualControlInput'.
  ///   Defaults to calling `self.makeInterceptors()`.
  func makeSetManualControlInputInterceptors() -> [ServerInterceptor<Mavsdk_Rpc_ManualControl_SetManualControlInputRequest, Mavsdk_Rpc_ManualControl_SetManualControlInputResponse>]
}