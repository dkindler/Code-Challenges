import Foundation

// MARK: - Tree

struct ExpressionTree: CustomStringConvertible {
    var elements = [Element]()

    init(string: String) {
        var elements = [Element]()
        for character in string.characters {
            guard character != " " else { continue }
            if character == ")" {
                let popped = elements.popWhile { $0 != Element.character("(") }
                elements.append(.subexpressionTree(ExpressionTree(popped.reversed())))
            } else {
                elements.append(.character(character))
            }
        }
        
        self.elements = elements
    }
    
    
    init(_ elements: [Element]) {
        self.elements = elements
    }
    
    var description: String {
        return elements.map({ $0.description }).joined()
    }
    
    
    /**
     Removes all subExpressionTrees in an ExpressionTree
     
         let ep = ExpressionTree("(abc)")
         print(ep)            // "(abc)"
         print(ep.flatten())  // "abc"
     
     - returns: flattened ExpressionTree
     */
    func flattened() -> ExpressionTree {
        return ExpressionTree(elements.flatMap { $0.flattened() } )
    }
    
    /**
     Reverses all elements in an ExpressionTree
     
         let ep = ExpressionTree("(abc)")
         print(ep)            // "(abc)"
         print(ep.reversed()) // "(cba)"
     
     - returns: reversed ExpressionTree
     */
    func reversed() -> ExpressionTree {
        let reversed = self.elements.reversed().flatMap { element -> [Element] in
            switch element {
                case .character:
                    return [element]
                case.subexpressionTree(let tree):
                    return [Element.subexpressionTree(ExpressionTree(tree.reversed().elements))]
                }
        }
        
        return ExpressionTree(reversed)
    }
    
    
    /**
     Flattens first element in ExpressionTree, and all elements inside of
     any subExpressionTrees
     
         let ep = ExpressionTree("(abc)")
         print(ep)            // "(abc)"
         print(ep.reversed()) // "(cba)"
     
     - returns: simplified ExpressionTree
     */
    func simplified() -> ExpressionTree {
        guard let first = self.elements.first else { return self }
        
        let flatFirst = first.flattened()
        let tail = elements.dropFirst().flatMap { element -> Element in
            switch element {
            case .character:
                return element
            case .subexpressionTree(let tree):
                return Element.subexpressionTree(tree.flattened())
            }
        }
        
        return ExpressionTree(flatFirst + tail)
    }
}

// MARK: - Element

indirect enum Element: CustomStringConvertible {
    case character(Character)
    case subexpressionTree(ExpressionTree)
    
    var description: String {
        switch self {
        case .character(let c):
            return "\(c)"
        case .subexpressionTree(let tree):
            return "(\(tree))"
        }
    }
    
    
    /**
     Flattens out element if element is a subExpressionTree
     
     - returns: Array of Elements
     */
    func flattened() -> [Element] {
        switch self {
        case .character:
            return [self]
        case .subexpressionTree(let tree):
            return tree.flattened().elements
        }
    }
}

func == (lhs: Element, rhs: Element) -> Bool {
    switch (lhs, rhs) {
    case (.character(let a), .character(let b)):
        return a == b
    case (.subexpressionTree(let c), .subexpressionTree(let d)):
        return c == d
    default:
        return false
    }
}

func == (lhs: ExpressionTree, rhs: ExpressionTree) -> Bool {
    guard lhs.elements.count == rhs.elements.count else { return false }
    for (index, lhsElement) in lhs.elements.enumerated() {
        if lhsElement != rhs.elements[index] { return false }
    }
    
    return true
}

func != (lhs: Element, rhs: Element) -> Bool {
    return !(lhs == rhs)
}

// MARK: - Helpers

extension Array {
    
    /**
     Pops elements in an Array until boolean statement is satisfied
     
     - parameters:
       - condition: Condition to be satisfied for popping to complete
     
     - returns: Array of popped elements
     */
    mutating func popWhile(condition: (Element) -> Bool) -> [Element] {
        var popped = [Element]()
        while let lastElement = popLast(), condition(lastElement) {
            popped.append(lastElement)
        }
        
        return popped
    }
}

// MARK: - Running

func inputHandler(data: String) -> String {
    let components = data.components(separatedBy: "/")
    var tree = ExpressionTree(string: components[0])
    
    if components.count >= 2 {
        let operations = components[1]
        for char in operations.characters {
            if char == "R" || char == "r" {
                tree = tree.reversed()
            } else if char == "S" || char == "s" {
                tree = tree.simplified()
            }
        }
    }
    
    return tree.description
}

// MARK: - STDIN STDOUT

func readData() -> Data {
    return FileHandle.standardInput.availableData
}

func readString() -> String {
    let string =  String(data: readData(), encoding: String.Encoding.utf8) ?? ""
    return string.trimmingCharacters(in: .whitespacesAndNewlines)
}

func readArrayOfStrings() -> [String] {
    return readString().components(separatedBy: .whitespacesAndNewlines)
}

var lines = readArrayOfStrings()
for line in lines {
    print(inputHandler(data: line))
}

// MARK: - Testing

func passesTestCases(_ tests: [String: String]) -> Bool {
    for input in tests.keys {
        if let expectedResult = tests[input], expectedResult != inputHandler(data: input) {
            print("\(input) != \(expectedResult). Should be \(inputHandler(data: input))")
            return false
        }
    }
    
    return true
}

let tests = ["": "",
             "/": "",
             "()/S": "",
             "/R": "",
             "A      A": "AA",
             "AB//R": "AB",
             "AB/r": "BA",
             "(AB)/s": "AB",
             "AB/R/": "BA",
             "AB/Z": "AB",
             "(AB)(CD(EF))/SS": "AB(CDEF)",
             "(AB)B/RSR/////":"(AB)B",
             "((((AB)C)D)E)F/S": "ABCDEF",
             "((((AB)C)D)E)F/RS": "F(EDCBA)",
             "(AB)((CDE)F)(G)/SRSR": "AB(CDEF)G"]

passesTestCases(tests) ? print("PASSES TESTS") : print("FAILS TESTS")







