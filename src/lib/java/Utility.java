package lib.java;

import java.math.BigInteger;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

import io.usethesource.vallang.*;


public class Utility {
	protected final IValueFactory values;
	
	public Utility(IValueFactory values){
		this.values = values;
	}
	
	public IValue md5HashFile(IValue input) throws NoSuchAlgorithmException {
		MessageDigest md = MessageDigest.getInstance("MD5");
		[]byte hash = md.digest();
		hashNumber = new BigInteger(hash);
		BigInteger bucketAmount = new BigInteger("1000");
		number.mod(bucketAmount)
		return values.string(md.digest("Hello"));
	}
}
