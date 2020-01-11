//
//  String+Extension.swift
//  On the Map
//
//  Created by Emmanuel Okwara on 11/01/2020.
//  Copyright © 2020 Emmanuel Okwara. All rights reserved.
//

import Foundation
import ProgressHUD

extension String {
    func isEmpty() -> Bool {
        return self.trimmingCharacters(in: .whitespacesAndNewlines) == ""
    }
    
    func showError() {
        ProgressHUD.showError(self, interaction: false)
    }
}
