
import java.util.Random;
import se.lth.cs.pt.window.SimpleWindow;

public class upp6 {
 	public static void main(String[] args) {
		SimpleWindow w = new SimpleWindow(600, 600, "TurtleDrawRandomFigure");
		Turtle t = new Turtle(w, 350, 350);
		Random rand = new Random();
		t.penDown();
		Turtle t2 = new Turtle(w, 250, 250);
		t2.penDown();
		
		while(true) {
			if((t.getX()<600 && t.getY()<600) && (t.getX()>0 && t.getY()>0)) {
			t.forward(rand.nextInt(10)+1);
			int rangle = rand.nextInt(360)-180;
			t.left(rangle);
			//t2.forward2(rand.nextInt(10)+1);
			int rangle2 = rand.nextInt(360)-180;
			t2.left(rangle2);
			SimpleWindow.delay(1);
			if(Math.hypot(t.getX()-t2.getX(), t.getY()-t2.getY())<50) {
				System.out.println("Sköldpaddorna krockade och dog");
				break;	
			}} else {
				t.jumpTo(0, 0);
				
			
			}
		}
	}
 	
}
