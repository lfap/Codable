import Foundation

// O objeto 'Chat' possui várias 'Attachments'
// Os 'Texts' são as várias mensagens de texto que você manda durante uma conversa
// Os 'Attachments' podem ser de tipos diferentes: 'Image', 'Audio', 'Video', 'Location', ...
struct Chat: Codable {
    let from: String
    let texts: [String]
    let attachments: [Attachment]
}

let json = """
{
    "from": "Bob",
    "texts": ["Hello, Bob", "What's up?", "Look what I just found!"],
    "attachments": [
        {
            "type": "image",
            "payload": {
                "url": "http://via.placeholder.com/640x480",
                "width": 640,
                "height": 480
            }
        },
        {
            "type": "audio",
            "payload": {
                "title": "Never Gonna Give You Up",
                "url": "https://contoso.com/media/NeverGonnaGiveYouUp.mp3",
                "duration": 1.3,
            }
        },
        {
            "type": "pdf",
            "payload": {
                "title": "The Swift Programming Language",
                "url": "https://contoso.com/media/SwiftBook.pdf"
            }
        }
    ]
}
""".data(using: .utf8)!

// MARK: - Attachments

// Base Protocol for Attachments
protocol AttachmentProtocol: Codable {
    var url: URL { get set }
}

// An image attachment
struct ImageAttachment: AttachmentProtocol {
    var url: URL
    
    let width: Int
    let height: Int
}

struct AudioAttachment: AttachmentProtocol {
    var url: URL
    
    let title: String
    let duration: Double
}

struct PDFAttachment: AttachmentProtocol {
    var url: URL
    
    let title: String
}


// O objeto 'Attachment' não é um attachment, mas ele armazena o 'Attachment' e o tipo dele.
// Uma forma abstrata de attachment, que sabe o tipo que é porém não sabe o que é.
struct Attachment: Codable {
    
    // O 'type' será o identificador que recebemos do servidor, para podermos diferenciar cada "tipo" de attachment.
    let type: String
    
    // O 'payload' é de fato nosso 'Attachment'
    let payload: AttachmentProtocol?
    
    enum CodingKeys: String, CodingKey {
        case type
        case payload
    }
    
    private typealias AttachmentDecoder = (KeyedDecodingContainer<CodingKeys>) throws -> AttachmentProtocol
    private typealias AttachmentEncoder = (AttachmentProtocol, inout KeyedEncodingContainer<CodingKeys>) throws -> Void
    
    // Array com todos os decoder que o 'Attachment' sabe decodificar
    private static var decoders: [String: AttachmentDecoder] = [:]
    
    // Array com todos os encoder que o 'Attachment' sabe codificar
    private static var encoders: [String: AttachmentEncoder] = [:]
    
    // Esse método ensina o 'Attachment' a codificar e decodificar um novo tipo de 'Attachment'
    static func register<A: AttachmentProtocol>(_ type: A.Type, for typeName: String) {
        
        // Defino a chave do Decodificador.
        decoders[typeName] = { container in
            
            // Decodifico aquele tipo normalmente.
            try container.decode(type, forKey: .payload)
        }
        
        // Defino a chave do Codificador
        encoders[typeName] = { payload, container in
            
            // Codifico ele normalmente
            try container.encode(payload as? A, forKey: .payload)
        }
    }
    
    // MARK: - Decodificador
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        // Pegamos o tipo, pois a partir do tipo conseguimos buscar o decoder no nosso array.
        type = try container.decode(String.self, forKey: .type)
        
        if let decode = Attachment.decoders[type] {
            
            // Se foi registrado um Decodificador então chamo a closure para decodificar.
            payload = try decode(container)
        } else {
            
            // Caso constrário defino 'nil' como payload
            // Ou seja a aplicação ainda não suporta esse tipo de 'Attachment'
            payload = nil
        }
    }
    
    // MARK: - Codificador
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        // Codificamos a chave/tipo de attachment, para enviarmos para o servidor.
        try container.encode(type, forKey: .type)
        
        // Se não existir um payload, defino o valor 'null' para aquela chave
        // Isso é mais uma precaução
        guard let payload = payload else {
            try container.encodeNil(forKey: .payload)
            return
        }
        
        // Se existir payload e não existir encoder, então esqueceu de registrar um 'encoder'
        guard let encoder = Attachment.encoders[type] else {
            let context = EncodingError.Context(codingPath: [], debugDescription: "Invalid attachment: \(type).")
            throw EncodingError.invalidValue(self, context)
        }
        
        // Usa a closure para codificar.
        try encoder(payload, &container)
    }
}

Attachment.register(ImageAttachment.self, for: "image")
Attachment.register(AudioAttachment.self, for: "audio")
Attachment.register(PDFAttachment.self, for: "pdf")

let decoder = JSONDecoder()
let chat = try decoder.decode(Chat.self, from: json)

for attachment in chat.attachments {
    switch attachment.payload {
    case let image as ImageAttachment:
        print("Found image \(image)")
    case let audio as AudioAttachment:
        print("Found audio \(audio)")
    case let pdf as PDFAttachment:
        print("Found pdf \(pdf)")
    default:
        print("Unsupported attachment")
    }
}
