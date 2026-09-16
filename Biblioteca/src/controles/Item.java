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
@Table(name = "item")
@NamedQueries({
    @NamedQuery(name = "Item.findAll", query = "SELECT i FROM Item i"),
    @NamedQuery(name = "Item.findByIditem", query = "SELECT i FROM Item i WHERE i.iditem = :iditem"),
    @NamedQuery(name = "Item.findByTitulo", query = "SELECT i FROM Item i WHERE i.titulo = :titulo"),
    @NamedQuery(name = "Item.findByQuantidade", query = "SELECT i FROM Item i WHERE i.quantidade = :quantidade"),
    @NamedQuery(name = "Item.findByIdtipoitem", query = "SELECT i FROM Item i WHERE i.idtipoitem = :idtipoitem"),
    @NamedQuery(name = "Item.findByIdclassificacao", query = "SELECT i FROM Item i WHERE i.idclassificacao = :idclassificacao"),
    @NamedQuery(name = "Item.findBySituacao", query = "SELECT i FROM Item i WHERE i.situacao = :situacao")})
public class Item implements Serializable {

    private static final long serialVersionUID = 1L;
    @Id
    @Basic(optional = false)
    @Column(name = "iditem")
    private Integer iditem;
    @Basic(optional = false)
    @Column(name = "titulo")
    private String titulo;
    @Basic(optional = false)
    @Column(name = "quantidade")
    private int quantidade;
    @Basic(optional = false)
    @Column(name = "idtipoitem")
    private int idtipoitem;
    @Basic(optional = false)
    @Column(name = "idclassificacao")
    private int idclassificacao;
    @Column(name = "situacao")
    private String situacao;

    public Item() {
    }

    public Item(Integer iditem) {
        this.iditem = iditem;
    }

    public Item(Integer iditem, String titulo, int quantidade, int idtipoitem, int idclassificacao) {
        this.iditem = iditem;
        this.titulo = titulo;
        this.quantidade = quantidade;
        this.idtipoitem = idtipoitem;
        this.idclassificacao = idclassificacao;
    }

    public Integer getIditem() {
        return iditem;
    }

    public void setIditem(Integer iditem) {
        this.iditem = iditem;
    }

    public String getTitulo() {
        return titulo;
    }

    public void setTitulo(String titulo) {
        this.titulo = titulo;
    }

    public int getQuantidade() {
        return quantidade;
    }

    public void setQuantidade(int quantidade) {
        this.quantidade = quantidade;
    }

    public int getIdtipoitem() {
        return idtipoitem;
    }

    public void setIdtipoitem(int idtipoitem) {
        this.idtipoitem = idtipoitem;
    }

    public int getIdclassificacao() {
        return idclassificacao;
    }

    public void setIdclassificacao(int idclassificacao) {
        this.idclassificacao = idclassificacao;
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
        hash += (iditem != null ? iditem.hashCode() : 0);
        return hash;
    }

    @Override
    public boolean equals(Object object) {
        // TODO: Warning - this method won't work in the case the id fields are not set
        if (!(object instanceof Item)) {
            return false;
        }
        Item other = (Item) object;
        if ((this.iditem == null && other.iditem != null) || (this.iditem != null && !this.iditem.equals(other.iditem))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "controles.Item[ iditem=" + iditem + " ]";
    }
    
}
