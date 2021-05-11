

public class array {
	public static void main(String[] args) {
		
		
		public static int maxIndex(int[] v) {
		    int maxNbr = Integer.MIN_VALUE;
		    for (int  i = 0; i < v.length; i++) {
		        if (v[i] > maxNbr) {
		            maxNbr = v[i];
		        }
		    } 
		    for (int  i = 0; i < v.length; i++){
		        int index = 0;
		        if(v[i] == maxNbr){
		            index = v[i];
		        }return index;
		    }
		    
		
		}
	}
}