import SwiftUI


func angleBetween3Points (a: CGPoint, b: CGPoint, c: CGPoint) -> Double {
    
    let angleAC = atan2(c.y - a.y, c.x - a.x)
    let angleBC = atan2(c.y - b.y, c.x - b.x)
    var angleACB = angleAC - angleBC
    
    if (Double(angleACB) > Double.pi) || (Double(angleACB) < -Double.pi) {
        angleACB = 0
    }
    
    let angle = Double(angleACB) * 180 / Double.pi
    
    return angle
}

func rotate<T>(_ array: inout [T], _ index: Int) {
	
	var initial: Int = 0
	
	index >= 0 ? (initial = array.count - (index % array.count)) : (initial = (abs(index) % array.count))
	
	let elementsToPutAtBeginning = Array(array[initial..<array.count])
	let elementsToPutAtEnd = Array(array[0..<initial])
	
	array = elementsToPutAtBeginning + elementsToPutAtEnd
}
