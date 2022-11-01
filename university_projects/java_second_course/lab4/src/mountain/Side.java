package mountain;

public class Side {
	private Point p1;
	private Point p2;
	
	public Side(Point p1,Point p2) {
		this.p1 = p1;
		this.p2 = p2;
	}
	@Override
	public int hashCode() {
		return p1.hashCode() + p2.hashCode();
	}
	
	
	@Override
	public boolean equals(Object otherSide) {
		Side temp = (Side)otherSide;
		if(( temp.p1.equals(this.p1) && temp.p2.equals(this.p2) ) || (temp.p1.equals(this.p2) && temp.p2.equals(this.p1) )){
			return true;
		}else {
			return false;
		}
	}
}
