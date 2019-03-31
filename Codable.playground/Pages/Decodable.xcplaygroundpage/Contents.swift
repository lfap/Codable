import Foundation

// Exemplo de JSON que recebemos no dia-a-dia.
let jsonAsString: String = """
{
    "brand": "VW",
    "model": "Gol",
    "year": 2019
}
"""


// Convertendo o JSON para Data (é como JSONs são tratados em Swift)
let jsonAsData = jsonAsString.data(using: .utf8)!

// 1 - Criar uma modelo que represente o retorno
struct Car: Decodable {
    let brand: String
    let model: String
    let year: Int
}

// 2 - Conformar `Car` com `Decodable`

// 3 - Criar uma instância de `JSONDecoder`
let jsonDecoder = JSONDecoder()

// 4 - Abrir classe JSONDecoder

// 5 - Chamar o método 'func decode(type: Decodable.Protocol, from: Data) throws'
do {
    let car = try jsonDecoder.decode(Car.self, from: jsonAsData)
    print(car)
} catch {
    print(error)
}
