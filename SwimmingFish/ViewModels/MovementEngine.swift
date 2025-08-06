//
//  MovementEngine.swift
//  Swimming Fish
//
//  Created by Matt Cadena on 7/26/25.
//

import Combine
import SwiftUI

class MovementEngine: ObservableObject {
    @Published var fish: [Fish] = []
    private var displayLink: CADisplayLink?
    private var lastTime: CFTimeInterval = 0
    private var bounds = CGRect.zero

    init(bounds: CGRect) {
        self.fish = fish
    }

    func setBounds(_ rect: CGRect) {
        bounds = rect
        if fish.isEmpty { setupFish() }
    }

    func setupFish() {
        let nemoRadius: CGFloat = 70.0
        let nemoPosition = CGPoint(
            x: CGFloat.random(in: nemoRadius...bounds.width - nemoRadius),
            y: CGFloat.random(in: nemoRadius...bounds.height - nemoRadius),
        )
        let fastestSpeed: CGFloat = 40.0
        let slowestSpeed: CGFloat = 25.0

        let nemoVelocity = CGVector(
            dx: [
                CGFloat.random(in: -fastestSpeed...(-slowestSpeed)),
                CGFloat.random(in: slowestSpeed...fastestSpeed),
            ].randomElement()!,
            dy: [
                CGFloat.random(in: -fastestSpeed...(-slowestSpeed)),
                CGFloat.random(in: slowestSpeed...fastestSpeed),
            ].randomElement()!,
        )
        let squishRadius: CGFloat = 80.0
        let squishPosition = CGPoint(
            x: CGFloat.random(in: squishRadius...bounds.width - squishRadius),
            y: CGFloat.random(in: squishRadius...bounds.height - squishRadius),
        )
        let squishVelocity = CGVector(
            dx: [
                CGFloat.random(in: -fastestSpeed...(-slowestSpeed)),
                CGFloat.random(in: slowestSpeed...fastestSpeed),
            ].randomElement()!,
            dy: [
                CGFloat.random(in: -fastestSpeed...(-slowestSpeed)),
                CGFloat.random(in: slowestSpeed...fastestSpeed),
            ].randomElement()!,
        )

        fish = [
            Fish(
                position: nemoPosition,
                velocity: nemoVelocity,
                radius: nemoRadius,
                imageName: "nemo1",
                message: "hi squish"
            ),
            Fish(
                position: squishPosition,
                velocity: squishVelocity,
                radius: squishRadius,
                imageName: "squish1",
                message: "hi nemo",
            ),
        ]
    }

    func start() {
        displayLink = CADisplayLink(target: self, selector: #selector(update))
        displayLink?.add(to: .main, forMode: .default)
    }

    @objc private func update(link: CADisplayLink) {
        let dt = lastTime == 0 ? 0 : link.timestamp - lastTime
        lastTime = link.timestamp
        tick(dt)
    }

    private func tick(_ dt: TimeInterval) {
        guard dt > 0 else { return }

        for i in fish.indices {
            var f = fish[i]
            f.position.x += f.velocity.dx * CGFloat(dt)
            f.position.y += f.velocity.dy * CGFloat(dt)

            if f.frame.minX <= bounds.minX || f.frame.maxX >= bounds.maxX {
                f.velocity.dx *= -1
                toggleImage(&f)
            }
            if f.frame.minY <= bounds.minY || f.frame.maxY >= bounds.maxY {
                f.velocity.dy *= -1
            }
            fish[i] = f
        }
    }

    func invert(_ id: UUID) {
        guard let i = fish.firstIndex(where: { $0.id == id }) else { return }
        fish[i].velocity.dx *= -1
        fish[i].velocity.dy *= -1
        toggleImage(&fish[i])
    }

    private func toggleImage(_ f: inout Fish) {
        if f.imageName == "nemo1" && f.velocity.dx < 0 {
            f.imageName = "nemo2"
        } else if f.imageName == "nemo2" && f.velocity.dx > 0 {
            f.imageName = "nemo1"
        }
    }

    func stop() {
        displayLink?.invalidate()
        displayLink = nil
        lastTime = 0
    }
    
    func pause() {
        displayLink?.isPaused = true
    }
    
    func resume() {
        displayLink?.isPaused = false
    }
}
