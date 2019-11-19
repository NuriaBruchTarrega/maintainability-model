package testing;

class Example {
	public static String hasNoDocstring() {
		return "NO DOCSTRING";
	}
	
	/**
	 * Returns a string
	 * 
	 * @return A string
	 */
	public static String hasDocstring() {
		return "DOCSTRING";
	}
	
	/*
	 * Not a valid Javadoc
	 */
	public static int duplicate1() {
		int a = 1;
		int b = 1;
		int c = 1;
		int d = 1;
		int e = 1;
		int f = 1;
		if (a + b == 2) return b;
		return a;
	}
	
	// Not a valid Javadoc
	public static int duplicate2() {
		int a = 1;
		int b = 1;
		int c = 1;
		int d = 1;
		int e = 1;
		int f = 1;
		return f;
	}
}
