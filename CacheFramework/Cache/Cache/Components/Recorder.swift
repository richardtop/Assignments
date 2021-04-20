import Foundation

public protocol Recorder {
    func record(entry: String?)
}

public struct ConsolePrinter: Recorder {
    public func record(entry: String?) {
        print(entry ?? "")
    }
}
