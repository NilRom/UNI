package bst;

import java.util.ArrayList;
import java.util.Comparator;
import java.util.Random;


public class BinarySearchTree<E> {
	BinaryNode<E> root; // Används också i BSTVisaulizer
	int size; // Används också i BSTVisaulizer
	private Comparator<E> comparator;
	
	// testing stuff
	private static String[] TESTWORDS = { "frankofil","boll","yxa","veteran","jägarsoldat","hund",
			"katt","snäll","stor","liten","grund","r","g","fem","asdasd","te","fiti","te","rompi","bil","hus","kuk","ica","godis","data","vad","hallå","haj","oj","fasiken","ok","nej","snälla","sluta",
			"kan","du","vara","tyst","var","är","daniel","vet","ej","men","han","ronkar","säkert",
			"kuken", "123", "skulle", "ut", "på", "tur", "när", "han", "upptäckte", "att", "han", "glömt", "sin", "lilla", "jihadi", "anorexic", "girlfriend", "that", "lived", "inside", "his", "dick", "the", "day", "was", "ruined", "the", "end"};

	private static int NBR = TESTWORDS.length;

	/**
	 * Constructs an empty binary search tree.
	 */
	public BinarySearchTree() {
		this.size = 0;
	}

	/**
	 * Constructs an empty binary search tree, sorted according to the specified
	 * comparator.
	 */
	public BinarySearchTree(Comparator<E> comparator) {
		this.comparator = comparator;
		this.size = 0;
	}

	/**
	 * Inserts the specified element in the tree if no duplicate exists.
	 * 
	 * @param x element to be inserted
	 * @return true if the the element was inserted
	 */
	public boolean add(E x) {
		if (this.contains(root, x)) {
			return false;
		} else {
			if (this.root == null) {
				this.root = new BinaryNode<E>(x);
				return true;
			}

			BinaryNode<E> temp = root;
			while (temp.left != null && temp.right != null) {
				temp = temp.left;
			}
			if(temp.right==null) {
				temp.right = new BinaryNode<E>(x);
			}else {
				temp.left = new BinaryNode<E>(x);
			}
			size++;
			return true;
		}
	}

	public boolean contains(BinaryNode<E> node, E key) {
		if (node == null) {
			return false;
		}
		if (node.element.equals(key)) {
			return true;
		}

		boolean leftExists = contains(node.left, key);
		if (leftExists) {
			return true;
		}
		boolean rightExists = contains(node.right, key);
		return rightExists;

	}

	/**
	 * Computes the height of tree.
	 * 
	 * @return the height of the tree
	 */
	public int height() {
		return maxDepth(root);
	}

	private int maxDepth(BinaryNode<E> node) {
		if (node == null) {
			return 0;
		}
		int lDepth = maxDepth(node.left);
		int rDepth = maxDepth(node.right);
		if (lDepth > rDepth) {
			return lDepth + 1;
		} else {
			return rDepth + 1;
		}
	}

	/**
	 * Returns the number of elements in this tree.
	 * 
	 * @return the number of elements in this tree
	 */
	public int size() {
		return this.size;
	}

	/**
	 * Removes all of the elements from this list.
	 */
	public void clear() {
		this.size = 0;
		this.root = null;
	}

	/**
	 * Print tree contents in inorder.
	 */
	public void printTree() {
		print(this.root);
	}

	private void print(BinaryNode<E> node) {
		if (node != null) {
			print(node.left);
			System.out.println(node.element.toString());
			print(node.right);
		}
	}

	/**
	 * Builds a complete tree from the elements in the tree.
	 */
	public void rebuild() {
		ArrayList<E> treelist = new ArrayList<E>();
		toArray(root,treelist);
		treelist.sort(comparator);
		this.root = buildTree(treelist, 0, size());
	}

	/*
	 * Adds all elements from the tree rooted at n in inorder to the list sorted.
	 */
	private void toArray(BinaryNode<E> n, ArrayList<E> sorted) {
		if(n!=null) {
			toArray(n.left,sorted);
			sorted.add(n.element);
			toArray(n.right,sorted);
		}
	}

	/*
	 * Builds a complete tree from the elements from position first to last in the
	 * list sorted. Elements in the list a are assumed to be in ascending order.
	 * Returns the root of tree.
	 */
	private BinaryNode<E> buildTree(ArrayList<E> sorted, int first, int last) {
		if(first>last) {
			return null;
		}
		int mid = (first+last)/2;
		BinaryNode<E> temproot = new BinaryNode<E>(sorted.get(mid));
		temproot.left = buildTree(sorted,first,mid-1);
		temproot.right = buildTree(sorted,mid+1,last);
		return temproot;
	}

	static class BinaryNode<E> {
		E element;
		BinaryNode<E> left;
		BinaryNode<E> right;

		private BinaryNode(E element) {
			this.element = element;

		}

	}

	public static void main(String[] args) {
		BinarySearchTree<Integer> intTree = new BinarySearchTree<Integer>();
		BinarySearchTree<String> stringTree = new BinarySearchTree<String>();
		BSTVisualizer stringviz = new BSTVisualizer("Tree with strings", 400, 400);
		BSTVisualizer intviz = new BSTVisualizer("Tree with integers", 400, 400);
		BSTVisualizer stringvizB = new BSTVisualizer("Tree with strings", 400, 400);
		BSTVisualizer intvizB = new BSTVisualizer("Tree with integers", 400, 400);
		Random rand = new Random();
		for (int i = 0; i < NBR; i++) {
			intTree.add(rand.nextInt(103));
			stringTree.add(TESTWORDS[i]);
		}
		intviz.drawTree(intTree);
		stringviz.drawTree(stringTree);
		intTree.printTree();
		stringTree.printTree();
		intTree.rebuild();
		stringTree.rebuild();
		intvizB.drawTree(intTree);
		stringvizB.drawTree(stringTree);
	}

}
