import Foundation
import Cocoa
import Carbon

class CarbonKeyHandler: NSObject {
    private var specialKeyHandlers: Dictionary<NSEvent.SpecialKey, () -> Void> = Dictionary()
    private var commandKeyHandlers: Dictionary<String, () -> Void> = Dictionary()
    private let dispatcher = GetEventDispatcherTarget()
    private var events: [EventTypeSpec] = [EventTypeSpec(
        eventClass: OSType(kEventClassKeyboard),
        eventKind: UInt32(kEventRawKeyDown)
    )]

    private override init() {
        super.init()
        InstallEventHandler(
            dispatcher,
            { (handler, eventRef, _) in
                guard handler != nil && eventRef != nil else {
                    return noErr
                }
                guard let event = NSEvent(eventRef: UnsafeRawPointer(eventRef!)) else {
                    return noErr
                }

                guard CarbonKeyHandler.shared.processEvent(event) else {
                    return noErr
                }

                return noErr
            },
            1,
            &events[0],
            nil,
            nil
        )
    }
    
    public func addHandler(forSpecialKey specialKey: NSEvent.SpecialKey, handler: @escaping () -> Void) {
        specialKeyHandlers[specialKey] = handler
    }
    
    public func addHandler(forCommandWithCharacters characters: String, handler: @escaping () -> Void) {
        commandKeyHandlers[characters] = handler
    }
    
    public func processEvent(_ event: NSEvent) -> Bool {
        if let key = event.specialKey {
            if let handler = specialKeyHandlers[key] {
                DispatchQueue.main.async(execute: handler)
                return true
            }
        }

        if event.modifierFlags.contains(.command) && event.characters != nil {
            if let handler = commandKeyHandlers[event.characters!] {
                DispatchQueue.main.async(execute: handler)
                return true
            }
        }
        
        return false
    }
    
    public static var shared: CarbonKeyHandler = {
        return CarbonKeyHandler()
    }()
}
