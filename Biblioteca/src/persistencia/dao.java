package persistencia;

import java.util.List;
import javax.persistence.*;

public class dao {
    
    public static void salvar (Object objeto) {
        EntityManager ent;
        ent = Persistence.createEntityManagerFactory("UP").createEntityManager();
        ent.getTransaction().begin();
        
        ent.merge(objeto);
        ent.getTransaction().commit();
     }
    public static List listar(String nomePesquisa) {
        EntityManager ent;
        ent = Persistence.createEntityManagerFactory("UP").createEntityManager();
        Query q = ent.createNamedQuery(nomePesquisa);
        List lista = q.getResultList();
        return lista;
    }
    public static List listar(String nomePesquisa,String parametro, int chave) {
        EntityManager ent;
        ent = Persistence.createEntityManagerFactory("UP").createEntityManager();
        Query q = ent.createNamedQuery(nomePesquisa);
        q.setParameter(parametro, chave);
        List lista = q.getResultList();
        return lista;
    }
    public static List listar(String nomePesquisa,String parametro, String chave) {
        EntityManager ent;
        ent = Persistence.createEntityManagerFactory("UP").createEntityManager();
        Query q = ent.createNamedQuery(nomePesquisa);
        q.setParameter(parametro, chave);
        List lista = q.getResultList();
        return lista;
    }
    public static List listar1Sql (String sql) {
        EntityManager ent;
        ent = Persistence.createEntityManagerFactory("UP").createEntityManager();
        Query q = ent.createQuery(sql);
        List lista = q.getResultList();
        return lista;
    }
    public static int executarSql(String sql) {
        EntityManager ent;
        ent = Persistence.createEntityManagerFactory("UP").createEntityManager();
        Query q = ent.createNativeQuery(sql);
        ent.getTransaction().begin();
        int r = q.executeUpdate();
        ent.getTransaction().commit();
        return r;
    }
      public static void excluir (Object objeto) {
        
        EntityManager ent;
        ent = Persistence.createEntityManagerFactory("UP").createEntityManager();
        ent.getTransaction().begin();
        
        ent.remove(ent.merge(objeto)); 
        ent.getTransaction().commit();
    }
     public static void excluir (String pesquisa, String parametro, int chave) {
        EntityManager ent;
        ent = Persistence.createEntityManagerFactory("UP").createEntityManager();
        ent.getTransaction().begin();
        Query q = ent.createNamedQuery(pesquisa);
        q.setParameter(parametro, chave);
        Object objeto = q.getSingleResult();
        ent.remove(objeto);
        ent.getTransaction().commit();
    }
     public static void excluir (String pesquisa, String parametro, String chave) {
        EntityManager ent;
        ent = Persistence.createEntityManagerFactory("UP").createEntityManager();
        ent.getTransaction().begin();
        Query q = ent.createNamedQuery(pesquisa);
        q.setParameter(parametro, chave);
        Object objeto = q.getSingleResult();
        ent.remove(objeto);
        ent.getTransaction().commit();
    }
      public static Object consultar (String pesquisa, String parametro, int chave) {
        EntityManager ent;
        ent = Persistence.createEntityManagerFactory("UP").createEntityManager();
        Query q = ent.createNamedQuery(pesquisa);
        q.setParameter(parametro, chave);
        Object objeto = q.getSingleResult();
        return objeto;
    }
      public static Object consultar (String pesquisa, String parametro, String chave) {
        EntityManager ent;
        ent = Persistence.createEntityManagerFactory("UP").createEntityManager();
        Query q = ent.createNamedQuery(pesquisa);
        q.setParameter(parametro, chave);
        Object objeto = q.getSingleResult();
        return objeto;
    }
}