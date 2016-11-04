
func threeSum(_ nums: [Int]) -> [[Int]] {
    let sortedNums = nums.sorted()
    var solutions = [[Int]]()
    var usedElements = Set<String>()
    
    guard nums.count >= 3 else { return solutions }
    
    for i in 0...(sortedNums.count - 3) {
        let a = sortedNums[i]
        
        var start = i + 1
        var end = sortedNums.count - 1
        if start >= end { continue }
        
        while start < end {
            let b = sortedNums[start]
            let c = sortedNums[end]
            let sum = a + b + c
            
            if sum == 0, !usedElements.contains("\(a) \(b) \(c)") {
                solutions.append([a, b, c])
                usedElements.insert("\(a) \(b) \(c)")
                end -= 1
            } else if sum > 0 {
                end -= 1
            } else {
                start += 1
            }
        }
    }
    
    return solutions
}
