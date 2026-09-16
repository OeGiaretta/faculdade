/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package controles;

import java.io.Serializable;
import java.math.BigDecimal;
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
@Table(name = "tipoitem")
@NamedQueries({
    @NamedQuery(name = "Tipoitem.findAll", query = "SELECT t FROM Tipoitem t"),
    @NamedQuery(name = "Tipoitem.findByIdtipoitem", query = "SELECT t FROM Tipoitem t WHERE t.idtipoitem = :idtipoitem"),
    @NamedQuery(name = "Tipoitem.findByDescricao", query = "SELECT t FROM Tipoitem t WHERE t.descricao = :descricao"),
    @NamedQuery(name = "Tipoitem.findByQtddiasprazo", query = "SELECT t FROM Tipoitem t WHERE t.qtddiasprazo = :qtddiasprazo"),
    @NamedQuery(name = "Tipoitem.findByVlrmulta", query = "SELECT t FROM Tipoitem t WHERE t.vlrmulta = :vlrmulta")})
public class Tipoitem implements Serializable {

    private static final long serialVersionUID = 1L;
    @Id
    @Basic(optional = false)
    @Column(name = "idtipoitem")
    private Integer idtipoitem;
    @Basic(optional = false)
    @Column(name = "descricao")
    private String descricao;
    @Basic(optional = false)
    @Column(name = "qtddiasprazo")
    private int qtddiasprazo;
    // @Max(value=?)  @Min(value=?)//if you know range of your decimal fields consider using these annotations to enforce field validation
    @Basic(optional = false)
    @Column(name = "vlrmulta")
    private BigDecimal vlrmulta;

    public Tipoitem() {
    }

    public Tipoitem(Integer idtipoitem) {
        this.idtipoitem = idtipoitem;
    }

    public Tipoitem(Integer idtipoitem, String descricao, int qtddiasprazo, BigDecimal vlrmulta) {
        this.idtipoitem = idtipoitem;
        this.descricao = descricao;
        this.qtddiasprazo = qtddiasprazo;
        this.vlrmulta = vlrmulta;
    }

    public Integer getIdtipoitem() {
        return idtipoitem;
    }

    public void setIdtipoitem(Integer idtipoitem) {
        this.idtipoitem = idtipoitem;
    }

    public String getDescricao() {
        return descricao;
    }

    public void setDescricao(String descricao) {
        this.descricao = descricao;
    }

    public int getQtddiasprazo() {
        return qtddiasprazo;
    }

    public void setQtddiasprazo(int qtddiasprazo) {
        this.qtddiasprazo = qtddiasprazo;
    }

    public BigDecimal getVlrmulta() {
        return vlrmulta;
    }

    public void setVlrmulta(BigDecimal vlrmulta) {
        this.vlrmulta = vlrmulta;
    }

    @Override
    public int hashCode() {
        int hash = 0;
        hash += (idtipoitem != null ? idtipoitem.hashCode() : 0);
        return hash;
    }

    @Override
    public boolean equals(Object object) {
        // TODO: Warning - this method won't work in the case the id fields are not set
        if (!(object instanceof Tipoitem)) {
            return false;
        }
        Tipoitem other = (Tipoitem) object;
        if ((this.idtipoitem == null && other.idtipoitem != null) || (this.idtipoitem != null && !this.idtipoitem.equals(other.idtipoitem))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "controles.Tipoitem[ idtipoitem=" + idtipoitem + " ]";
    }
    
}
