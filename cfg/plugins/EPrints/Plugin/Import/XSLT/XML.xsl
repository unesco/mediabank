<?xml version="1.0"?>

    <xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" ept:name="myXML" ept:visible="all" ept:advertise="1" ept:sourceNamespace="http://purl.org/dc/elements/1.1/" ept:targetNamespace="http://eprints.org/ep2/data/2.0" ept:produce="list/eprint" xmlns:ept="http://eprints.org/ep2/xslt/1.0" xmlns:opf="http://www.idpf.org/2007/opf" xmlns="http://eprints.org/ep2/data/2.0">
        <xsl:output method="xml" indent="yes" encoding="utf-8" />

        <xsl:template match="/">
            <eprints>
                <xsl:apply-templates select="eprints/eprint" />
            </eprints>
        </xsl:template>

        <xsl:template match="eprint">
            <eprint>
                <eprint_status>archive</eprint_status>
                <userid>1</userid>
                <type>image</type>
                <metadata_visibility>show</metadata_visibility>
                <contact_email>mediabank@unesco.org</contact_email>
                <divisions>ERI/DPI</divisions>
                <full_text_status>public</full_text_status>
                <keywords>
                    <item>Import</item>
                </keywords>
                <documents>
                    <document>
                        <price>100</price>
                        <files>
                            <file>
                                <datasetid>image</datasetid>
                                <filename><xsl:value-of select="./str_unescoRef" />.jpg</filename>
                                <url>file:///home/denix/photobank/<xsl:value-of select="./str_unescoRef" />.jpg</url>
                            </file>
                        </files>
                        <format>image</format>
                        <security>paypal</security>
                        <main><xsl:value-of select="./str_unescoRef" />.jpg</main>
                    </document>
                </documents>

                <xsl:apply-templates select="num_objectUID" />
                <xsl:apply-templates select="str_countryId" />
                <xsl:apply-templates select="str_copyright" />
                <xsl:apply-templates select="str_yearShoot" />
                <xsl:apply-templates select="lib_photobank_description" />
                <creators>
                    <xsl:apply-templates select="str_photographer" />
                </creators>
                <subjects>
                    <xsl:apply-templates select="int_themeId|num_subthemes" />
                </subjects>
            </eprint>
        </xsl:template>

        <xsl:template match="num_objectUID">
            <eprintid><xsl:value-of select="." /></eprintid>
            <source>UNESCO Photobank</source>
            <job_identifier> Folder: <xsl:value-of select="../str_refFolder" /> UNESCO: <xsl:value-of select="../str_unescoRef" /></job_identifier>
        </xsl:template>

        <xsl:template match="str_countryId">
            <where_shown>
                <city><xsl:value-of select="../str_place" /></city>
                <country><xsl:value-of select="." /></country>
            </where_shown>
        </xsl:template>

        <xsl:template match="str_copyright">
            <credit_line>©<xsl:value-of select="." /></credit_line>
        </xsl:template>

        <xsl:template match="str_yearShoot">
            <date><xsl:value-of select="." /></date>
        </xsl:template>

        <xsl:template match="str_photographer">
                        <item>
                    <name>
                        <xsl:choose>
                            <xsl:when test="contains(., ',')">
                                <family><xsl:value-of select="substring-before(., ',')" /></family>
                                <given><xsl:value-of select="translate(substring-after(., ','), ' ', '')" /></given>
                            </xsl:when>
                            <xsl:when test="contains(., ' ')">
                                <family><xsl:value-of select="substring-after(., ' ')" /></family>
                                <given><xsl:value-of select="translate(substring-after(., ','), ' ', '')" /></given>
                            </xsl:when>
                            <xsl:otherwise>
                                <family><xsl:value-of select="." /></family>
                            </xsl:otherwise>
                        </xsl:choose>
                    </name>
                    <dept>UNESCO</dept>
                </item>
        </xsl:template>

        <xsl:template match="lib_photobank_description">
            <ml_abstract>
                <item>
                    <text><xsl:value-of select="./str_description_en" /></text>
                    <lang><xsl:value-of select="./str_languageUID_en" /></lang>
                </item>
                <item>
                    <text><xsl:value-of select="./str_description_fr" /></text>
                    <lang><xsl:value-of select="./str_languageUID_fr" /></lang>
                </item>
            </ml_abstract>
            <ml_title>
                <item>
                    <text><xsl:value-of select="substring(./str_description_en,0,80)" /></text>
                    <lang><xsl:value-of select="./str_languageUID_en" /></lang>
                </item>
            </ml_title>
        </xsl:template>

        <xsl:template match="int_themeId|num_subthemes">
                <item><xsl:value-of select="." /></item>
        </xsl:template>

        <!-- Ignored -->
        <xsl:template match="str_refFolder|str_unescoRef|str_languageUID|str_place" />
    </xsl:stylesheet>
