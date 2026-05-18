package main

import "fmt"

func main() {
	fmt.Println("Manipulando arrays")
	var numeros [4]int
	numeros[0] = 10
	numeros[0] = 20
	numeros[0] = 30
	numeros[0] = 40
	fmt.Println(numeros)
	fmt.Println()

	idades := [3]float64(1.0, 5.5, 0.3)
	fmt.Println(idades)
	fmt.Println()

	nomes := [3]string("Carro", "Moto", "Paulo")
	fmt.Println(nomes)
	fmt.Println()

	for i := range nomes {
		fmt.Println(nomes)
	}

}
