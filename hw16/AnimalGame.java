// Yale Spector
// Homework 14
// Animal Game in Java

import java.io.*;
import java.util.Scanner;

public class AnimalGame implements Serializable {

//	Eclipse told me to insert the following line, so...
	private static final long serialVersionUID = 1L;
	
	private Question firstQuestion;
	
	private transient Scanner scan = new Scanner(System.in);
	
	public AnimalGame(Question question) {
		this.firstQuestion = question;
	}
	
	public AnimalGame(String questionData) {
		this.firstQuestion = new Question(questionData);
		System.out.println(firstQuestion.toString());
	}
	
	private void readObject ( ObjectInputStream stream ) throws IOException, ClassNotFoundException
	{
	   stream.defaultReadObject();
	   this.scan = new Scanner(System.in);
	}
	
	public void refine(Question guess, String correctAnimal, String newQuestionData) {
		String oldAnimal = guess.data;
		guess.data = newQuestionData;
		guess.yes = new Question(correctAnimal);
		guess.no = new Question(oldAnimal);
	}
	
	public void ask(Question question) {
		System.out.print(question.toString() + " (y/n): ");
	  
		if (question.isAnimal()) {
			this.finish(question);
		} else {
			String answer = scan.next();
			if (answer.equals("y")) {
				this.ask(question.yes);
			} else if (answer.equals("n")) {
				this.ask(question.no);
			} else {
				System.out.println("Invalid input! Try again.");
				this.ask(question);
			}
		}
	}
	
	public void finish(Question question) {
		String answer = scan.next();
		if (answer.equals("y")) {
			System.out.println("I'm so smart. Thanks for playing!");
		} else if (answer.equals("n")) {
			String animal;
			String newQuestion;
			System.out.println("Oh no... could you tell me what animal you were thinking of?");
			scan.nextLine();
			animal = scan.nextLine();
			System.out.println("And what question would distinguish your animal from what I guessed?");
			newQuestion = scan.nextLine();
			System.out.println("Ok. I will remember this for next time!");
			this.refine(question, animal, newQuestion);
			
			try {
				this.save();
			} catch (IOException e) {
				e.printStackTrace();
			}
		} else {
			System.out.println("Invalid input! Try again.");
			this.ask(question);
		}
	}
	
	public void save() throws IOException {
		OutputStream os = new FileOutputStream("game.ser");
		ObjectOutput oo = new ObjectOutputStream(os);
		oo.writeObject(this);
		oo.close();
	}

	public void play() {
		System.out.println("Welcome to AnimalGame!");
		System.out.println("Think of an animal. I will try to guess it.");
		this.ask(firstQuestion);
	}
	
	public static void main(String[] args) throws IOException, ClassNotFoundException {
		
		AnimalGame game;
		
		File gameFile = new File("game.ser");
		if (gameFile.exists()) {
			InputStream is;
			is = new FileInputStream("game.ser");
			ObjectInput oi;
			oi = new ObjectInputStream(is);
			game = (AnimalGame)oi.readObject();
			oi.close();
		} else {
			game = new AnimalGame("cat");
		}
		
		game.play();

	}

}
