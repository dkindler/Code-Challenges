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
    
    func flattened() -> ExpressionTree {
        return ExpressionTree(elements.flatMap { $0.flattened() } )
    }
    
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
    
    func flattened() -> [Element] {
        switch self {
        case .character:
            return [self]
        case .subexpressionTree(let tree):
            return tree.flattened().elements
        }
    }
}

func == (a: Element, b: Element) -> Bool {
    //TODO: Quick hack, totally inefficient.
    return a.description == b.description
}

func != (a: Element, b: Element) -> Bool {
    return !(a == b)
}

// MARK: - Helpers

extension Array {
    mutating func popWhile(condition: (Element) -> Bool) -> [Element] {
        var popped = [Element]()
        while let lastElement = popLast(), condition(lastElement) {
            popped.append(lastElement)
        }
        
        return popped
    }
}

// MARK: - Running

func inputHandler(data: String) {
    let components = data.components(separatedBy: "/")
    var tree = ExpressionTree(string: components[0])
    
    if components.count == 2 {
        let operations = components[1]
        for char in operations.characters {
            if char == "R" {
                tree = tree.reversed()
            } else if char == "S" {
                tree = tree.simplified()
            }
        }
    }
    
    print(tree)
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
    inputHandler(data: line)
}

// MARK: - Testing

inputHandler(data: "(ABC) / RS")
inputHandler(data: "(AB)C((DE)F) / RSSR")
