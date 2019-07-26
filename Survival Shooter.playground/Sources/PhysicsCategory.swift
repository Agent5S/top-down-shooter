import Foundation

public enum PhysicsCategory: UInt32 {
    case worldBounds    = 0b0001
    case enemy          = 0b0010
    case player         = 0b0100
    case bullet         = 0b1000
}

func bitmask(_ categories: PhysicsCategory...) -> UInt32 {
    var ret: UInt32 = 0
    for category in categories {
        ret = ret | category.rawValue
    }
    
    return ret
}

