//
//  SettingsAboutView.swift
//  Ikalendar2
//
//  Copyright (c) 2023 TIANWEI ZHANG. All rights reserved.
//

import SimpleHaptics
import StoreKit
import SwiftUI

// MARK: - SettingsAboutView

/// The About page in App Settings.
struct SettingsAboutView: View {
  typealias Scoped = Constants.Styles.Settings.About

  @Environment(\.requestReview) private var requestReview
  @Environment(\.openURL) private var openURL

  @State private var appStoreOverlayPresented = false

  var body: some View {
    List {
      Section {
        rowAppInfo
      }
      .listRowBackground(Color.clear)

      Section(header: Text("Share")) {
        rowShare
      }

      Section(header: Text("Review")) {
        rowRating
        rowLeavingReview
        rowAppStoreOverlay
      }

      Section(header: Text("Contact")) {
        rowDeveloperTwitter
        rowDeveloperEmail
      }

      Section(header: Text("Others")) {
        rowSourceCode
        rowPrivacyPolicy
      }
    }
    .navigationTitle("About")
    .navigationBarTitleDisplayMode(.inline)
    .listStyle(.insetGrouped)
  }

  // MARK: - Icon Section

  private var rowAppInfo: some View {
    var appIconImage: some View {
      Image(IkaAppIcon.defaultIcon.getImageName(.mid))
        .antialiased(true)
        .resizable()
        .scaledToFit()
        .frame(
          width: IkaAppIcon.DisplayMode.mid.sideLen,
          height: IkaAppIcon.DisplayMode.mid.sideLen)
        .clipShape(
          IkaAppIcon.DisplayMode.mid.clipShape)
        .overlay(
          IkaAppIcon.DisplayMode.mid.clipShape
            .stroke(Scoped.STROKE_COLOR, lineWidth: Scoped.STROKE_LINE_WIDTH)
            .opacity(Scoped.STROKE_OPACITY))
        .shadow(radius: Constants.Styles.Global.SHADOW_RADIUS)
    }

    var appIconTitle: some View {
      let title = Constants.Keys.BundleInfo.APP_DISPLAY_NAME
      let text =
        Text(title)
          .font(Scoped.APP_ICON_TITLE_FONT)
          .fontWeight(Scoped.APP_ICON_TITLE_FONT_WEIGHT)
          .foregroundColor(.accentColor)
      return text
    }

    var appIconSubtitle: some View {
      let versionNumber = Constants.Keys.BundleInfo.APP_VERSION
      let buildNumber = Constants.Keys.BundleInfo.APP_BUILD
      let subtitle = "Version \(versionNumber) (\(buildNumber))"
      let text =
        Text(subtitle)
          .font(Scoped.APP_ICON_SUBTITLE_FONT)
          .fontWeight(Scoped.APP_ICON_SUBTITLE_FONT_WEIGHT)
          .foregroundColor(.secondary)
      return text
    }

    return
      VStack(alignment: .center) {
        appIconImage
        appIconTitle
        appIconSubtitle
      }
      .hAlignment(.center)
  }

  // MARK: - Share Section

  private var rowShare: some View {
    // NOTE: could not find error handling for invalid URL ShareLink as of iOS 16
    // NOTE: could not find a way to trigger haptics when tapped ShareLink as of iOS 16
    let shareURL = URL(string: Constants.Keys.URL.APP_STORE_PAGE_US)!

    return
      ShareLink(item: shareURL) {
        Label {
          Text("Share ikalendar2")
            .foregroundColor(.primary)
        }
        icon: {
          Image(systemName: Scoped.SHARE_SFSYMBOL)
        }
      }
  }

  // MARK: - Review Section

  private var rowRating: some View {
    Button {
      SimpleHaptics.generateTask(.selection)
      Task { await requestReview() }
    } label: {
      Label {
        Text("Rate ikalendar2")
          .foregroundColor(.primary)
      }
      icon: {
        Image(systemName: Scoped.RATING_SFSYMBOL)
      }
    }
  }

  private var rowLeavingReview: some View {
    Button {
      guard let url = URL(string: Constants.Keys.URL.APP_STORE_REVIEW) else { return }
      openURL(url)
    } label: {
      Label {
        Text("Leave a Review")
          .foregroundColor(.primary)
      }
      icon: {
        Image(systemName: Scoped.REVIEW_SFSYMBOL)
      }
    }
  }

  private var rowAppStoreOverlay: some View {
    Button {
      SimpleHaptics.generateTask(.selection)
      appStoreOverlayPresented.toggle()
    } label: {
      Label {
        Text("View ikalendar2 on the App Store")
          .foregroundColor(.primary)
      }
      icon: {
        Image(systemName: Scoped.VIEW_ON_APP_STORE_SFSYMBOL)
      }
    }
    .appStoreOverlay(isPresented: $appStoreOverlayPresented) {
      SKOverlay.AppConfiguration(
        appIdentifier: Constants.Keys.BundleInfo.APP_STORE_IDENTIFIER,
        position: .bottom)
    }
  }

  // MARK: - Contact Section

  private var rowDeveloperTwitter: some View {
    let twitterURLString = Constants.Keys.URL.DEVELOPER_TWITTER
    let twitterHandle = twitterURLString
      .shortenedURL(base: Constants.Keys.URL.TWITTER_BASE, newPrefix: "@")!

    return
      Button {
        guard let url = URL(string: twitterURLString) else { return }
        openURL(url)
      } label: {
        HStack {
          Label {
            Text("Developer's Twitter")
              .foregroundColor(.primary)
          }
          icon: {
            Image(Scoped.TWITTER_ICON_NAME)
              .antialiased(true)
              .resizable()
              .scaledToFit()
              .frame(width: Scoped.TWITTER_ICON_SIDE_LEN)
          }

          Spacer()

          Text(twitterHandle)
            .foregroundColor(.secondary)
        }
      }
  }

  private var rowDeveloperEmail: some View {
    Button {
      guard let url = URL(string: Constants.Keys.URL.DEVELOPER_EMAIL) else { return }
      openURL(url)
    } label: {
      Label {
        Text("Feedback Email")
          .foregroundColor(.primary)
      }
      icon: {
        Image(systemName: Scoped.EMAIL_SFSYMBOL)
      }
    }
  }

  // MARK: - Others Section

  private var rowSourceCode: some View {
    Button {
      guard let url = URL(string: Constants.Keys.URL.SOURCE_CODE_REPO) else { return }
      openURL(url)
    } label: {
      HStack {
        Label {
          Text("Source Code")
            .foregroundColor(.primary)
        }
        icon: {
          Image(systemName: Scoped.SOURCE_CODE_SFSYMBOL)
        }

        Spacer()

        Constants.Styles.Global.EXTERNAL_LINK_JUMP_ICON
      }
    }
  }

  private var rowPrivacyPolicy: some View {
    Button {
      guard let url = URL(string: Constants.Keys.URL.PRIVACY_POLICY) else { return }
      openURL(url)
    } label: {
      HStack {
        Label {
          Text("Privacy Policy")
            .foregroundColor(.primary)
        }
        icon: {
          Image(systemName: Scoped.PRIVACY_POLICY_SFSYMBOL)
        }

        Spacer()

        Constants.Styles.Global.EXTERNAL_LINK_JUMP_ICON
      }
    }
  }

}

// MARK: - SettingsAboutView_Previews

struct SettingsAboutView_Previews: PreviewProvider {
  static var previews: some View {
    Group {
      SettingsAboutView()
        .preferredColorScheme(.dark)
    }
  }
}
