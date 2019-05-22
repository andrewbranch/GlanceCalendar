import Cocoa

class VibrantView: NSView {
    public var vibrant = true
    override var allowsVibrancy: Bool {
        get {
            return vibrant
        }
    }
}
