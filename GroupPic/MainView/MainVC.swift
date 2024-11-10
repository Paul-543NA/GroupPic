//
//  MainVC.swift
//  GroupPic
//
//  Created by Paul Festor on 17/07/2022.
//

import Foundation
import SwiftUI

class MainVC: ObservableObject {
    
    enum Status {
        case noPicsTaken
        case firstPicTaken
        case bothPicsTaken
    }
    
    @Published var status: Status = .noPicsTaken
    @Published var backImage: UIImage? = nil
    @Published var frontImage: UIImage? = nil
    
    // MARK: - Intents
    func mainButtonPressed() {
        
    }
    
    // MARK: - Internal Logic
    
}
