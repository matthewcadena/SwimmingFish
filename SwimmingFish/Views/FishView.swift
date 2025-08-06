import Combine
//
//  FishView.swift
//  Swimming Fish
//
//  Created by Matt Cadena on 7/26/25.
//
import SwiftUI

struct FishView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var rvm = RoomViewModel()
    @StateObject private var engine = MovementEngine(
        bounds: .zero
    )

    var roomCode: String
    var isNemo: Bool
    var isCreator: Bool

    var body: some View {

        GeometryReader { geo in
            ZStack {
                Image("0039")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()

                ForEach(engine.fish) { f in
                    Image(f.imageName).resizable()
                        .frame(width: f.radius * 2, height: f.radius * 2)
                        .position(f.position)
                        .onTapGesture {
                            engine.invert(f.id)
                        }
                    Text(
                        f.imageName == "nemo1" || f.imageName == "nemo2"
                            ? rvm.nemoMessage : rvm.squishMessage
                    )
                    .font(.caption)
                    .position(x: f.position.x - 5, y: f.position.y - f.radius)
                }

                VStack {
                    HStack {
                        Text("room: \(roomCode)")
                            .font(.caption)
                        TextField(
                            "your message",
                            text: isNemo
                                ? $rvm.nemoMessage : $rvm.squishMessage,
                            onCommit: {
                                let text =
                                    isNemo
                                    ? rvm.nemoMessage
                                    : rvm.squishMessage
                                rvm.updateMessage(
                                    code: roomCode,
                                    nemoMessageUpdate: isNemo,
                                    message: text
                                )
                            }
                        )
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .frame(width: 200)
                        Spacer()
                    }
                    .padding()
                    .background(Color.black.opacity(0.3))

                    Spacer()

                }
                .onAppear {
                    if isCreator {
                        rvm.createRoom(code: roomCode, asNemo: isNemo)
                    } else {
                        rvm.joinRoom(code: roomCode, asNemo: isNemo)
                    }
                    engine.setBounds(UIScreen.main.bounds)
                    engine.start()
                }
                .onDisappear {
                    engine.stop()
                    rvm.stopListening()
                }
            }
        }

    }
}
