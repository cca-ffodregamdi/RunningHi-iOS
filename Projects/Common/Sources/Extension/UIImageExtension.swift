//
//  UIImageExtension.swift
//  Common
//
//  Created by 유현진 on 6/16/24.
//

import UIKit

public extension UIImage {
    func isDark(threshold: Float = 0.5) -> Bool {
        guard let cgImage = self.cgImage else { return false }
        let width = cgImage.width
        let height = cgImage.height
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGImageAlphaInfo.premultipliedLast.rawValue
        let context = CGContext(data: nil, width: width, height: height, bitsPerComponent: 8, bytesPerRow: width * 4, space: colorSpace, bitmapInfo: bitmapInfo)
        
        guard let context = context else { return false }
        context.draw(cgImage, in: CGRect(x: 0, y: 0, width: width, height: height))
        
        guard let pixelBuffer = context.data else { return false }
        let pixels = pixelBuffer.bindMemory(to: UInt32.self, capacity: width * height)
        
        var totalLuminance: Float = 0
        for x in 0..<width {
            for y in 0..<height {
                let offset = x + y * width
                let color = pixels[offset]
                
                let r = Float((color >> 24) & 255) * 0.2126
                let g = Float((color >> 16) & 255) * 0.7152
                let b = Float((color >> 8) & 255) * 0.0722
                totalLuminance += (r + g + b) / 255.0
            }
        }
        
        let luminance = totalLuminance / Float(width * height)
        return luminance < threshold
    }
}
