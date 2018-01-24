<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:dhd="http://dhd2018.uni-koeln.de"
    xmlns:t="http://www.tei-c.org/ns/1.0"
    exclude-result-prefixes="xs dhd t"
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
    <xsl:variable name="input-image-files">
        <xsl:choose>
            <xsl:when test="//*:images">
                <xsl:value-of select="//*:images[1]/@n"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>????</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:variable>
    <xsl:variable name="files" select="collection(concat('xml','/?recurse=yes;select=*.xml'))"/>
    <xsl:variable name="program" select="document('DHd2018-Programm.xml')"/>

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
                <h1>Test von <xsl:value-of select="current-dateTime()"/></h1>
                <p>Anzahl Dateien: <xsl:value-of select="count($files)"/></p>
                <xsl:if test="count($files) != $files-in-folder">
                    <p>Achtung! Zahl der Dateien stimmt nicht überein: <a href="dir.xml.txt">dir.xml.txt</a></p>
                    <xsl:result-document href="dir.xml.txt" method="text">
                        <xsl:for-each select="$files">
                            <xsl:text>
</xsl:text><xsl:value-of  select="replace(tokenize(document-uri(.), '/')[last()], '%20', ' ')"/>
                        </xsl:for-each>
                    </xsl:result-document>
                </xsl:if>
                
                <p>Anzahl der Bilder: <xsl:value-of select="count($files//graphic)"/></p>
                <xsl:if test="count($files//graphic) != $input-image-files">
                    <p>Achtung! Zahl der Bildreferenz im XML und der heruntergeladenen Bilder stimmt nicht überein: <a href="tei-graphic.txt">tei-graphic.txt</a> und <a href="images/">input/images</a></p>
                    <xsl:result-document href="tei-graphic.txt" method="text">
                        <xsl:for-each select="$files">
                            <xsl:sort select="document-uri(.)"/>
                            <xsl:variable name="filename" select="tokenize(document-uri(.),'/')[last()]"/>
                            <xsl:variable name="filename-without-extension" select="substring-before($filename, '.xml')"/>

                            <!-- Kopiere modifizierte XML-Dateien in das XML-Verzeichnis -->
                            <xsl:result-document href="xml/{$filename}">
                                <xsl:apply-templates mode="copyxml">
                                    <xsl:with-param name="filename" select="$filename-without-extension"/>
                                </xsl:apply-templates>
                            </xsl:result-document>
                            
                            <!-- Liste alle Bilder auf -->
                            <xsl:for-each select=".//graphic">
                                <xsl:sort select="@url"/>
                                <xsl:if test="not(starts-with(@url,$filename-without-extension))"><xsl:value-of select="$filename-without-extension"/><xsl:text>-</xsl:text></xsl:if><xsl:value-of select="replace(@url, '^Pictures/', '')"/><xsl:text>
</xsl:text>
                            </xsl:for-each>
                        </xsl:for-each>
                    </xsl:result-document>
                </xsl:if>
                
                <xsl:for-each select="$files">
                    <xsl:sort select="document-uri(.)"/>
                    <xsl:variable name="filename" select="tokenize(document-uri(.),'/')[last()]"/>
                    <xsl:variable name="current-folder" select="replace(replace(substring-after(substring-before(document-uri(.), $filename),'file:/'), '/', '\\'), '%20', ' ')"/>
                    <xsl:variable name="title" select="/TEI//titleStmt/(title/title[@type='main']|title[not(title)])/dhd:strip(normalize-space(.))"/>
                    <xsl:variable name="paper" select="$program//*:paper[./*:title[contains(./dhd:strip(normalize-space()), $title)]]"/>
                    <xsl:variable name="session" select="$paper/*:session_short"/>
                    
                    <div id="document-uri(.)" class="contrib">
                        <p>Datei: <a href="{document-uri(.)}"><xsl:value-of select="tokenize(document-uri(.),'/')[last()]"/></a></p>
                        <p>Typ: <xsl:value-of select="//keywords[@scheme='ConfTool'][@n='subcategory']/term"/></p>
                        <p>Session: <xsl:if test="count($session) != 1"><b>ACHTUNG, keine automatische Session-Zuordnung möglich!!!</b></xsl:if><xsl:value-of select="$session"/></p>
                        <p>Titel: <xsl:value-of select="/TEI/teiHeader[1]/fileDesc[1]/titleStmt[1]/title"/></p>
                        <p>Autoren: <xsl:apply-templates select="/TEI/teiHeader/fileDesc/titleStmt/author"/></p>
                        <p>Text: <xsl:value-of select="string-length(/TEI/text/body/string())"/><xsl:text> Zeichen </xsl:text>
                            <xsl:if test="string-length(/TEI/text/body/string()) lt 4000"><span class="Achtung">ACHTUNG: Text kürzer als 5000 Zeichen</span></xsl:if></p>
                        <p>Überschriften: <xsl:value-of select="count(.//head)"/> <xsl:if test="count(.//head) = 0"><xsl:text> </xsl:text><span class="Achtung">Achtung, keine Überschriften im TEI</span></xsl:if>
                            <xsl:if test="count(.//titleStmt//title[@type='sub']) gt 1"><xsl:text> </xsl:text><b>ACHTUNG! mehr als ein Untertitel, evtl. vermischt mit Überschriften?</b></xsl:if>
                        </p>
                        <xsl:if test=".//graphic"><p>Bilder: 
                            <xsl:for-each select=".//graphic">
                                <xsl:variable name="filename-short" select="substring-before($filename, '.xml')"/>
                                <xsl:variable name="image-file-name" select="replace(tokenize(@url,'/')[last()], '/', '\\')"/>
                                <xsl:variable name="image-path">
                                    <xsl:choose>
                                        <xsl:when test="@url=concat($filename-short,'-', $image-file-name)">
                                            <xsl:value-of select="@url"/>
                                        </xsl:when>
                                        <xsl:when test="starts-with(@url,'http')">
                                            <xsl:value-of select="@url"/>
                                        </xsl:when>
                                        <xsl:when test="starts-with(@url, 'Pictures/')">
                                            <xsl:value-of select="$filename-short"/>
                                            <xsl:text>-</xsl:text>
                                            <xsl:value-of select="$image-file-name"/>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:value-of select="@url"/>
                                        </xsl:otherwise>
                                    </xsl:choose>                                    
                                </xsl:variable>
                                <img alt="###################### ACHTUNG! {$image-path}" 
                                    src="./images/{$image-path}" 
                                    height="100"/></xsl:for-each>
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
    <xsl:template match="graphic[contains(@url,'/')]" mode="copyxml">
        <xsl:param name="filename"/>
        <xsl:variable name="image-file-name" select="substring(replace(tokenize(@url,'/')[last()], '/', '\\'),1,100)"/>
        <xsl:copy>
            <xsl:apply-templates 
                select="@*[name() != 'url']" mode="copyxml"/>
                <xsl:attribute name="url">
                    <xsl:choose>
                        <xsl:when test="@url=concat($filename,'-', $image-file-name)">
                            <xsl:value-of select="@url"/>
                        </xsl:when>
                        <xsl:when test="starts-with(@url,'http')">
                            <xsl:value-of select="@url"/>
                        </xsl:when>
                        <xsl:when test="starts-with(@url, 'Pictures/')">
                            <xsl:value-of select="$filename"/>
                            <xsl:text>-</xsl:text>
                            <xsl:value-of select="$image-file-name"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="@url"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:attribute>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="TEI"
        mode="copyxml">
        <xsl:param name="filename"/>
        <xsl:copy>
            <xsl:apply-templates 
                select="@*[name() != 'url']" mode="copyxml"/>
            <xsl:attribute name="xml:id" select="$filename"/>
            <xsl:apply-templates 
                select="comment()|processing-instruction()|*|text()" 
                mode="copyxml">
                <xsl:with-param name="filename" select="$filename"/>
            </xsl:apply-templates>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="/TEI/teiHeader[1]/fileDesc[1]/publicationStmt[1]"
        mode="copyxml">
        <xsl:copy>
            <publisher>Georg Vogeler, im Auftrag des Verbands Digital Humanities im deutschaprachigen Raum e.V.</publisher>
            <address>
                <addrLine>Universität Graz</addrLine>
                <addrLine>Zentrum für Informationsmodellierung - Austrian Centre for Digital Humanities</addrLine>
                <addrLine>Elisabethstraße 59/III</addrLine>
                <addrLine>8010 Graz</addrLine>
            </address>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="profileDesc"
        mode="copyxml">
        <xsl:param name="filename"/>
        <xsl:variable name="title" select="ancestor::TEI//titleStmt/(title/title[@type='main']|title[not(title)])/dhd:strip(normalize-space(.))"/>
        <xsl:copy>
            <xsl:apply-templates 
                select="@*" mode="copyxml"/>
            <xsl:apply-templates 
                select="comment()|processing-instruction()|*|text()" 
                mode="copyxml">
                <xsl:with-param name="filename" select="$filename"/>
            </xsl:apply-templates>
            
            <xsl:if test="not(settingDesc)">
                <xsl:variable name="paper" select="$program//*:paper[./*:title[contains(./dhd:strip(normalize-space()), $title)]]"/>
                <settingDesc xmlns="http://www.tei-c.org/ns/1.0">
                    <ab n="conference">DHd2018 - "Kritik der Digitalen Vernunft", Köln</ab>
                    <xsl:if test="$paper/*:paperID"><ab n="paperID"><xsl:value-of select="$paper/*:paperID"/></ab></xsl:if>
                    <xsl:for-each select="$paper/*[contains(name(), 'session_')]">
                        <ab n="{name()}"><xsl:value-of select="."/></ab>
                    </xsl:for-each>
            </settingDesc></xsl:if>
        </xsl:copy>
    </xsl:template>
    <xsl:function name="dhd:strip">
        <xsl:param name="input"/>
        <xsl:value-of select="replace($input,'[^0-z]', '')"/>
    </xsl:function>
</xsl:stylesheet>