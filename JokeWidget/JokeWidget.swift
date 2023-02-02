import WidgetKit
import SwiftUI
import Foundation

struct Provider: TimelineProvider {
    @AppStorage("refreshInterval") var refreshInterval: Int = 600
    
    func placeholder(in context: Context) -> JokeEntry {
        JokeEntry(date: Date(), joke: "Loading...")
    }

    func getSnapshot(in context: Context, completion: @escaping (JokeEntry) -> ()) {
        let entry = JokeEntry(date: Date(), joke: "Loading...")
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<JokeEntry>) -> ()) {
        var entries: [JokeEntry] = []
        
        let url = URL(string: "https://icanhazdadjoke.com/slack")!
        
        let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
            guard let data = data else { return }
            
            let json = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
            let jokes = json["attachments"] as! [[String: Any]]
            for joke in jokes {
                let text = joke["text"] as! String
                let jokeEntry = JokeEntry(date: Date(), joke: text)
                entries.append(jokeEntry)
            }
            let timeline = Timeline(entries: entries, policy: .after(Date().addingTimeInterval(Double(self.refreshInterval))))
            completion(timeline)
        }
        task.resume()
    }
}

struct JokeEntry: TimelineEntry {
    let date: Date
    let joke: String
}

struct JokeWidgetEntryView : View {
    var entry: JokeEntry

    var body: some View {
        Text(entry.joke)
            .padding()
    }
}

struct JokeWidget: Widget {
    let kind: String = "JokeWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider(refreshInterval: 600)) { entry in
            JokeWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("My Joke Widget")
        .description("This is a widget that displays random jokes.")
        .supportedFamilies([.systemMedium, .systemLarge])
    }
}

struct JokeWidget_Previews: PreviewProvider {
    static var previews: some View {
        JokeWidgetEntryView(entry: JokeEntry(date: Date(), joke: "Why don't scientists trust atoms? Because they make up everything."))
            .previewContext(WidgetPreviewContext(family: .systemMedium))
        JokeWidgetEntryView(entry: JokeEntry(date: Date(), joke: "Why don't scientists trust atoms? Because they make up everything."))
            .previewContext(WidgetPreviewContext(family: .systemLarge))
    }
}
