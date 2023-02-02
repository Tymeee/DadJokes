//
//  ContentView.swift
//  DadJokes
//
//  Created by E2318556 on 26/1/2566 BE.
//

import Foundation
import SwiftUI

struct ContentView: View {
    @State private var joke: String?
    
    var body: some View {
        VStack(spacing: 30){
            if joke != nil {
                Text("\(joke!)")
            } else {
                Text("Loading...")
            }
            
            
            Button(action: {
                self.loadJoke()
            }) {
                Text("Load new joke")
            }
        }.onAppear(perform: loadJoke)
            .padding(20)
    }
    
    private func loadJoke() {
        var request = URLRequest(url: URL(string: "https://icanhazdadjoke.com/slack")!)
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            guard let data = data else { return }
            
            let decoder = JSONDecoder()
            
            do {
                let apiResponse = try decoder.decode(JokeResponse.self, from: data)
                DispatchQueue.main.async {
                    self.joke = apiResponse.attachments[0].text
                }
            } catch {
                print(error.localizedDescription)
            }
        }.resume()
    }
}

struct JokeResponse: Decodable {
    let attachments: [Joke]
}

struct Joke: Decodable {
    let text: String
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
