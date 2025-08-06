//
//  Fish.swift
//  Swimming Fish
//
//  Created by Matt Cadena on 7/26/25.
//
import SwiftUI
import Combine

struct Fish: Identifiable {
    let id = UUID()
    var position: CGPoint
    var velocity: CGVector
    var radius: CGFloat
    var frame: CGRect {
        CGRect(
            x: position.x - radius,
            y: position.y - 10,
            width: radius*2, height:radius*2,
        )
    }
    var imageName: String
    var message: String?
}
