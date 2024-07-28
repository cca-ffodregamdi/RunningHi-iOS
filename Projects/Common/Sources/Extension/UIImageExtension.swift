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
    
    func averageColor(in rect: CGRect) -> UIColor? {
            guard let cgImage = self.cgImage else { return nil }
            let width = Int(rect.width)
            let height = Int(rect.height)
            let bitsPerComponent = 8
            let bytesPerRow = width * 4
            let colorSpace = CGColorSpaceCreateDeviceRGB()
            let bitmapInfo = CGImageAlphaInfo.premultipliedLast.rawValue

            guard let context = CGContext(
                data: nil,
                width: width,
                height: height,
                bitsPerComponent: bitsPerComponent,
                bytesPerRow: bytesPerRow,
                space: colorSpace,
                bitmapInfo: bitmapInfo
            ) else { return nil }

            context.draw(cgImage, in: CGRect(x: -rect.origin.x, y: -rect.origin.y, width: self.size.width, height: self.size.height))

            guard let data = context.data else { return nil }
            let dataType = data.bindMemory(to: UInt8.self, capacity: width * height * 4)

            var totalRed = 0
            var totalGreen = 0
            var totalBlue = 0

            for x in 0..<width {
                for y in 0..<height {
                    let pixelIndex = ((width * y) + x) * 4
                    totalRed += Int(dataType[pixelIndex])
                    totalGreen += Int(dataType[pixelIndex + 1])
                    totalBlue += Int(dataType[pixelIndex + 2])
                }
            }

            let totalPixels = width * height
            let avgRed = totalRed / totalPixels
            let avgGreen = totalGreen / totalPixels
            let avgBlue = totalBlue / totalPixels

            return UIColor(red: CGFloat(avgRed) / 255.0, green: CGFloat(avgGreen) / 255.0, blue: CGFloat(avgBlue) / 255.0, alpha: 1.0)
        }
    
    func resized(to size: CGSize) -> UIImage {
        return UIGraphicsImageRenderer(size: size).image { _ in
            draw(in: CGRect(origin: .zero, size: size))
        }
    }
}
