
public class Mole {
	private Graphics g = new Graphics(30,50,10);
	public static void main(String[] args) {
		System.out.println("Keep on digging!");
		Mole m = new Mole();
		m.drawWorld();
		m.dig();
	}
		public void drawWorld(){
			g.rectangle(0, 0, 30, 50, Colors.SOIL);
			
	}
		public void dig() {
		int x = g.getWidth() / 2;
		int y = g.getHeight() / 2;
		while(true) {
			g.block(x, y, Colors.MOLE);
			char key = g.waitForKey();
			g.block(x, y, Colors.TUNNEL);
			if (key == 'w') {
				y--;}
			else if (key == 'a') {
				x--;}
			else if (key == 'd') {
				x++;
			}
			else if (key == 's') {
				y++;
				}
			if(x>29) {
				x--;
			}
			else if(x<1) {
				x++;
			}
			else if(y>48) {
				y--;}
			else if(y<1) {
				y++;
				}
			
			
			System.out.println(y);}
		}
		}
