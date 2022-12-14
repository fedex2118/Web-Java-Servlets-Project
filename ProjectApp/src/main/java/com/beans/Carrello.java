package com.beans;

import java.util.Vector;

public class Carrello {
	
	private Vector<Prodotto> vettoreProdotti;
	
	public Carrello() {
		this.vettoreProdotti= new Vector<Prodotto>();
	}
	
	public void add(Prodotto p, boolean acquistaSubito) {
		if(!acquistaSubito) { // caso carrello
			if(!checkSameCode(p)) { // caso prodotti nel carrello con codice uguale
				vettoreProdotti.add(p);
			}
		} else // caso acquista subito
			vettoreProdotti.add(p);
	}
	
	public void removeFirst() { vettoreProdotti.remove(0); }
	
	public void remove(int i) { vettoreProdotti.remove(i); }
	
	public void removeAll() { vettoreProdotti.removeAll(vettoreProdotti);}
	
	public void removeLast() { vettoreProdotti.remove(len()-1); }
	
	public Prodotto getProdotto(int i) {return vettoreProdotti.elementAt(i);}
	
	public int len() {return vettoreProdotti.size();}
	
	private boolean checkSameCode(Prodotto prodotto) {
		boolean sameCode = false;
		// se il prodotto esiste già non lo aggiungiamo al carrello ma aggiungiamo la sua quantità aggiornata
		for (int i = 0; i < len(); i++) {
			Prodotto p = vettoreProdotti.get(i);
			if(prodotto.getCodice() == p.getCodice()) {
				p.setQuantita(p.getQuantita() + prodotto.getQuantita());
				sameCode = true;
			}
		}
		return sameCode;
	}
}
