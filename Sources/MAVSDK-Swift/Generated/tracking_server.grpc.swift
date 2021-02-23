//
// DO NOT EDIT.
//
// Generated by the protocol buffer compiler.
// Source: tracking_server.proto
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


/// Usage: instantiate Mavsdk_Rpc_TrackingServer_TrackingServerServiceClient, then call methods of this protocol to make API calls.
internal protocol Mavsdk_Rpc_TrackingServer_TrackingServerServiceClientProtocol: GRPCClient {
  func setTrackingPointStatus(
    _ request: Mavsdk_Rpc_TrackingServer_SetTrackingPointStatusRequest,
    callOptions: CallOptions?
  ) -> UnaryCall<Mavsdk_Rpc_TrackingServer_SetTrackingPointStatusRequest, Mavsdk_Rpc_TrackingServer_SetTrackingPointStatusResponse>

  func setTrackingRectangleStatus(
    _ request: Mavsdk_Rpc_TrackingServer_SetTrackingRectangleStatusRequest,
    callOptions: CallOptions?
  ) -> UnaryCall<Mavsdk_Rpc_TrackingServer_SetTrackingRectangleStatusRequest, Mavsdk_Rpc_TrackingServer_SetTrackingRectangleStatusResponse>

  func setTrackingOffStatus(
    _ request: Mavsdk_Rpc_TrackingServer_SetTrackingOffStatusRequest,
    callOptions: CallOptions?
  ) -> UnaryCall<Mavsdk_Rpc_TrackingServer_SetTrackingOffStatusRequest, Mavsdk_Rpc_TrackingServer_SetTrackingOffStatusResponse>

  func subscribeTrackingPointCommand(
    _ request: Mavsdk_Rpc_TrackingServer_SubscribeTrackingPointCommandRequest,
    callOptions: CallOptions?,
    handler: @escaping (Mavsdk_Rpc_TrackingServer_TrackingPointCommandResponse) -> Void
  ) -> ServerStreamingCall<Mavsdk_Rpc_TrackingServer_SubscribeTrackingPointCommandRequest, Mavsdk_Rpc_TrackingServer_TrackingPointCommandResponse>

  func subscribeTrackingRectangleCommand(
    _ request: Mavsdk_Rpc_TrackingServer_SubscribeTrackingRectangleCommandRequest,
    callOptions: CallOptions?,
    handler: @escaping (Mavsdk_Rpc_TrackingServer_TrackingRectangleCommandResponse) -> Void
  ) -> ServerStreamingCall<Mavsdk_Rpc_TrackingServer_SubscribeTrackingRectangleCommandRequest, Mavsdk_Rpc_TrackingServer_TrackingRectangleCommandResponse>

  func subscribeTrackingOffCommand(
    _ request: Mavsdk_Rpc_TrackingServer_SubscribeTrackingOffCommandRequest,
    callOptions: CallOptions?,
    handler: @escaping (Mavsdk_Rpc_TrackingServer_TrackingOffCommandResponse) -> Void
  ) -> ServerStreamingCall<Mavsdk_Rpc_TrackingServer_SubscribeTrackingOffCommandRequest, Mavsdk_Rpc_TrackingServer_TrackingOffCommandResponse>

  func respondTrackingPointCommand(
    _ request: Mavsdk_Rpc_TrackingServer_RespondTrackingPointCommandRequest,
    callOptions: CallOptions?
  ) -> UnaryCall<Mavsdk_Rpc_TrackingServer_RespondTrackingPointCommandRequest, Mavsdk_Rpc_TrackingServer_RespondTrackingPointCommandResponse>

  func respondTrackingRectangleCommand(
    _ request: Mavsdk_Rpc_TrackingServer_RespondTrackingRectangleCommandRequest,
    callOptions: CallOptions?
  ) -> UnaryCall<Mavsdk_Rpc_TrackingServer_RespondTrackingRectangleCommandRequest, Mavsdk_Rpc_TrackingServer_RespondTrackingRectangleCommandResponse>

  func respondTrackingOffCommand(
    _ request: Mavsdk_Rpc_TrackingServer_RespondTrackingOffCommandRequest,
    callOptions: CallOptions?
  ) -> UnaryCall<Mavsdk_Rpc_TrackingServer_RespondTrackingOffCommandRequest, Mavsdk_Rpc_TrackingServer_RespondTrackingOffCommandResponse>

}

extension Mavsdk_Rpc_TrackingServer_TrackingServerServiceClientProtocol {

  /// Set/update the current point tracking status.
  ///
  /// - Parameters:
  ///   - request: Request to send to SetTrackingPointStatus.
  ///   - callOptions: Call options.
  /// - Returns: A `UnaryCall` with futures for the metadata, status and response.
  internal func setTrackingPointStatus(
    _ request: Mavsdk_Rpc_TrackingServer_SetTrackingPointStatusRequest,
    callOptions: CallOptions? = nil
  ) -> UnaryCall<Mavsdk_Rpc_TrackingServer_SetTrackingPointStatusRequest, Mavsdk_Rpc_TrackingServer_SetTrackingPointStatusResponse> {
    return self.makeUnaryCall(
      path: "/mavsdk.rpc.tracking_server.TrackingServerService/SetTrackingPointStatus",
      request: request,
      callOptions: callOptions ?? self.defaultCallOptions
    )
  }

  /// Set/update the current rectangle tracking status.
  ///
  /// - Parameters:
  ///   - request: Request to send to SetTrackingRectangleStatus.
  ///   - callOptions: Call options.
  /// - Returns: A `UnaryCall` with futures for the metadata, status and response.
  internal func setTrackingRectangleStatus(
    _ request: Mavsdk_Rpc_TrackingServer_SetTrackingRectangleStatusRequest,
    callOptions: CallOptions? = nil
  ) -> UnaryCall<Mavsdk_Rpc_TrackingServer_SetTrackingRectangleStatusRequest, Mavsdk_Rpc_TrackingServer_SetTrackingRectangleStatusResponse> {
    return self.makeUnaryCall(
      path: "/mavsdk.rpc.tracking_server.TrackingServerService/SetTrackingRectangleStatus",
      request: request,
      callOptions: callOptions ?? self.defaultCallOptions
    )
  }

  /// Set the current tracking status to off.
  ///
  /// - Parameters:
  ///   - request: Request to send to SetTrackingOffStatus.
  ///   - callOptions: Call options.
  /// - Returns: A `UnaryCall` with futures for the metadata, status and response.
  internal func setTrackingOffStatus(
    _ request: Mavsdk_Rpc_TrackingServer_SetTrackingOffStatusRequest,
    callOptions: CallOptions? = nil
  ) -> UnaryCall<Mavsdk_Rpc_TrackingServer_SetTrackingOffStatusRequest, Mavsdk_Rpc_TrackingServer_SetTrackingOffStatusResponse> {
    return self.makeUnaryCall(
      path: "/mavsdk.rpc.tracking_server.TrackingServerService/SetTrackingOffStatus",
      request: request,
      callOptions: callOptions ?? self.defaultCallOptions
    )
  }

  /// Subscribe to incoming tracking point command.
  ///
  /// - Parameters:
  ///   - request: Request to send to SubscribeTrackingPointCommand.
  ///   - callOptions: Call options.
  ///   - handler: A closure called when each response is received from the server.
  /// - Returns: A `ServerStreamingCall` with futures for the metadata and status.
  internal func subscribeTrackingPointCommand(
    _ request: Mavsdk_Rpc_TrackingServer_SubscribeTrackingPointCommandRequest,
    callOptions: CallOptions? = nil,
    handler: @escaping (Mavsdk_Rpc_TrackingServer_TrackingPointCommandResponse) -> Void
  ) -> ServerStreamingCall<Mavsdk_Rpc_TrackingServer_SubscribeTrackingPointCommandRequest, Mavsdk_Rpc_TrackingServer_TrackingPointCommandResponse> {
    return self.makeServerStreamingCall(
      path: "/mavsdk.rpc.tracking_server.TrackingServerService/SubscribeTrackingPointCommand",
      request: request,
      callOptions: callOptions ?? self.defaultCallOptions,
      handler: handler
    )
  }

  /// Subscribe to incoming tracking rectangle command.
  ///
  /// - Parameters:
  ///   - request: Request to send to SubscribeTrackingRectangleCommand.
  ///   - callOptions: Call options.
  ///   - handler: A closure called when each response is received from the server.
  /// - Returns: A `ServerStreamingCall` with futures for the metadata and status.
  internal func subscribeTrackingRectangleCommand(
    _ request: Mavsdk_Rpc_TrackingServer_SubscribeTrackingRectangleCommandRequest,
    callOptions: CallOptions? = nil,
    handler: @escaping (Mavsdk_Rpc_TrackingServer_TrackingRectangleCommandResponse) -> Void
  ) -> ServerStreamingCall<Mavsdk_Rpc_TrackingServer_SubscribeTrackingRectangleCommandRequest, Mavsdk_Rpc_TrackingServer_TrackingRectangleCommandResponse> {
    return self.makeServerStreamingCall(
      path: "/mavsdk.rpc.tracking_server.TrackingServerService/SubscribeTrackingRectangleCommand",
      request: request,
      callOptions: callOptions ?? self.defaultCallOptions,
      handler: handler
    )
  }

  /// Subscribe to incoming tracking off command.
  ///
  /// - Parameters:
  ///   - request: Request to send to SubscribeTrackingOffCommand.
  ///   - callOptions: Call options.
  ///   - handler: A closure called when each response is received from the server.
  /// - Returns: A `ServerStreamingCall` with futures for the metadata and status.
  internal func subscribeTrackingOffCommand(
    _ request: Mavsdk_Rpc_TrackingServer_SubscribeTrackingOffCommandRequest,
    callOptions: CallOptions? = nil,
    handler: @escaping (Mavsdk_Rpc_TrackingServer_TrackingOffCommandResponse) -> Void
  ) -> ServerStreamingCall<Mavsdk_Rpc_TrackingServer_SubscribeTrackingOffCommandRequest, Mavsdk_Rpc_TrackingServer_TrackingOffCommandResponse> {
    return self.makeServerStreamingCall(
      path: "/mavsdk.rpc.tracking_server.TrackingServerService/SubscribeTrackingOffCommand",
      request: request,
      callOptions: callOptions ?? self.defaultCallOptions,
      handler: handler
    )
  }

  /// Respond to an incoming tracking point command.
  ///
  /// - Parameters:
  ///   - request: Request to send to RespondTrackingPointCommand.
  ///   - callOptions: Call options.
  /// - Returns: A `UnaryCall` with futures for the metadata, status and response.
  internal func respondTrackingPointCommand(
    _ request: Mavsdk_Rpc_TrackingServer_RespondTrackingPointCommandRequest,
    callOptions: CallOptions? = nil
  ) -> UnaryCall<Mavsdk_Rpc_TrackingServer_RespondTrackingPointCommandRequest, Mavsdk_Rpc_TrackingServer_RespondTrackingPointCommandResponse> {
    return self.makeUnaryCall(
      path: "/mavsdk.rpc.tracking_server.TrackingServerService/RespondTrackingPointCommand",
      request: request,
      callOptions: callOptions ?? self.defaultCallOptions
    )
  }

  /// Respond to an incoming tracking rectangle command.
  ///
  /// - Parameters:
  ///   - request: Request to send to RespondTrackingRectangleCommand.
  ///   - callOptions: Call options.
  /// - Returns: A `UnaryCall` with futures for the metadata, status and response.
  internal func respondTrackingRectangleCommand(
    _ request: Mavsdk_Rpc_TrackingServer_RespondTrackingRectangleCommandRequest,
    callOptions: CallOptions? = nil
  ) -> UnaryCall<Mavsdk_Rpc_TrackingServer_RespondTrackingRectangleCommandRequest, Mavsdk_Rpc_TrackingServer_RespondTrackingRectangleCommandResponse> {
    return self.makeUnaryCall(
      path: "/mavsdk.rpc.tracking_server.TrackingServerService/RespondTrackingRectangleCommand",
      request: request,
      callOptions: callOptions ?? self.defaultCallOptions
    )
  }

  /// Respond to an incoming tracking off command.
  ///
  /// - Parameters:
  ///   - request: Request to send to RespondTrackingOffCommand.
  ///   - callOptions: Call options.
  /// - Returns: A `UnaryCall` with futures for the metadata, status and response.
  internal func respondTrackingOffCommand(
    _ request: Mavsdk_Rpc_TrackingServer_RespondTrackingOffCommandRequest,
    callOptions: CallOptions? = nil
  ) -> UnaryCall<Mavsdk_Rpc_TrackingServer_RespondTrackingOffCommandRequest, Mavsdk_Rpc_TrackingServer_RespondTrackingOffCommandResponse> {
    return self.makeUnaryCall(
      path: "/mavsdk.rpc.tracking_server.TrackingServerService/RespondTrackingOffCommand",
      request: request,
      callOptions: callOptions ?? self.defaultCallOptions
    )
  }
}

internal final class Mavsdk_Rpc_TrackingServer_TrackingServerServiceClient: Mavsdk_Rpc_TrackingServer_TrackingServerServiceClientProtocol {
  internal let channel: GRPCChannel
  internal var defaultCallOptions: CallOptions

  /// Creates a client for the mavsdk.rpc.tracking_server.TrackingServerService service.
  ///
  /// - Parameters:
  ///   - channel: `GRPCChannel` to the service host.
  ///   - defaultCallOptions: Options to use for each service call if the user doesn't provide them.
  internal init(channel: GRPCChannel, defaultCallOptions: CallOptions = CallOptions()) {
    self.channel = channel
    self.defaultCallOptions = defaultCallOptions
  }
}

/// To build a server, implement a class that conforms to this protocol.
internal protocol Mavsdk_Rpc_TrackingServer_TrackingServerServiceProvider: CallHandlerProvider {
  /// Set/update the current point tracking status.
  func setTrackingPointStatus(request: Mavsdk_Rpc_TrackingServer_SetTrackingPointStatusRequest, context: StatusOnlyCallContext) -> EventLoopFuture<Mavsdk_Rpc_TrackingServer_SetTrackingPointStatusResponse>
  /// Set/update the current rectangle tracking status.
  func setTrackingRectangleStatus(request: Mavsdk_Rpc_TrackingServer_SetTrackingRectangleStatusRequest, context: StatusOnlyCallContext) -> EventLoopFuture<Mavsdk_Rpc_TrackingServer_SetTrackingRectangleStatusResponse>
  /// Set the current tracking status to off.
  func setTrackingOffStatus(request: Mavsdk_Rpc_TrackingServer_SetTrackingOffStatusRequest, context: StatusOnlyCallContext) -> EventLoopFuture<Mavsdk_Rpc_TrackingServer_SetTrackingOffStatusResponse>
  /// Subscribe to incoming tracking point command.
  func subscribeTrackingPointCommand(request: Mavsdk_Rpc_TrackingServer_SubscribeTrackingPointCommandRequest, context: StreamingResponseCallContext<Mavsdk_Rpc_TrackingServer_TrackingPointCommandResponse>) -> EventLoopFuture<GRPCStatus>
  /// Subscribe to incoming tracking rectangle command.
  func subscribeTrackingRectangleCommand(request: Mavsdk_Rpc_TrackingServer_SubscribeTrackingRectangleCommandRequest, context: StreamingResponseCallContext<Mavsdk_Rpc_TrackingServer_TrackingRectangleCommandResponse>) -> EventLoopFuture<GRPCStatus>
  /// Subscribe to incoming tracking off command.
  func subscribeTrackingOffCommand(request: Mavsdk_Rpc_TrackingServer_SubscribeTrackingOffCommandRequest, context: StreamingResponseCallContext<Mavsdk_Rpc_TrackingServer_TrackingOffCommandResponse>) -> EventLoopFuture<GRPCStatus>
  /// Respond to an incoming tracking point command.
  func respondTrackingPointCommand(request: Mavsdk_Rpc_TrackingServer_RespondTrackingPointCommandRequest, context: StatusOnlyCallContext) -> EventLoopFuture<Mavsdk_Rpc_TrackingServer_RespondTrackingPointCommandResponse>
  /// Respond to an incoming tracking rectangle command.
  func respondTrackingRectangleCommand(request: Mavsdk_Rpc_TrackingServer_RespondTrackingRectangleCommandRequest, context: StatusOnlyCallContext) -> EventLoopFuture<Mavsdk_Rpc_TrackingServer_RespondTrackingRectangleCommandResponse>
  /// Respond to an incoming tracking off command.
  func respondTrackingOffCommand(request: Mavsdk_Rpc_TrackingServer_RespondTrackingOffCommandRequest, context: StatusOnlyCallContext) -> EventLoopFuture<Mavsdk_Rpc_TrackingServer_RespondTrackingOffCommandResponse>
}

extension Mavsdk_Rpc_TrackingServer_TrackingServerServiceProvider {
  internal var serviceName: Substring { return "mavsdk.rpc.tracking_server.TrackingServerService" }

  /// Determines, calls and returns the appropriate request handler, depending on the request's method.
  /// Returns nil for methods not handled by this service.
  internal func handleMethod(_ methodName: Substring, callHandlerContext: CallHandlerContext) -> GRPCCallHandler? {
    switch methodName {
    case "SetTrackingPointStatus":
      return CallHandlerFactory.makeUnary(callHandlerContext: callHandlerContext) { context in
        return { request in
          self.setTrackingPointStatus(request: request, context: context)
        }
      }

    case "SetTrackingRectangleStatus":
      return CallHandlerFactory.makeUnary(callHandlerContext: callHandlerContext) { context in
        return { request in
          self.setTrackingRectangleStatus(request: request, context: context)
        }
      }

    case "SetTrackingOffStatus":
      return CallHandlerFactory.makeUnary(callHandlerContext: callHandlerContext) { context in
        return { request in
          self.setTrackingOffStatus(request: request, context: context)
        }
      }

    case "SubscribeTrackingPointCommand":
      return CallHandlerFactory.makeServerStreaming(callHandlerContext: callHandlerContext) { context in
        return { request in
          self.subscribeTrackingPointCommand(request: request, context: context)
        }
      }

    case "SubscribeTrackingRectangleCommand":
      return CallHandlerFactory.makeServerStreaming(callHandlerContext: callHandlerContext) { context in
        return { request in
          self.subscribeTrackingRectangleCommand(request: request, context: context)
        }
      }

    case "SubscribeTrackingOffCommand":
      return CallHandlerFactory.makeServerStreaming(callHandlerContext: callHandlerContext) { context in
        return { request in
          self.subscribeTrackingOffCommand(request: request, context: context)
        }
      }

    case "RespondTrackingPointCommand":
      return CallHandlerFactory.makeUnary(callHandlerContext: callHandlerContext) { context in
        return { request in
          self.respondTrackingPointCommand(request: request, context: context)
        }
      }

    case "RespondTrackingRectangleCommand":
      return CallHandlerFactory.makeUnary(callHandlerContext: callHandlerContext) { context in
        return { request in
          self.respondTrackingRectangleCommand(request: request, context: context)
        }
      }

    case "RespondTrackingOffCommand":
      return CallHandlerFactory.makeUnary(callHandlerContext: callHandlerContext) { context in
        return { request in
          self.respondTrackingOffCommand(request: request, context: context)
        }
      }

    default: return nil
    }
  }
}
