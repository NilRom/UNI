package map;

public class SimpleHashMap<K, V> implements Map<K, V> {
	private Entry[] entries;
	private int filled;
	private int size = 0;

	public SimpleHashMap() {
		entries = (Entry<K, V>[]) new Entry[16];
		filled = 0;

	}

	public SimpleHashMap(int capacity) {
		entries = (Entry<K, V>[]) new Entry[capacity];
	}

	@Override
	public V get(Object object) {
		K key = (K) object;
		for (int i = 0; i < entries.length; i++) {
			Entry<K, V> currentEntry = entries[i];
			while (currentEntry != null) {
				if (currentEntry.getKey().equals(key)) {
					return currentEntry.value;
				}
				currentEntry = currentEntry.next;
			}
		}
		return null;
	}

	@Override
	public boolean isEmpty() {
		for (int i = 0; i < entries.length; i++) {
			if (entries[i] != null) {
				return false;
			}
		}
		return true;
	}

	@Override
	public V put(K key, V val) {
		int index = index(key);
		Entry<K, V> existingEntry = find(index, key);
		if (existingEntry != null) {
			V temp = existingEntry.value;
			existingEntry.setValue(val);
			return temp;
		}
		Entry<K, V> newEntry = new Entry<K, V>(key, val);
		Entry<K, V> currentEntry = entries[index];
		newEntry.next = currentEntry;
		entries[index] = newEntry;
		size++;
		if ((double) filled / (double) entries.length > 0.75) {
			rehash();
		}
		return null;
	}

	private void rehash() {
		this.size = 0;
		Entry[] oldEntries = entries;
		entries = new Entry[oldEntries.length * 2];
		for (int i = 0; i < entries.length; i++) {
			Entry<K, V> currentEntry = entries[i];
			while (currentEntry != null) {
				K key = currentEntry.getKey();
				V val = currentEntry.getValue();
				put(key, val);
				currentEntry = currentEntry.next;
			}
		}
	}

	@Override
	public V remove(Object object) {
		K key = (K) object;
		int index = index(key);
		Entry<K, V> currentEntry = entries[index];

		// case 1 List empty
		if (currentEntry == null) {
			return null;
		}

		// case 2 remove first element of list
		if (currentEntry.key.equals(key)) {
			V temp = currentEntry.value;
			entries[index] = currentEntry.next;
			this.size--;
			return temp;
			
		}
		// case 3 later
		Entry<K, V> previous = currentEntry;
		currentEntry = currentEntry.next;

		while (currentEntry != null) {
			if (currentEntry.getKey().equals(key)) {
				V temp = currentEntry.value;
				previous.next = currentEntry.next;
				this.size--;
				return temp;
			}
			previous = previous.next;
			currentEntry = currentEntry.next;
		}
		return null;
	}

	@Override
	public int size() {
		return this.size;
	}

	public String show() {
		StringBuilder sb1 = new StringBuilder();

		for (int i = 0; i < entries.length; i++) {
			StringBuilder sb2 = new StringBuilder();
			Entry<K, V> temp = entries[i];
			while (temp != null) {
				sb2.append(temp.toString() + " ");
				temp = temp.next;
			}
			sb1.append(sb2.toString() + "\n");
		}
		return sb1.toString();
	}

	private int index(K key) {
		int index = key.hashCode() % entries.length;
		if (index < 0) {
			index = index + entries.length;
		}
		return index;
	}

	private Entry<K, V> find(int index, K key) {
		Entry<K, V> temp = (Entry<K, V>) entries[index];
		while (temp != null) {
			if (temp.getKey().equals(key)) {
				return temp;
			}
			temp = temp.next;
		}
		return null;
	}

	private static class Entry<K, V> implements Map.Entry<K, V> {
		private K key;
		private V value;
		private Entry<K, V> next;

		public Entry(K key, V value) {
			this.key = key;
			this.value = value;
		}

		@Override
		public K getKey() {
			return key;
		}

		@Override
		public V getValue() {
			return value;
		}

		@Override
		public V setValue(V value) {
			this.value = value;
			return value;
		}

		@Override
		public String toString() {
			return key.toString() + "=" + value.toString();
		}

	}

}
