//
//  BattleRotationCell.swift
//  Ikalendar2
//
//  Copyright (c) 2023 TIANWEI ZHANG. All rights reserved.
//

import SwiftUI

// MARK: - BattleRotationCell

struct BattleRotationCell: View {
  enum CellType {
    case primary
    case secondary
  }

  let type: CellType
  let rotation: BattleRotation
  let rowWidth: CGFloat

  @Namespace var ruleIcon
  @Namespace var ruleTitle
  @Namespace var stageA
  @Namespace var stageB

  var body: some View {
    switch type {
    case .primary:
      BattleRotationCellPrimary(
        rotation: rotation,
        rowWidth: rowWidth,
        animationNamespaces:
        .init(
          ruleIcon: ruleIcon,
          ruleTitle: ruleTitle,
          stageA: stageA,
          stageB: stageB))
    case .secondary:
      BattleRotationCellSecondary(
        rotation: rotation,
        rowWidth: rowWidth,
        animationNamespaces:
        .init(
          ruleIcon: ruleIcon,
          ruleTitle: ruleTitle,
          stageA: stageA,
          stageB: stageB))
    }
  }
}

// MARK: - BattleRotationCellPrimary

/// The primary version of a cell component for the battle rotation that takes
/// all the space in the list content.
struct BattleRotationCellPrimary: View {
  typealias Scoped = Constants.Style.Rotation.Battle.Cell.Primary

  @Environment(\.horizontalSizeClass) private var horizontalSizeClass

  @EnvironmentObject private var ikaTimePublisher: IkaTimePublisher

  let rotation: BattleRotation
  let rowWidth: CGFloat
  let animationNamespaces: Constants.Namespace.Battle

  private var isHorizontalCompact: Bool { horizontalSizeClass == .compact }

  var body: some View {
    VStack(spacing: Scoped.CELL_SPACING_V) {
      HStack(alignment: .center) {
        ruleSection
        Spacer()
        remainingTimeSection
      }

      if rotation.isCurrent()
      {
        ProgressView(
          value: min(ikaTimePublisher.currentTime, rotation.endTime) - rotation.startTime,
          total: rotation.endTime - rotation.startTime)
          .padding(.bottom, Scoped.PROGRESS_BAR_PADDING_BOTTOM)
          .tint(.accentColor)
      }

      // MARK: Stage Section

      HStack {
        BattleRotationStageCardPrimary(
          rotation: rotation,
          stageSelection: .stageA)
          .matchedGeometryEffect(
            id: rotation.id,
            in: animationNamespaces.stageA)
        BattleRotationStageCardPrimary(
          rotation: rotation,
          stageSelection: .stageB)
          .matchedGeometryEffect(
            id: rotation.id,
            in: animationNamespaces.stageB)
      }
    }
    .padding(.top, Scoped.CELL_PADDING_TOP)
    .padding(.bottom, Scoped.CELL_PADDING_BOTTOM)
  }

  // MARK: Rule Section

  private var ruleSection: some View {
    HStack(
      alignment: .center,
      spacing: Scoped.RULE_SECTION_SPACING)
    {
      // Rule icon
      Image(rotation.rule.imgFilnMid)
        .antialiased(true)
        .resizable()
        .matchedGeometryEffect(
          id: rotation.id,
          in: animationNamespaces.ruleIcon)
        .scaledToFit()
        .shadow(radius: Constants.Style.Global.SHADOW_RADIUS)
        .layoutPriority(1)

      // Rule title
      BattlePrimaryRuleTitleTextLayout {
        // actual rule title
        BattleRotationCellPrimaryRuleTitleText(battleRule: rotation.rule)

        // all other possible rule titles for the layout to compute ideal size
        ForEach(BattleRule.allCases) { rule in
          BattleRotationCellPrimaryRuleTitleText(battleRule: rule)
        }
      }
      .matchedGeometryEffect(
        id: rotation.id,
        in: animationNamespaces.ruleTitle)
      .padding(.vertical, Scoped.RULE_TITLE_PADDING_V)
    }
    .frame(
      width: rowWidth * Scoped.RULE_SECTION_WIDTH_RATIO,
      height: rowWidth * Scoped.RULE_SECTION_HEIGHT_RATIO,
      alignment: .leading)
    .hAlignment(.leading)
  }

  // MARK: Remaining Time Section

  private var remainingTimeSection: some View {
    Text(ikaTimePublisher.currentTime.toTimeRemainingStringKey(until: rotation.endTime))
      .scaledLimitedLine()
      .foregroundColor(.secondary)
      .ikaFont(
        .ika2,
        size: Scoped.REMAINING_TIME_FONT_SIZE,
        relativeTo: Scoped.REMAINING_TIME_TEXT_STYLE_RELATIVE_TO)
      .frame(
        width: rowWidth * Scoped.REMAINING_TIME_SECTION_WIDTH_RATIO,
        alignment: .trailing)
  }
}

// MARK: - BattleRotationCellPrimaryRuleTitleText

struct BattleRotationCellPrimaryRuleTitleText: View {
  typealias Scoped = Constants.Style.Rotation.Battle.Cell.Primary

  let battleRule: BattleRule

  var body: some View {
    Text(battleRule.name.localizedStringKey)
      .scaledLimitedLine()
      .ikaFont(
        .ika2,
        size: Scoped.RULE_TITLE_FONT_SIZE_MAX,
        relativeTo: Scoped.RULE_TITLE_TEXT_STYLE_RELATIVE_TO)
  }
}

// MARK: - BattleRotationCellSecondary

/// The secondary version of a cell component for the battle rotation
/// that takes all the space in a list unit.
struct BattleRotationCellSecondary: View {
  typealias Scoped = Constants.Style.Rotation.Battle.Cell.Secondary

  @EnvironmentObject private var ikaPreference: IkaPreference

  let rotation: BattleRotation
  let rowWidth: CGFloat
  let animationNamespaces: Constants.Namespace.Battle

  var body: some View {
    HStack {
      // MARK: Rule section

      VStack(spacing: Scoped.RULE_SECTION_SPACING) {
        // Rule icon
        Image(rotation.rule.imgFilnMid)
          .antialiased(true)
          .resizable()
          .matchedGeometryEffect(
            id: rotation.id,
            in: animationNamespaces.ruleIcon)
          .scaledToFit()
          .shadow(radius: Constants.Style.Global.SHADOW_RADIUS)
          .frame(maxWidth: rowWidth * Scoped.RULE_IMG_MAX_WIDTH)
          .padding(Scoped.RULE_IMG_PADDING)
          .background(Color.tertiarySystemGroupedBackground)
          .cornerRadius(Scoped.RULE_IMG_FRAME_CORNER_RADIUS)

        // Rule title
        Text(rotation.rule.name.localizedStringKey)
          .matchedGeometryEffect(
            id: rotation.id,
            in: animationNamespaces.ruleTitle)
          .scaledLimitedLine()
          .ikaFont(
            .ika2,
            size: Scoped.RULE_FONT_SIZE,
            relativeTo: .body)

          .frame(height: Scoped.RULE_TITLE_HEIGHT)
      }
      .frame(maxWidth: rowWidth * Scoped.RULE_SECTION_WIDTH_RATIO)
      .padding(.trailing, Scoped.RULE_SECTION_PADDING_TRAILING)

      // MARK: Stage Section

      BattleSecondaryStagesLayout {
        BattleRotationStageCardSecondary(
          rotation: rotation,
          stageSelection: .stageA)
          .matchedGeometryEffect(
            id: rotation.id,
            in: animationNamespaces.stageA)

        BattleRotationStageCardSecondary(
          rotation: rotation,
          stageSelection: .stageB)
          .matchedGeometryEffect(
            id: rotation.id,
            in: animationNamespaces.stageB)
      }
    }
  }
}

// MARK: - BattleRotationCell_Previews

struct BattleRotationCell_Previews: PreviewProvider {
  static var previews: some View {
    @Namespace var ruleIcon
    @Namespace var ruleTitle
    @Namespace var stageA
    @Namespace var stageB

    GeometryReader { geo in
      List {
        Section {
          BattleRotationCellPrimary(
            rotation: IkaMockData.getBattleRotation(
              rule: .towerControl,
              rawStartTime: Date()),
            rowWidth: geo.size.width,
            animationNamespaces:
            .init(
              ruleIcon: ruleIcon,
              ruleTitle: ruleTitle,
              stageA: stageA,
              stageB: stageB))
        }
        Section {
          BattleRotationCellSecondary(
            rotation: IkaMockData.getBattleRotation(
              rule: .clamBlitz,
              rawStartTime: Date()),
            rowWidth: geo.size.width,
            animationNamespaces:
            .init(
              ruleIcon: ruleIcon,
              ruleTitle: ruleTitle,
              stageA: stageA,
              stageB: stageB))
        }
      }
      .listStyle(InsetGroupedListStyle())
    }
  }
}
