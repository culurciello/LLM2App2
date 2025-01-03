//
//  ContentView.swift
//  LL-windsurf
//
//  Created by Eugenio Culurciello on 1/3/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var networkManager = NetworkManager()
    @State private var showSplash = true
    @State private var showStandings = false
    
    var body: some View {
        Group {
            if showSplash {
                SplashView {
                    withAnimation {
                        showSplash = false
                    }
                }
            } else {
                if showStandings {
                    StandingsView(showStandings: $showStandings)
                        .environmentObject(networkManager)
                } else {
                    ResultsView(showStandings: $showStandings)
                        .environmentObject(networkManager)
                }
            }
        }
    }
}

struct SplashView: View {
    let onComplete: () -> Void
    
    var body: some View {
        ZStack {
            Color(uiColor: .systemBackground).ignoresSafeArea()
            
            Image("logo")
                .resizable()
                .scaledToFit()
                .frame(width: 200)
                .preferredColorScheme(.light) // Force light mode for logo
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                onComplete()
            }
        }
    }
}

struct ResultsView: View {
    @EnvironmentObject var networkManager: NetworkManager
    @Binding var showStandings: Bool
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(uiColor: .systemBackground).ignoresSafeArea()
                
                if networkManager.isLoading {
                    ProgressView()
                } else {
                    ScrollView {
                        LazyVStack(spacing: 16) {
                            ForEach(networkManager.matchResults) { match in
                                MatchResultCard(match: match)
                            }
                        }
                        .padding()
                    }
                }
            }
            .navigationTitle("Latest Results")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Standings") {
                        withAnimation {
                            showStandings = true
                        }
                    }
                    .buttonStyle(PrimaryButtonStyle())
                }
            }
        }
        .onAppear {
            networkManager.fetchLatestMatches()
        }
    }
}

struct MatchResultCard: View {
    let match: MatchResult
    
    var body: some View {
        VStack(spacing: 12) {
            Text(match.utcDate.formatted(date: .abbreviated, time: .shortened))
                .font(.body)
                .foregroundColor(.secondary)
            
            HStack {
                Spacer()
                Text(match.homeTeam.name)
                    .font(.headline)
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.trailing)
                Text("\(match.score.fullTime.home ?? 0)")
                    .font(.title)
                    .foregroundColor(.primary)
                    .padding(.horizontal)
                Text("-")
                    .font(.headline)
                    .foregroundColor(.primary)
                Text("\(match.score.fullTime.away ?? 0)")
                    .font(.title)
                    .foregroundColor(.primary)
                    .padding(.horizontal)
                Text(match.awayTeam.name)
                    .font(.headline)
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.leading)
                Spacer()
            }
        }
        .padding()
        .background(Color(uiColor: .systemGray5))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: Color(uiColor: .systemGray4).opacity(0.1), radius: 2)
    }
}

struct StandingsView: View {
    @EnvironmentObject var networkManager: NetworkManager
    @Binding var showStandings: Bool
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(uiColor: .systemBackground).ignoresSafeArea()
                
                if networkManager.isLoading {
                    ProgressView()
                } else {
                    ScrollView {
                        VStack(spacing: 16) {
                            StandingsHeader()
                            ForEach(networkManager.standings) { standing in
                                StandingRow(standing: standing)
                            }
                        }
                        .padding()
                    }
                }
            }
            .navigationTitle("LaLiga Standings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Results") {
                        withAnimation {
                            showStandings = false
                        }
                    }
                    .buttonStyle(PrimaryButtonStyle())
                }
            }
        }
        .onAppear {
            networkManager.fetchStandings()
        }
    }
}

struct StandingsHeader: View {
    var body: some View {
        HStack {
            Text("#")
                .font(.body)
                .frame(width: 30)
            
            Text("Team")
                .font(.body)
            
            Spacer()
            
            HStack(spacing: 20) {
                Text("MP")
                    .font(.body)
                    .frame(width: 30)
                
                Text("Pts")
                    .font(.body)
                    .frame(width: 30)
            }
        }
        .foregroundColor(.secondary)
        .padding(.horizontal)
    }
}

struct StandingRow: View {
    let standing: TeamStanding
    
    var body: some View {
        HStack {
            Text("\(standing.position)")
                .font(.headline)
                .foregroundColor(.primary)
                .frame(width: 30)
            
            Text(standing.team.name)
                .font(.headline)
                .foregroundColor(.primary)
            
            Spacer()
            
            HStack(spacing: 20) {
                Text("\(standing.playedGames)")
                    .font(.body)
                    .foregroundColor(.primary)
                    .frame(width: 30)
                
                Text("\(standing.points)")
                    .font(.headline)
                    .foregroundColor(.primary)
                    .frame(width: 30)
            }
        }
        .padding()
        .background(Color(uiColor: .systemGray5))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(color: Color(uiColor: .systemGray4).opacity(0.1), radius: 2)
    }
}

#Preview {
    ContentView()
}
