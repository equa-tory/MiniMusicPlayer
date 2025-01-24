//
//  PanGesture.swift
//  MiniMusicPlayer
//
//  Created by Alex Barauskas on 24.01.2025.
//

import SwiftUI

//struct PanGesture: UIGestureRecognizerRepresentable {
//    var onChange: (Value) -> ()
//    var onEnd: (Value) -> ()
//    
//    func makeUIGestureRecognizer(context: Context) -> some UIPanGestureRecognizer {
//        let gesture = UIPanGestureRecognizer()
//        return gesture
//    }
//    
//    func updateUIGestureRecognizer(_ recognizer: UIPanGestureRecognizer, context: Context) {
//        
//    }
//    
//    func handleUIGestureRecognizerAction(_ recognizer: UIPanGestureRecognizer, context: Context) {
//        let state = recognizer.state
//        let translation = recognizer.translation(in: recognizer.view).toSize()
//        let velocity = recognizer.velocity(in: recognizer.view).toSize()
//        let value = Value(translation: translation, velocity: velocity)
//        
//        if state == .began || state == .changed {
//            onChange(value)
//        } else {
//            onEnd(value)
//        }
//    }
//    
//    struct Value {
//        var translation: CGSize
//        var velocity: CGSize
//    }
//}
//
//extension CGPoint {
//    func toSize() -> CGSize {
//        return .init(width: x, height: y)
//    }
//}

struct PanGesture: UIGestureRecognizerRepresentable {
    var onChange: (Value) -> ()
    var onEnd: (Value) -> ()
    
    func makeCoordinator(converter: CoordinateSpaceConverter) -> Coordinator {
        Coordinator(onChange: onChange, onEnd: onEnd)
    }
    
    func makeUIGestureRecognizer(context: Context) -> some UIGestureRecognizer {
        let gesture = UIPanGestureRecognizer(target: context.coordinator, action: #selector(context.coordinator.handleAction(_:)))
        return gesture
    }
    
    func updateUIGestureRecognizer(_ recognizer: UIGestureRecognizerType, context: Context) {
        // No update needed
    }
    
    class Coordinator: NSObject {
        var onChange: (Value) -> ()
        var onEnd: (Value) -> ()
        
        init(onChange: @escaping (Value) -> (), onEnd: @escaping (Value) -> ()) {
            self.onChange = onChange
            self.onEnd = onEnd
        }
        
        @objc func handleAction(_ recognizer: UIPanGestureRecognizer) {
            let state = recognizer.state
            let translation = recognizer.translation(in: recognizer.view).toSize()
            let velocity = recognizer.velocity(in: recognizer.view).toSize()
            let value = Value(translation: translation, velocity: velocity)
            
            if state == .began || state == .changed {
                onChange(value)
            } else {
                onEnd(value)
            }
        }
    }
    
    struct Value {
        var translation: CGSize
        var velocity: CGSize
    }
}

extension CGPoint {
    func toSize() -> CGSize {
        CGSize(width: x, height: y)
    }
}
