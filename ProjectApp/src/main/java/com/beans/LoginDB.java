package com.beans;

import java.util.Iterator;
import java.util.Vector;

public class LoginDB
{
	// TODO Default Users, tipo gli utenti ADMIN???
	private Vector<User> users = new Vector<>();
	
	public LoginDB() {
		// TODO ciclo for dove si aggiungono agli users i default users
	}
	
	public void addUser(User user) {
		// TODO cercare se l'utente esiste già? forse conviene farlo altrove però
		users.add(user);
	}
	
	public User getUser(String userName, String pwd) {
		Iterator<User> iterator = users.iterator();
		User bean;
		synchronized (users) {
			while (iterator.hasNext()) {
				bean = iterator.next();
				if (bean.checkCredentials(userName, pwd))
					return bean;
			}
		}
		return null;
	}
	
	public int getLength() {
		return users.size();
	}
}
