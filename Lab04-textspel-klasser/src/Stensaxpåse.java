import java.util.Scanner;

public class Stensaxpåse {

	public static void main(String[] args) {
		
		String playerchoice; //Attribut för att beskriva vad man valt
		Data d = new Data(); //Dataobjekt för att anropa Data metoden i data klassen
		Scanner scan = new Scanner(System.in); //scanner objekt för att anropa scanner
		System.out.println("Hej! Nu ska vi spela sten, sax påse. Skriv vad du väljer av de tre alternativen(Sten sax eller påse) i terminalen.");
		System.out.println(" Varje vinst ger ett poäng, varje förlust ger datorn ett poäng");
		System.out.println("Om du vill avsluta spelet kan du skriva 'Nej' i terminalen"); //Massa text som förklarar spelet
		int ppoints = 0; //poängräknare för datorn och spelaren
		int cpoints = 0;
		while(true) {
			System.out.println("Du har " + ppoints + " poäng");
			System.out.println("Datorn har " + cpoints + " poäng"); //skriver ut ställningen 
		d.generateComputerchoice(); //anropar metod för att generera datorns val slumpmässigt
		String cchoice = d.getComputerchoice(); //sparar valet i lokal variabel 
		playerchoice = scan.next(); //sparar in spelarens val 
		playerchoice = playerchoice.toUpperCase(); //ändrar så man slipper bry sig om upper/lower 
		if(playerchoice.contentEquals("NEJ")) {
			System.out.println("Tack för att du spelade");
			if(ppoints < cpoints) {
				System.out.println("Datorn fick fler poäng än du, du förlorade. LOSER");
			}
			else if(ppoints>cpoints) {
				System.out.println("Du avslutade spelet med fler poäng än datorn. Du vann. Bra jobbat");
				
			}
			else {
				System.out.println("Du och datorn hade lika många poäng när spelet avslutades. Det blev lika");
			}
			break;}
		
		System.out.println("Du valde " + playerchoice);
		System.out.println("Datorn valde " + cchoice);
		
		if (cchoice.equals(playerchoice)) {
			System.out.println("Wow! Det blev lika");
		}
		else if(cchoice.equals("STEN")&&playerchoice.contentEquals("SAX")) {
			System.out.println("Din sax krossades av en elak sten. Du förlorade, loser. Bättre lycka nästa gång");
			cpoints++;}
		else if(cchoice.equals("PÅSE")&&playerchoice.contentEquals("SAX")) {
			System.out.println("Din sax klippte sönder datorns påse. Du vann. Grattis till poängen");
			ppoints++;}
		else if(cchoice.equals("STEN")&&playerchoice.contentEquals("PÅSE")) {
			System.out.println("Du fångade datorns sten i en påse. Du vann. Grattis till poängen");
			ppoints++;}
		else if(cchoice.equals("SAX")&&playerchoice.contentEquals("PÅSE")) {
			System.out.println("Din påse klipptes isär av datorns sax. Du förlorade. Bättre lycka nästa gång");
			cpoints++;}
		else if(cchoice.equals("SAX")&&playerchoice.contentEquals("STEN")) {
			System.out.println("Datorn sax krossades av din sten. Du vann. Grattis till poängen");
			ppoints++;}
		else if(cchoice.equals("PÅSE")&&playerchoice.contentEquals("STEN")) {
			System.out.println("Din sten fångades av datorns påse. Du förlorade. Bättre lycka nästa gång");
			cpoints++;} //Ett gäng ifsatser för att avgöra vad som hände. 
	}

}}
