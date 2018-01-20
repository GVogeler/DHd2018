<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    xpath-default-namespace="http://www.tei-c.org/ns/1.0"
    version="2.0">
    <!-- Verarbeitungsprozeß:
        Herunterladen aller DHc-Dateien
        Umbenennen (rename *.dhc *.zip)
        Extrahieren Ordner
        Extrahieren XML, verschieben nach input\xml
        Verschieben Bilder
    -->
    <!-- Testen:
    Vorhandensein von 
        Titel, Untertitel
        Autoren, 
        Text, 
        Bildern 
        Bibliographie
    -->
    <xsl:output method="xml" indent="yes"/>
    <xsl:variable name="folder">
        <xsl:choose>
            <xsl:when test="//*:folder">
                <xsl:value-of select="//*:folder[1]"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>xml</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:variable>
    <xsl:variable name="files-in-folder">
        <xsl:choose>
            <xsl:when test="//*:folder">
                <xsl:value-of select="//*:folder[1]/@n"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>xml</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:variable>
    <xsl:variable name="files" select="collection(concat('xml','/?recurse=yes;select=*.xml'))"/>
    <xsl:template match="/">
        <xsl:result-document href="files.xml">
            <teiCorpus xmlns="http://www.tei-c.org/ns/1.0">
                <teiHeader>
                    <fileDesc>
                        <titleStmt>
                            <title><xsl:value-of select="$folder"/></title>
                        </titleStmt>
                        <publicationStmt><p>internal</p></publicationStmt>
                        <sourceDesc><p>From ConfTool</p></sourceDesc>
                    </fileDesc>
                </teiHeader>
                <xsl:comment select="$files/document-uri(.)"/>
                <xsl:copy-of select="$files"/>
            </teiCorpus>
        </xsl:result-document>
        <xsl:result-document href="bilder.bat" method="text" encoding="utf-8">
<!--            Erzeuge eine .bat-Datei, mit der die bilder aus dem originalen Ordner in einen Zielordner kopiert werden und dabei normalisiert benannt werden.-->
            <xsl:variable name="imagetypes" select="$files//graphic/@url[not(starts-with(., 'http'))]/tokenize(., '\.')[last()]"/>
            <xsl:text>REM </xsl:text>
            <xsl:for-each select="distinct-values($imagetypes)"><xsl:value-of select="."/><xsl:text>, </xsl:text></xsl:for-each><xsl:text>
</xsl:text>
            <xsl:text>cd images
REM online-Bilder
</xsl:text>
            <xsl:for-each select="$files//graphic/@url[starts-with(., 'http')]">
                <xsl:text>curl </xsl:text><xsl:value-of select="."/><xsl:text> -O
</xsl:text>
            </xsl:for-each>
            <xsl:text>REM Bilder aus den DHc-Dateien
</xsl:text>
            <xsl:for-each select="$files">
                <xsl:variable name="docuri" select="document-uri(.)"/>
                <xsl:variable name="filename" select="tokenize(document-uri(.),'/')[last()]"/>
                <xsl:variable name="current-folder" select="replace(replace(substring-after(substring-before($docuri, $filename),'file:/'), '/', '\\'), '%20', ' ')"/>
                <xsl:for-each select=".//graphic">
                    <xsl:variable name="image-file-name" select="replace(tokenize(@url,'/')[last()], '/', '\\')"/>
                    <!-- 1. Erzeuge Unterverzeichnis Pictures und verschiebe die Bilddateien dorthin -->
                    <xsl:text>mkdir "</xsl:text>
                    <xsl:value-of select="$current-folder"/>
                    <xsl:text>Pictures\</xsl:text>
                    <xsl:text>"
move "</xsl:text>
                    <xsl:value-of select="$current-folder"/>
                    <xsl:value-of select="$image-file-name"/>
                    <xsl:text>" "</xsl:text>
                    <xsl:value-of select="$current-folder"/>
                    <xsl:text>Pictures\</xsl:text>
                    <xsl:value-of select="$image-file-name"/><xsl:text>"
</xsl:text>
                    <!-- 2. Kopiere sie in input/images/{filename}-{imagename} -->
                    <xsl:text>copy "</xsl:text>
                    <xsl:value-of select="$current-folder"/>
                    <xsl:text>Pictures\</xsl:text>
                    <xsl:value-of select="$image-file-name"/>
                    <xsl:text>" </xsl:text>
                    <xsl:value-of select="replace(substring-before($filename, '.xml'), ' ', '_')"/>
                    <xsl:text>-</xsl:text>
                    <xsl:value-of select="$image-file-name"/><xsl:text>
</xsl:text></xsl:for-each>
            </xsl:for-each>
        </xsl:result-document>
        <xsl:result-document href="Bibliographie.html">
            <html>
                <head>
                    <title>Bibliographien</title>
                    <meta charset="utf-8"/>
                    <style>
                        .bold {font-weight:bold;}
                        .italic {font-style:italic;}
                    </style>
                </head>
                <body>
                    <xsl:for-each select="$files">
                        <xsl:variable name="filename" select="tokenize(document-uri(.),'/')[last()]"/>
                        <div><h1><a href="xml/{$filename}"><xsl:value-of select="$filename"/></a></h1>
                        <ul>
                            <xsl:apply-templates select=".//bibl" mode="bibl.html"/>
                        </ul>
                        </div>
                    </xsl:for-each>
                </body>
            </html>
        </xsl:result-document>
        <xsl:result-document href="Bibliographie.xml">
            <TEI xmlns="http://www.tei-c.org/ns/1.0">
                <teiHeader>
                    <fileDesc>
                        <titleStmt>
                            <title></title>
                        </titleStmt>
                        <publicationStmt></publicationStmt>
                        <sourceDesc></sourceDesc>
                    </fileDesc>
                </teiHeader>
                <text>
                    <body>
                        <listBibl>
                            <xsl:for-each select="$files//bibl">
                                <xsl:copy-of select="."/>
                            </xsl:for-each>
                        </listBibl>
                    </body>
                </text>
            </TEI>
        </xsl:result-document>
        <html>
            <head>
                <title>XML-Test</title>
                <style>
            .Achtung {font-weight:bold;}
            .contrib {border-style: solid;
                page-break-inside:avoid;}
<!--            img {display:block}-->
            .authorname {font-variant: small-caps;}
        </style>
            <meta charset="utf-8"/>
        </head>
            <body>
                <p>Anzahl Dateien: <xsl:value-of select="count($files)"/></p>
                <xsl:if test="count($files) != $files-in-folder">
                    <p>Zahl der Dateien stimmt nicht überein: <a href="dir.xml.txt">dir.xml.txt</a></p>
                    <xsl:result-document href="dir.xml.txt" method="text">
                        <xsl:for-each select="$files">
                            <xsl:text>
</xsl:text><xsl:value-of  select="replace(tokenize(document-uri(.), '/')[last()], '%20', ' ')"/>
                        </xsl:for-each>
                    </xsl:result-document>
                </xsl:if>
                <xsl:for-each select="$files">
                    <xsl:sort select="document-uri(.)"/>
                    <xsl:variable name="filename" select="tokenize(document-uri(.),'/')[last()]"/>
                    <xsl:variable name="current-folder" select="replace(replace(substring-after(substring-before(document-uri(.), $filename),'file:/'), '/', '\\'), '%20', ' ')"/>
                    <!-- Kopiere XML-Dateien in das XML-Verzeichnis -->
                    <xsl:result-document href="xml/{$filename}">
                        <xsl:apply-templates mode="copyxml">
                            <xsl:with-param name="filename" select="substring-before($filename, '.xml')"/>
                        </xsl:apply-templates>
                    </xsl:result-document>
                    <div id="document-uri(.)" class="contrib">
                        <p>Datei: <a href="{document-uri(.)}"><xsl:value-of select="tokenize(document-uri(.),'/')[last()]"/></a></p>
                        <p>Typ: <xsl:value-of select=".//keywords[@scheme='ConfTool'][@n='subcategory']/term"/></p>
                        <p>Titel: <xsl:value-of select="/TEI/teiHeader[1]/fileDesc[1]/titleStmt[1]/title"/></p>
                        <p>Autoren: <xsl:apply-templates select="/TEI/teiHeader/fileDesc/titleStmt/author"/></p>
                        <p>Text: <xsl:value-of select="string-length(/TEI/text/body/string())"/><xsl:text> Zeichen </xsl:text>
                            <xsl:if test="string-length(/TEI/text/body/string()) lt 4000"><span class="Achtung">ACHTUNG: Text kürzer als 5000 Zeichen</span></xsl:if></p>
                        <p>Überschriften: <xsl:value-of select="count(.//head)"/> <xsl:if test="count(.//head) = 0"><xsl:text> </xsl:text><span class="Achtung">Achtung, keine Überschriften im TEI</span></xsl:if></p>
                        <xsl:if test=".//graphic"><p>Bilder: 
                            <xsl:for-each select=".//graphic">
                                <xsl:variable name="image-file-name" select="replace(tokenize(@url,'/')[last()], '/', '\\')"/>
                                <img alt="###################### ACHTUNG! {@url}" src="../input/images/{
                                replace(substring-before($filename, '.xml'), ' ', '_')
                                }-{
                                $image-file-name
                                }" height="100"/></xsl:for-each>
                        </p></xsl:if> 
                        <p>Bibliographie: <xsl:value-of select="count(.//bibl)"/><xsl:if test="count(.//bibl) = 0"><span class="Achtung"> ACHTUNG! Keine Bibliographie!</span></xsl:if>
                            <xsl:if test=".//bibl[not(hi)]"><span style="font-weight:bold;"><xsl:text> ACHTUNG! Bibliographie ohne Formatierung?</xsl:text></span>
                                <!--<ul><xsl:for-each select=".//bibl[not(hi)]"><xsl:apply-templates select="."/></xsl:for-each></ul>-->
                            </xsl:if></p>
                    </div>
                </xsl:for-each>
            </body>
        </html>
    </xsl:template>
    <xsl:template match="hi">
        <span class="{@rend}"><xsl:apply-templates/></span>
    </xsl:template>
    <xsl:template match="bibl">
        <xsl:if test="not(hi)"><li class="Achtung">ACHTUNG, keine Formatierung in: <xsl:value-of select="."/></li></xsl:if>
    </xsl:template>
    <xsl:template match="bibl" mode="bibl.html">
        <li><xsl:apply-templates/></li>
    </xsl:template>
    <xsl:template match="author">
        <xsl:apply-templates/><xsl:text>; </xsl:text>
    </xsl:template>
    
    <xsl:template match="author/persName">
        <span class="author"><xsl:apply-templates/></span>
    </xsl:template>
    <xsl:template match="author/persName/surname">
        <span class="authorname"><xsl:apply-templates/></span>
    </xsl:template>
    <xsl:template match="affiliation">
        <xsl:text> (</xsl:text><xsl:apply-templates/><xsl:text>) </xsl:text>
    </xsl:template>
    
    <xsl:template match="@*|comment()|processing-instruction()|*|text()" 
        mode="copyxml" priority="-2">
        <xsl:param name="filename"/>
        <xsl:copy>
            <xsl:apply-templates 
                select="@*" mode="copyxml"/>
            <xsl:apply-templates 
                select="comment()|processing-instruction()|*|text()" 
                mode="copyxml">
                <xsl:with-param name="filename" select="$filename"/>
            </xsl:apply-templates>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="graphic" mode="copyxml">
        <xsl:param name="filename"/>
        <xsl:variable name="image-file-name" select="substring(replace(tokenize(@url,'/')[last()], '/', '\\'),1,100)"/>
        <xsl:copy>
            <xsl:apply-templates 
                select="@*[name() != 'url']" mode="copyxml"/>
                <xsl:attribute name="url">
                    <xsl:choose>
                        <xsl:when test="starts-with(@url,'http')">
                            <xsl:value-of select="@url"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="$filename"/>
                            <xsl:text>-</xsl:text>
                            <xsl:value-of select="$image-file-name"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:attribute>
        </xsl:copy>
    </xsl:template>
</xsl:stylesheet>