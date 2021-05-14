import java.util.Random;

public class AbsentMindedTurtle extends RaceTurtle {
	int absent; // Hur absentminded han är

	public AbsentMindedTurtle(RaceWindow w, int nbr, int absent) {
		super(w, nbr);
		this.absent = absent;
	}

	public void raceStep() {
		Random rand = new Random();
		if (rand.nextInt(100) < absent) {
			// gör ingenting
		} else {
			super.raceStep();
		}
	}

	public String toString() {
		return "Nummer " + startnumber + " - AbsentMindedTurtle" + " ("+absent+"% Frånvarande)";
	}
}
