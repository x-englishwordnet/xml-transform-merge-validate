<xsl:stylesheet version="3.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema"
	xmlns:my="https://1313ou.github.io/ewn-transform3">

	<xsl:output
		omit-xml-declaration="no"
		method="xml"
		version="1.0"
		encoding="UTF-8"
		indent="yes"
		doctype-system="http://globalwordnet.github.io/schemas/WN-LMF-relaxed-1.0.dtd" />
	<xsl:strip-space elements="*" />

	<xsl:variable name="debug" select="true()" />

	<xsl:function name="my:strip" as="xs:string">
		<xsl:param name="str" as="xs:string" />
		<xsl:sequence select="replace(replace($str,'--a$','-a'),'-a-|-ip-|-p-|--', '-')" />
	</xsl:function>

	<xsl:key name="get-group" match="*[@id]" use="my:strip(@id)" />

	<xsl:template match="/">
		<xsl:copy>
			<xsl:apply-templates select="@*|node()" />
		</xsl:copy>
	</xsl:template>

	<xsl:template match="node() | @*">
		<xsl:copy>
			<xsl:apply-templates select="node() | @*" />
		</xsl:copy>
	</xsl:template>

	<xsl:template match="LexicalEntry">
		<xsl:variable name="myGID" select="my:strip(@id)" />
		<xsl:variable name="myGroup" select="key('get-group', $myGID)" />
		<xsl:variable name="id1" select="generate-id()" />
		<xsl:variable name="id2" select="generate-id($myGroup[1])" />

		<xsl:if test="$debug">
			<xsl:message>
				<xsl:text>ele=</xsl:text>
				<xsl:value-of select="./@id" />
				<xsl:text>&#xa;</xsl:text>

				<xsl:text>gid=</xsl:text>
				<xsl:value-of select="$myGID" />
				<xsl:text>&#xa;</xsl:text>

				<xsl:text>count=</xsl:text>
				<xsl:value-of select="count($myGroup)" />
				<xsl:text> group=</xsl:text>
				<xsl:for-each select="$myGroup">
					<xsl:value-of select="./@id" />
					<xsl:text> </xsl:text>
				</xsl:for-each>
				<xsl:text>&#xa;</xsl:text>
				<!-- <xsl:text>id1=</xsl:text> -->
				<!-- <xsl:value-of select="$id1" /> -->
				<!-- <xsl:text>&#xa;</xsl:text> -->
				<!-- <xsl:text>id2=</xsl:text> -->
				<!-- <xsl:value-of select="$id2" /> -->
				<!-- <xsl:text>&#xa;</xsl:text> -->
				<xsl:text>is first in group=</xsl:text>
				<xsl:value-of select="$id1 = $id2" />

				<xsl:text>&#xa;</xsl:text>
			</xsl:message>
		</xsl:if>

		<!-- if is first in group -->
		<xsl:if test="$id1 = $id2">
			<xsl:copy>
				<xsl:attribute name="id" select="$myGID" />
<!-- 				<xsl:copy-of select="@*" /> -->
				<!-- copy unique subelements -->
				<xsl:copy-of select="./Lemma" />
				<xsl:copy-of select="./Form" />
				<!-- copy group subelements -->
				<xsl:apply-templates select="$myGroup/Sense" />
				<xsl:apply-templates select="$myGroup/SyntacticRelation" />
			</xsl:copy>
		</xsl:if>
	</xsl:template>
</xsl:stylesheet>
