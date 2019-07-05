package validator;

//if using Xerces validation
//import org.apache.xerces.util.XMLChar;

public class ValidateChars {

	public static void main(String[] args) {

		System.out.println("Char test");
		char c = 'ʻ';
		boolean okValid = XMLChar.isValid(c);
		boolean okName = XMLChar.isName(c);
		boolean okNCName = XMLChar.isNCName(c);
		System.out.printf("'%c' validChar=%b validName=%b  validName=%b\n", c, okValid, okName, okNCName);

		System.out.println();
		System.out.println("ID test");

		final String[] ids = new String[] { "", "ab", "a b", "a;b", "a,b", "a:b", "a.b", "aʻb", "a'b", "a_b",
				"ewn-Hawaiʻi_Volcanoes_National_Park-n", "ewn-Hawai'i_Volcanoes_National_Park-n" };

		for (String id : ids) {
			boolean ok = XMLChar.isValidName(id);
			System.out.printf("'%s' %s\n", id, ok ? "ok" : "fail");
		}

		System.out.println("Done");
	}
}
