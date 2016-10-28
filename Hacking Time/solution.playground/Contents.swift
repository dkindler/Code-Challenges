import Foundation

// MARK: - String

extension String {
    func charAt(index: Int) -> Character? {
        guard index >= 0 && index <= (characters.count - 1) else { return nil }
        return Array(characters)[index]
    }
    
    mutating func popToFront() {
        guard self.characters.count > 1 else { return }
        if let poppedChar = self.characters.popLast() {
            self = String(describing: poppedChar) + self
        }
    }
    
    func decrypt(with: String) -> String {
        return rotated(by: with, isEncrypting: false)
    }
    
    func encrypt(with: String) -> String {
        return rotated(by: with, isEncrypting: true)
    }
    
    func findCharOffsetsOf(string: String) -> String {
        guard self.characters.count == string.characters.count else { return "" }
        
        var result = ""
        for (index, char) in string.characters.enumerated() {
            guard char.isAlphabetic() else { continue }
            
            let selfChar = Array(characters)[index]
            let diff = char.getAlphabetIndex() - selfChar.getAlphabetIndex()
            result += "\(diff >= 0 ? diff : 26 + diff)"
        }
        
        return result
    }
    
    private func rotated(by: String, isEncrypting: Bool) -> String {
        var curIndex = 0
        return characters.map { char -> String in
            if !char.isAlphabetic() { return String(char) }
            
            if let currentChar = by.charAt(index: curIndex % by.characters.count) {
                curIndex += 1
                let rotateAmount = isEncrypting ? Int(String(currentChar))! : -Int(String(currentChar))!
                return String(char.rotated(by: rotateAmount))
            } else {
                return ""
            }
            
        }.joined()
    }
}

// MARK: - Character

extension Character {
    func isAlphabetic() -> Bool {
        return isLowercase() || isUppercase()
    }
    
    func isLowercase() -> Bool {
        return (self >= "a" && self <= "z")
    }
    
    func isUppercase() -> Bool {
        return (self >= "A" && self <= "Z")
    }
    
    func getAlphabetIndex() -> Int {
        guard isUppercase() || isLowercase() else { return -1 }
        return getAlphabet().index(of: self) ?? -1
    }
    
    func rotated(by: Int) -> Character {
        guard by >= -9 && by <= 9 else { return self }
        
        var data = getAlphabet()
        let index = getAlphabetIndex() + by
        if index < 0 {
            return data[data.count + index]
        } else {
            return data[index % data.count]
        }
    }
    
    private func getAlphabet() -> [Character] {
        guard isAlphabetic() else { return [Character]() }
        
        let lowercase = Array("abcdefghijklmnopqrstuvwxyz".characters)
        let uppercase = Array("ABCDEFGHIJKLMNOPQRSTUVWXYZ".characters)
        return isUppercase() ? uppercase : lowercase
    }
}

// MARK: - Testing
var runTests = false

// Using data given, I was able to find the char offset to be "251220825122082" by checking the difference between the two string
var aliceKey = "Your friend, Alice".findCharOffsetsOf(string: "Atvt hrqgse, Cnikg")

// There seems to be repeated chars in aliceKey, so lets assume aliceKey is actually "2512208"
aliceKey = "2512208"

// Loop through substrings (0..<n), (1..<n), (2..<n) ... (n-2..<n) and see if I can find any english in the results
let encryptedString = "Otjfvknou kskgnl, K mbxg iurtsvcnb ksgq hoz atv. Vje xcxtyqrl vt ujg smewfv vrmcxvtg rwqr ju vhm ytsf elwepuqyez"
var startIndexInt = 0

if runTests {
    while startIndexInt < encryptedString.characters.count {
        let startIndex = encryptedString.index(encryptedString.startIndex, offsetBy: startIndexInt)
        
        let subString = encryptedString[startIndex..<encryptedString.endIndex]
        print("\(startIndexInt)) \(subString.decrypt(with: aliceKey))")
        
        startIndexInt += 1
    }
}

// The substring (8..<n) was the following:
// "s friend, I have important info for you. The password to the secret treasure room is the word clocktower"
// Now I just need to find (0..<8)
// Lets try to rearrange aliceKey
if runTests {
    var key = aliceKey
    let subString = encryptedString.substring(to: encryptedString.index(encryptedString.startIndex, offsetBy: 8))
    for _ in 0..<key.characters.count {
        key.popToFront()
        print("Key \(key): \(subString.decrypt(with: key))")
    }
}

// With the very first itteration it became apparent "8251220" is aliceKey
// So, just to verify:
if runTests {
    aliceKey = "8251220"
    print(encryptedString.decrypt(with: aliceKey))
}

// MARK: - HackerRank Tester

func decrypt(encrypted_message: String) -> String {
    return encrypted_message.decrypt(with: aliceKey)
}




