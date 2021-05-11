package rekrytering;

import java.util.Arrays;

public class FindBestCandidates {
	private static final double MIN_AVG_GRADE = 4.5;

	public static void main(String[] args) {
		Applicant[] applicants = FileReader.readFromFile("applications_x.txt", 400);

		// Läs från fil (Börja med "applications_small.txt), spara resultatet i en
		// vektor
		// Applicant test = applicants[1];
		// System.out.println(test.toString(test));

		// Skicka in Applicant-vektorn (som du fick i föregående steg) till metoden
		Applicant[] good = findBestCandidates(applicants);
		Arrays.sort(good);
		// findBestCandidiates (nedan)

		// Spara resultatet i en vektor

		// Printa resultatet från findBestCandidates
		for (int i = 0; i < good.length; i++) {
			System.out.println(good[i].toString(good[i]));
		}
	}

	public static Applicant[] findBestCandidates(Applicant[] applicants) {
		// Hitta alla kandidater som har medelbetyg över MIN_AVG_GRADE
		int n = 0;
		int k = 0;
		for (int i = 0; i < applicants.length; i++) {
			Applicant a = applicants[i];
			if (a != null && a.getAvgGrade() > MIN_AVG_GRADE) {
				k++;
			}
		}
		Applicant[] accepted = new Applicant[k];

		for (int j = 0; j < applicants.length; j++) {
			Applicant a = applicants[j];
			if (a != null && a.getAvgGrade() > MIN_AVG_GRADE) {
				accepted[n] = applicants[j];
				n++;
			}

		}
		return accepted;
	}
}

// Lagra alla dessa kandidater i en vektor, returnera vektorn
