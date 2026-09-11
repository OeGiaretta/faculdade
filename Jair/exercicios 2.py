class Animal:
    def emitir_som(self):
        print("O animal está emitindo um som.")


class Cachorro(Animal):
    def emitir_som(self):
        print("O cachorro faz: Au au!")


class Gato(Animal):
    def emitir_som(self):
        print("O gato faz: Miau!")

animais = [
    Cachorro(),
    Gato()
]

for animal in animais:
    animal.emitir_som()