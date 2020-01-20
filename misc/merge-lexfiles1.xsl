<xsl:transform version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="xml" indent="yes"/>
  <xsl:param name="updateFileName" select="'updates.xml'" />
  <xsl:param name="updates" select="document($updateFileName)" />

  <xsl:variable name="updateItems" select="$updates/LexicalResource/Lexicon/LexicalEntry" />

  <xsl:template match="@* | node()">
    <xsl:copy>
      <xsl:apply-templates select="@* | node()"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="LexicalEntry">
    <xsl:copy>
      <xsl:apply-templates select="@* | node()[not(self::entry)] | entry[not(id = $updateItems/id)]" />
      <xsl:apply-templates select="$updateItems" />
    </xsl:copy>
  </xsl:template>

</xsl:transform>
