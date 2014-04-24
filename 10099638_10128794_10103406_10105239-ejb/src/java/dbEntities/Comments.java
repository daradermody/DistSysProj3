/* 
 * Group:       Niko Flores (10103406), Emma Foley (10105239), Dara Dermody (10099638), Patrick O'Keeffe (10128794)
 * Module:      Distributed Systems 2
 *      Code:   CE4208
 * Lecturer:    Reiner Dojen
 * Date:        25 April 2014
 *
 * Project:     Online Shop Application using Enterprise JavaBeans and Entity Classes
 *      Number: 3
 */

package dbEntities;

import java.io.Serializable;
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
import javax.validation.constraints.NotNull;
import javax.validation.constraints.Size;
import javax.xml.bind.annotation.XmlRootElement;

/**
 * Database Entity class for Comments.
 * 
 * @author Emma Foley 10105239
 * @author Dara Dermody 10099638
 * @author Niko Flores 10103406
 * @author Patrick O Keeffe 10128794
 */
@Entity
@Table(name = "COMMENTS")
@XmlRootElement
@NamedQueries({
    @NamedQuery(name = "Comments.findAll", query = "SELECT c FROM Comments c"),
    @NamedQuery(name = "Comments.findById", query = "SELECT c FROM Comments c WHERE c.id = :id"),
    @NamedQuery(name = "Comments.findByContent", query = "SELECT c FROM Comments c WHERE c.content = :content"),
    @NamedQuery(name = "Comments.findByPoster", query = "SELECT c FROM Comments c WHERE c.poster = :poster"),
    @NamedQuery(name = "Comments.findByProduct", query = "SELECT c FROM Comments c WHERE c.product = :product"),
    @NamedQuery(name = "Comments.findByDate", query = "SELECT c FROM Comments c WHERE c.date = :date")})
public class Comments implements Serializable {
    private static final long serialVersionUID = 1L;
    @Id
    @Basic(optional = false)
    @NotNull
    @Column(name = "ID")
    private Integer id;
    @Basic(optional = false)
    @NotNull
    @Size(min = 1, max = 2048)
    @Column(name = "CONTENT")
    private String content;
    @Basic(optional = false)
    @NotNull
    @Size(min = 1, max = 255)
    @Column(name = "POSTER")
    private String poster;
    @Basic(optional = false)
    @NotNull
    @Column(name = "PRODUCT")
    private int product;
    @Column(name = "DATE")
    @Temporal(TemporalType.TIMESTAMP)
    private Date date;

    public Comments() {
    }

    public Comments(Integer id) {
        this.id = id;
    }

    public Comments(Integer id, String content, String poster, int product) {
        this.id = id;
        this.content = content;
        this.poster = poster;
        this.product = product;
    }
    
    public Comments(Product prod, Customer cust, String content) {
        this.product = prod.getId();
        this.poster = cust.getUsername();
        this.content = content;
    }

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public String getPoster() {
        return poster;
    }

    public void setPoster(String poster) {
        this.poster = poster;
    }

    public int getProduct() {
        return product;
    }

    public void setProduct(int product) {
        this.product = product;
    }

    public Date getDate() {
        return date;
    }

    public void setDate(Date date) {
        this.date = date;
    }

    @Override
    public int hashCode() {
        int hash = 0;
        hash += (id != null ? id.hashCode() : 0);
        return hash;
    }

    @Override
    public boolean equals(Object object) {
        // TODO: Warning - this method won't work in the case the id fields are not set
        if (!(object instanceof Comments)) {
            return false;
        }
        Comments other = (Comments) object;
        if ((this.id == null && other.id != null) || (this.id != null && !this.id.equals(other.id))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "testDBEntities.Comments[ id=" + id + " ]";
    }
    
}
