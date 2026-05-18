public class Veiculo {

    private String marca;
    private String modelo;
    private int ano;
    private double velocidade;

    public String getMarca() {
        return marca;
    }

    public void setMarca(String marca) {
        this.marca = marca;
    }

    public String getModelo() {
        return modelo;
    }

    public void setModelo(String modelo) {
        this.modelo = modelo;
    }

    public int getAno() {
        return ano;
    }

    public void setAno(int ano) {
        this.ano = ano;
    }

    public double getVelocidade() {
        return velocidade;
    }

    public void setVelocidade(double velocidade) {
        if (velocidade >= 0) 
            this.velocidade = velocidade;
        }  
}


public class Main {
    public static void main(String[] args) {

        Veiculo v1 = new Veiculo();

        v1.setMarca("Toyota");
        v1.setModelo("Corolla");
        v1.setAno(2022);
        v1.setVelocidade(120);

        System.out.println("Marca: " + v1.getMarca());
        System.out.println("Modelo: " + v1.getModelo());
        System.out.println("Ano: " + v1.getAno());
        System.out.println("Velocidade: " + v1.getVelocidade() + " km/h");
    }
}