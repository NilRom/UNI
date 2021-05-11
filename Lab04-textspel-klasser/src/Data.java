
import java.util.Random;
public class Data {
String computerchoice = "";
Random r = new Random();
public void generateComputerchoice(){
	int rnum = r.nextInt(3);
	if (rnum == 0) {
		this.computerchoice = "STEN";
	}
	if (rnum == 1) {
		this.computerchoice = "SAX";
	}
	if (rnum == 2) {
		this.computerchoice = "PÅSE";
	}
}
public String getComputerchoice() {
	return computerchoice;
}



}
