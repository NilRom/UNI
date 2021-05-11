package rekrytering;

import java.io.File;
import java.io.FileNotFoundException;
import java.util.Scanner;

public class FileReader {

	/**
	 * Returnerar max nbrOfRows rader från filen som en vektor av Applicant-objekt.
	 * Läser i filen tills det inte finns fler rader eller tills man läst nbrOfRows
	 * rader (det som inträffar först). Returnerar null om filen inte finns.
	 */
	public static Applicant[] readFromFile(String fileName, int nbrOfRows) {
		Scanner scan;

		try {
			scan = new Scanner(new File(fileName), "utf-8");

		} catch (FileNotFoundException e) {
			System.err.println("File not found" + fileName);
			e.printStackTrace();
			return null;
		}

		int i = 0;
		int nbrreadrows = 0;
		Applicant[] applicants = new Applicant[nbrOfRows];
		while (nbrreadrows < nbrOfRows && scan.hasNextLine()) {
			String row = scan.nextLine();
			String[] splits = row.split(" ");
			if (splits.length == 3) {
				Applicant a = new Applicant(splits[0] + " " + splits[1], splits[2]);
				applicants[i] = a;
				nbrreadrows++;
				i++;
			}
		}
		return applicants;
	}
	// Här kan du använda Scannern för att läsa från filen fileName.
	// Varje rad motsvarar en Applicant. Kontrollera vad Applicants konstruktor
	// kräver
	// Alla Applicant-objekt (max nbrOfRows stycken) ska lagras i en
	// Applicant-vektor och returneras på slutet
	// return null; //Byt ut denna rad mot hela lösningen
}
