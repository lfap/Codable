import Foundation

// Um JSON mais próxmo do dia-a-dia
let jsonAsString = """
{
    "name": "John",
    "last_name": "Malkovich",
    "createdAt": "2015-12-19T15:27:02Z",
    "genre": "MALE"
}
"""

let jsonAsData = jsonAsString.data(using: .utf8)!

// 1 - Vamos criar nosso modelo que representa o JSON.
struct Person: Codable {
    let firstName: String
    let lastName: String
    let createdAt: Date
    let gender: Gender
    
    enum CodingKeys: String, CodingKey {
        case firstName = "name"
        case lastName = "last_name"
        case createdAt
        case gender = "genre"
    }
}

// 2 - Criar um enum que represento o gênero.
enum Gender: String, Codable {
    case male = "MALE"
    case female = "FEMALE"
}





// 3 - Conformar `Person` e `Gender` ao protocolo `Codable`.
// Vamos conformar com Codable pois vamos fazer o Decode e o Encoder, nesse exemplo.





// 4 - Criar um instância de `JSONDecoder`
let jsonDecoder = JSONDecoder()





// 5 - O atributo 'createdAt' está no formato `yyyy-MM-dd'T'HH:mm:ssZ`, vamos configurar isso no `jsonDecoder`
let formatter = DateFormatter()
formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
jsonDecoder.dateDecodingStrategy = .formatted(formatter)



do {
    // 6 - Converter nosso JSON em uma instância.
    let john = try jsonDecoder.decode(Person.self, from: jsonAsData)
//    print(john)
} catch {
    print(error)
}


// 7 - Para especificarmos as keys a serem usadas na hora de 'Decodificar' e 'Codificar'
//     temos que sobrescrever o enum 'CodingKeys', que já tem uma implementação default
















//#####################################################################################
//#####################################################################################
//#####################################################################################
//#####################################################################################

// Exemplo de uma instância de um objeto.

let maryPoppins = Person(firstName: "Mary",
                         lastName: "Poppins",
                         createdAt: Date(),
                         gender: .female)

// 2 - Criar uma instância de JSONEncoder
let jsonEncoder = JSONEncoder()
jsonEncoder.outputFormatting = .prettyPrinted

// 3 - Definir o formato que irá codificar a data.
jsonEncoder.dateEncodingStrategy = .formatted(formatter)

// 4 - Chamar o método de encode
do {
    let data = try jsonEncoder.encode(maryPoppins)
    
    let str = String(data: data, encoding: .utf8)!
    print(str)
} catch {
    print(error)
}
