//
//  Common.swift
//  Sundial
//
//  Created by Sergei Mikhan on 10/4/17.
//  Copyright © 2017 Netcosports. All rights reserved.
//

import UIKit
import Astrolabe
import RxSwift
import RxCocoa

public protocol Titleable {
  var title: String { get }
}

public protocol Indicatorable {
  var indicatorColor: UIColor { get }
}

public typealias ViewModelable = Titleable & Indicatorable

public protocol Selectable: class {
  var selectedItem: ControlProperty<Int> { get }
}

extension CollectionViewPagerSource: Selectable {
  public var selectedItem: ControlProperty<Int> { return rx.selectedItem }
}

extension CollectionViewReusedPagerSource: Selectable {
  public var selectedItem: ControlProperty<Int> { return rx.selectedItem }
}

public typealias Progress = (pages: ClosedRange<Int>, progress: CGFloat)

extension ClosedRange where Bound == Int {

  var next: ClosedRange<Int> {
    return lowerBound.advanced(by: 1)...upperBound.advanced(by: 1)
  }

}

public enum Anchor {
  case content
  case centered
  case fillEqual
  case equal(size: CGFloat)
  case left(offset: CGFloat)
  case right(offset: CGFloat)
}

public enum DecorationAlignment {
  case top
  case topOffset(variable: Variable<CGFloat>)
}

public enum JumpingPolicy: Equatable {
  case disabled
  case skip(pages: Int)

  public static func == (lhs: JumpingPolicy, rhs: JumpingPolicy) -> Bool {
    switch (lhs, rhs) {
    case (.disabled, .disabled): return true
    case (.skip(let lhs), .skip(let rhs)): return lhs == rhs
    default: return false
    }
  }
}

public struct Settings {
  public var stripHeight: CGFloat
  public var markerHeight: CGFloat
  public var itemMargin: CGFloat
  public var bottomStripSpacing: CGFloat
  public var anchor: Anchor
  public var inset: UIEdgeInsets
  public var alignment: DecorationAlignment
  public var pagesOnScreen: Int {
    willSet {
      assert(newValue > 0, "number of pages on screen should be greater than 0")
    }
  }
  public var jumpingPolicy: JumpingPolicy {
    willSet {
      assert(newValue == .disabled || pagesOnScreen == 1, "jumping policy doesn't support 2+ pages currently")
    }
  }

  public init(stripHeight: CGFloat = 80.0,
              markerHeight: CGFloat = 5.5,
              itemMargin: CGFloat = 12.0,
              bottomStripSpacing: CGFloat = 0.0,
              anchor: Anchor = .centered,
              inset: UIEdgeInsets = .zero,
              alignment: DecorationAlignment = .top,
              pagesOnScreen: Int = 1,
              jumpingPolicy: JumpingPolicy = .disabled) {
    self.stripHeight = stripHeight
    self.markerHeight = markerHeight
    self.itemMargin = itemMargin
    self.bottomStripSpacing = bottomStripSpacing
    self.anchor = anchor
    self.inset = inset
    self.alignment = alignment
    assert(pagesOnScreen > 0, "number of pages on screen should be greater than 0")
    self.pagesOnScreen = pagesOnScreen
    assert(jumpingPolicy == .disabled || pagesOnScreen == 1, "jumping policy doesn't support 2+ pages currently")
    self.jumpingPolicy = jumpingPolicy
  }

}
