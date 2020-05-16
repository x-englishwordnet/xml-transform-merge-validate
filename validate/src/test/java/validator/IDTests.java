package validator;

import static org.junit.jupiter.api.Assertions.*;

import org.junit.jupiter.api.Test;

class IDTests
{
	@Test
	void test()
	{
		assertFalse(XMLChar.isValidName(""));
		assertTrue(XMLChar.isValidName("ab"));
		assertFalse(XMLChar.isValidName("a b"));
		assertFalse(XMLChar.isValidName("a;b"));
		assertFalse(XMLChar.isValidName("a,b"));
		assertTrue(XMLChar.isValidName("a:b"));
		assertTrue(XMLChar.isValidName("a.b"));
		assertTrue(XMLChar.isValidName("aʻb"));
		assertFalse(XMLChar.isValidName("a'b"));
		assertTrue(XMLChar.isValidName("a_b"));
		assertTrue(XMLChar.isValidName("ewn-Hawaiʻi_Volcanoes_National_Park-n"));
		assertFalse(XMLChar.isValidName("ewn-Hawai'i_Volcanoes_National_Park-n"));
	}
}
