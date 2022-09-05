//
//  RootView.swift
//  Ikalendar2
//
//  Copyright (c) 2022 TIANWEI ZHANG. All rights reserved.
//

import SwiftUI

/// The entry view of the app.
/// Provide an interface for some upfront View-level configurations.
struct RootView: View {
  @Environment(\.colorScheme) var deviceColorScheme

  @EnvironmentObject var ikaStatus: IkaStatus
  @EnvironmentObject var ikaPreference: IkaPreference

  var body: some View {
    MainView()
      .fullScreenCover(isPresented: $ikaStatus.isSettingsPresented) {
        SettingsMainView()
          .environmentObject(ikaStatus)
          .environmentObject(ikaPreference)
          .accentColor(.orange)
      }
  }
}
