import se.lth.cs.pt.window.SimpleWindow;
import se.lth.cs.pt.square.Square;

public class AnimateSquare3 {
	public static void main(String[] args) {
		SimpleWindow w = new SimpleWindow(600, 600, "DrawSquare");
		Square sq = new Square(0, 0, 100);
		int oldX = 0; 
		int oldY = 0;
		while (true) {
			w.waitForMouseClick(); 
			int x = w.getMouseX();
			int y = w.getMouseY();
			sq.erase(w);
			sq.move(x-oldX, y-oldY);
			sq.draw(w);
			oldX = x;
			oldY = y;		
	}}
}
