//
//  SalmonRotationRow.swift
//  Ikalendar2
//
//  Copyright (c) 2023 TIANWEI ZHANG. All rights reserved.
//

import SwiftUI

// MARK: - SalmonRotationRow

/// A row containing all the information of a salmon rotation.
struct SalmonRotationRow: View {
  @EnvironmentObject private var ikaTimePublisher: IkaTimePublisher

  let rotation: SalmonRotation
  let index: Int
  let rowWidth: CGFloat

  private var rowType: RowType {
    // expired rotations already filtered out, so index will reflect truth
    switch index {
    case 0:
      return rotation.isCurrent() ? .first(.active) : .first(.idle)
    case 1:
      return .second
    default:
      return .other
    }
  }

  var body: some View {
    Section {
      SalmonRotationCell(
        rotation: rotation,
        rowWidth: rowWidth)
    } header: {
      switch rowType {
      case .first,
           .second:
        SalmonRotationHeader(
          rotation: rotation,
          rowType: rowType)

      case .other:
        EmptyView()
      }
    }
  }
}

// MARK: SalmonRotationRow.RowType

extension SalmonRotationRow {
  enum RowType: Equatable {
    typealias Scoped = Constants.Style.Rotation.Header.Salmon

    case first(SalmonCurrentStatus)
    case second
    case other

    enum SalmonCurrentStatus {
      case active
      case idle
    }

    var prefixString: String? {
      switch self {
      case .first(let currentStatus):
        switch currentStatus {
        case .active:
          return Scoped.FIRST_PREFIX_STRINGS.active
        case .idle:
          return Scoped.FIRST_PREFIX_STRINGS.idle
        }

      case .second:
        return Scoped.SECOND_PREFIX_STRING

      case .other:
        return nil
      }
    }
  }
}

// MARK: - SalmonRotationHeader

/// The header of the salmon rotation row.
struct SalmonRotationHeader: View {
  typealias Scoped = Constants.Style.Rotation.Header

  @EnvironmentObject private var ikaTimePublisher: IkaTimePublisher

  let rotation: SalmonRotation
  let rowType: SalmonRotationRow.RowType

  var body: some View {
    HStack {
      // can force unwrap `prefixString` here because .other row type will not have header
      Text(rowType.prefixString!.localizedStringKey)
        .fontIka(
          .ika1,
          size: Scoped.PREFIX_FONT_SIZE,
          relativeTo: .title2)
        .foregroundColor(Color.systemBackground)
        .padding(.horizontal, Scoped.PREFIX_PADDING)
        .background(Color.secondary)
        .cornerRadius(Scoped.PREFIX_FRAME_CORNER_RADIUS)

      Spacer()

      // Time Until String (if first rotation idle)
      if
        case .first(let currentStatus) = rowType,
        currentStatus == .idle
      {
        Text(ikaTimePublisher.currentTime.toTimeUntilString(until: rotation.startTime))
          .scaledLimitedLine()
          .fontIka(
            .ika2,
            size: Scoped.CONTENT_FONT_SIZE,
            relativeTo: .headline)
      }
    }
  }
}

// MARK: - SalmonRotationRow_Previews

struct SalmonRotationRow_Previews: PreviewProvider {
  static var previews: some View {
    SalmonRotationRow(
      rotation: IkaMockData.getSalmonRotation(),
      index: 0,
      rowWidth: 390)
  }
}