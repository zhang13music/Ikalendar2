//
//  CarouselColumn.swift
//  Ikalendar2
//
//  Copyright (c) 2023 TIANWEI ZHANG. All rights reserved.
//

import SwiftUI

// MARK: - CarouselColumn

struct CarouselColumn: View {
  typealias Scoped = Constants.Style.Carousel.Column

  @EnvironmentObject private var ikaInterfaceOrientationPublisher: IkaInterfaceOrientationPublisher
  private var ifPortrait: Bool { ikaInterfaceOrientationPublisher.currentOrientation.isPortrait }

  let gameMode: GameMode
  let battleMode: BattleMode

  private var listVOffsetFactor: CGFloat {
    ifPortrait
      ? Scoped.LIST_OFFSET_V_FACTOR_PORTRAIT
      : Scoped.LIST_OFFSET_V_FACTOR_LANDSCAPE }

  private var modeIconSizeFactor: CGFloat { listVOffsetFactor * Scoped.MODE_ICON_SIZE_FACTOR }

  private var maskGradientDensity: Int {
    ifPortrait
      ? Scoped.MASK_GRADIENT_DENSITY_PORTRAIT
      : Scoped.MASK_GRADIENT_DENSITY_LANDSCAPE }

  private var maskGradient: Gradient {
    .init(
      colors:
      (0 ..< maskGradientDensity)
        .map { $0 == 0
          ? Color.primary.opacity(0)
          : Color.primary }) }

  private var rotationList: some View {
    Group {
      switch gameMode {
      case .battle:
        BattleRotationList(specifiedBattleMode: battleMode)
      default:
        SalmonRotationList()
      }
    }
  }

  var body: some View {
    GeometryReader { geo in
      ZStack {
        VStack {
          Spacer()
            .frame(height: geo.size.height * listVOffsetFactor)

          rotationList
            .mask(
              LinearGradient(
                gradient: maskGradient,
                startPoint: .top,
                endPoint: .bottom))
        }

        ModeIconStamp(
          iconSize: geo.size.height * modeIconSizeFactor,
          gameModeSelection: gameMode,
          battleModeSelection: battleMode)
          .vAlignment(.top)
      }
    }
  }

  // MARK: Lifecycle

  init(
    gameMode: GameMode,
    battleMode: BattleMode = .gachi)
  {
    self.gameMode = gameMode
    self.battleMode = battleMode
  }
}
