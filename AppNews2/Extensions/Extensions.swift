//
//  Extensions.swift
//  AppNews2
//
//  Created by Nazildo Souza on 19/09/20.
//

import SwiftUI

struct BlurView: UIViewRepresentable {
    let style: UIBlurEffect.Style
    
    func makeUIView(context: Context) -> UIVisualEffectView {
        let effect = UIBlurEffect(style: style)
        let blur = UIVisualEffectView(effect: effect)
        return blur
    }
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        
    }

}

struct Corners : Shape {
    
    var corner : UIRectCorner
    var size : CGSize
    
    func path(in rect: CGRect) -> Path {
        
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corner, cornerRadii: size)
        
        return Path(path.cgPath)
    }
}
