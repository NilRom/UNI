package memory;

import java.util.Random;

public class MemoryBoard {
	private int size;
	private MemoryCardImage[][] board;
	private Boolean[][] isUp;

	/**
	 * Skapar ett memorybräde med size * size kort. backFileName är filnamnet för
	 * filen med baksidesbilden. Vektorn frontFileNames innehåller filnamnen för
	 * frontbilderna.
	 */
	public MemoryBoard(int size, String backFileName, String[] frontFileNames) {
		this.size = size;
		this.board = new MemoryCardImage[size][size];
		createCards(backFileName, frontFileNames);
		isUp = new Boolean[size][size];
		for (int i = 0; i < size; i++) {
			for (int k = 0; k < size; k++) {
				isUp[i][k] = false;
			}
		}
	}

	/*
	 * Skapar size * size / 2 st memorykortbilder. Placerar ut varje kort på två
	 * slumpmässiga ställen på spelplanen.
	 */
	private void createCards(String backFileName, String[] frontFileNames) {
		for (int i = 0; i < frontFileNames.length; i++) {
			MemoryCardImage card = new MemoryCardImage(frontFileNames[i], backFileName);
			Random rand = new Random();
			int r = rand.nextInt(size);
			int c = rand.nextInt(size);
			while (board[r][c] != null) {
				r = rand.nextInt(size);
				c = rand.nextInt(size);
			}
			board[r][c] = card;
			while (board[r][c] != null) {
				r = rand.nextInt(size);
				c = rand.nextInt(size);
			}
			board[r][c] = card;

		}
	}

	/** Tar reda på brädets storlek. */
	public int getSize() {
		return size;
	}

	/**
	 * Hämtar den tvåsidiga bilden av kortet på rad r, kolonn c. Raderna och
	 * kolonnerna numreras från 0 och uppåt.
	 */
	public MemoryCardImage getCard(int r, int c) {
		return board[r][c];
	}

	/** Vänder kortet på rad r, kolonn c. */
	public void turnCard(int r, int c) {
		if (isUp[r][c] == false) {
			isUp[r][c] = true;
		} else {
			isUp[r][c] = false;
		}
	}

	/** Returnerar true om kortet r, c har framsidan upp. */
	public boolean frontUp(int r, int c) {
		return isUp[r][c];
	}

	/**
	 * Returnerar true om det är samma kort på rad r1, kolonn c2 som på rad r2,
	 * kolonn c2.
	 */
	public boolean same(int r1, int c1, int r2, int c2) {
		return getCard(r1, c1).getFront().equals(getCard(r2, c2).getFront());
	}

	/** Returnerar true om alla kort har framsidan upp. */
	public boolean hasWon() {
		for (int i = 0; i < size; i++) {
			for (int k = 0; k < size; k++) {
				if (isUp[i][k] == false) {
					return false;
				}
			}
		}
		return true;
	}
}
