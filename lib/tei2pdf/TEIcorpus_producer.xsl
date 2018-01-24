<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
    version="2.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns="http://www.tei-c.org/ns/1.0"
    xpath-default-namespace="http://www.tei-c.org/ns/1.0"
    exclude-result-prefixes="#all">

    <!-- =================================================================================
         XSL to create a TEI Corpus file from the individual XML files in input/xml.

         v.1 Created for Digital Humanities 2013 at the University of Nebraska-Lincoln by Karin Dalziel

         All selections are very literal, which may work or not depending on your TEI.
         Change as necessary

         ================================================================================= -->

    <xsl:output indent="no"/><!-- Wed, 22 Jun 2016 10:02:03 +0200 moocow: indent="yes" breaks manual formatting (e.g. for subscripts) -->

    <!-- This is a wildly inefficient but convienent way to select documents -->
    <xsl:variable name="files" select="collection('../../input/xml?recurse=yes;select=*.xml')"/>

    <!-- =================================================================================
         Main Document Structure
         ================================================================================= -->

    <xsl:template match="/">

        <teiCorpus xml:id="Book_Corpus">

            <xsl:call-template name="TEICorpusHeader"/>

            <!-- Begin repeating corpus info -->

            <!-- Introductory Materials -->
            <xsl:for-each select="$files[normalize-space(//keywords[@n='category']) = 'Intro']">
                <xsl:sort select="normalize-space(/TEI/@xml:id)"/>
                    <xsl:variable name="id"><xsl:value-of select="/TEI/@xml:id"/></xsl:variable>
                    <TEI n="{$id}">
                        <xsl:for-each select="/TEI/teiHeader[1]">
                            <xsl:copy>
                                <xsl:apply-templates select="@*|node()"/>
                            </xsl:copy>
                        </xsl:for-each>
                        <xsl:copy-of select="/TEI/text"/>
                    </TEI>
            </xsl:for-each>

            <!-- List of Reviewers -->
            <xsl:for-each select="$files[normalize-space(//keywords[@n='category']) = 'Reviewers']">
                <xsl:sort select="normalize-space(/TEI/@xml:id)"/>
                    <xsl:variable name="id"><xsl:value-of select="/TEI/@xml:id"/></xsl:variable>
                    <TEI n="{$id}">
                        <xsl:for-each select="/TEI/teiHeader[1]">
                            <xsl:copy>
                                <xsl:apply-templates select="@*|node()"/>
                            </xsl:copy>
                        </xsl:for-each>
                        <xsl:copy-of select="/TEI/text"/>
                    </TEI>

            </xsl:for-each>

            <!-- Plenary Sessions -->
            <xsl:for-each select="$files[normalize-space(//keywords[@n='category']) = 'Plenary']">
                <xsl:sort select="replace(lower-case(normalize-space(/TEI/teiHeader[1]/fileDesc[1]/titleStmt[1]/title[1])), '[^a-z]', '')"/>
                    <xsl:variable name="id"><xsl:value-of select="/TEI/@xml:id"/></xsl:variable>
                    <TEI n="{$id}">
                        <xsl:for-each select="/TEI/teiHeader[1]">
                            <xsl:copy>
                                <xsl:apply-templates select="@*|node()"/>
                            </xsl:copy>
                        </xsl:for-each>
                        <xsl:copy-of select="/TEI/text"/>
                    </TEI>
            </xsl:for-each>

            <!-- Workshops -->
            <xsl:for-each select="$files[normalize-space(//keywords[@n='subcategory']) = 'Workshop']">
                <xsl:sort select="replace(lower-case(normalize-space(/TEI/teiHeader[1]/fileDesc[1]/titleStmt[1]/title[1])), '[^a-z]', '')"/>
                    <xsl:variable name="id"><xsl:value-of select="/TEI/@xml:id"/></xsl:variable>
                    <TEI n="{$id}">
                        <xsl:for-each select="/TEI/teiHeader[1]">
                            <xsl:copy>
                                <xsl:apply-templates select="@*|node()"/>
                            </xsl:copy>
                        </xsl:for-each>
                        <xsl:copy-of select="/TEI/text"/>
                    </TEI>
            </xsl:for-each>

            <!-- Panels -->
            <xsl:for-each select="$files[normalize-space(//keywords[@n='subcategory']) = 'Panel']">
                <xsl:sort select="replace(lower-case(normalize-space(/TEI/teiHeader[1]/fileDesc[1]/titleStmt[1]/title[1])), '[^a-z]', '')"/>
                    <xsl:variable name="id"><xsl:value-of select="/TEI/@xml:id"/></xsl:variable>
                    <TEI n="{$id}">
                        <xsl:for-each select="/TEI/teiHeader[1]">
                            <xsl:copy>
                                <xsl:apply-templates select="@*|node()"/>
                            </xsl:copy>
                        </xsl:for-each>
                            <xsl:copy-of select="TEI/text"/>
                    </TEI>
            </xsl:for-each>

            <!-- Sektionen -->
            <xsl:for-each select="$files[normalize-space(//keywords[@n='subcategory']) = 'Sektion']">
                <xsl:sort select="replace(lower-case(normalize-space(/TEI/teiHeader[1]/fileDesc[1]/titleStmt[1]/title[1])), '[^a-z]', '')"/>
                    <xsl:variable name="id"><xsl:value-of select="/TEI/@xml:id"/></xsl:variable>
                    <TEI n="{$id}">
                        <xsl:for-each select="/TEI/teiHeader[1]">
                            <xsl:copy>
                                <xsl:apply-templates select="@*|node()"/>
                            </xsl:copy>
                        </xsl:for-each>
                        <xsl:copy-of select="/TEI/text"/>
                    </TEI>
            </xsl:for-each>

            <!-- Vorträge -->
            <xsl:for-each select="$files[normalize-space(//keywords[@n='subcategory']) = 'Vortrag']">
                <xsl:sort select="replace(lower-case(normalize-space(/TEI/teiHeader[1]/fileDesc[1]/titleStmt[1]/title[1])), '[^a-z]', '')"/>
                    <xsl:variable name="id"><xsl:value-of select="/TEI/@xml:id"/></xsl:variable>
                    <TEI n="{$id}">
                        <xsl:for-each select="/TEI/teiHeader[1]">
                            <xsl:copy>
                                <xsl:apply-templates select="@*|node()"/>
                            </xsl:copy>
                        </xsl:for-each>
                            <xsl:copy-of select="TEI/text"/>
                    </TEI>
            </xsl:for-each>

            <!-- Posters -->
            <xsl:for-each select="$files[normalize-space(//keywords[@n='subcategory']) = 'Poster']">
                <xsl:sort select="replace(lower-case(normalize-space(/TEI/teiHeader[1]/fileDesc[1]/titleStmt[1]/title[1])), '[^a-z]', '')"/>
                    <xsl:variable name="id"><xsl:value-of select="/TEI/@xml:id"/></xsl:variable>
                    <TEI n="{$id}">
                        <xsl:for-each select="/TEI/teiHeader[1]">
                            <xsl:copy>
                                <xsl:apply-templates select="@*|node()"/>
                            </xsl:copy>
                        </xsl:for-each>
                            <xsl:copy-of select="TEI/text"/>
                    </TEI>
            </xsl:for-each>

            <!-- End repeating corpus info -->

        </teiCorpus>

    </xsl:template>


    <!-- =================================================================================
         TEI Text template rules
         ================================================================================= -->

    <xsl:template match="p">
        <xsl:element name="p">
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="@*|node()">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
    </xsl:template>

    <xsl:template name="TEICorpusHeader">

            <teiHeader>
                <fileDesc>
                    <titleStmt>
                        <title>Digital Humanities 2013 Combined Abstracts</title>
                        <author>
                        </author>
                    </titleStmt>
                    <publicationStmt>
                        <authority></authority>
                        <publisher>University of Nebraska-Lincoln</publisher>
                        <distributor>
                            <name>Center for Digital Research in the Humanities</name>
                            <address>
<addrLine>319 Love Library</addrLine>
<addrLine>University of Nebraska&#8211;Lincoln</addrLine>
<addrLine>Lincoln, NE 68588-4100</addrLine>
<addrLine>cdrh@unl.edu</addrLine>
</address>
                        </distributor>
                        <pubPlace>Lincoln, Nebraska</pubPlace>
                        <address>
<addrLine>University of Nebraska-Lincoln</addrLine>
<addrLine>Lincoln, NE 68588-4100</addrLine>
</address>
                        <availability>
                            <p></p>
                        </availability>
                    </publicationStmt>

                    <notesStmt><note></note></notesStmt>

                    <sourceDesc>
                        <p>No source: created in electronic format.</p>
                    </sourceDesc>
                </fileDesc>

                <profileDesc>
                    <textClass>
                    </textClass>
                </profileDesc>

                <revisionDesc>
                    <change>
                        <date when="2013-03-27"></date>
                        <name>Laura Weakly</name>
                        <desc>Initial encoding</desc>
                    </change>
                </revisionDesc>
            </teiHeader>
    </xsl:template>



    <xsl:template match="author">
        <author>
            <xsl:attribute name="n">
                <xsl:value-of select="replace(persName/surname,'[^a-zA-Z0-9]','')"/>
                <xsl:value-of select="replace(persName/forename,'[^a-zA-Z0-9]','')"/>
                <xsl:choose>
                    <xsl:when test="/teiCorpus">
                        <xsl:value-of select="/teiCorpus/@xml:id"/>
                    </xsl:when>
                    <xsl:when test="/TEI">
                        <xsl:value-of select="/TEI/@xml:id"/>
                    </xsl:when>
                </xsl:choose>
            </xsl:attribute>
            <persName>
                <xsl:attribute name="n">
                    <xsl:value-of select="replace(persName/surname,'[^a-zA-Z0-9]','') "/>
                    <xsl:value-of select="replace(persName/forename,'[^a-zA-Z0-9]','') "/>
                </xsl:attribute>
                <xsl:copy-of select="persName/node()"/></persName>
            <xsl:copy-of select="affiliation"/>
            <xsl:copy-of select="email"/>

        </author>
    </xsl:template>

    <xsl:template name="TEIHeader">
        <xsl:param name="title"/>
            <teiHeader>
                <fileDesc>
                    <titleStmt>
                        <title><xsl:value-of select="$title"/></title>
                    </titleStmt>
                    <publicationStmt>
                    </publicationStmt>


                    <sourceDesc>
                        <p>No source: created in electronic format.</p>
                    </sourceDesc>
                </fileDesc>


            </teiHeader>
    </xsl:template>

</xsl:stylesheet>
