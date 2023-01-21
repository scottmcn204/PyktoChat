//
//  SettingsViewModel.swift
//  PyktoChat
//
//  Created by Scott McNally on 20/01/2023.
//

import Foundation
import SwiftUI

class SettingsViewModel : ObservableObject {
    var databaseService = DatabaseService()
    func deactivateAccount(completion: @escaping () -> Void) {
        databaseService.deactivateAccount {
            completion()
        }
    }
}
