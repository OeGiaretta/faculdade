/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package controles;

import java.io.Serializable;
import java.math.BigDecimal;
import java.util.Date;
import javax.persistence.Basic;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.NamedQueries;
import javax.persistence.NamedQuery;
import javax.persistence.Table;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;

/**
 *
 * @author carlo
 */
@Entity
@Table(name = "emprestimo")
@NamedQueries({
    @NamedQuery(name = "Emprestimo.findAll", query = "SELECT e FROM Emprestimo e"),
    @NamedQuery(name = "Emprestimo.findByIdemprestimo", query = "SELECT e FROM Emprestimo e WHERE e.idemprestimo = :idemprestimo"),
    @NamedQuery(name = "Emprestimo.findByCodleitor", query = "SELECT e FROM Emprestimo e WHERE e.codleitor = :codleitor"),
    @NamedQuery(name = "Emprestimo.findByIditem", query = "SELECT e FROM Emprestimo e WHERE e.iditem = :iditem"),
    @NamedQuery(name = "Emprestimo.findByDataemprestimo", query = "SELECT e FROM Emprestimo e WHERE e.dataemprestimo = :dataemprestimo"),
    @NamedQuery(name = "Emprestimo.findByDataprevdevolucao", query = "SELECT e FROM Emprestimo e WHERE e.dataprevdevolucao = :dataprevdevolucao"),
    @NamedQuery(name = "Emprestimo.findByDatadevolucao", query = "SELECT e FROM Emprestimo e WHERE e.datadevolucao = :datadevolucao"),
    @NamedQuery(name = "Emprestimo.findByVlrmulta", query = "SELECT e FROM Emprestimo e WHERE e.vlrmulta = :vlrmulta")})
public class Emprestimo implements Serializable {

    private static final long serialVersionUID = 1L;
    @Id
    @Basic(optional = false)
    @Column(name = "idemprestimo")
    private Integer idemprestimo;
    @Basic(optional = false)
    @Column(name = "codleitor")
    private int codleitor;
    @Basic(optional = false)
    @Column(name = "iditem")
    private int iditem;
    @Basic(optional = false)
    @Column(name = "dataemprestimo")
    @Temporal(TemporalType.DATE)
    private Date dataemprestimo;
    @Basic(optional = false)
    @Column(name = "dataprevdevolucao")
    @Temporal(TemporalType.DATE)
    private Date dataprevdevolucao;
    @Basic(optional = false)
    @Column(name = "datadevolucao")
    @Temporal(TemporalType.DATE)
    private Date datadevolucao;
    // @Max(value=?)  @Min(value=?)//if you know range of your decimal fields consider using these annotations to enforce field validation
    @Column(name = "vlrmulta")
    private BigDecimal vlrmulta;

    public Emprestimo() {
    }

    public Emprestimo(Integer idemprestimo) {
        this.idemprestimo = idemprestimo;
    }

    public Emprestimo(Integer idemprestimo, int codleitor, int iditem, Date dataemprestimo, Date dataprevdevolucao, Date datadevolucao) {
        this.idemprestimo = idemprestimo;
        this.codleitor = codleitor;
        this.iditem = iditem;
        this.dataemprestimo = dataemprestimo;
        this.dataprevdevolucao = dataprevdevolucao;
        this.datadevolucao = datadevolucao;
    }

    public Integer getIdemprestimo() {
        return idemprestimo;
    }

    public void setIdemprestimo(Integer idemprestimo) {
        this.idemprestimo = idemprestimo;
    }

    public int getCodleitor() {
        return codleitor;
    }

    public void setCodleitor(int codleitor) {
        this.codleitor = codleitor;
    }

    public int getIditem() {
        return iditem;
    }

    public void setIditem(int iditem) {
        this.iditem = iditem;
    }

    public Date getDataemprestimo() {
        return dataemprestimo;
    }

    public void setDataemprestimo(Date dataemprestimo) {
        this.dataemprestimo = dataemprestimo;
    }

    public Date getDataprevdevolucao() {
        return dataprevdevolucao;
    }

    public void setDataprevdevolucao(Date dataprevdevolucao) {
        this.dataprevdevolucao = dataprevdevolucao;
    }

    public Date getDatadevolucao() {
        return datadevolucao;
    }

    public void setDatadevolucao(Date datadevolucao) {
        this.datadevolucao = datadevolucao;
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
        hash += (idemprestimo != null ? idemprestimo.hashCode() : 0);
        return hash;
    }

    @Override
    public boolean equals(Object object) {
        // TODO: Warning - this method won't work in the case the id fields are not set
        if (!(object instanceof Emprestimo)) {
            return false;
        }
        Emprestimo other = (Emprestimo) object;
        if ((this.idemprestimo == null && other.idemprestimo != null) || (this.idemprestimo != null && !this.idemprestimo.equals(other.idemprestimo))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "controles.Emprestimo[ idemprestimo=" + idemprestimo + " ]";
    }
    
}
