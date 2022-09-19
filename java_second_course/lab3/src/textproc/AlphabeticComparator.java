package textproc;
import java.util.*;
import java.util.Map.Entry;


public class AlphabeticComparator implements Comparator<Map.Entry<String,Integer>>{

	@Override
	public int compare(Entry<String, Integer> o1, Entry<String, Integer> o2) {
		return o1.getKey().compareTo(o2.getKey());

	}
}
