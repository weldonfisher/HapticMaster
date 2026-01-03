import Foundation
import Network
import Combine

class WebServer: ObservableObject {
    static let shared = WebServer()
    private var listener: NWListener?
    private let port: NWEndpoint.Port = 3000
    
    // UI State
    @Published var status: String = "Initializing..."
    @Published var isConnected: Bool = false
    @Published var lastSignalTime: Date? = nil
    
    // Helper for UI formatting
    var statusColor: String { isConnected ? "green" : "red" }
    
    func start() {
        do {
            let parameters = NWParameters.tcp
            listener = try NWListener(using: parameters, on: port)
            
            listener?.stateUpdateHandler = { state in
                DispatchQueue.main.async {
                    switch state {
                    case .ready:
                        self.status = "Listening on Port \(self.port)"
                        self.isConnected = true
                        print("Server ready on port \(self.port)")
                    case .failed(let error):
                        self.status = "Failed: \(error.localizedDescription)"
                        self.isConnected = false
                        print("Server failed: \(error)")
                    case .waiting(let error):
                         self.status = "Waiting: \(error.localizedDescription)"
                         self.isConnected = false
                    default:
                        self.isConnected = false
                    }
                }
            }
            
            listener?.newConnectionHandler = { connection in
                connection.start(queue: .global())
                self.handleConnection(connection)
            }
            
            listener?.start(queue: .global())
        } catch {
            print("Failed to create listener: \(error)")
            DispatchQueue.main.async {
                self.status = "Error starting server"
                self.isConnected = false
            }
        }
    }
    
    func stop() {
        listener?.cancel()
        DispatchQueue.main.async {
            self.status = "Stopped"
            self.isConnected = false
        }
    }
    
    private func handleConnection(_ connection: NWConnection) {
        connection.receive(minimumIncompleteLength: 1, maximumLength: 65536) { data, _, isComplete, error in
            if let data = data, let message = String(data: data, encoding: .utf8) {
                // Update Last Signal on Main Thread
                DispatchQueue.main.async {
                    self.lastSignalTime = Date()
                }
                
                if let bodyRange = message.range(of: "\r\n\r\n") {
                    let bodyString = String(message[bodyRange.upperBound...])
                    self.processJson(bodyString)
                }
                
                let response = "HTTP/1.1 200 OK\r\nContent-Length: 2\r\n\r\nok"
                connection.send(content: response.data(using: .utf8), completion: .contentProcessed({ _ in
                    connection.cancel()
                }))
            }
        }
    }
    
    private func processJson(_ jsonString: String) {
        if UserDefaults.standard.bool(forKey: "allowWebHaptics") == false {
            print("Web ignored (User Disabled)")
            return
        }
        
        guard let data = jsonString.data(using: .utf8) else { return }
        
        do {
            if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                if let pattern = json["pattern"] as? String {
                    HapticEngine.shared.playPattern(pattern)
                } else {
                    HapticEngine.shared.playPattern("single")
                }
            }
        } catch {
            print("JSON Error: \(error)")
        }
    }
}
