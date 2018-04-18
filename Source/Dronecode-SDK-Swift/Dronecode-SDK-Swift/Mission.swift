import Foundation
import gRPC
import RxSwift

public struct MissionItem : Equatable {
    public let latitudeDeg: Double
    public let longitudeDeg: Double
    public let relativeAltitudeM: Double
    public let speedMPS: Float
    public let isFlyThrough: Bool
    public let gimbalPitchDeg: Float
    public let gimbalYawDeg: Float
    public let cameraAction: CameraAction

    public init(latitudeDeg: Double, longitudeDeg: Double, relativeAltitudeM: Double, speedMPS: Float, isFlyThrough: Bool, gimbalPitchDeg: Float, gimbalYawDeg: Float, cameraAction: CameraAction) {
        self.latitudeDeg = latitudeDeg
        self.longitudeDeg = longitudeDeg
        self.relativeAltitudeM = relativeAltitudeM
        self.speedMPS = speedMPS
        self.isFlyThrough = isFlyThrough
        self.gimbalPitchDeg = gimbalPitchDeg
        self.gimbalYawDeg = gimbalYawDeg
        self.cameraAction = cameraAction
    }

    public static func == (lhs: MissionItem, rhs: MissionItem) -> Bool {
        return lhs.latitudeDeg == rhs.latitudeDeg
            && lhs.longitudeDeg == rhs.longitudeDeg
            && lhs.relativeAltitudeM == rhs.relativeAltitudeM
            && lhs.speedMPS == rhs.speedMPS
            && lhs.isFlyThrough == rhs.isFlyThrough
            && lhs.gimbalPitchDeg == rhs.gimbalPitchDeg
            && lhs.gimbalYawDeg == rhs.gimbalYawDeg
            && lhs.cameraAction == rhs.cameraAction
    }
}

public enum CameraAction {
    case NONE
    case TAKE_PHOTO
    case START_PHOTO_INTERVAL
    case STOP_PHOTO_INTERVAL
    case START_VIDEO
    case STOP_VIDEO
}

public class Mission {
    let service: Dronecore_Rpc_Mission_MissionServiceService

    public convenience init(address: String, port: Int) {
        let service = Dronecore_Rpc_Mission_MissionServiceServiceClient(address: "\(address):\(port)", secure: false)
        self.init(service: service)
    }

    init(service: Dronecore_Rpc_Mission_MissionServiceService) {
        self.service = service
    }

    public func uploadMission(missionItems: [MissionItem]) -> Completable {
        return Completable.create { completable in
            var uploadMissionRequest = Dronecore_Rpc_Mission_UploadMissionRequest()

            for missionItem in missionItems {
                var rpcMissionItem = Dronecore_Rpc_Mission_MissionItem()
                rpcMissionItem.latitudeDeg = missionItem.latitudeDeg
                rpcMissionItem.longitudeDeg = missionItem.longitudeDeg
                rpcMissionItem.relativeAltitudeM = missionItem.relativeAltitudeM
                rpcMissionItem.speedMS = missionItem.speedMPS
                rpcMissionItem.isFlyThrough = missionItem.isFlyThrough
                rpcMissionItem.gimbalPitchDeg = missionItem.gimbalPitchDeg
                rpcMissionItem.gimbalYawDeg = missionItem.gimbalYawDeg
                rpcMissionItem.cameraAction = self.translateCameraAction(cameraAction: missionItem.cameraAction)

                uploadMissionRequest.mission.missionItem.append(rpcMissionItem)
            }

            do {
                let uploadMissionResponse = try self.service.uploadmission(uploadMissionRequest)
                if (uploadMissionResponse.missionResult.result == Dronecore_Rpc_Mission_MissionResult.Result.success) {
                    completable(.completed)
                } else {
                    completable(.error("Cannot upload mission: \(uploadMissionResponse.missionResult.result)"))
                }
            } catch {
                completable(.error(error))
            }

            return Disposables.create {}
        }
    }

    func translateCameraAction(cameraAction: CameraAction) -> Dronecore_Rpc_Mission_MissionItem.CameraAction {
        switch (cameraAction) {
        case .NONE:
            return Dronecore_Rpc_Mission_MissionItem.CameraAction.none
        case .TAKE_PHOTO:
            return Dronecore_Rpc_Mission_MissionItem.CameraAction.takePhoto
        case .START_PHOTO_INTERVAL:
            return Dronecore_Rpc_Mission_MissionItem.CameraAction.startPhotoInterval
        case .STOP_PHOTO_INTERVAL:
            return Dronecore_Rpc_Mission_MissionItem.CameraAction.stopPhotoInterval
        case .START_VIDEO:
            return Dronecore_Rpc_Mission_MissionItem.CameraAction.startVideo
        case .STOP_VIDEO:
            return Dronecore_Rpc_Mission_MissionItem.CameraAction.stopVideo
        }
    }

    public func startMission() -> Completable {
        return Completable.create { completable in
            let startMissionRequest = Dronecore_Rpc_Mission_StartMissionRequest()

            do {
                let startMissionResponse = try self.service.startmission(startMissionRequest)
                if (startMissionResponse.missionResult.result == Dronecore_Rpc_Mission_MissionResult.Result.success) {
                    completable(.completed)
                } else {
                    completable(.error("Cannot start mission: \(startMissionResponse.missionResult.result)"))
                }
            } catch {
                completable(.error(error))
            }

            return Disposables.create {}
        }
    }
}
