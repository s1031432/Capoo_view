//
//  ViewController.swift
//  capoo_view
//
//  Created by 黃翊唐 on 2024/7/12.
//

import UIKit

class ViewController: UIViewController {
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage? {
        let size = image.size
        
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio, height: size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(origin: .zero, size: newSize)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 获取 superView 的宽度和高度
        let superViewWidth = self.view.frame.width
        let superViewHeight = self.view.frame.height
        print(superViewWidth, superViewHeight)
        
        // recommended to use square images
        if let image = UIImage(named: "capoo.jpg") {
            let image = resizeImage(image:image, targetSize:CGSize(width:superViewWidth, height:superViewHeight))
            guard let cgImage = image?.cgImage,
                let data = cgImage.dataProvider?.data,
                let bytes = CFDataGetBytePtr(data) else {
                fatalError("Couldn't access image data")
            }
            assert(cgImage.colorSpace?.model == .rgb)

            let bytesPerPixel = cgImage.bitsPerPixel / cgImage.bitsPerComponent
            for y in 0 ..< cgImage.height {
                for x in 0 ..< cgImage.width {
                    let offset = (y * cgImage.bytesPerRow) + (x * bytesPerPixel)
                    let components = (r: bytes[offset+2], g: bytes[offset+1], b: bytes[offset])
//                    print("[x:\(x), y:\(y)] \(components)")
                    let squareView = UIView()
                    squareView.backgroundColor = UIColor(red: CGFloat(components.r)/255, green: CGFloat(components.g)/255, blue: CGFloat(components.b)/255, alpha: 1.0)
                    // set view position and size
                    squareView.frame = CGRect(x: x, y: Int(superViewHeight/4)+y, width: 1, height: 1)
                    
                    // add view to ViewController
                    self.view.addSubview(squareView)
                }
//                print("---")
            }
        } else {
            print("Failed to load image from bundle.")
        }
    }
}
