package transformer;

import java.util.Arrays;

public class XMLTransform
{
	/**
	 * Validate all
	 *
	 * @param xsl
	 *            xsl path
	 * @param filenames
	 *            files
	 */
	public static void transform(final String xsd, final String... filenames)
	{
	}

	/**
	 * Main
	 *
	 * @param args
	 *            args[0] xsl, args[1..] files to validate
	 */
	public static void main(final String[] args)
	{
		transform(args[0], Arrays.copyOfRange(args, 1, args.length));
		System.out.println("Done");
	}
}
