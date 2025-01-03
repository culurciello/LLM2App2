import Foundation

class NetworkManager: ObservableObject {
    private let apiToken = "a0cf963ad1ef47b78e0380c78021204a"
    private let baseURL = "https://api.football-data.org/v4"
    
    @Published var matchResults: [MatchResult] = []
    @Published var standings: [TeamStanding] = []
    @Published var isLoading = false
    @Published var error: Error?
    
    func fetchLatestMatches() {
        isLoading = true
        let url = "\(baseURL)/teams/86/matches?status=FINISHED&limit=10"
        var request = URLRequest(url: URL(string: url)!)
        request.setValue(apiToken, forHTTPHeaderField: "X-Auth-Token")
        
        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            DispatchQueue.main.async {
                self?.isLoading = false
                if let error = error {
                    self?.error = error
                    return
                }
                
                guard let data = data else { return }
                
                do {
                    let decoder = JSONDecoder()
                    decoder.dateDecodingStrategy = .iso8601
                    let response = try decoder.decode(MatchesResponse.self, from: data)
                    self?.matchResults = response.matches
                } catch {
                    self?.error = error
                }
            }
        }.resume()
    }
    
    func fetchStandings() {
        isLoading = true
        let url = "\(baseURL)/competitions/PD/standings"
        var request = URLRequest(url: URL(string: url)!)
        request.setValue(apiToken, forHTTPHeaderField: "X-Auth-Token")
        
        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            DispatchQueue.main.async {
                self?.isLoading = false
                if let error = error {
                    self?.error = error
                    return
                }
                
                guard let data = data else { return }
                
                do {
                    let decoder = JSONDecoder()
                    let response = try decoder.decode(StandingsResponse.self, from: data)
                    self?.standings = response.standings[0].table
                } catch {
                    self?.error = error
                }
            }
        }.resume()
    }
}

// MARK: - Data Models
struct MatchesResponse: Codable {
    let matches: [MatchResult]
}

struct MatchResult: Codable, Identifiable {
    let id: Int
    let utcDate: Date
    let homeTeam: Team
    let awayTeam: Team
    let score: Score
    
    struct Team: Codable {
        let name: String
    }
    
    struct Score: Codable {
        let fullTime: FullTime
        let winner: String?
        
        struct FullTime: Codable {
            let home: Int?
            let away: Int?
        }
    }
}

struct StandingsResponse: Codable {
    let standings: [Standing]
    
    struct Standing: Codable {
        let table: [TeamStanding]
    }
}

struct TeamStanding: Codable, Identifiable {
    let position: Int
    let team: Team
    let points: Int
    let playedGames: Int
    let won: Int
    let draw: Int
    let lost: Int
    let goalsFor: Int
    let goalsAgainst: Int
    
    var id: Int { position }
    
    struct Team: Codable {
        let name: String
    }
}
