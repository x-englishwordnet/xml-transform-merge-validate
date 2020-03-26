package validator;

/*
 * Xerces class modified as per [4][4a][5] BNF in XSD specification
 *
 * The Apache Software License, Version 1.1
 *
 *
 * Copyright (c) 1999-2002 The Apache Software Foundation.  All rights
 * reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 *
 * 1. Redistributions of source code must retain the above copyright
 *    notice, this list of conditions and the following disclaimer.
 *
 * 2. Redistributions in binary form must reproduce the above copyright
 *    notice, this list of conditions and the following disclaimer in
 *    the documentation and/or other materials provided with the
 *    distribution.
 *
 * 3. The end-user documentation included with the redistribution,
 *    if any, must include the following acknowledgment:
 *       "This product includes software developed by the
 *        Apache Software Foundation (http://www.apache.org/)."
 *    Alternately, this acknowledgment may appear in the software itself,
 *    if and wherever such third-party acknowledgments normally appear.
 *
 * 4. The names "Xerces" and "Apache Software Foundation" must
 *    not be used to endorse or promote products derived from this
 *    software without prior written permission. For written
 *    permission, please contact apache@apache.org.
 *
 * 5. Products derived from this software may not be called "Apache",
 *    nor may "Apache" appear in their name, without prior written
 *    permission of the Apache Software Foundation.
 *
 * THIS SOFTWARE IS PROVIDED ``AS IS'' AND ANY EXPRESSED OR IMPLIED
 * WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
 * OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 * DISCLAIMED.  IN NO EVENT SHALL THE APACHE SOFTWARE FOUNDATION OR
 * ITS CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
 * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
 * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF
 * USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
 * ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
 * OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT
 * OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
 * SUCH DAMAGE.
 * ====================================================================
 *
 * This software consists of voluntary contributions made by many
 * individuals on behalf of the Apache Software Foundation and was
 * originally based on software copyright (c) 1999, International
 * Business Machines, Inc., http://www.apache.org.  For more
 * information on the Apache Software Foundation, please see
 * <http://www.apache.org/>.
 */

/**
 * This class defines the basic XML character properties. The data in this class
 * can be used to verify that a character is a valid XML character or if the
 * character is a space, name start, or name character.
 * <p>
 * A series of convenience methods are supplied to ease the burden of the
 * developer. Because inlining the checks can improve per character performance,
 * the tables of character properties are public. Using the character as an
 * index into the <code>CHARS</code> array and applying the appropriate mask
 * flag (e.g. <code>MASK_VALID</code>), yields the same results as calling the
 * convenience methods. There is one exception: check the comments for the
 * <code>isValid</code> method for details.
 *
 * @author Glenn Marcy, IBM
 * @author Andy Clark, IBM
 * @author Eric Ye, IBM
 * @author Arnaud Le Hors, IBM
 * @author Rahul Srivastava, Sun Microsystems Inc.
 * @author Bernard Bou, updated to new spec
 *
 * @version $Id: XMLChar.java,v 1.12 2002/12/07 00:24:06 neilg Exp $
 */
public class XMLChar {

	//
	// Constants
	//

	private static final int w = 1 << 20;

	/** Character flags. */
	private static final byte[] CHARS = new byte[w];

	/** Valid character mask. */
	public static final int MASK_VALID = 0x01;

	/** Space character mask. */
	public static final int MASK_SPACE = 0x02;

	/** Name start character mask. */
	public static final int MASK_NAME_START = 0x04;

	/** Name character mask. */
	public static final int MASK_NAME = 0x08;

	/** Pubid character mask. */
	public static final int MASK_PUBID = 0x10;

	/**
	 * Content character mask. Special characters are those that can be considered
	 * the start of markup, such as '&lt;' and '&amp;'. The various newline
	 * characters are considered special as well. All other valid XML characters can
	 * be considered content.
	 * <p>
	 * This is an optimization for the inner loop of character scanning.
	 */
	public static final int MASK_CONTENT = 0x20;

	/** NCName start character mask. */
	public static final int MASK_NCNAME_START = 0x40;

	/** NCName character mask. */
	public static final int MASK_NCNAME = 0x80;

	//
	// Debug init by putting chars in targets
	//
	static final int[] debugTargets = {}; //{ 0x2BB, '\'' };

	static void hook(int c, String where) {
		for (int t : debugTargets)
			if (c == t)
				System.out.printf("'%c' defined in %s\n", t, where);
	}

	//
	// Static initialization
	//
	static {

		//
		// [2] Char ::= #x9 | #xA | #xD | [#x20-#xD7FF] |
		// [#xE000-#xFFFD] | [#x10000-#x10FFFF]
		//

		int charRange[] = { 0x0009, 0x000A, 0x000D, 0x000D, 0x0020, 0xD7FF, 0xE000, 0xFFFD, };

		//
		// [3] S ::= (#x20 | #x9 | #xD | #xA)+
		//

		int spaceChar[] = { 0x0020, 0x0009, 0x000D, 0x000A, };

		//
		// [4] NameStartChar ::= ":" | [A-Z] | "_" | [a-z] | [#xC0-#xD6] | [#xD8-#xF6] |
		// [#xF8-#x2FF] | [#x370-#x37D] | [#x37F-#x1FFF] | [#x200C-#x200D] |
		// [#x2070-#x218F] | [#x2C00-#x2FEF] | [#x3001-#xD7FF] | [#xF900-#xFDCF] |
		// [#xFDF0-#xFFFD] | [#x10000-#xEFFFF]
		//

		int nameStartChar[] = { ':', '_', };

		int nameStartRange[] = { //
				'a', 'z', //
				'A', 'Z', //
				0xC0, 0xD6, //
				0xD8, 0xF6, //
				0xF8, 0x2FF, //
				0x370, 0x37D, //
				0x37F, 0x1FFF, //
				0x200C, 0x200D, //
				0x2070, 0x218F, //
				0x2C00, 0x2FEF, //
				0x3001, 0xD7FF, //
				0xF900, 0xFDCF, //
				0xFDF0, 0xFFFD, //
				0x10000, 0xEFFFF, //
		};

		//
		// [4a] NameChar ::= NameStartChar | "-" | "." | [0-9] | #xB7 | [#x0300-#x036F]
		// | [#x203F-#x2040]
		//
		int nameChar[] = { '-', '.', // '-' and '.'
				0xB7, };

		int nameRange[] = { '0', '9', //
				0x0300, 0x036F, //
				0x203F, 0x2040, //
		};

		//
		// [13] PubidChar ::= #x20 | 0xD | 0xA | [a-zA-Z0-9] | [-'()+,./:=?;!*#@$_%]
		//

		int pubidChar[] = { 0x000A, 0x000D, 0x0020, 0x0021, 0x0023, 0x0024, 0x0025, 0x003D, 0x005F };

		int pubidRange[] = { 0x0027, 0x003B, 0x003F, 0x005A, 0x0061, 0x007A };

		//
		// SpecialChar ::= '<', '&', '\n', '\r', ']'
		//

		int specialChar[] = { '<', '&', '\n', '\r', ']', };

		//
		// Initialize
		//

		// set valid characters
		for (int i = 0; i < charRange.length; i += 2) {
			for (int j = charRange[i]; j <= charRange[i + 1]; j++) {
				CHARS[j] |= MASK_VALID | MASK_CONTENT;
				hook(j, "charRange");
			}
		}

		// remove special characters
		for (int i = 0; i < specialChar.length; i++) {
			CHARS[specialChar[i]] = (byte) (CHARS[specialChar[i]] & ~MASK_CONTENT);
			hook(i, "specialChar");
		}

		// set space characters
		for (int i = 0; i < spaceChar.length; i++) {
			CHARS[spaceChar[i]] |= MASK_SPACE;
			hook(i, "spaceChar");
		}

		// set name start + name characters + nc name start + nc name characters
		for (int i = 0; i < nameStartChar.length; i++) {
			CHARS[nameStartChar[i]] |= MASK_NAME_START | MASK_NAME | MASK_NCNAME_START | MASK_NCNAME;
			hook(i, "nameStartChar");
		}
		for (int i = 0; i < nameStartRange.length; i += 2) {
			for (int j = nameStartRange[i]; j <= nameStartRange[i + 1]; j++) {
				CHARS[j] |= MASK_NAME_START | MASK_NAME | MASK_NCNAME_START | MASK_NCNAME;
				hook(j, "nameStartRange");
			}
		}
		// set extra name characters + nc name characters
		for (int i = 0; i < nameChar.length; i++) {
			CHARS[nameChar[i]] |= MASK_NAME | MASK_NCNAME;
			hook(i, "nameChar");
		}
		for (int i = 0; i < nameRange.length; i += 2) {
			for (int j = nameRange[i]; j <= nameRange[i + 1]; j++) {
				CHARS[j] |= MASK_NAME | MASK_NCNAME;
				hook(j, "nameRange");
			}
		}

		// remove ':' from allowable MASK_NCNAME_START and MASK_NCNAME chars
		CHARS[':'] &= ~(MASK_NCNAME_START | MASK_NCNAME);

		// set Pubid characters
		for (int i = 0; i < pubidChar.length; i++) {
			CHARS[pubidChar[i]] |= MASK_PUBID;
		}
		for (int i = 0; i < pubidRange.length; i += 2) {
			for (int j = pubidRange[i]; j <= pubidRange[i + 1]; j++) {
				CHARS[j] |= MASK_PUBID;
			}
		}

	} // <clinit>()

	//
	// Public static methods
	//

	/**
	 * Returns true if the specified character is a supplemental character.
	 *
	 * @param c The character to check.
	 */
	public static boolean isSupplemental(int c) {
		return (c >= 0x10000 && c <= 0x10FFFF);
	}

	/**
	 * Returns true the supplemental character corresponding to the given
	 * surrogates.
	 *
	 * @param h The high surrogate.
	 * @param l The low surrogate.
	 */
	public static int supplemental(char h, char l) {
		return (h - 0xD800) * 0x400 + (l - 0xDC00) + 0x10000;
	}

	/**
	 * Returns the high surrogate of a supplemental character
	 *
	 * @param c The supplemental character to "split".
	 */
	public static char highSurrogate(int c) {
		return (char) (((c - 0x00010000) >> 10) + 0xD800);
	}

	/**
	 * Returns the low surrogate of a supplemental character
	 *
	 * @param c The supplemental character to "split".
	 */
	public static char lowSurrogate(int c) {
		return (char) (((c - 0x00010000) & 0x3FF) + 0xDC00);
	}

	/**
	 * Returns whether the given character is a high surrogate
	 *
	 * @param c The character to check.
	 */
	public static boolean isHighSurrogate(int c) {
		return (0xD800 <= c && c <= 0xDBFF);
	}

	/**
	 * Returns whether the given character is a low surrogate
	 *
	 * @param c The character to check.
	 */
	public static boolean isLowSurrogate(int c) {
		return (0xDC00 <= c && c <= 0xDFFF);
	}

	/**
	 * Returns true if the specified character is valid. This method also checks the
	 * surrogate character range from 0x10000 to 0x10FFFF.
	 * <p>
	 * If the program chooses to apply the mask directly to the <code>CHARS</code>
	 * array, then they are responsible for checking the surrogate character range.
	 *
	 * @param c The character to check.
	 */
	public static boolean isValid(int c) {
		return (c < 0x10000 && (CHARS[c] & MASK_VALID) != 0) || (0x10000 <= c && c <= 0x10FFFF);
	} // isValid(int):boolean

	/**
	 * Returns true if the specified character is invalid.
	 *
	 * @param c The character to check.
	 */
	public static boolean isInvalid(int c) {
		return !isValid(c);
	} // isInvalid(int):boolean

	/**
	 * Returns true if the specified character can be considered content.
	 *
	 * @param c The character to check.
	 */
	public static boolean isContent(int c) {
		return (c < 0x10000 && (CHARS[c] & MASK_CONTENT) != 0) || (0x10000 <= c && c <= 0x10FFFF);
	} // isContent(int):boolean

	/**
	 * Returns true if the specified character can be considered markup. Markup
	 * characters include '&lt;', '&amp;', and '%'.
	 *
	 * @param c The character to check.
	 */
	public static boolean isMarkup(int c) {
		return c == '<' || c == '&' || c == '%';
	} // isMarkup(int):boolean

	/**
	 * Returns true if the specified character is a space character as defined by
	 * production [3] in the XML 1.0 specification.
	 *
	 * @param c The character to check.
	 */
	public static boolean isSpace(int c) {
		return c < 0x10000 && (CHARS[c] & MASK_SPACE) != 0;
	} // isSpace(int):boolean

	/**
	 * Returns true if the specified character is a valid name start character as
	 * defined by production [5] in the XML 1.0 specification.
	 *
	 * @param c The character to check.
	 */
	public static boolean isNameStart(int c) {
		return c < 0x10000 && (CHARS[c] & MASK_NAME_START) != 0;
	} // isNameStart(int):boolean

	/**
	 * Returns true if the specified character is a valid name character as defined
	 * by production [4] in the XML 1.0 specification.
	 *
	 * @param c The character to check.
	 */
	public static boolean isName(int c) {
		return c < 0x10000 && (CHARS[c] & MASK_NAME) != 0;
	} // isName(int):boolean

	/**
	 * Returns true if the specified character is a valid NCName start character as
	 * defined by production [4] in Namespaces in XML recommendation.
	 *
	 * @param c The character to check.
	 */
	public static boolean isNCNameStart(int c) {
		return c < 0x10000 && (CHARS[c] & MASK_NCNAME_START) != 0;
	} // isNCNameStart(int):boolean

	public static byte data(int c) {
		return c < w ? CHARS[c] : -1;
	}

	/**
	 * Returns true if the specified character is a valid NCName character as
	 * defined by production [5] in Namespaces in XML recommendation.
	 *
	 * @param c The character to check.
	 */
	public static boolean isNCName(int c) {
		return c < 0x10000 && (CHARS[c] & MASK_NCNAME) != 0;
	} // isNCName(int):boolean

	/**
	 * Returns true if the specified character is a valid Pubid character as defined
	 * by production [13] in the XML 1.0 specification.
	 *
	 * @param c The character to check.
	 */
	public static boolean isPubid(int c) {
		return c < 0x10000 && (CHARS[c] & MASK_PUBID) != 0;
	} // isPubid(int):boolean

	/*
	 * [5] Name ::= (Letter | '_' | ':') (NameChar)*
	 */
	/**
	 * Check to see if a string is a valid Name according to [5] in the XML 1.0
	 * Recommendation
	 *
	 * @param name string to check
	 * @return true if name is a valid Name
	 */
	public static boolean isValidName(String name) {
		if (name.length() == 0)
			return false;
		char ch = name.charAt(0);
		if (isNameStart(ch) == false)
			return false;
		for (int i = 1; i < name.length(); i++) {
			ch = name.charAt(i);
			if (isName(ch) == false) {
				return false;
			}
		}
		return true;
	} // isValidName(String):boolean

	/*
	 * from the namespace rec [4] NCName ::= (Letter | '_') (NCNameChar)*
	 */
	/**
	 * Check to see if a string is a valid NCName according to [4] from the XML
	 * Namespaces 1.0 Recommendation
	 *
	 * @param name string to check
	 * @return true if name is a valid NCName
	 */
	public static boolean isValidNCName(String ncName) {
		if (ncName.length() == 0)
			return false;
		char ch = ncName.charAt(0);
		if (isNCNameStart(ch) == false)
			return false;
		for (int i = 1; i < ncName.length(); i++) {
			ch = ncName.charAt(i);
			if (isNCName(ch) == false) {
				return false;
			}
		}
		return true;
	} // isValidNCName(String):boolean

	/*
	 * [7] Nmtoken ::= (NameChar)+
	 */
	/**
	 * Check to see if a string is a valid Nmtoken according to [7] in the XML 1.0
	 * Recommendation
	 *
	 * @param nmtoken string to check
	 * @return true if nmtoken is a valid Nmtoken
	 */
	public static boolean isValidNmtoken(String nmtoken) {
		if (nmtoken.length() == 0)
			return false;
		for (int i = 0; i < nmtoken.length(); i++) {
			char ch = nmtoken.charAt(i);
			if (!isName(ch)) {
				return false;
			}
		}
		return true;
	} // isValidName(String):boolean

	// encodings

	/**
	 * Returns true if the encoding name is a valid IANA encoding. This method does
	 * not verify that there is a decoder available for this encoding, only that the
	 * characters are valid for an IANA encoding name.
	 *
	 * @param ianaEncoding The IANA encoding name.
	 */
	public static boolean isValidIANAEncoding(String ianaEncoding) {
		if (ianaEncoding != null) {
			int length = ianaEncoding.length();
			if (length > 0) {
				char c = ianaEncoding.charAt(0);
				if ((c >= 'A' && c <= 'Z') || (c >= 'a' && c <= 'z')) {
					for (int i = 1; i < length; i++) {
						c = ianaEncoding.charAt(i);
						if ((c < 'A' || c > 'Z') && (c < 'a' || c > 'z') && (c < '0' || c > '9') && c != '.' && c != '_'
								&& c != '-') {
							return false;
						}
					}
					return true;
				}
			}
		}
		return false;
	} // isValidIANAEncoding(String):boolean

	/**
	 * Returns true if the encoding name is a valid Java encoding. This method does
	 * not verify that there is a decoder available for this encoding, only that the
	 * characters are valid for an Java encoding name.
	 *
	 * @param javaEncoding The Java encoding name.
	 */
	public static boolean isValidJavaEncoding(String javaEncoding) {
		if (javaEncoding != null) {
			int length = javaEncoding.length();
			if (length > 0) {
				for (int i = 1; i < length; i++) {
					char c = javaEncoding.charAt(i);
					if ((c < 'A' || c > 'Z') && (c < 'a' || c > 'z') && (c < '0' || c > '9') && c != '.' && c != '_'
							&& c != '-') {
						return false;
					}
				}
				return true;
			}
		}
		return false;
	} // isValidIANAEncoding(String):boolean

} // class XMLChar
