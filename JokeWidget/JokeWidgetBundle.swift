//
//  JokeWidgetBundle.swift
//  JokeWidget
//
//  Created by E2318556 on 29/1/2566 BE.
//

import WidgetKit
import SwiftUI

@main
struct JokeWidgetBundle: WidgetBundle {
    var body: some Widget {
        JokeWidget()
        JokeWidgetLiveActivity()
    }
}
