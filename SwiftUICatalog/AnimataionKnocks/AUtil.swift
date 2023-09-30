//
//  Util.swift
//  SwiftUICatalog
//
//  Created by po_miyasaka on 2023/09/29.
//

import SwiftUI
import UIKit

@MainActor func triggerHaptic() {
    let impactFeedbackgenerator = UIImpactFeedbackGenerator(style: .medium)
    impactFeedbackgenerator.prepare()
    impactFeedbackgenerator.impactOccurred()
}
