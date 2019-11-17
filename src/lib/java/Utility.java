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
		return values.string(md.digest("Hello"));
	}
}
