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
//  @Environment(\.requestReview) private var requestReview

  typealias Scoped = Constants.Styles.Settings.About

  @Environment(\.openURL) private var openURL

  @State private var appStoreOverlayPresented = false

  var body: some View {
    Form {
      Section(header: Spacer()) {
        appIconContent
      }
      .listRowBackground(Color.clear)

      Section(header: Text("Share")) {
        rowShare
      }

      Section(header: Text("Contact")) {
        rowDeveloperTwitter
        rowDeveloperEmail
      }

      Section(header: Text("Review")) {
        rowRating
        rowLeavingReview
        rowAppStoreOverlay
      }

      Section(header: Text("Others")) {
        rowSourceCode
        rowPrivacyPolicy
      }
    }
    .navigationTitle("About")
    .navigationBarTitleDisplayMode(.inline)
  }

  // MARK: - Icon Section

  private var appIconContent: some View {
    HStack {
      Spacer()
      appIconLabel
      Spacer()
    }
  }

  private var appIconLabel: some View {
    var appIconImage: some View {
      Image(uiImage: UIImage(named: Scoped.APP_ICON_NAME) ?? UIImage())
        .antialiased(true)
        .resizable()
        .scaledToFit()
        .frame(width: Scoped.APP_ICON_SIDE_LEN, height: Scoped.APP_ICON_SIDE_LEN)
        .cornerRadius(Scoped.APP_ICON_CORNER_RADIUS)
    }

    var appIconTitle: some View {
      let title = Constants.Keys.appDisplayName
      let text =
        Text(title)
          .font(Scoped.APP_ICON_TITLE_FONT)
          .fontWeight(Scoped.APP_ICON_TITLE_FONT_WEIGHT)
          .foregroundColor(.accentColor)
      return text
    }

    var appIconSubtitle: some View {
      let versionNumber = Constants.Keys.appVersion
      let buildNumber = Constants.Keys.appBuildNumber
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

  // MARK: - Contact Section

  private var rowDeveloperTwitter: some View {
    let twitterURLString = Constants.Keys.URL.DEVELOPER_TWITTER
    let twitterHandle =
      twitterURLString.replacingOccurrences(
        of: "https://twitter.com/",
        with: "@")

    return
      Button {
        SimpleHaptics.generateTask(.selection)
        if let url = URL(string: twitterURLString) {
          openURL(url)
        }
      } label: {
        Label {
          HStack {
            Text("Developer's Twitter")
              .foregroundColor(.primary)
            Spacer()
            Text(twitterHandle)
              .foregroundColor(.secondary)
          }
        }
        icon: {
          Image(Scoped.TWITTER_ICON_NAME)
            .antialiased(true)
            .resizable()
            .scaledToFit()
            .frame(width: Scoped.TWITTER_ICON_SIDE_LEN)
        }
      }
  }

  private var rowDeveloperEmail: some View {
    Button {
      SimpleHaptics.generateTask(.selection)
      if let url = URL(string: Constants.Keys.URL.DEVELOPER_EMAIL) {
        openURL(url)
      }
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

  // MARK: - Review Section

  private var rowRating: some View {
    Button {
      SimpleHaptics.generateTask(.selection)
      didTapRate()
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
      SimpleHaptics.generateTask(.selection)
      if let url = URL(string: Constants.Keys.URL.APP_STORE_REVIEW) {
        openURL(url)
      }
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
        appIdentifier: Constants.Keys.appStoreIdentifier,
        position: .bottom)
    }
  }

  // MARK: - Others Section

  private var rowSourceCode: some View {
    Button {
      SimpleHaptics.generateTask(.selection)
      if let url = URL(string: Constants.Keys.URL.SOURCE_CODE_REPO) {
        openURL(url)
      }
    } label: {
      Label {
        Text("Source Code")
          .foregroundColor(.primary)
      }
      icon: {
        Image(systemName: Scoped.SOURCE_CODE_SFSYMBOL)
      }
    }
  }

  private var rowPrivacyPolicy: some View {
    Button {
      SimpleHaptics.generateTask(.selection)
      if let url = URL(string: Constants.Keys.URL.PRIVACY_POLICY) {
        openURL(url)
      }
    } label: {
      Label {
        Text("Privacy Policy")
          .foregroundColor(.primary)
      }
      icon: {
        Image(systemName: Scoped.PRIVACY_POLICY_SFSYMBOL)
      }
    }
  }

  // MARK: Private

  // MARK: - End Components ↑↑↑

  // Handle the tap on the share button. [Deprecated since iOS 16]
//  func didTapShare() {
//    guard let shareURL = URL(string: Constants.Keys.URL.APP_STORE_PAGE_US) else { return }
//    let activityVC =
//      UIActivityViewController(
//        activityItems: [shareURL],
//        applicationActivities: nil)
//    let keyWindow = UIApplication.shared.windows.filter(\.isKeyWindow).first
//    if var topController = keyWindow?.rootViewController {
//      while let presentedViewController = topController.presentedViewController {
//        topController = presentedViewController
//      }
//      topController.present(
//        activityVC,
//        animated: true,
//        completion: nil)
//    }
//  }

  /// Handle the tap on the rate button.
  private func didTapRate() {
//    requestReview()
    if
      let scene =
      UIApplication.shared.connectedScenes
        .first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene
    {
      SKStoreReviewController.requestReview(in: scene)
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
