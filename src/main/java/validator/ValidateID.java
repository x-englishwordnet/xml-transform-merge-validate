package validator;

//if using Xerces validation
//import org.apache.xerces.util.XMLChar;

public class ValidateID
{
	public static void main(String[] args)
	{
		String id = join(args);
		System.out.println("ID validation of " + id);
		boolean result = XMLChar.isValidName(id);
		System.out.println(result);
		System.err.println("Done");
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
