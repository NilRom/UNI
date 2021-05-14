import java.util.ArrayList;
import java.util.Random;

public class TurtleRace2 {

	public static void main(String[] args) {
		ArrayList<RaceTurtle> RaceTurtles = new ArrayList<RaceTurtle>();
		ArrayList<RaceTurtle> Finished = new ArrayList<RaceTurtle>();
		RaceWindow w = new RaceWindow();
		// skapar alla sköldisar
		for (int i = 1; i < 9; i++) {
			Random r = new Random();
			int r1 = r.nextInt(3)+1;
			int r2 = r.nextInt(100)+1;
			int r3 = r.nextInt(5)+1;
			if(r1 == 1) {
			RaceTurtles.add(new MoleTurtle(w, i));
			}
			else if(r1 == 2) {
				RaceTurtles.add(new AbsentMindedTurtle(w,i,r2));
			}
			else {
				RaceTurtles.add(new DizzyTurtle(w,i,r3));
			}
		}
		for(RaceTurtle r : RaceTurtles) {
			System.out.println(r);
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
