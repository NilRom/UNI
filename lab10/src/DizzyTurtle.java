
public class DizzyTurtle extends RaceTurtle {
	int dizziness;

	public DizzyTurtle(RaceWindow w, int nbr, int dizziness) {
		super(w, nbr);
		this.dizziness = dizziness;
	}

	public void raceStep() {
		int r1 = (int) (Math.random() * ((1 - 6) + 1)) + 1;
		int r2 = (int) (Math.random() * ((1 - 6) + 1)) + 1;
		super.left(r1 * dizziness/5);
		super.left(-r2 * dizziness/5);
		super.raceStep();

	}

	public String toString() {
		return "Nummer " + startnumber + " - DizzyTurtle" + " (Yrsel: "+dizziness+")";
	}
}
