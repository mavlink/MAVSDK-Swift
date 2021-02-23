//
// DO NOT EDIT.
//
// Generated by the protocol buffer compiler.
// Source: tune.proto
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


/// Enable creating and sending a tune to be played on the system.
///
/// Usage: instantiate `Mavsdk_Rpc_Tune_TuneServiceClient`, then call methods of this protocol to make API calls.
internal protocol Mavsdk_Rpc_Tune_TuneServiceClientProtocol: GRPCClient {
  var serviceName: String { get }
  var interceptors: Mavsdk_Rpc_Tune_TuneServiceClientInterceptorFactoryProtocol? { get }

  func playTune(
    _ request: Mavsdk_Rpc_Tune_PlayTuneRequest,
    callOptions: CallOptions?
  ) -> UnaryCall<Mavsdk_Rpc_Tune_PlayTuneRequest, Mavsdk_Rpc_Tune_PlayTuneResponse>
}

extension Mavsdk_Rpc_Tune_TuneServiceClientProtocol {
  internal var serviceName: String {
    return "mavsdk.rpc.tune.TuneService"
  }

  /// Send a tune to be played by the system.
  ///
  /// - Parameters:
  ///   - request: Request to send to PlayTune.
  ///   - callOptions: Call options.
  /// - Returns: A `UnaryCall` with futures for the metadata, status and response.
  internal func playTune(
    _ request: Mavsdk_Rpc_Tune_PlayTuneRequest,
    callOptions: CallOptions? = nil
  ) -> UnaryCall<Mavsdk_Rpc_Tune_PlayTuneRequest, Mavsdk_Rpc_Tune_PlayTuneResponse> {
    return self.makeUnaryCall(
      path: "/mavsdk.rpc.tune.TuneService/PlayTune",
      request: request,
      callOptions: callOptions ?? self.defaultCallOptions,
      interceptors: self.interceptors?.makePlayTuneInterceptors() ?? []
    )
  }
}

internal protocol Mavsdk_Rpc_Tune_TuneServiceClientInterceptorFactoryProtocol {

  /// - Returns: Interceptors to use when invoking 'playTune'.
  func makePlayTuneInterceptors() -> [ClientInterceptor<Mavsdk_Rpc_Tune_PlayTuneRequest, Mavsdk_Rpc_Tune_PlayTuneResponse>]
}

internal final class Mavsdk_Rpc_Tune_TuneServiceClient: Mavsdk_Rpc_Tune_TuneServiceClientProtocol {
  internal let channel: GRPCChannel
  internal var defaultCallOptions: CallOptions
  internal var interceptors: Mavsdk_Rpc_Tune_TuneServiceClientInterceptorFactoryProtocol?

  /// Creates a client for the mavsdk.rpc.tune.TuneService service.
  ///
  /// - Parameters:
  ///   - channel: `GRPCChannel` to the service host.
  ///   - defaultCallOptions: Options to use for each service call if the user doesn't provide them.
  ///   - interceptors: A factory providing interceptors for each RPC.
  internal init(
    channel: GRPCChannel,
    defaultCallOptions: CallOptions = CallOptions(),
    interceptors: Mavsdk_Rpc_Tune_TuneServiceClientInterceptorFactoryProtocol? = nil
  ) {
    self.channel = channel
    self.defaultCallOptions = defaultCallOptions
    self.interceptors = interceptors
  }
}

/// Enable creating and sending a tune to be played on the system.
///
/// To build a server, implement a class that conforms to this protocol.
internal protocol Mavsdk_Rpc_Tune_TuneServiceProvider: CallHandlerProvider {
  var interceptors: Mavsdk_Rpc_Tune_TuneServiceServerInterceptorFactoryProtocol? { get }

  /// Send a tune to be played by the system.
  func playTune(request: Mavsdk_Rpc_Tune_PlayTuneRequest, context: StatusOnlyCallContext) -> EventLoopFuture<Mavsdk_Rpc_Tune_PlayTuneResponse>
}

extension Mavsdk_Rpc_Tune_TuneServiceProvider {
  internal var serviceName: Substring { return "mavsdk.rpc.tune.TuneService" }

  /// Determines, calls and returns the appropriate request handler, depending on the request's method.
  /// Returns nil for methods not handled by this service.
  internal func handle(
    method name: Substring,
    context: CallHandlerContext
  ) -> GRPCServerHandlerProtocol? {
    switch name {
    case "PlayTune":
      return UnaryServerHandler(
        context: context,
        requestDeserializer: ProtobufDeserializer<Mavsdk_Rpc_Tune_PlayTuneRequest>(),
        responseSerializer: ProtobufSerializer<Mavsdk_Rpc_Tune_PlayTuneResponse>(),
        interceptors: self.interceptors?.makePlayTuneInterceptors() ?? [],
        userFunction: self.playTune(request:context:)
      )

    default:
      return nil
    }
  }
}

internal protocol Mavsdk_Rpc_Tune_TuneServiceServerInterceptorFactoryProtocol {

  /// - Returns: Interceptors to use when handling 'playTune'.
  ///   Defaults to calling `self.makeInterceptors()`.
  func makePlayTuneInterceptors() -> [ServerInterceptor<Mavsdk_Rpc_Tune_PlayTuneRequest, Mavsdk_Rpc_Tune_PlayTuneResponse>]
}
