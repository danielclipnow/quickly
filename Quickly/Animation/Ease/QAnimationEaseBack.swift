//
//  Quickly
//

public class QAnimationEaseBackIn : IQAnimationEase {

    public func perform(_ x: Double) -> Double {
        return x * x * x - x * sin(x * Double.pi)
    }

}

public class QAnimationEaseBackOut : IQAnimationEase {

    public func perform(_ x: Double) -> Double {
        let f = (1 - x)
        return 1 - (f * f * f - f * sin(f * Double.pi))
    }

}

public class QAnimationEaseBackInOut : IQAnimationEase {

    public func perform(_ x: Double) -> Double {
        if x < 1 / 2 {
            let f = 2 * x
            return 1 / 2 * (f * f * f - f * sin(f * Double.pi))
        } else {
            let f = 1 - (2 * x - 1)
            let g = sin(f * Double.pi)
            let h = (f * f * f - f * g)
            return 1 / 2 * (1 - h) + 1 / 2
        }
    }

}