class Veiculo:
    def acelerar(self):
        print("O veículo está acelerando.")


class Carro(Veiculo):
    def acelerar(self):
        print("O carro está acelerando na estrada.")


class Moto(Veiculo):
    def acelerar(self):
        print("A moto está acelerando rapidamente.")


class Barco(Veiculo):
    def acelerar(self):
        print("O barco está acelerando sobre a água.")


veiculos = [
    Carro(),
    Moto(),
    Barco()
]

for veiculo in veiculos:
    veiculo.acelerar()