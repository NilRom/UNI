import java.util.ArrayList;

public class TurtleRace {

	public static void main(String[] args) {
		ArrayList<RaceTurtle> RaceTurtles = new ArrayList<RaceTurtle>();
		ArrayList<RaceTurtle> Finished = new ArrayList<RaceTurtle>();
		RaceWindow w = new RaceWindow();
		// skapar alla sköldisar
		for (int i = 1; i < 9; i++) {
			RaceTurtles.add(new RaceTurtle(w, i));
		}
		while (!RaceTurtles.isEmpty()) {
			for (RaceTurtle r : RaceTurtles) {
				r.raceStep();
				RaceWindow.delay(1);
				//Om sköldpadda kommit i mål läggs den i lista för de som kommit fram
				if (r.getX() >= RaceWindow.X_END_POS) {
					Finished.add(r);
				}
			}
			//Loopar igenom de som kommit i mål om en kommit i mål tas den bort från racearna 
			for (RaceTurtle r : Finished) {
				if (Finished.contains(r)) {
					RaceTurtles.remove(r);
				}
			}
		}
		//skriver ut de som placerat top 3
		for (int k = 0; k < 3; k++) {
			System.out.println("På plats " + (k + 1) + ": " + Finished.get(k).toString());
		}
	}

}
