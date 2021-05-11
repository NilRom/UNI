

public class RaceTurtle extends Turtle {
	int startnumber;

	public RaceTurtle(RaceWindow w, int nbr) {
		super(w, RaceWindow.getStartXPos(nbr), RaceWindow.getStartYPos(nbr));
		this.startnumber = nbr;
		super.penDown();
	}

	public void raceStep() {
		int rstep = (int)(Math.random()*((1-6)+1))+1;
		forward(rstep);
	}
	
	public String toString() {
		return "Nummer " + startnumber + toString();
	}
}