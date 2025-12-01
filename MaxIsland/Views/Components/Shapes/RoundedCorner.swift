

import SwiftUI

struct CustomRoundedRectangle: Shape {
    var topLeft: CGFloat = 0
    var topRight: CGFloat = 0
    var bottomLeft: CGFloat = 0
    var bottomRight: CGFloat = 0
    
    var animatableData: AnimatableData {
        get {
            AnimatableData(
                topLeft: topLeft,
                topRight: topRight,
                bottomLeft: bottomLeft,
                bottomRight: bottomRight
            )
        }
        set {
            topLeft = newValue.topLeft
            topRight = newValue.topRight
            bottomLeft = newValue.bottomLeft
            bottomRight = newValue.bottomRight
        }
    }
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        let width = rect.size.width
        let height = rect.size.height
        
        // Ensure corner radii don't exceed half the width/height
        let maxRadius = min(width, height) / 2
        let tl = min(topLeft, maxRadius)
        let tr = min(topRight, maxRadius)
        let bl = min(bottomLeft, maxRadius)
        let br = min(bottomRight, maxRadius)
        
        // Start from top-left, going clockwise
        path.move(to: CGPoint(x: tl, y: 0))
        
        // Top edge and top-right corner
        path.addLine(to: CGPoint(x: width - tr, y: 0))
        path.addArc(
            center: CGPoint(x: width - tr, y: tr),
            radius: tr,
            startAngle: Angle(degrees: -90),
            endAngle: Angle(degrees: 0),
            clockwise: false
        )
        
        // Right edge and bottom-right corner
        path.addLine(to: CGPoint(x: width, y: height - br))
        path.addArc(
            center: CGPoint(x: width - br, y: height - br),
            radius: br,
            startAngle: Angle(degrees: 0),
            endAngle: Angle(degrees: 90),
            clockwise: false
        )
        
        // Bottom edge and bottom-left corner
        path.addLine(to: CGPoint(x: bl, y: height))
        path.addArc(
            center: CGPoint(x: bl, y: height - bl),
            radius: bl,
            startAngle: Angle(degrees: 90),
            endAngle: Angle(degrees: 180),
            clockwise: false
        )
        
        // Left edge and top-left corner
        path.addLine(to: CGPoint(x: 0, y: tl))
        path.addArc(
            center: CGPoint(x: tl, y: tl),
            radius: tl,
            startAngle: Angle(degrees: 180),
            endAngle: Angle(degrees: 270),
            clockwise: false
        )
        
        path.closeSubpath()
        return path
    }
}

// MARK: - AnimatableData for smooth animations
extension CustomRoundedRectangle {
    struct AnimatableData: VectorArithmetic {
        var topLeft: CGFloat
        var topRight: CGFloat
        var bottomLeft: CGFloat
        var bottomRight: CGFloat
        
        static var zero: AnimatableData {
            AnimatableData(topLeft: 0, topRight: 0, bottomLeft: 0, bottomRight: 0)
        }
        
        static func + (lhs: AnimatableData, rhs: AnimatableData) -> AnimatableData {
            AnimatableData(
                topLeft: lhs.topLeft + rhs.topLeft,
                topRight: lhs.topRight + rhs.topRight,
                bottomLeft: lhs.bottomLeft + rhs.bottomLeft,
                bottomRight: lhs.bottomRight + rhs.bottomRight
            )
        }
        
        static func - (lhs: AnimatableData, rhs: AnimatableData) -> AnimatableData {
            AnimatableData(
                topLeft: lhs.topLeft - rhs.topLeft,
                topRight: lhs.topRight - rhs.topRight,
                bottomLeft: lhs.bottomLeft - rhs.bottomLeft,
                bottomRight: lhs.bottomRight - rhs.bottomRight
            )
        }
        
        mutating func scale(by rhs: Double) {
            topLeft *= rhs
            topRight *= rhs
            bottomLeft *= rhs
            bottomRight *= rhs
        }
        
        var magnitudeSquared: Double {
            Double(topLeft * topLeft + topRight * topRight + bottomLeft * bottomLeft + bottomRight * bottomRight)
        }
    }
}

// MARK: - Convenience View Extension
extension View {
    func customRoundedRectangle(
        topLeft: CGFloat = 0,
        topRight: CGFloat = 0,
        bottomLeft: CGFloat = 0,
        bottomRight: CGFloat = 0
    ) -> some View {
        self.clipShape(CustomRoundedRectangle(
            topLeft: topLeft,
            topRight: topRight,
            bottomLeft: bottomLeft,
            bottomRight: bottomRight
        ))
    }
}
