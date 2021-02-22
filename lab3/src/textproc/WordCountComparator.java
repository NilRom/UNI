package textproc;
import java.util.*;
import java.util.Map.Entry;


public class WordCountComparator implements Comparator<Map.Entry<String,Integer>>{

	@Override
	public int compare(Entry<String, Integer> o1, Entry<String, Integer> o2) {
		int temp = -(o1.getValue()-o2.getValue());
		if(temp != 0) {
			return temp;
		}
		else {
			return o1.getKey().compareTo(o2.getKey());
		}
		
	}

}
