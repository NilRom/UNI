package textproc;

import java.awt.BorderLayout;
import java.awt.Container;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;
import javax.swing.JButton;
import javax.swing.JFrame;
import javax.swing.JList;
import javax.swing.JOptionPane;
import javax.swing.JPanel;
import javax.swing.JScrollPane;
import javax.swing.JTextField;
import javax.swing.SwingUtilities;

public class BookReaderController {
	private boolean isAlphabetic = true;

	public BookReaderController(GeneralWordCounter counter) {
		SwingUtilities.invokeLater(() -> createWindow(counter, "BookReader", 200, 500));
	}
	
	private void createWindow(GeneralWordCounter counter, String title, int width, int height) {
		JFrame frame = new JFrame(title);

		frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
		Container pane = frame.getContentPane();
		SortedListModel<Map.Entry<String, Integer>> listmodel = new SortedListModel<Entry<String, Integer>>(
				counter.getWordList());
		JList<Entry<String, Integer>> listView = new JList<Entry<String, Integer>>(listmodel);
		JScrollPane scrollPane = new JScrollPane(listView);

		JPanel panel = new JPanel();

		JButton alphabetic = new JButton("Alphabetic");
		alphabetic.addActionListener(e -> {
			listmodel.sort(new AlphabeticComparator());
			isAlphabetic = true;
		});
		JButton frequency = new JButton("Frequency");
		frequency.addActionListener(e -> {
			listmodel.sort(new WordCountComparator());
			isAlphabetic = false;
		});
		JTextField textfield = new JTextField("Enter text to search");
		JButton find = new JButton("Find");
		JOptionPane optionPane = new JOptionPane("Search for a word");
		find.addActionListener(e -> {
			String searchedWord = textfield.getText();
			
			searchedWord = searchedWord.replaceAll("\\s+", "");
			searchedWord = searchedWord.toLowerCase();
			int index = -1;
			boolean found = false;
			List<Map.Entry<String, Integer>> temp = counter.getWordList();
			if (isAlphabetic) {
				temp.sort(new AlphabeticComparator());
				for (Map.Entry<String, Integer> pair : temp) {
					index++;
					if (pair.getKey().equals(searchedWord)) {
						found = true;
						break;
					}
				}
			} else {
				temp.sort(new WordCountComparator());
				for (Map.Entry<String, Integer> pair : temp) {
					index++;
					if (pair.getKey().equals(searchedWord)) {
						found = true;
						break;
					}
				}
			}
			if (!found) {
				optionPane.showMessageDialog(null, "Text does not contain the searched word");
			}
			listView.ensureIndexIsVisible(index);
			listView.setSelectedIndex(index);
		});
		panel.add(optionPane, BorderLayout.EAST);
		panel.add(alphabetic);
		panel.add(frequency);
		panel.add(find, BorderLayout.NORTH);
		pane.add(panel, BorderLayout.SOUTH);
		pane.add(textfield, BorderLayout.NORTH);
		pane.add(scrollPane);
		frame.pack();
		frame.getRootPane().setDefaultButton(find);
		frame.setVisible(true);

	}

}
