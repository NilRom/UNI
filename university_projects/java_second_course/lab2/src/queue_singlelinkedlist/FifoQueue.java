package queue_singlelinkedlist;

import java.util.*;

public class FifoQueue<E> extends AbstractQueue<E> implements Queue<E> {
	private QueueNode<E> last;
	private int size;

	public FifoQueue() {
		super();
		last = null;
		size = 0;
	}

	/**
	 * Inserts the specified element into this queue, if possible post: The
	 * specified element is added to the rear of this queue
	 * 
	 * @param e the element to insert
	 * @return true if it was possible to add the element to this queue, else false
	 */
	public boolean offer(E e) {
		QueueNode<E> temp = new QueueNode<E>(e);
		if (size != 0) {
			temp.setNext(last.getNext());
			this.last.setNext(temp);
		}
		if (size == 0) {
			temp.setNext(temp);
		}
		this.last = temp;
		if (this.last == temp) {
			size++;
			return true;
		} else {
			return false;
		}
	}

	/**
	 * Returns the number of elements in this queue
	 * 
	 * @return the number of elements in this queue
	 */
	public int size() {
		return size;
	}

	/**
	 * Retrieves, but does not remove, the head of this queue, returning null if
	 * this queue is empty
	 * 
	 * @return the head element of this queue, or null if this queue is empty
	 */
	public E peek() {
		if (size != 0) {
			return this.last.getNext().getElement();
		} else {
			return null;
		}
	}

	/**
	 * Retrieves and removes the head of this queue, or null if this queue is empty.
	 * post: the head of the queue is removed if it was not empty
	 * 
	 * @return the head of this queue, or null if the queue is empty
	 */
	public E poll() {
		if (size > 1) {
			E temp = this.last.getNext().getElement();
			last = last.getNext();
			size--;
			return temp;
		} else if (size == 1) {
			E temp = this.last.getNext().getElement();
			last = null;
			size--;
			return temp;
		} else {
			return null;
		}
	}

	/**
	 * Appends the specified queue to this queue post: all elements from the
	 * specified queue are appended to this queue. The specified queue (q) is empty
	 * 
	 * @param q the queue to append
	 */
	public void append(FifoQueue<E> q) {
		if (this == q) {
			throw new IllegalArgumentException();
		} else if (q.isEmpty()) {
			return;
		} else if (this.isEmpty()) {
			this.last = q.last;
			this.size = q.size;
			q.last = null;
			q.size = 0;
		} else {

			QueueNode<E> temp = this.last.next;
			this.last.next = q.last.next;
			this.last = q.last;
			this.size = this.size() + q.size();
			this.last.next = temp;
			q.last = null;
			q.size = 0;

		}
	}

	/**
	 * Returns an iterator over the elements in this queue
	 * 
	 * @return an iterator over the elements in this queue
	 */
	public Iterator<E> iterator() {
		return new QueueIterator();
	}

	private class QueueIterator implements Iterator<E> {
		private QueueNode<E> pos;

		private QueueIterator() {
			if (last != null) {
				pos = last.next;
			} else {
				pos = null;
			}
		}

		@Override
		public boolean hasNext() {
			return pos != null;
		}

		@Override
		public E next() {
			if (hasNext()) {
				QueueNode<E> temp = pos;
				if (pos == last || last.next == last) {
					pos = null;
				} else {
					pos = pos.next;
				}
				return temp.getElement();
			} else {
				throw new NoSuchElementException();
			}
		}
	}

	private static class QueueNode<E> {
		E element;
		QueueNode<E> next;

		private QueueNode(E x) {
			element = x;
			next = null;
		}

		private E getElement() {
			return element;
		}

		private QueueNode<E> getNext() {
			return next;
		}

		private void setNext(QueueNode<E> nextNode) {
			if (!nextNode.equals(null)) {
				this.next = nextNode;
			}
		}
	}

}
