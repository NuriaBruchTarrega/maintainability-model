package lib.java;

import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

import org.rascalmpl.interpreter.utils.RuntimeExceptionFactory;

import io.usethesource.vallang.*;

public class Utility {
	protected final IValueFactory values;

	public Utility(IValueFactory values) {
		this.values = values;
	}

	/**
	 * Creates MD5 hash of a string input.
	 * 
	 * @author Cleverton Hentz
	 * @see https://github.com/usethesource/rascal/pull/1056
	 */
	public IString hashMD5(IString in) throws IOException {
		byte[] hash;
		try {
			MessageDigest md = MessageDigest.getInstance("MD5");
			md.update(StandardCharsets.UTF_8.encode(in.getValue()));
			hash = md.digest();
		} catch (NoSuchAlgorithmException e) {
			throw RuntimeExceptionFactory.io(values.string("Cannot load MD5 digest algorithm"), null, null);
		}

		StringBuffer result = new StringBuffer(hash.length * 2);
		for (int i = 0; i < hash.length; i++) {
			result.append(Integer.toString((hash[i] & 0xff) + 0x100, 16).substring(1));
		}
		return values.string(result.toString());
	}
}
