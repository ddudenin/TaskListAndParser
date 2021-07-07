import UIKit

struct Person : Codable, CustomStringConvertible {
    let age: Int
    let isDeveloper: Bool
    let name: String
    
    var description: String {
        return "name: \(self.name) age: \(self.age) isDeveloper: \(self.isDeveloper)"
    }
}

protocol ParserHandler {
    
    var next: ParserHandler? { get set }
    func handleParse(_ data: Data) -> [Person]
}

class ParserType1: ParserHandler {
    
    var next: ParserHandler?
    
    private struct PersonsData: Codable {
        let data: [Person]
    }
    
    func handleParse(_ data: Data) -> [Person] {
        do {
            let personsData = try JSONDecoder().decode(PersonsData.self, from: data)
            return personsData.data
        } catch {
            return self.next?.handleParse(data) ?? []
        }
    }
}

class ParserType2: ParserHandler {
    
    var next: ParserHandler?
    
    private struct PersonsData: Codable {
        let result: [Person]
    }
    
    func handleParse(_ data: Data) -> [Person] {
        do {
            let personsData = try JSONDecoder().decode(PersonsData.self, from: data)
            return personsData.result
        } catch {
            return self.next?.handleParse(data) ?? []
        }
    }
}

class ParserType3: ParserHandler {
    
    var next: ParserHandler?
    
    func handleParse(_ data: Data) -> [Person] {
        do {
            let persons = try JSONDecoder().decode([Person].self, from: data)
            return persons
        } catch {
            return self.next?.handleParse(data) ?? []
        }
    }
}

func data(from file: String) -> Data {
    let path1 = Bundle.main.path(forResource: file, ofType: "json")!
    let url = URL(fileURLWithPath: path1)
    let data = try! Data(contentsOf: url)
    return data
}


func parse(_ fileName: String) -> [Person] {
    let parser1 = ParserType1()
    let parser2 = ParserType2()
    let parser3 = ParserType3()
    
    parser3.next = parser2
    parser2.next = parser1
    parser1.next = nil
    
    let data = data(from: fileName)
    
    return parser3.handleParse(data)
}

for i in 1...3 {
    print(parse("\(i)"))
}



