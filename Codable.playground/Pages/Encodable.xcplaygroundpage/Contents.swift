import Foundation

// Exemplo de uma modelo no nosso dia-a-dia
struct Person: Encodable {
    let name: String
    let age: Int
}

// 2 - Criar uma instância do objeto.
let mary = Person(name: "Mary", age: 30)

// 3 - Conformar a modelo com o Protocolo 'Encodable'

// 4 - Criar uma instância de JSONEncoder.
let jsonEncoder = JSONEncoder()

// 5 - Abrir a classe `JSONEncoder` e mostrar os atributos

// 6 - Chamar o método encode(value: Encodable) throws
do {
    let data = try jsonEncoder.encode(mary)
    let str = String(data: data, encoding: .utf8)!
    print(str)
} catch {
    print(error)
}
