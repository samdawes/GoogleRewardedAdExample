//
//  AdCoordinator.swift
//  GoogleRewardedAdExample
//
//  Created by Sam Dawes on 8/17/24.
//

import Foundation
import GoogleMobileAds

protocol AdCoordinatorDelegate {
    func rewardSuccessAction()
    func adDidDismiss()
}

class AdCoordinator: NSObject {
    #if DEBUG
    // Test Ad unit ID
    private let adUnitId = "ca-app-pub-3940256099942544/1712485313"
    #else
    // Your real Ad unit ID will go here
    private let adUnitId = ""
    #endif
    
    private var ad: GADRewardedAd?
    var delegate: AdCoordinatorDelegate?
    
    func loadAd() async throws {
        ad = try await GADRewardedAd.load(withAdUnitID: adUnitId, request: GADRequest())
    }
    
    @MainActor
    func presentAd() {
        guard let ad else {
            return print("Ad was not loaded.")
        }
        ad.present(fromRootViewController: nil) {
            self.delegate?.rewardSuccessAction()
        }
    }
}

extension AdCoordinator: GADFullScreenContentDelegate {
    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        delegate?.adDidDismiss()
    }
}
