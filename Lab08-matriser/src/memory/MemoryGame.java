package memory;

import java.util.Scanner;
import java.util.ArrayList;

public class MemoryGame {
	public static void main(String[] args) {
		String wantToPlay = "ja";
		Scanner scan = new Scanner(System.in);
		ArrayList<Integer> highScore = new ArrayList<Integer>();
		
		while (true) {
			String[] frontFileNames = { "can.jpg", "flopsy_mopsy_cottontail.jpg", "friends.jpg", "mother_ladybird.jpg",
					"mr_mcgregor.jpg", "mrs_rabbit.jpg", "mrs_tittlemouse.jpg", "radishes.jpg" };
			MemoryBoard board = new MemoryBoard(4, "back.jpg", frontFileNames);
			MemoryWindow window = new MemoryWindow(board);
			int counter = 0;
			while (!board.hasWon()) {
				counter++;
				window.delay(800);
				window.drawBoard();
				window.waitForMouseClick();
				int r1 = window.getMouseRow();
				int c1 = window.getMouseCol();
				board.turnCard(r1, c1);
				window.drawCard(r1, c1);
				window.waitForMouseClick();
				int r2 = window.getMouseRow();
				int c2 = window.getMouseCol();
				board.turnCard(r2, c2);
				window.drawCard(r2, c2);
				if (!board.same(r1, c1, r2, c2)) {
					board.turnCard(r1, c1);
					board.turnCard(r2, c2);
				}
			}
			highScore.add(counter);
			System.out.println("Grattis! Du vann, det tog " + counter + " försök \n" + "Highscore:");
			for (int i : highScore) {
				System.out.println(i);
			}
			System.out.println("Vill du spela en gång till? För ja skriv 'ja' i terminalen");
			wantToPlay = scan.next();
		}
		// Fyll i egen kod här
	}
}
