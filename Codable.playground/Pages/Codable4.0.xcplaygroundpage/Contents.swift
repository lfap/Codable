import Foundation

// Um verdadeiro JSON no nosso dia-a-dia
let jsonAsString = """
{
    "name": "Sherlock Holmes",
    "idade": 40,
    "car": "Ford",
    "car_model":"T",
    "car_y34r": 1927
}
"""

let jsonAsData = jsonAsString.data(using: .utf8)!

// 1 - Criar uma modelo que corresponde ao nosso JSON.

struct Person: Codable {
    let name: String
    let age: Int
    let car: Car
    
    enum CodingKeys: String, CodingKey {
        case name
        case age = "idade"
    }
}
extension Person {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        name = try container.decode(String.self, forKey: Person.CodingKeys.name)
        age = try container.decode(Int.self, forKey: Person.CodingKeys.age)
        
        car = try Car(from: decoder)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = try encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(name, forKey: Person.CodingKeys.name)
        try container.encode(age, forKey: Person.CodingKeys.age)
        
        try car.encode(to: encoder)
        
    }
}


struct Car: Codable {
    let brand: String
    let model: String
    let year: Int
    
    enum CodingKeys: String, CodingKey {
        case brand = "car"
        case model = "car_model"
        case year = "car_y34r"
    }
   
}




// 4 - Implementar o construtor init(from decoder: Decoder) na strcut 'Person'


// 5 - Instanciar um objeto do tipo JSONDecoder.
let jsonDecoder = JSONDecoder()


// 7 - Fazer o decode do nosso JSON em objeto.
do {
    let sherlock = try jsonDecoder.decode(Person.self, from: jsonAsData)
//    print(sherlock)
} catch {
    print(error)
}













//#####################################################################################
//#####################################################################################
//#####################################################################################
//#####################################################################################

// 1 - Vamos criar uma instância de um objeto 'Car' e 'Person'.
let car = Car(brand: "Ford", model: "Mustang", year: 1967)
let lara = Person(name: "Lara Croft", age: 28, car: car)

// 2 - Criar uma instância de 'JSONEncoder'
let jsonEncoder = JSONEncoder()

// 3 - Para facilitar a visualização do JSON, vamos definir o output format
jsonEncoder.outputFormatting = .prettyPrinted

// 4 - Codificar nosso objeto

do {
    let data = try jsonEncoder.encode(lara)
    let str = String(data: data, encoding: .utf8)!
    print(str)
} catch {
    print(error)
}









// ??? Carro não está presente no JSON. ???

// 5 - Implementar o método encode(to encoder: Encoder) em 'Person'
