//
//  CTBikeService.swift
//  ctkit
//
//  Created by Gert-Jan Vercauteren on 26/09/2018.
//

import Foundation
import RxSwift

public enum CTBikeRegistrationFlow: String, Codable {
    case imei = "imei_flow"
    case frameNumberOnly = "frame_number_only_flow"
}

/**
 The CTBikeService is the main entry point to manage and create bikes for an authenticated user.
 It allows for all basic management and some convenience methods to help ease the management of bikes.
 */
public class CTBikeService: NSObject {

    /**
     Create a new bike with the minimal amount of data
     
     - Parameter name: The name of the bike
     - Parameter imei: The IMEI number of the bike
     - Parameter activationCode: The activationCode of the bike
     
     - Returns: An observable of the newly created bike.
     */
    public func create(withName name: String, imei: String, activationCode: String) -> Observable<CTBikeModel> {
        return CTKit.shared.restManager.post(endpoint: "bike", parameters: [
            "name": name,
            "imei": imei,
            "activation_code": activationCode]
        )
    }

    /**
     Create a new bike with the minimal amount of data
     
     - Parameter name: The name of the bike
     - Parameter activationCode: The activationCode of the bike
     
     - Returns: An observable of the newly created bike.
     */
    public func create(withName name: String, andActivationCode activationCode: String) -> Observable<CTBikeModel> {
        return CTKit.shared.restManager.post(endpoint: "bike", parameters: [
            "name": name,
            "activation_code": activationCode]
        )
    }

    /**
     Update an existing bike from the full model.
     
     - Note: Fields that can be patched are documented in the CTBikeModel
     
     - Parameter bike: The CTBikeModel with updated data that has to be patched on the API
     
     - Returns: An observable containing the update bike.
     */
    public func patch(withBike bike: CTBikeModel) -> Observable<CTBikeModel> {
        return CTKit.shared.restManager.patch(endpoint: "bike/\(bike.id)", parameters: try? bike.asDictionary())
    }

    /**
     Delete the bike from the account, when a user is the owner the bike will be deregistered.
     Once deregistration took place a different user will be able to add the bike to their account.
     When the user is not the owner the link with the shared bike will be broken.
     
     The outcome of this call is that a user will no longer have access to the bike, no matter if the user was the owner or not.
     
     - Parameter identifier: The identifier of the bike you want to delete
     
     - Returns: A completable call indicating the operation was successful.
     */
    public func delete(withBikeId identifier: Int) -> Observable<Int> {
        return CTKit.shared.restManager.archive(endpoint: "bike/\(identifier)").map { (_: CTBikeModel) in identifier }
    }

    /**
     Fetch a single bike the user has access to based on the bike identifier.
     When the user has no access to the bike a 422 error will be thrown to indicate the bike could not be found.
     
     - Parameter identifier: The bike identifier you want to retrieve the data for
     
     - Returns An observable containing the bike.
     */
    public func fetch(withId identifier: Int) -> Observable<CTBikeModel> {
        return CTKit.shared.restManager.get(endpoint: "bike/\(identifier)")
    }

    /**
     Fetch all the bikes a user has access to or owns. The `fetchOwned` and `fetchShared` function calls filter this call further.
     
     - Returns: An observable with the list of bikes the user has access to.
     */
    public func fetchAll() -> Observable<[CTBikeModel]> {
        return CTKit.shared.restManager.get(endpoint: "bike")
    }

    /**
     Fetch all bikes the user owns
     
     - Note: Deleting any of these bikes results in full deletion. Another user will be able to register the bike.
     - Returns:  An observable with the list of bikes the user is the owner of.
     */
    public func fetchOwned() -> Observable<[CTBikeModel]> {
        return self.fetchAll().map { result in
            return result.filter { $0.owner?.id == CTKit.shared.currentActiveUserId }
        }
    }

    /**
     Fetch all bikes the user has access to.
     
     - Note: Deleting any of these bikes results in breaking the shared bike connection.
             Another user will _not_ be able to register the bike.
     - Returns:  An observable with the list of bikes the user is the owner of.
     */
    public func fetchShared() -> Observable<[CTBikeModel]> {
        return self.fetchAll().map { result in
            return result.filter { $0.owner?.id != CTKit.shared.currentActiveUserId }
        }
    }

    /**
     Search for a bike based on its framenumber. This call will return the first part of the IMEI
     so that a user has a hint of what number you need.
     This call can return 0 or 1 results.
     When 0 results are returned the bike could already be registered or simply doesn't exist in our database.
     
     - Parameter identifier: The frame number of a bike you want to fetch some information about
     - Returns: An array with information of an unregistered bike. When the array is empty the bike doesn't exist or is already registered.
     */
    public func searchUnregisteredBike(withActivationCode identifier: String) -> Observable<[CTUnregisteredBikeInformationModel]> {
        return searchBike(withActivationCode: identifier).flatMap {
            (unregisteredBike: [CTUnregisteredBikeModel]) -> Observable<[CTUnregisteredBikeInformationModel]> in

            if unregisteredBike.isEmpty {
                let emptyResult: [CTUnregisteredBikeInformationModel] = []
                print("🔥 EMPTYYY")
                return Observable.of(emptyResult)
            } else {
                print("🔥 NOT EMPTY")
                return self.getBikeTypeInformation(withIdentifier: unregisteredBike[0].bikeTypeId).map {
                    (bikeType: CTBikeTypeModel) -> [CTUnregisteredBikeInformationModel] in
                    return [CTUnregisteredBikeInformationModel(
                        partialIMEI: unregisteredBike[0].partialIMEI,
                        frameNumber: unregisteredBike[0].frameNumber,
                        activationCode: unregisteredBike[0].activationCode,
                        manufacturerSKU: unregisteredBike[0].manufacturerSKU,
                        modelName: unregisteredBike[0].manufacturerModelName,
                        registrationFlow: bikeType.registrationFlow)]
                }
            }
        }
    }

    /**
     Search for an unregistered bike. When the array is empty the bike is registered or does not exist.
     This search can return 0 or 1 results.

     - Parameter identifier: The activation code of a bike you want to fetch some information about
     - Returns: 0 or 1 results, based on a found bike the api.
     */
    public func searchBike(withActivationCode identifier: String) -> Observable<[CTUnregisteredBikeModel]> {
        return CTKit.shared.restManager.get(endpoint: "v2/bike/search", parameters: ["activation_code": identifier])
    }

    /**
     Request paring for bikes that under user's other account(s)

     - Parameter identifier: The activation code of the bike you want to add
     - Returns: A Completable async callback.
     */
    public func requestPairing(forActivationCode identifier: String) -> Completable {
        return CTKit.shared.restManager.postCompletable(endpoint: "v2/tools/support-request", parameters: ["activation_code": identifier])
    }

    /**
     Get bike type information

     - Parameter identifier: The id of the biketype. This can be found by calling searchBike(_)
     - Returns: Observable with biketype information
    */
    public func getBikeTypeInformation(withIdentifier identifier: Int) -> Observable<CTBikeTypeModel> {
        return CTKit.shared.restManager.get(endpoint: "bike-type/\(identifier)")
    }

    /**
     Update the linked users array for a bike. The array that is patched will be the new list of linked users.
     When you want to remove a linked user, remove it from the list in the model, then call this function
     
     - Parameter identifier: The bike with updated linked users you want to persist on the API
     - Parameter users: The users to patch, this will overwrite any other linked users.
     - Returns: An observable with the updated bike model in sync with the API.
     */
    public func updateLinkedUsers(withBikeId identifier: Int, andLinkedUsers users: [CTBasicUserModel]) -> Observable<CTBikeModel> {
        let userDict = users.map { user in try! user.asDictionary() }
        return CTKit.shared.restManager.patch(endpoint: "bike/\(identifier)", parameters: ["linked_users": userDict])
    }

    /**
     Update the settings for notification for a bike.
     
     
     - Parameter identifier: The bike id to patch notifications on
     - Parameter settings: Notification settings object with the state of toggles (on/off)
     - Returns: An observable with the updated settings model in sync with the API.
     */
    public func updateNotificationSettings(withBikeId identifier: Int,
                                           andSettings settings: CTBikeNotificationSettingsModel) -> Observable<CTBikeNotificationSettingsModel> {
        return CTKit.shared.restManager.patch(endpoint: "bike/\(identifier)", parameters: try? settings.asDictionary())
    }

    /**
     Fetch notification settngs for a bike
     
     - Parameter identifier: The bike id to get notification settings for
     - Returns: An observable containing the notification settings for a bike
     */
    public func fetchNotificationSettings(withBikeId identifier: Int) -> Observable<CTBikeNotificationSettingsModel> {
        return CTKit.shared.restManager.get(endpoint: "bike/\(identifier)")
    }

    /**
     Fetch the features for a bike with the articleNumber on the bike object.

     - Parameter articleNumber: The articlenumber of the bike you want the features of
     - Returns: Features of the bike
     */
    public func fetchFeatures(withArticleNumber articleNumber: String) -> Observable<CTBikeFeatureModel> {
        return CTBikeTypeService().fetchBikeType(withArticleNumber: articleNumber).map { $0.features }
    }
}
