package validator;

//if using Xerces validation
//import org.apache.xerces.util.XMLChar;

public class ValidateChars
{
	public static void main(String[] args)
	{
		String str = join(args);
		System.out.println("Char tests of " + str);

		for (int i = 0; i < str.length(); i++)
		{
			char c = str.charAt(i);
			boolean okValid = XMLChar.isValid(c);
			boolean okName = XMLChar.isName(c);
			boolean okNCName = XMLChar.isNCName(c);
			System.out.printf("'%c'	validChar=%b validName=%b validNCName=%b\n", c, okValid, okName, okNCName);
		}
	}

	private static String join(String[] args)
	{
		StringBuilder sb = new StringBuilder();
		boolean first = true;
		for (String arg : args)
		{
			if (first)
				first = false;
			else
				sb.append(' ');
			sb.append(arg);
		}
		return sb.toString();
	}
}
