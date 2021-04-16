//
//  Extensions.swift
//  Instagram2
//
//  Created by Roy Park on 4/15/21.
//

import Foundation
import UIKit


extension UIView {
    var top: CGFloat {
        frame.origin.y
    }
    
    var bottom: CGFloat {
        frame.origin.y+height
    }
    
    var left: CGFloat {
        frame.origin.x
    }
    
    var right: CGFloat {
        frame.origin.x+width
    }
    
    var width: CGFloat {
        frame.size.width
    }
    
    var height: CGFloat {
        frame.size.height
    }
}


extension Encodable {
    // You can now map stuff from the database directly into model instead of doing a unnecessary step
    func asDictionary() -> [String: Any]? {
        guard let data = try? JSONEncoder().encode(self) else { return nil }
        guard let json = try? JSONSerialization.jsonObject(
            with: data,
            options: .allowFragments
        ) as? [String: Any] else {
            return nil
        }
        return json
    }
}
