import Foundation

class VendingMachineProduct {
    var name: String
    var amount: Int
    var price: Double

    init(name: String, amount: Int, price: Double) {
        self.name = name
        self.amount = amount
        self.price = price
    }
}

//TODO: Definir os erros
enum VendingMachineError: Error {
    case productNotFound
    case productUnavailable
    case insufficientMoney
    case productStuck
    case noChange
}

extension VendingMachineError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .productNotFound:
            return "O produto escolhido não é vendido nessa máquina"
        case .productUnavailable:
            return "O produto escolhido acabou"
        case .productStuck:
            return "O produto ficou preso"
        case .insufficientMoney:
            return "A quantia inserida não condiz com o preço do produto"
        case .noChange:
            return "Desculpe, não temos troco"
        }
    }
}

class VendingMachine {
    private var estoque: [VendingMachineProduct]
    private var money: Double
    private var amountOfChange: Double
    
    init(products: [VendingMachineProduct]) {
        self.estoque = products
        self.money = 0
        self.amountOfChange = 100
    }
    
    func getProduct(named name: String, with money: Double) throws {
        //TODO: receber o dinheiro e salvar em uma variável
        self.money += money

        //TODO: achar o produto que o cliente quer
        let produtoOptional = estoque.first { (produto) -> Bool in
            return produto.name == name
        }
        guard let produto = produtoOptional else { throw VendingMachineError.productNotFound }

        //TODO: ver se ainda tem esse produto
        guard produto.amount > 0 else { throw VendingMachineError.productUnavailable }

        //TODO: ver se o dinheiro é o suficiente pro produto
        guard produto.price <= self.money else { throw VendingMachineError.insufficientMoney }

        //TODO: entregar o produto
        self.money -= produto.price
        produto.amount -= 1

        if Int.random(in: 0...100) < 10 {
            throw VendingMachineError.productStuck
        }
    }
    
    func getTroco() throws -> Double {
        //TODO: devolver o dinheiro que não foi gasto
        let money = self.money
        guard money <= amountOfChange else { throw VendingMachineError.noChange }
        self.amountOfChange -= money
        self.money = 0.0
        return money
    }
}

let vendingMachines = VendingMachine(products: [
    VendingMachineProduct(name: "Doritos", amount: 5, price: 8.5),
    VendingMachineProduct(name: "Toddynho", amount: 10, price: 2.5),
    VendingMachineProduct(name: "Água", amount: 3, price: 1.5)
])

do {
    try vendingMachines.getProduct(named: "Doritos", with: 200)
    try vendingMachines.getTroco()
} catch {
    print(error.localizedDescription)
}
