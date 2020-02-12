<xsl:stylesheet version="3.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema"
	xmlns:my="https://1313ou.github.io/ewn-transform3">

	<xsl:output
		omit-xml-declaration="no"
		method="xml"
		version="1.1"
		encoding="UTF-8"
		indent="yes"
		doctype-system="http://globalwordnet.github.io/schemas/WN-LMF-relaxed-1.0.dtd" />
	<xsl:strip-space elements="*" />

	<xsl:function name="my:strip" as="xs:string">
		<xsl:param name="str" as="xs:string" />
		<xsl:sequence select="replace(replace($str,'--a$','-a'),'-a-|-ip-|-p-|--', '-')" />
	</xsl:function>

	<xsl:key name="find-group" match="*[@id]" use="my:strip(@id)" />

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
		<xsl:variable name="myKey" select="my:strip(@id)" />
		<xsl:variable name="myGroup" select="key('find-group', $myKey)" />
		<xsl:variable name="id1" select="generate-id()" />
		<xsl:variable name="id2" select="generate-id($myGroup[1])" />

		<xsl:message>
			<xsl:text>ele=</xsl:text>
			<xsl:value-of select="./@id" />
			<xsl:text>&#xa;</xsl:text>

			<xsl:text>key=</xsl:text>
			<xsl:value-of select="$myKey" />
			<xsl:text>&#xa;</xsl:text>

			<xsl:text>count=</xsl:text>
			<xsl:value-of select="count($myGroup)" />
			<xsl:text> group=</xsl:text>
			<xsl:for-each select="$myGroup">
				<xsl:value-of select="./@id" />
				<xsl:text> </xsl:text>
			</xsl:for-each>
			<xsl:text>&#xa;</xsl:text>
<!-- 			<xsl:text>id1=</xsl:text> -->
<!-- 			<xsl:value-of select="$id1" /> -->
<!-- 			<xsl:text>&#xa;</xsl:text> -->
<!-- 			<xsl:text>id2=</xsl:text> -->
<!-- 			<xsl:value-of select="$id2" /> -->
<!-- 			<xsl:text>&#xa;</xsl:text> -->
			<xsl:text>is first in group=</xsl:text>
			<xsl:value-of select="$id1 = $id2" />

			<xsl:text>&#xa;</xsl:text>
		</xsl:message>

		<!-- if is first in group -->
		<xsl:if test="$id1 = $id2">
			<xsl:copy>
				<xsl:attribute name="id" select="$myKey" />
<!-- 				<xsl:copy-of select="@*" /> -->
				<!-- copy unique subelements -->
				<xsl:copy-of select="./Lemma" />
				<xsl:copy-of select="./Form" />
				<!-- copy other group subelements -->
				<xsl:apply-templates select="$myGroup/Sense|SyntacticRelation" />
			</xsl:copy>
		</xsl:if>
	</xsl:template>
</xsl:stylesheet>
