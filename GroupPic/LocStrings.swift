//
//  LocStrings.swift
//  GroupPic
//
//  Created by Paul Festor on 24/07/2022.
//

import Foundation


struct LocStrings {
    static let welcome = "welcome".localized
    static let onboarding_1 = "onboarding_1".localized
    static let onboarding_2 = "onboarding_2".localized
    static let onboarding_3 = "onboarding_3".localized
    static let onboarding_4 = "onboarding_4".localized
    static let photo_saved = "saved".localized
    static let save_photo = "save photo".localized
    static let privacy_policy = "privacy_policy".localized
    static let settings = "settings".localized
    static let auto_scaling = "auto_scaling".localized
    static let auto_scaling_desc = "auto_scaling_desc".localized
    static let done = "done".localized
}

extension String {
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
}
