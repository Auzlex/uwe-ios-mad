//
//  MarqueeViewModifier.swift
//  Crypto Currency Price Checker
//
//  Created by Charles Edwards on 09/05/2022.
//

import Foundation
import SwiftUI

// https://swiftuirecipes.com/blog/swiftui-marquee

struct SizePreferenceKey: PreferenceKey {
  static var defaultValue: CGSize = .zero

  static func reduce(value: inout CGSize, nextValue: () -> CGSize) {
    value = nextValue()
  }
}

struct MeasureSizeModifier: ViewModifier {
  func body(content: Content) -> some View {
    content.background(GeometryReader { geometry in
      Color.clear.preference(key: SizePreferenceKey.self,
                             value: geometry.size)
    })
  }
}

public struct AnimationObserverModifier<Value: VectorArithmetic>: AnimatableModifier {
  // this is the view property that drives the animation - offset, opacity, etc.
  private let observedValue: Value
  private let onChange: ((Value) -> Void)?
  private let onComplete: (() -> Void)?

  // SwiftUI implicity sets this value as the animation progresses
  public var animatableData: Value {
    didSet {
      notifyProgress()
    }
  }

  public init(for observedValue: Value,
              onChange: ((Value) -> Void)?,
              onComplete: (() -> Void)?) {
    self.observedValue = observedValue
    self.onChange = onChange
    self.onComplete = onComplete
    animatableData = observedValue
  }

  public func body(content: Content) -> some View {
    content
  }

  private func notifyProgress() {
    DispatchQueue.main.async {
      onChange?(animatableData)
      if animatableData == observedValue {
        onComplete?()
      }
    }
  }
}

public extension View {
    func animationObserver<Value: VectorArithmetic>(for value: Value,
                                                    onChange: ((Value) -> Void)? = nil,
                                                    onComplete: (() -> Void)? = nil) -> some View {
      self.modifier(AnimationObserverModifier(for: value,
                                                 onChange: onChange,
                                                 onComplete: onComplete))
    }
}

extension View {
  func measureSize(perform action: @escaping (CGSize) -> Void) -> some View {
    self.modifier(MeasureSizeModifier())
      .onPreferenceChange(SizePreferenceKey.self, perform: action)
  }
}

struct Marquee: ViewModifier {
  let duration: TimeInterval
  let direction: Direction
  let autoreverse: Bool

  @State private var offset = CGFloat.zero
  @State private var parentSize = CGSize.zero
  @State private var contentSize = CGSize.zero

  func body(content: Content) -> some View {
    // measures parent view width
    Color.clear
      .frame(height: 0)
      // measureSize from https://swiftuirecipes.com/blog/getting-size-of-a-view-in-swiftui
      .measureSize { size in
        parentSize = size
        updateAnimation(sizeChanged: true)
      }

    content
      .measureSize { size in
        contentSize = size
        updateAnimation(sizeChanged: true)
      }
      .offset(x: offset)
      // animationObserver from https://swiftuirecipes.com/blog/swiftui-animation-observer
      .animationObserver(for: offset, onComplete: {
        updateAnimation(sizeChanged: false)
      })
  }

  private func updateAnimation(sizeChanged: Bool) {
    if sizeChanged || !autoreverse {
      offset = max(parentSize.width, contentSize.width) * ((direction == .leftToRight) ? -1 : 1)
    }
    withAnimation(.linear(duration: duration)) {
      offset = -offset
    }
  }

  enum Direction {
    case leftToRight, rightToLeft
  }
}

extension View {
  func marquee(duration: TimeInterval,
               direction: Marquee.Direction = .rightToLeft,
               autoreverse: Bool = false) -> some View {
    self.modifier(Marquee(duration: duration,
                          direction: direction,
                          autoreverse: autoreverse))
  }
}

