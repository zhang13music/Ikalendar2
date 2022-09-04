//
//  ModalDismissable.swift
//  Ikalendar2
//
//  Copyright (c) 2022 TIANWEI ZHANG. All rights reserved.
//

import SwiftUI
import UIKit

// MARK: - MbModalHackView

struct MbModalHackView: UIViewControllerRepresentable {
  var dismissable: () -> Bool = { false }

  // MARK: Internal

  class Coordinator: NSObject, UIAdaptivePresentationControllerDelegate {
    var dismissable: () -> Bool = { false }

    // MARK: Lifecycle

    init(dismissable: @escaping () -> Bool) {
      self.dismissable = dismissable
    }

    // MARK: Internal

    func presentationControllerShouldDismiss(_: UIPresentationController) -> Bool {
      dismissable()
    }
  }

  func makeUIViewController(context _: UIViewControllerRepresentableContext<MbModalHackView>)
    -> UIViewController
  {
    UIViewController()
  }

  func updateUIViewController(
    _ uiViewController: UIViewController,
    context: UIViewControllerRepresentableContext<MbModalHackView>)
  {
    rootViewController(of: uiViewController).presentationController?.delegate = context.coordinator
  }

  func makeCoordinator() -> Coordinator {
    Coordinator(dismissable: dismissable)
  }

  // MARK: Private

  private func rootViewController(of uiViewController: UIViewController) -> UIViewController {
    if let parent = uiViewController.parent {
      return rootViewController(of: parent)
    }
    else {
      return uiViewController
    }
  }
}

/// view.allowAutoDismiss(...)
extension View {
  func allowAutoDismiss(_ dismissable: @escaping () -> Bool) -> some View {
    background(MbModalHackView(dismissable: dismissable))
  }
}
