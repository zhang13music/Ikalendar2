//
//  SalmonRotationListView.swift
//  Ikalendar2
//
//  Copyright (c) 2023 TIANWEI ZHANG. All rights reserved.
//

import SwiftUI

// MARK: - SalmonRotationListView

/// The view that displays a list of salmon rotations.
struct SalmonRotationListView: View {
  @EnvironmentObject private var ikaCatalog: IkaCatalog
  @EnvironmentObject private var ikaTimePublisher: IkaTimePublisher

  private var salmonRotations: [SalmonRotation] {
    // filter: display current and future rotations only
    ikaCatalog.salmonRotations.filter { !$0.isExpired() }
  }

  var body: some View {
    GeometryReader { geo in
      List {
        ForEach(
          Array(zip(salmonRotations.indices, salmonRotations)),
          id: \.1)
        { index, rotation in
          SalmonRotationRow(
            rotation: rotation,
            index: index,
            rowWidth: geo.size.width)
            .listRowSeparator(.hidden)
        }
      }
      .listStyle(.insetGrouped)
      .animation(
        .spring(
          response: 0.6,
          dampingFraction: 0.8),
        value: salmonRotations)
      .disabled(ikaCatalog.loadStatus != .loaded)
    }
  }
}

// MARK: - SalmonRotationListView_Previews

struct SalmonRotationListView_Previews: PreviewProvider {
  static var previews: some View {
    SalmonRotationListView()
  }
}