//
//  Button+Extension.swift
//  On the Map
//
//  Created by Emmanuel Okwara on 12/01/2020.
//  Copyright © 2020 Emmanuel Okwara. All rights reserved.
//

import Foundation
import UIKit

extension UIButton {
    func toggleState(on enabled: Bool) {
        self.isEnabled = enabled
        self.alpha = enabled ? 1 : 0.5
    }
}
