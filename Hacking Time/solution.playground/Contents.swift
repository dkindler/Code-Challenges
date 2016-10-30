import Foundation

// MARK: - String

extension String {
    func charAt(index: Int) -> Character? {
        guard index >= 0 && index <= (characters.count - 1) else { return nil }
        return Array(characters)[index]
    }
    
    mutating func popCharacterToFront() {
        guard self.characters.count > 1 else { return }
        if let poppedChar = self.characters.popLast() {
            self = String(describing: poppedChar) + self
        }
    }
    
    func decrypt(key: String) -> String {
        return rotated(by: key, isEncrypting: false)
    }
    
    func encrypt(key: String) -> String {
        return rotated(by: key, isEncrypting: true)
    }
    
    func characterOffset(string: String) -> String {
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
        guard isAlphabetic() else { return -1 }
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
    
    func getAlphabet() -> [Character] {
        guard isAlphabetic() else { return [Character]() }
        return isUppercase() ? Array("ABCDEFGHIJKLMNOPQRSTUVWXYZ".characters) : Array("abcdefghijklmnopqrstuvwxyz".characters)
    }
}

// MARK: - Testing
var runTests = true

// Using data given I was able to find the char offset to be "251220825122082" by checking the difference between the two strings
var aliceKey = "Your friend, Alice".characterOffset(string: "Atvt hrqgse, Cnikg")

// There seems to be repeated chars in aliceKey, so lets assume aliceKey is actually "2512208"
aliceKey = "2512208"

// Loop through substrings [(0..<n), (1..<n), (2..<n) ... (n-2..<n)] and see if I can find any english in the results
let encryptedString = "Otjfvknou kskgnl, K mbxg iurtsvcnb ksgq hoz atv. Vje xcxtyqrl vt ujg smewfv vrmcxvtg rwqr ju vhm ytsf elwepuqyez"

if runTests {
    for var i in 0..<encryptedString.characters.count {
        let startIndex = encryptedString.index(encryptedString.startIndex, offsetBy: i)
        let subString = encryptedString[startIndex..<encryptedString.endIndex]
        print("\(i)) \(subString.decrypt(key: aliceKey))")
    }
}

// The substring (1..<n) was the following:
// "reetings friend, I have important info for you. The password to the secret treasure room is the word clocktower"
// That just means the last character on aliceKey needs to be popped to the front
aliceKey.popCharacterToFront()

// Lets verify:
if runTests {
    print(encryptedString.decrypt(key: aliceKey))
}

// MARK: - HackerRank Tester

func decrypt(encrypted_message: String) -> String {
    return encrypted_message.decrypt(key: aliceKey)
}
