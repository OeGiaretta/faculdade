/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package controles;

import java.io.Serializable;
import javax.persistence.Basic;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.NamedQueries;
import javax.persistence.NamedQuery;
import javax.persistence.Table;

/**
 *
 * @author carlo
 */
@Entity
@Table(name = "leitor")
@NamedQueries({
    @NamedQuery(name = "Leitor.findAll", query = "SELECT l FROM Leitor l"),
    @NamedQuery(name = "Leitor.findByCodleitor", query = "SELECT l FROM Leitor l WHERE l.codleitor = :codleitor"),
    @NamedQuery(name = "Leitor.findByNome", query = "SELECT l FROM Leitor l WHERE l.nome = :nome"),
    @NamedQuery(name = "Leitor.findByEndereco", query = "SELECT l FROM Leitor l WHERE l.endereco = :endereco"),
    @NamedQuery(name = "Leitor.findByTelefone", query = "SELECT l FROM Leitor l WHERE l.telefone = :telefone"),
    @NamedQuery(name = "Leitor.findBySituacao", query = "SELECT l FROM Leitor l WHERE l.situacao = :situacao")})
public class Leitor implements Serializable {

    private static final long serialVersionUID = 1L;
    @Id
    @Basic(optional = false)
    @Column(name = "codleitor")
    private Integer codleitor;
    @Basic(optional = false)
    @Column(name = "nome")
    private String nome;
    @Column(name = "endereco")
    private String endereco;
    @Column(name = "telefone")
    private String telefone;
    @Column(name = "situacao")
    private String situacao;

    public Leitor() {
    }

    public Leitor(Integer codleitor) {
        this.codleitor = codleitor;
    }

    public Leitor(Integer codleitor, String nome) {
        this.codleitor = codleitor;
        this.nome = nome;
    }

    public Integer getCodleitor() {
        return codleitor;
    }

    public void setCodleitor(Integer codleitor) {
        this.codleitor = codleitor;
    }

    public String getNome() {
        return nome;
    }

    public void setNome(String nome) {
        this.nome = nome;
    }

    public String getEndereco() {
        return endereco;
    }

    public void setEndereco(String endereco) {
        this.endereco = endereco;
    }

    public String getTelefone() {
        return telefone;
    }

    public void setTelefone(String telefone) {
        this.telefone = telefone;
    }

    public String getSituacao() {
        return situacao;
    }

    public void setSituacao(String situacao) {
        this.situacao = situacao;
    }

    @Override
    public int hashCode() {
        int hash = 0;
        hash += (codleitor != null ? codleitor.hashCode() : 0);
        return hash;
    }

    @Override
    public boolean equals(Object object) {
        // TODO: Warning - this method won't work in the case the id fields are not set
        if (!(object instanceof Leitor)) {
            return false;
        }
        Leitor other = (Leitor) object;
        if ((this.codleitor == null && other.codleitor != null) || (this.codleitor != null && !this.codleitor.equals(other.codleitor))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "controles.Leitor[ codleitor=" + codleitor + " ]";
    }
    
}
