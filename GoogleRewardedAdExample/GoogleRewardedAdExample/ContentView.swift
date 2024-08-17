//
//  ContentView.swift
//  GoogleRewardedAdExample
//
//  Created by Sam Dawes on 8/17/24.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel = ViewModel()
    
    var body: some View {
        ZStack {
            VStack(alignment: .center, spacing: 50) {
                Text("Rewards: \(viewModel.rewardCount)")
                    .font(.title)
                Button(action: {
                    viewModel.playAd()
                }, label: {
                    Text("Play Ad")
                })
                .buttonStyle(BorderedProminentButtonStyle())
                .disabled(viewModel.isLoading)
                .alert("Error", isPresented: $viewModel.showError) {
                    Button("OK", role: .cancel) { }
                } message: {
                    Text("There was an error loading the ad. Please try again later.")
                }
            }
            .padding()
            if viewModel.isLoading {
                ProgressView()
            }
        }
    }
}

extension ContentView {
    class ViewModel: ObservableObject, AdCoordinatorDelegate {
        @Published var isLoading: Bool = false
        @Published var showError: Bool = false
        @Published var rewardCount: Int = 0
        
        private let adCoordinator = AdCoordinator()
        
        init() {
            adCoordinator.delegate = self
        }
        
        @MainActor
        func playAd() {
            Task {
                do {
                    isLoading = true
                    try await adCoordinator.loadAd()
                    isLoading = false
                    adCoordinator.presentAd()
                } catch {
                    isLoading = false
                    showError = true
                }
            }
        }
        
        func rewardSuccessAction() {
            //We can do any action here after the user has successfully received a reward.
            //For example, I am incrementing the reward count and displaying that in the UI.
            rewardCount += 1
        }
        
        func adDidDismiss() {
            //Write anything you want to do here after the ad dismisses.
        }
    }
}

#Preview {
    ContentView()
}
