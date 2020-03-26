package validator;

//if using Xerces validation
//import org.apache.xerces.util.XMLChar;

public class ValidateChars
{
	public static void main(String[] args)
	{
		char c = args[0].charAt(0);
		System.out.println("Char test of " + c);

		boolean okValid = XMLChar.isValid(c);
		boolean okName = XMLChar.isName(c);
		boolean okNCName = XMLChar.isNCName(c);
		System.out.printf("'%c' validChar=%b validName=%b  validNCName=%b\n", c, okValid, okName, okNCName);
		System.out.println("Done");
	}
}
