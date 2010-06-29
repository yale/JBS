// Yale Spector
// Homework 14
// Animal Game in Java

import java.io.Serializable;

public class Question implements Serializable {
	private static final long serialVersionUID = 1L;
	String data;
	Question yes;
	Question no;
	
	public Question(String data) {
		this.data = data;
		this.yes = null;
		this.no = null;
	}
	
	public boolean isAnimal() {
		return (this.yes == null && this.no == null);
	}
	
	public String toString() {
		if (this.isAnimal()) {
			return "Are you thinking of: " + this.data;
		} else {
			return this.data;
		}
	}
}
