//
//  AutoLoadingOverlay.swift
//  Ikalendar2
//
//  Copyright (c) 2023 TIANWEI ZHANG. All rights reserved.
//

import SwiftUI

// MARK: - AutoLoadingOverlay

struct AutoLoadingOverlay: View {
  typealias Scoped = Constants.Style.Overlay.AutoLoading

  var autoLoadStatus: IkaCatalog.AutoLoadStatus

  var body: some View {
    Image(systemName: iconName)
      .foregroundColor(.white)
      .font(Scoped.SFSYMBOL_FONT)
      .frame(
        width: Scoped.FRAME_SIDE,
        height: Scoped.FRAME_SIDE)
      .background(.thinMaterial)
      .cornerRadius(Scoped.FRAME_CORNER_RADIUS)
      .opacity(autoLoadStatus == .idle ? 0 : 1)
      .padding()
      .animation(
        Constants.Config.Animation.appDefault,
        value: autoLoadStatus)
  }

  private var iconName: String {
    switch autoLoadStatus {
    case .autoLoading:
      return Scoped.LOADING_SFSYMBOL
    case .autoLoaded(let loadedStatus):
      switch loadedStatus {
      case .success:
        return Scoped.LOADED_SUCCESS_SFSYMBOL
      case .failure:
        return Scoped.LOADED_FAILURE_SFSYMBOL
      }
    case .idle:
      return Scoped.REGULAR_SFSYMBOL
    }
  }
}

// MARK: - AutoLoadingOverlay_Previews

struct AutoLoadingOverlay_Previews: PreviewProvider {
  static var previews: some View {
    AutoLoadingOverlay(autoLoadStatus: .autoLoading)
  }
}
