import Foundation

// Um JSON comum no nosso dia-a-dia
let jsonAsString: String = """
{
    "name": "Carol Danvers",
    "age": 29,
    "gender": "FEMALE",
    "car": {
        "brand": "VW",
        "model": "Gol",
        "year": 2018
    }
}
"""

let jsonAsData = jsonAsString.data(using: .utf8)!



// 1 - Criar uma modelo para representar nosso JSON.
struct Person: Codable {
    let name: String
    let age: Int
    let gender: Gender
    let car: Car
}

enum Gender: String, Codable {
    case male = "MALE"
    case female = "FEMALE"
}

struct Car: Codable {
    let brand: String
    let model: String
    let year: Int
}


// 2 - Criar uma instância de JSONDecoder
let jsonDecoder = JSONDecoder()

// 4 - Decodificar o JSON no nosso objeto.

do {
    let carol = try jsonDecoder.decode(Person.self, from: jsonAsData)
//    print(carol)
} catch {
    print(error)
}









//#####################################################################################
//#####################################################################################
//#####################################################################################
//#####################################################################################

// 1 - Uma instância de um objeto 'Person' e 'Car'

let car = Car(brand: "Audi",
              model: "R8",
              year: 2016)
let tony = Person(name: "Tony Stark",
                  age: 40,
                  gender: Gender.male,
                  car: car)

// 2 - Criar uma instância de 'JSONEncoder'
let jsonEncoder = JSONEncoder()
jsonEncoder.outputFormatting = .prettyPrinted

// 3 - Codificar nossa instância 'tony'
do {
    let data = try jsonEncoder.encode(tony)
    let str = String(data: data, encoding: .utf8)!
    print(str)
} catch {
    print(error)
}


