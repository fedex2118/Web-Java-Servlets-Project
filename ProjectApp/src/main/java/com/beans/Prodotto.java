package com.beans;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

public class Prodotto {
	
	private int codice;
	private int quantita;
	
	public Prodotto(int codice,int quantita) {
		this.codice = codice;
		this.quantita = quantita;
	}
	
	public int getCodice() {return codice;}
	public int getQuantita() {return quantita;}
	
	public void setQuantita(int nuovaQuantita) {
		quantita = nuovaQuantita;
	}
	
	public String getNomeProdotto() {
		Connection conn = null; // connection to the database
	    String dbURL = "jdbc:mysql://localhost:3306/mydb";
	    String dbUser = "root";
	    String dbPass = "";
	    String risultato="";
	    
		try {
    		// connects to the database
    		Class.forName("com.mysql.jdbc.Driver");
    		conn = DriverManager.getConnection(dbURL, dbUser, dbPass);

    		// constructs SQL statement
    		Statement stmt = conn.createStatement();  
            ResultSet rs = stmt.executeQuery("select * from prodotto where idProdotto="+codice );
            while(rs.next()) {
            	return risultato = rs.getString("nome");
            	
            }
            
    	} catch (SQLException | ClassNotFoundException ex) {
    		ex.printStackTrace();
    	} finally {
    		if (conn != null) {
    			// closes the database connection
    			try {
    				conn.close();
    			} catch (SQLException ex) {
    				ex.printStackTrace();
    			}
    		}
    	}
		
		return risultato;
	}
}
