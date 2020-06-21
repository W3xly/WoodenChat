//
//  UIImage + Extensions.swift
//  WoodenChat
//
//  Created by Johana Šlechtová on 17/06/2020.
//  Copyright © 2020 Jan Podmolík. All rights reserved.
//

import UIKit

extension UIImage {
    func sameAspectRation(newHeight: CGFloat) -> UIImage {
        let scale = newHeight / size.height
        let newWidth = size.width * scale
        let newSize = CGSize(width: newWidth, height: newHeight)
        return UIGraphicsImageRenderer(size: newSize).image { _ in
            self.draw(in: .init(origin: .zero, size: newSize))
        }
    }
}
