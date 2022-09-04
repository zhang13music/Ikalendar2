//
//  SalmonRotation.swift
//  Ikalendar2
//
//  Copyright (c) 2022 TIANWEI ZHANG. All rights reserved.
//

import Foundation

/// Data model for the salmon run rotation.
struct SalmonRotation: Rotation, Identifiable, Equatable {
  var id: String {
    "\(startTime.timeIntervalSince1970)-\(stage?.name ?? "nil")"
  }

  let startTime: Date
  let endTime: Date
  let stage: SalmonStage?
  let weapons: [SalmonWeapon]?
  var rewardGear: SalmonApparel?
  let grizzcoWeapon: GrizzcoWeapon?

  // MARK: Lifecycle

  init(
    startTime: Date,
    endTime: Date,
    stage: SalmonStage? = nil,
    weapons: [SalmonWeapon]? = nil,
    rewardGear: SalmonApparel? = nil,
    grizzcoWeapon: GrizzcoWeapon? = nil)
  {
    self.startTime = startTime
    self.endTime = endTime
    self.stage = stage
    self.weapons = weapons
    self.rewardGear = rewardGear
    self.grizzcoWeapon = grizzcoWeapon
  }

  // MARK: Internal

  /// The equal comparison operator for the SalmonRotation struct.
  /// - Parameters:
  ///   - lhs: The left hand side.
  ///   - rhs: The right hand side.
  /// - Returns: The comparison result.
  static func == (
    lhs: SalmonRotation,
    rhs: SalmonRotation)
    -> Bool
  {
    lhs.id == rhs.id
  }
}
