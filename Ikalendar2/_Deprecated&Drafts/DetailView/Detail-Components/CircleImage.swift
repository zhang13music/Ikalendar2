//
//  CircleImage.swift
//  Ikalendar2
//
//  Copyright (c) 2023 TIANWEI ZHANG. All rights reserved.
//

import SwiftUI

// MARK: - CircleImage

/// A image framed in a circle with a drop shadow effect.
struct CircleImage: View {
  var image: Image

  var body: some View {
    ZStack {
      Rectangle()
        .foregroundColor(.white)
      image
        .resizable()
        .scaledToFill()
    }
    .frame(width: 180, height: 180)
    .clipShape(Circle())
    .overlay(Circle().stroke(Color.white, lineWidth: 4))
    .shadow(radius: 7)
  }
}

// MARK: - CircleImage_Previews

struct CircleImage_Previews: PreviewProvider {
  static var previews: some View {
    CircleImage(image: Image(BattleStage.theReef.imgFilnLarge))
  }
}
