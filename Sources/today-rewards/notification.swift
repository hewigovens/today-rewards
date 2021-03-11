import Foundation

func notify(title: String, message: String) {

    let source = "display notification \"\(message)\" with title \"\(title)\""
    let task = Process()
    task.launchPath = "/usr/bin/osascript"
    task.arguments = ["-e", source]
    task.launch()
}
