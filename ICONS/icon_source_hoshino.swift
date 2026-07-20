//
//  icon_source_hoshino.swift
//  Hoshino Software & Security brand logo (flat, minimal)
//
//  Draws the flat brand mark with CoreGraphics and renders it to
//  /tmp/icon-final-hoshino/hoshino.png. Run: swift ICONS/icon_source_hoshino.swift
//  then copy the output over docs/hoshino.png.
//
//  Design: v3. v1 (star + shield-and-lock + two illustrated dachshunds on
//  a bright violet gradient) read as too busy and too cartoonish; v2 swapped
//  in a single small dachshund silhouette, which read as "weird" at this
//  size/treatment. Settled on a wordmark lockup on a flat, dark,
//  near-neutral background with exactly one small graphic accent: a single
//  four-point star (Hoshino = "star"), same fill as the type.
//

import AppKit
import CoreGraphics

let S: CGFloat = 1024
func rgb(_ hex: UInt32, _ a: CGFloat = 1) -> CGColor {
    CGColor(red: CGFloat((hex >> 16) & 0xFF)/255, green: CGFloat((hex >> 8) & 0xFF)/255, blue: CGFloat(hex & 0xFF)/255, alpha: a)
}

let c = CGContext(data: nil, width: Int(S), height: Int(S), bitsPerComponent: 8, bytesPerRow: 0,
                  space: CGColorSpaceCreateDeviceRGB(), bitmapInfo: CGImageAlphaInfo.noneSkipLast.rawValue)!

func rr(_ r: CGRect, _ radius: CGFloat, _ color: CGColor) {
    c.saveGState()
    c.setFillColor(color)
    c.addPath(CGPath(roundedRect: r, cornerWidth: radius, cornerHeight: radius, transform: nil))
    c.fillPath()
    c.restoreGState()
}
func ellipse(_ r: CGRect, _ color: CGColor) {
    c.saveGState()
    c.setFillColor(color)
    c.addPath(CGPath(ellipseIn: r, transform: nil))
    c.fillPath()
    c.restoreGState()
}
func withTransform(tx: CGFloat, ty: CGFloat, rotationDeg: CGFloat = 0, scaleX: CGFloat = 1, scaleY: CGFloat = 1, _ draw: () -> Void) {
    c.saveGState()
    c.translateBy(x: tx, y: ty)
    c.rotate(by: rotationDeg * .pi / 180)
    c.scaleBy(x: scaleX, y: scaleY)
    draw()
    c.restoreGState()
}

// MARK: - Background: flat, dark, near-neutral (no bright gradient)

let bg = rgb(0x171325)
c.setFillColor(bg)
c.fill(CGRect(x: 0, y: 0, width: S, height: S))

let cream = rgb(0xF8FAFC)

// MARK: - Star mark (Hoshino = "star"): single flat shape, same tone as the type

func drawStar(center: CGPoint, outerR: CGFloat, innerR: CGFloat, points: Int, color: CGColor, rotationDeg: CGFloat = 0) {
    let path = CGMutablePath()
    let step = CGFloat.pi / CGFloat(points)
    for i in 0..<(points * 2) {
        let r = i % 2 == 0 ? outerR : innerR
        let angle = CGFloat(i) * step + rotationDeg * .pi / 180
        let pt = CGPoint(x: center.x + r * sin(angle), y: center.y + r * cos(angle))
        if i == 0 { path.move(to: pt) } else { path.addLine(to: pt) }
    }
    path.closeSubpath()
    c.saveGState()
    c.setFillColor(color)
    c.addPath(path)
    c.fillPath()
    c.restoreGState()
}

drawStar(center: CGPoint(x: S/2, y: 660), outerR: 82, innerR: 32, points: 4, color: cream)

// MARK: - Wordmark

func drawText(_ str: String, font: NSFont, color: NSColor, centerX: CGFloat, baselineY: CGFloat, tracking: CGFloat) -> CGFloat {
    let attrs: [NSAttributedString.Key: Any] = [.font: font, .foregroundColor: color, .kern: tracking]
    let attr = NSAttributedString(string: str, attributes: attrs)
    let size = attr.size()
    let nsContext = NSGraphicsContext(cgContext: c, flipped: false)
    NSGraphicsContext.saveGraphicsState()
    NSGraphicsContext.current = nsContext
    attr.draw(at: CGPoint(x: centerX - size.width/2, y: baselineY))
    NSGraphicsContext.restoreGraphicsState()
    return size.width
}

let creamNS = NSColor(cgColor: cream)!
_ = drawText("HOSHINO", font: NSFont(name: "HelveticaNeue-Bold", size: 128) ?? NSFont.boldSystemFont(ofSize: 128),
             color: creamNS, centerX: S/2, baselineY: 340, tracking: 6)

let tagline = "SOFTWARE & SECURITY"
let taglineFont = NSFont(name: "HelveticaNeue-Bold", size: 34) ?? NSFont.boldSystemFont(ofSize: 34)
let taglineW = drawText(tagline, font: taglineFont, color: creamNS, centerX: S/2, baselineY: 266, tracking: 5)
let ruleY: CGFloat = 282, ruleGap: CGFloat = 28, ruleW: CGFloat = 64
rr(CGRect(x: S/2 - taglineW/2 - ruleGap - ruleW, y: ruleY, width: ruleW, height: 4), 2, cream)
rr(CGRect(x: S/2 + taglineW/2 + ruleGap, y: ruleY, width: ruleW, height: 4), 2, cream)

// MARK: - Export

let rep = NSBitmapImageRep(cgImage: c.makeImage()!)
try? FileManager.default.createDirectory(atPath: "/tmp/icon-final-hoshino", withIntermediateDirectories: true)
try! rep.representation(using: .png, properties: [:])!.write(to: URL(fileURLWithPath: "/tmp/icon-final-hoshino/hoshino.png"))
print("rendered to /tmp/icon-final-hoshino/hoshino.png")
