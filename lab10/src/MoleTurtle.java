import java.util.Random;

public class MoleTurtle extends RaceTurtle {

	public MoleTurtle(RaceWindow w, int nbr) {
		super(w,nbr);
	}
	public void raceStep() {
		Random r = new Random();
		boolean r1 = r.nextBoolean();
		super.raceStep();
		if(r1) {
			super.penUp();
		}
		else {
			super.penDown();
		}
	}
	public String toString() {
		return super.toString()+ "- MoleTurtle";
	}
}
