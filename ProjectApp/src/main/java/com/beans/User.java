package com.beans;

public class User 
{
	private final String userName;
	private final String pwd;
	
	public User(String userName, String pwd) {
		this.userName = userName;
		this.pwd = pwd;
	}
	
	// Getters
	public String getUserName() { return userName; }
	public String getPwd() { return pwd; }
	
	// Metodi Utilità
	public boolean checkCredentials(String userName, String pwd) {
		return (this.userName.equals(userName) && this.pwd.equals(pwd));
	}
}
