//
//  HomeView.swift
//  Swimming Fish
//
//  Created by Matt Cadena on 7/27/25.
//

import SwiftUI

struct HomeView: View {
    @State private var joinCode = ""
    @State private var navigateToRoom = false
    @State private var roomCode = ""
    @State private var isNemo = false
    @State private var isCreator = false
    
    var body: some View {
        VStack(spacing: 20) {
            Text("two fishes :)")
                .font(.largeTitle)
                .padding(.bottom, 40)
            
            Button("create room") {
                roomCode = String((0..<6).map { _ in "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789".randomElement()! })
                isNemo = true
                isCreator = true
                navigateToRoom = true
            }
            .buttonStyle(.borderedProminent)
            
            TextField("enter room code", text: $joinCode)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .frame(width: 200)
            
            Button("join room as nemo") {
                roomCode = joinCode.uppercased()
                isNemo = true
                isCreator = false
                navigateToRoom = true
            }
            .buttonStyle(.bordered)
            
            Button("join room as squish") {
                roomCode = joinCode.uppercased()
                isNemo = false
                isCreator = false
                navigateToRoom = true
            }
            .buttonStyle(.bordered)
            
            Spacer()
            
        }
        .padding()
        .navigationDestination(isPresented: $navigateToRoom) {
            FishView(roomCode: roomCode, isNemo: isNemo, isCreator: isCreator)
        }
        
    }
}
