//
//  CarbonKeyHandler.swift
//  GlanceCalendar
//
//  Created by Andrew Branch on 11/10/18.
//  Copyright © 2018 Wheream.io. All rights reserved.
//

import Foundation
import Cocoa
import Carbon

class CarbonKeyHandler: NSObject {
    private var ptr = UnsafeMutableRawPointer.allocate(byteCount: 0, alignment: 0)
    private var specialKeyHandlers: Dictionary<NSEvent.SpecialKey, () -> Void> = Dictionary()
    private var commandKeyHandlers: Dictionary<String, () -> Void> = Dictionary()
    private let dispatcher = GetEventDispatcherTarget()
    private var events: [EventTypeSpec] = [EventTypeSpec(
        eventClass: OSType(kEventClassKeyboard),
        eventKind: UInt32(kEventRawKeyDown)
    )]

    override init() {
        super.init()
        ptr.storeBytes(of: self, toByteOffset: 0, as: CarbonKeyHandler.self)
        InstallEventHandler(
            dispatcher,
            { (handler, eventRef, selfPointer) in
                guard handler != nil && eventRef != nil else {
                    return noErr
                }
                guard let event = NSEvent(eventRef: UnsafeRawPointer(eventRef!)) else {
                    return noErr
                }

                let context = selfPointer!.load(as: CarbonKeyHandler.self)
                guard CarbonKeyHandler.processEvent(event, context: context) else {
                    return noErr
                }

                return noErr
            },
            1,
            &events[0],
            ptr,
            nil
        )
    }
    
    public func addHandler(forSpecialKey specialKey: NSEvent.SpecialKey, handler: @escaping () -> Void) {
        ptr.storeBytes(of: self, toByteOffset: 0, as: CarbonKeyHandler.self)
        specialKeyHandlers[specialKey] = handler
    }
    
    public func addHandler(forCommandWithCharacters characters: String, handler: @escaping () -> Void) {
        ptr.storeBytes(of: self, toByteOffset: 0, as: CarbonKeyHandler.self)
        commandKeyHandlers[characters] = handler
    }
    
    static func processEvent(_ event: NSEvent, context: CarbonKeyHandler) -> Bool {
        if let key = event.specialKey {
            if let handler = context.specialKeyHandlers[key] {
                DispatchQueue.main.async(execute: handler)
                return true
            }
        }

        if event.modifierFlags.contains(.command) && event.characters != nil {
            if let handler = context.commandKeyHandlers[event.characters!] {
                DispatchQueue.main.async(execute: handler)
                return true
            }
        }
        
        return false
    }
}
