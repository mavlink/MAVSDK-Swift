//
// DO NOT EDIT.
//
// Generated by the protocol buffer compiler.
// Source: gimbal.proto
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


/// Provide control over a gimbal.
///
/// Usage: instantiate `Mavsdk_Rpc_Gimbal_GimbalServiceClient`, then call methods of this protocol to make API calls.
internal protocol Mavsdk_Rpc_Gimbal_GimbalServiceClientProtocol: GRPCClient {
  var serviceName: String { get }
  var interceptors: Mavsdk_Rpc_Gimbal_GimbalServiceClientInterceptorFactoryProtocol? { get }

  func setPitchAndYaw(
    _ request: Mavsdk_Rpc_Gimbal_SetPitchAndYawRequest,
    callOptions: CallOptions?
  ) -> UnaryCall<Mavsdk_Rpc_Gimbal_SetPitchAndYawRequest, Mavsdk_Rpc_Gimbal_SetPitchAndYawResponse>

  func setPitchRateAndYawRate(
    _ request: Mavsdk_Rpc_Gimbal_SetPitchRateAndYawRateRequest,
    callOptions: CallOptions?
  ) -> UnaryCall<Mavsdk_Rpc_Gimbal_SetPitchRateAndYawRateRequest, Mavsdk_Rpc_Gimbal_SetPitchRateAndYawRateResponse>

  func setMode(
    _ request: Mavsdk_Rpc_Gimbal_SetModeRequest,
    callOptions: CallOptions?
  ) -> UnaryCall<Mavsdk_Rpc_Gimbal_SetModeRequest, Mavsdk_Rpc_Gimbal_SetModeResponse>

  func setRoiLocation(
    _ request: Mavsdk_Rpc_Gimbal_SetRoiLocationRequest,
    callOptions: CallOptions?
  ) -> UnaryCall<Mavsdk_Rpc_Gimbal_SetRoiLocationRequest, Mavsdk_Rpc_Gimbal_SetRoiLocationResponse>

  func takeControl(
    _ request: Mavsdk_Rpc_Gimbal_TakeControlRequest,
    callOptions: CallOptions?
  ) -> UnaryCall<Mavsdk_Rpc_Gimbal_TakeControlRequest, Mavsdk_Rpc_Gimbal_TakeControlResponse>

  func releaseControl(
    _ request: Mavsdk_Rpc_Gimbal_ReleaseControlRequest,
    callOptions: CallOptions?
  ) -> UnaryCall<Mavsdk_Rpc_Gimbal_ReleaseControlRequest, Mavsdk_Rpc_Gimbal_ReleaseControlResponse>

  func subscribeControl(
    _ request: Mavsdk_Rpc_Gimbal_SubscribeControlRequest,
    callOptions: CallOptions?,
    handler: @escaping (Mavsdk_Rpc_Gimbal_ControlResponse) -> Void
  ) -> ServerStreamingCall<Mavsdk_Rpc_Gimbal_SubscribeControlRequest, Mavsdk_Rpc_Gimbal_ControlResponse>
}

extension Mavsdk_Rpc_Gimbal_GimbalServiceClientProtocol {
  internal var serviceName: String {
    return "mavsdk.rpc.gimbal.GimbalService"
  }

  ///
  ///
  /// Set gimbal pitch and yaw angles.
  ///
  /// This sets the desired pitch and yaw angles of a gimbal.
  /// Will return when the command is accepted, however, it might
  /// take the gimbal longer to actually be set to the new angles.
  ///
  /// - Parameters:
  ///   - request: Request to send to SetPitchAndYaw.
  ///   - callOptions: Call options.
  /// - Returns: A `UnaryCall` with futures for the metadata, status and response.
  internal func setPitchAndYaw(
    _ request: Mavsdk_Rpc_Gimbal_SetPitchAndYawRequest,
    callOptions: CallOptions? = nil
  ) -> UnaryCall<Mavsdk_Rpc_Gimbal_SetPitchAndYawRequest, Mavsdk_Rpc_Gimbal_SetPitchAndYawResponse> {
    return self.makeUnaryCall(
      path: "/mavsdk.rpc.gimbal.GimbalService/SetPitchAndYaw",
      request: request,
      callOptions: callOptions ?? self.defaultCallOptions,
      interceptors: self.interceptors?.makeSetPitchAndYawInterceptors() ?? []
    )
  }

  ///
  ///
  /// Set gimbal angular rates around pitch and yaw axes.
  ///
  /// This sets the desired angular rates around pitch and yaw axes of a gimbal.
  /// Will return when the command is accepted, however, it might
  /// take the gimbal longer to actually reach the angular rate.
  ///
  /// - Parameters:
  ///   - request: Request to send to SetPitchRateAndYawRate.
  ///   - callOptions: Call options.
  /// - Returns: A `UnaryCall` with futures for the metadata, status and response.
  internal func setPitchRateAndYawRate(
    _ request: Mavsdk_Rpc_Gimbal_SetPitchRateAndYawRateRequest,
    callOptions: CallOptions? = nil
  ) -> UnaryCall<Mavsdk_Rpc_Gimbal_SetPitchRateAndYawRateRequest, Mavsdk_Rpc_Gimbal_SetPitchRateAndYawRateResponse> {
    return self.makeUnaryCall(
      path: "/mavsdk.rpc.gimbal.GimbalService/SetPitchRateAndYawRate",
      request: request,
      callOptions: callOptions ?? self.defaultCallOptions,
      interceptors: self.interceptors?.makeSetPitchRateAndYawRateInterceptors() ?? []
    )
  }

  ///
  ///
  /// Set gimbal angular rates around pitch and yaw axes.
  ///
  /// This sets the desired angular rates around pitch and yaw axes of a gimbal.
  /// Will return when the command is accepted, however, it might
  /// take the gimbal longer to actually reach the angular rate.
  ///
  /// - Parameters:
  ///   - request: Request to send to SetPitchRateAndYawRate.
  ///   - callOptions: Call options.
  /// - Returns: A `UnaryCall` with futures for the metadata, status and response.
  internal func setPitchRateAndYawRate(
    _ request: Mavsdk_Rpc_Gimbal_SetPitchRateAndYawRateRequest,
    callOptions: CallOptions? = nil
  ) -> UnaryCall<Mavsdk_Rpc_Gimbal_SetPitchRateAndYawRateRequest, Mavsdk_Rpc_Gimbal_SetPitchRateAndYawRateResponse> {
    return self.makeUnaryCall(
      path: "/mavsdk.rpc.gimbal.GimbalService/SetPitchRateAndYawRate",
      request: request,
      callOptions: callOptions ?? self.defaultCallOptions
    )
  }

  ///
  /// Set gimbal mode.
  ///
  /// This sets the desired yaw mode of a gimbal.
  /// Will return when the command is accepted. However, it might
  /// take the gimbal longer to actually be set to the new angles.
  ///
  /// - Parameters:
  ///   - request: Request to send to SetMode.
  ///   - callOptions: Call options.
  /// - Returns: A `UnaryCall` with futures for the metadata, status and response.
  internal func setMode(
    _ request: Mavsdk_Rpc_Gimbal_SetModeRequest,
    callOptions: CallOptions? = nil
  ) -> UnaryCall<Mavsdk_Rpc_Gimbal_SetModeRequest, Mavsdk_Rpc_Gimbal_SetModeResponse> {
    return self.makeUnaryCall(
      path: "/mavsdk.rpc.gimbal.GimbalService/SetMode",
      request: request,
      callOptions: callOptions ?? self.defaultCallOptions,
      interceptors: self.interceptors?.makeSetModeInterceptors() ?? []
    )
  }

  ///
  /// Set gimbal region of interest (ROI).
  ///
  /// This sets a region of interest that the gimbal will point to.
  /// The gimbal will continue to point to the specified region until it
  /// receives a new command.
  /// The function will return when the command is accepted, however, it might
  /// take the gimbal longer to actually rotate to the ROI.
  ///
  /// - Parameters:
  ///   - request: Request to send to SetRoiLocation.
  ///   - callOptions: Call options.
  /// - Returns: A `UnaryCall` with futures for the metadata, status and response.
  internal func setRoiLocation(
    _ request: Mavsdk_Rpc_Gimbal_SetRoiLocationRequest,
    callOptions: CallOptions? = nil
  ) -> UnaryCall<Mavsdk_Rpc_Gimbal_SetRoiLocationRequest, Mavsdk_Rpc_Gimbal_SetRoiLocationResponse> {
    return self.makeUnaryCall(
      path: "/mavsdk.rpc.gimbal.GimbalService/SetRoiLocation",
      request: request,
      callOptions: callOptions ?? self.defaultCallOptions,
      interceptors: self.interceptors?.makeSetRoiLocationInterceptors() ?? []
    )
  }

  ///
  /// Take control.
  ///
  /// There can be only two components in control of a gimbal at any given time.
  /// One with "primary" control, and one with "secondary" control. The way the
  /// secondary control is implemented is not specified and hence depends on the
  /// vehicle.
  ///
  /// Components are expected to be cooperative, which means that they can
  /// override each other and should therefore do it carefully.
  ///
  /// - Parameters:
  ///   - request: Request to send to TakeControl.
  ///   - callOptions: Call options.
  /// - Returns: A `UnaryCall` with futures for the metadata, status and response.
  internal func takeControl(
    _ request: Mavsdk_Rpc_Gimbal_TakeControlRequest,
    callOptions: CallOptions? = nil
  ) -> UnaryCall<Mavsdk_Rpc_Gimbal_TakeControlRequest, Mavsdk_Rpc_Gimbal_TakeControlResponse> {
    return self.makeUnaryCall(
      path: "/mavsdk.rpc.gimbal.GimbalService/TakeControl",
      request: request,
      callOptions: callOptions ?? self.defaultCallOptions,
      interceptors: self.interceptors?.makeTakeControlInterceptors() ?? []
    )
  }

  ///
  /// Release control.
  ///
  /// Release control, such that other components can control the gimbal.
  ///
  /// - Parameters:
  ///   - request: Request to send to ReleaseControl.
  ///   - callOptions: Call options.
  /// - Returns: A `UnaryCall` with futures for the metadata, status and response.
  internal func releaseControl(
    _ request: Mavsdk_Rpc_Gimbal_ReleaseControlRequest,
    callOptions: CallOptions? = nil
  ) -> UnaryCall<Mavsdk_Rpc_Gimbal_ReleaseControlRequest, Mavsdk_Rpc_Gimbal_ReleaseControlResponse> {
    return self.makeUnaryCall(
      path: "/mavsdk.rpc.gimbal.GimbalService/ReleaseControl",
      request: request,
      callOptions: callOptions ?? self.defaultCallOptions,
      interceptors: self.interceptors?.makeReleaseControlInterceptors() ?? []
    )
  }

  ///
  /// Subscribe to control status updates.
  ///
  /// This allows a component to know if it has primary, secondary or
  /// no control over the gimbal. Also, it gives the system and component ids
  /// of the other components in control (if any).
  ///
  /// - Parameters:
  ///   - request: Request to send to SubscribeControl.
  ///   - callOptions: Call options.
  ///   - handler: A closure called when each response is received from the server.
  /// - Returns: A `ServerStreamingCall` with futures for the metadata and status.
  internal func subscribeControl(
    _ request: Mavsdk_Rpc_Gimbal_SubscribeControlRequest,
    callOptions: CallOptions? = nil,
    handler: @escaping (Mavsdk_Rpc_Gimbal_ControlResponse) -> Void
  ) -> ServerStreamingCall<Mavsdk_Rpc_Gimbal_SubscribeControlRequest, Mavsdk_Rpc_Gimbal_ControlResponse> {
    return self.makeServerStreamingCall(
      path: "/mavsdk.rpc.gimbal.GimbalService/SubscribeControl",
      request: request,
      callOptions: callOptions ?? self.defaultCallOptions,
      interceptors: self.interceptors?.makeSubscribeControlInterceptors() ?? [],
      handler: handler
    )
  }
}

internal protocol Mavsdk_Rpc_Gimbal_GimbalServiceClientInterceptorFactoryProtocol {

  /// - Returns: Interceptors to use when invoking 'setPitchAndYaw'.
  func makeSetPitchAndYawInterceptors() -> [ClientInterceptor<Mavsdk_Rpc_Gimbal_SetPitchAndYawRequest, Mavsdk_Rpc_Gimbal_SetPitchAndYawResponse>]

  /// - Returns: Interceptors to use when invoking 'setPitchRateAndYawRate'.
  func makeSetPitchRateAndYawRateInterceptors() -> [ClientInterceptor<Mavsdk_Rpc_Gimbal_SetPitchRateAndYawRateRequest, Mavsdk_Rpc_Gimbal_SetPitchRateAndYawRateResponse>]

  /// - Returns: Interceptors to use when invoking 'setMode'.
  func makeSetModeInterceptors() -> [ClientInterceptor<Mavsdk_Rpc_Gimbal_SetModeRequest, Mavsdk_Rpc_Gimbal_SetModeResponse>]

  /// - Returns: Interceptors to use when invoking 'setRoiLocation'.
  func makeSetRoiLocationInterceptors() -> [ClientInterceptor<Mavsdk_Rpc_Gimbal_SetRoiLocationRequest, Mavsdk_Rpc_Gimbal_SetRoiLocationResponse>]

  /// - Returns: Interceptors to use when invoking 'takeControl'.
  func makeTakeControlInterceptors() -> [ClientInterceptor<Mavsdk_Rpc_Gimbal_TakeControlRequest, Mavsdk_Rpc_Gimbal_TakeControlResponse>]

  /// - Returns: Interceptors to use when invoking 'releaseControl'.
  func makeReleaseControlInterceptors() -> [ClientInterceptor<Mavsdk_Rpc_Gimbal_ReleaseControlRequest, Mavsdk_Rpc_Gimbal_ReleaseControlResponse>]

  /// - Returns: Interceptors to use when invoking 'subscribeControl'.
  func makeSubscribeControlInterceptors() -> [ClientInterceptor<Mavsdk_Rpc_Gimbal_SubscribeControlRequest, Mavsdk_Rpc_Gimbal_ControlResponse>]
}

internal final class Mavsdk_Rpc_Gimbal_GimbalServiceClient: Mavsdk_Rpc_Gimbal_GimbalServiceClientProtocol {
  internal let channel: GRPCChannel
  internal var defaultCallOptions: CallOptions
  internal var interceptors: Mavsdk_Rpc_Gimbal_GimbalServiceClientInterceptorFactoryProtocol?

  /// Creates a client for the mavsdk.rpc.gimbal.GimbalService service.
  ///
  /// - Parameters:
  ///   - channel: `GRPCChannel` to the service host.
  ///   - defaultCallOptions: Options to use for each service call if the user doesn't provide them.
  ///   - interceptors: A factory providing interceptors for each RPC.
  internal init(
    channel: GRPCChannel,
    defaultCallOptions: CallOptions = CallOptions(),
    interceptors: Mavsdk_Rpc_Gimbal_GimbalServiceClientInterceptorFactoryProtocol? = nil
  ) {
    self.channel = channel
    self.defaultCallOptions = defaultCallOptions
    self.interceptors = interceptors
  }
}

/// Provide control over a gimbal.
///
/// To build a server, implement a class that conforms to this protocol.
internal protocol Mavsdk_Rpc_Gimbal_GimbalServiceProvider: CallHandlerProvider {
  var interceptors: Mavsdk_Rpc_Gimbal_GimbalServiceServerInterceptorFactoryProtocol? { get }

  ///
  ///
  /// Set gimbal pitch and yaw angles.
  ///
  /// This sets the desired pitch and yaw angles of a gimbal.
  /// Will return when the command is accepted, however, it might
  /// take the gimbal longer to actually be set to the new angles.
  func setPitchAndYaw(request: Mavsdk_Rpc_Gimbal_SetPitchAndYawRequest, context: StatusOnlyCallContext) -> EventLoopFuture<Mavsdk_Rpc_Gimbal_SetPitchAndYawResponse>

  ///
  ///
  /// Set gimbal angular rates around pitch and yaw axes.
  ///
  /// This sets the desired angular rates around pitch and yaw axes of a gimbal.
  /// Will return when the command is accepted, however, it might
  /// take the gimbal longer to actually reach the angular rate.
  func setPitchRateAndYawRate(request: Mavsdk_Rpc_Gimbal_SetPitchRateAndYawRateRequest, context: StatusOnlyCallContext) -> EventLoopFuture<Mavsdk_Rpc_Gimbal_SetPitchRateAndYawRateResponse>

  ///
  ///
  /// Set gimbal angular rates around pitch and yaw axes.
  ///
  /// This sets the desired angular rates around pitch and yaw axes of a gimbal.
  /// Will return when the command is accepted, however, it might
  /// take the gimbal longer to actually reach the angular rate.
  func setPitchRateAndYawRate(request: Mavsdk_Rpc_Gimbal_SetPitchRateAndYawRateRequest, context: StatusOnlyCallContext) -> EventLoopFuture<Mavsdk_Rpc_Gimbal_SetPitchRateAndYawRateResponse>
  ///
  /// Set gimbal mode.
  ///
  /// This sets the desired yaw mode of a gimbal.
  /// Will return when the command is accepted. However, it might
  /// take the gimbal longer to actually be set to the new angles.
  func setMode(request: Mavsdk_Rpc_Gimbal_SetModeRequest, context: StatusOnlyCallContext) -> EventLoopFuture<Mavsdk_Rpc_Gimbal_SetModeResponse>

  ///
  /// Set gimbal region of interest (ROI).
  ///
  /// This sets a region of interest that the gimbal will point to.
  /// The gimbal will continue to point to the specified region until it
  /// receives a new command.
  /// The function will return when the command is accepted, however, it might
  /// take the gimbal longer to actually rotate to the ROI.
  func setRoiLocation(request: Mavsdk_Rpc_Gimbal_SetRoiLocationRequest, context: StatusOnlyCallContext) -> EventLoopFuture<Mavsdk_Rpc_Gimbal_SetRoiLocationResponse>
  ///
  /// Take control.
  ///
  /// There can be only two components in control of a gimbal at any given time.
  /// One with "primary" control, and one with "secondary" control. The way the
  /// secondary control is implemented is not specified and hence depends on the
  /// vehicle.
  ///
  /// Components are expected to be cooperative, which means that they can
  /// override each other and should therefore do it carefully.
  func takeControl(request: Mavsdk_Rpc_Gimbal_TakeControlRequest, context: StatusOnlyCallContext) -> EventLoopFuture<Mavsdk_Rpc_Gimbal_TakeControlResponse>
  ///
  /// Release control.
  ///
  /// Release control, such that other components can control the gimbal.
  func releaseControl(request: Mavsdk_Rpc_Gimbal_ReleaseControlRequest, context: StatusOnlyCallContext) -> EventLoopFuture<Mavsdk_Rpc_Gimbal_ReleaseControlResponse>
  ///
  /// Subscribe to control status updates.
  ///
  /// This allows a component to know if it has primary, secondary or
  /// no control over the gimbal. Also, it gives the system and component ids
  /// of the other components in control (if any).
  func subscribeControl(request: Mavsdk_Rpc_Gimbal_SubscribeControlRequest, context: StreamingResponseCallContext<Mavsdk_Rpc_Gimbal_ControlResponse>) -> EventLoopFuture<GRPCStatus>
}

extension Mavsdk_Rpc_Gimbal_GimbalServiceProvider {
  internal var serviceName: Substring { return "mavsdk.rpc.gimbal.GimbalService" }

  /// Determines, calls and returns the appropriate request handler, depending on the request's method.
  /// Returns nil for methods not handled by this service.
  internal func handle(
    method name: Substring,
    context: CallHandlerContext
  ) -> GRPCServerHandlerProtocol? {
    switch name {
    case "SetPitchAndYaw":
      return UnaryServerHandler(
        context: context,
        requestDeserializer: ProtobufDeserializer<Mavsdk_Rpc_Gimbal_SetPitchAndYawRequest>(),
        responseSerializer: ProtobufSerializer<Mavsdk_Rpc_Gimbal_SetPitchAndYawResponse>(),
        interceptors: self.interceptors?.makeSetPitchAndYawInterceptors() ?? [],
        userFunction: self.setPitchAndYaw(request:context:)
      )

    case "SetPitchRateAndYawRate":
      return UnaryServerHandler(
        context: context,
        requestDeserializer: ProtobufDeserializer<Mavsdk_Rpc_Gimbal_SetPitchRateAndYawRateRequest>(),
        responseSerializer: ProtobufSerializer<Mavsdk_Rpc_Gimbal_SetPitchRateAndYawRateResponse>(),
        interceptors: self.interceptors?.makeSetPitchRateAndYawRateInterceptors() ?? [],
        userFunction: self.setPitchRateAndYawRate(request:context:)
      )

    case "SetPitchRateAndYawRate":
      return CallHandlerFactory.makeUnary(callHandlerContext: callHandlerContext) { context in
        return { request in
          self.setPitchRateAndYawRate(request: request, context: context)
        }
      }

    case "SetMode":
      return UnaryServerHandler(
        context: context,
        requestDeserializer: ProtobufDeserializer<Mavsdk_Rpc_Gimbal_SetModeRequest>(),
        responseSerializer: ProtobufSerializer<Mavsdk_Rpc_Gimbal_SetModeResponse>(),
        interceptors: self.interceptors?.makeSetModeInterceptors() ?? [],
        userFunction: self.setMode(request:context:)
      )

    case "SetRoiLocation":
      return UnaryServerHandler(
        context: context,
        requestDeserializer: ProtobufDeserializer<Mavsdk_Rpc_Gimbal_SetRoiLocationRequest>(),
        responseSerializer: ProtobufSerializer<Mavsdk_Rpc_Gimbal_SetRoiLocationResponse>(),
        interceptors: self.interceptors?.makeSetRoiLocationInterceptors() ?? [],
        userFunction: self.setRoiLocation(request:context:)
      )

    case "TakeControl":
      return UnaryServerHandler(
        context: context,
        requestDeserializer: ProtobufDeserializer<Mavsdk_Rpc_Gimbal_TakeControlRequest>(),
        responseSerializer: ProtobufSerializer<Mavsdk_Rpc_Gimbal_TakeControlResponse>(),
        interceptors: self.interceptors?.makeTakeControlInterceptors() ?? [],
        userFunction: self.takeControl(request:context:)
      )

    case "ReleaseControl":
      return UnaryServerHandler(
        context: context,
        requestDeserializer: ProtobufDeserializer<Mavsdk_Rpc_Gimbal_ReleaseControlRequest>(),
        responseSerializer: ProtobufSerializer<Mavsdk_Rpc_Gimbal_ReleaseControlResponse>(),
        interceptors: self.interceptors?.makeReleaseControlInterceptors() ?? [],
        userFunction: self.releaseControl(request:context:)
      )

    case "SubscribeControl":
      return ServerStreamingServerHandler(
        context: context,
        requestDeserializer: ProtobufDeserializer<Mavsdk_Rpc_Gimbal_SubscribeControlRequest>(),
        responseSerializer: ProtobufSerializer<Mavsdk_Rpc_Gimbal_ControlResponse>(),
        interceptors: self.interceptors?.makeSubscribeControlInterceptors() ?? [],
        userFunction: self.subscribeControl(request:context:)
      )

    default:
      return nil
    }
  }
}

internal protocol Mavsdk_Rpc_Gimbal_GimbalServiceServerInterceptorFactoryProtocol {

  /// - Returns: Interceptors to use when handling 'setPitchAndYaw'.
  ///   Defaults to calling `self.makeInterceptors()`.
  func makeSetPitchAndYawInterceptors() -> [ServerInterceptor<Mavsdk_Rpc_Gimbal_SetPitchAndYawRequest, Mavsdk_Rpc_Gimbal_SetPitchAndYawResponse>]

  /// - Returns: Interceptors to use when handling 'setPitchRateAndYawRate'.
  ///   Defaults to calling `self.makeInterceptors()`.
  func makeSetPitchRateAndYawRateInterceptors() -> [ServerInterceptor<Mavsdk_Rpc_Gimbal_SetPitchRateAndYawRateRequest, Mavsdk_Rpc_Gimbal_SetPitchRateAndYawRateResponse>]

  /// - Returns: Interceptors to use when handling 'setMode'.
  ///   Defaults to calling `self.makeInterceptors()`.
  func makeSetModeInterceptors() -> [ServerInterceptor<Mavsdk_Rpc_Gimbal_SetModeRequest, Mavsdk_Rpc_Gimbal_SetModeResponse>]

  /// - Returns: Interceptors to use when handling 'setRoiLocation'.
  ///   Defaults to calling `self.makeInterceptors()`.
  func makeSetRoiLocationInterceptors() -> [ServerInterceptor<Mavsdk_Rpc_Gimbal_SetRoiLocationRequest, Mavsdk_Rpc_Gimbal_SetRoiLocationResponse>]

  /// - Returns: Interceptors to use when handling 'takeControl'.
  ///   Defaults to calling `self.makeInterceptors()`.
  func makeTakeControlInterceptors() -> [ServerInterceptor<Mavsdk_Rpc_Gimbal_TakeControlRequest, Mavsdk_Rpc_Gimbal_TakeControlResponse>]

  /// - Returns: Interceptors to use when handling 'releaseControl'.
  ///   Defaults to calling `self.makeInterceptors()`.
  func makeReleaseControlInterceptors() -> [ServerInterceptor<Mavsdk_Rpc_Gimbal_ReleaseControlRequest, Mavsdk_Rpc_Gimbal_ReleaseControlResponse>]

  /// - Returns: Interceptors to use when handling 'subscribeControl'.
  ///   Defaults to calling `self.makeInterceptors()`.
  func makeSubscribeControlInterceptors() -> [ServerInterceptor<Mavsdk_Rpc_Gimbal_SubscribeControlRequest, Mavsdk_Rpc_Gimbal_ControlResponse>]
}
