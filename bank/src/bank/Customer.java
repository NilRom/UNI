package bank;
public class Customer {
	private String name;
	private long idNr;
	private int customerNr;
	private static int customerNrGenerator = 0;

	public Customer(String name, long idNr) {
		this.name = name;
		this.idNr = idNr;
		customerNrGenerator++;
		this.customerNr=customerNrGenerator;
		
	}

	public String getName() {
		return name;
	}

	public long getIdNr() {
		return idNr;
	}

	public int getCustomerNr() {
		return customerNr;
	}
	public String ToString() {
		return "Namn; " + name  + "\n" + "idNr: " + idNr ;
	}
}
