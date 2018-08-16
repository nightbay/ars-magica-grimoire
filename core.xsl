<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="3.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
  xmlns:java="http://xml.apache.org/xslt/java"
  exclude-result-prefixes="java"
  xmlns:fo="http://www.w3.org/1999/XSL/Format">  
    
  <xsl:template match="p">
    <fo:block text-indent="1em" font-family="{$textfont}" font-size="8pt" font-weight="normal"><xsl:apply-templates/><xsl:call-template name="source"/></fo:block>
  </xsl:template>

  <xsl:decimal-format name="d" decimal-separator="." grouping-separator=" "/>
  
  <xsl:template match="spellcount"><xsl:value-of select="format-number(count(//spell[name != '']), '# ###', 'd')"/></xsl:template>
    
  <xsl:template match="booklist">
    <fo:inline font-family="Lauren C. Brown" font-size="10pt"> Ars Magica (<xsl:value-of select="count($in/ars_magica/spells/spell[not(@source)])"/> incantesimi),</fo:inline>
    <xsl:for-each select="$in/ars_magica/books/book">
      <xsl:sort select="name"/>
      <xsl:variable name="abbrev" select="abbreviation"/>
      <xsl:if test="position() = last()"><xsl:text> </xsl:text>e </xsl:if><fo:inline font-family="Lauren C. Brown" font-size="10pt"><xsl:value-of select="name" /><xsl:text> </xsl:text>(<xsl:value-of select="abbreviation" />, <xsl:value-of select="count($in/ars_magica/spells/spell[@source=$abbrev])"/> <xsl:choose><xsl:when test="count($in/ars_magica/spells/spell[@source=$abbrev]) = 1"> incantesimo)</xsl:when>
        <xsl:otherwise> incantesimi)</xsl:otherwise></xsl:choose><xsl:if test="position() &lt; last()">,</xsl:if></fo:inline>
    </xsl:for-each>
  </xsl:template>
  
  <xsl:template match="p" mode="preface">
    <xsl:variable name="indent">
      <xsl:choose>
        <xsl:when test="@indent = 'false'">0em</xsl:when>
        <xsl:otherwise>1em</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="colour">
      <xsl:choose>
        <xsl:when test="@colour = 'hand'"><xsl:value-of select="$handcolour"/></xsl:when>
        <xsl:when test="@colour"><xsl:value-of select="@colour"/></xsl:when>
        <xsl:otherwise><xsl:value-of select="$textcolour"/></xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="font">
      <xsl:choose>
        <xsl:when test="@font = 'hand'"><xsl:value-of select="$handfont"/></xsl:when>
        <xsl:when test="@font"><xsl:value-of select="@font"/></xsl:when>
        <xsl:otherwise><xsl:value-of select="$textfont"/></xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="size">
      <xsl:choose>
        <xsl:when test="@size"><xsl:value-of select="@size"/></xsl:when>
        <xsl:otherwise>8pt</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <fo:block text-indent="{$indent}" color="{$colour}" font-family="{$font}" font-size="{$size}" font-weight="normal"><xsl:apply-templates/></fo:block>
  </xsl:template>

  <xsl:template match="spell-link"><xsl:variable name="sname" select="@name"/><fo:inline font-style="italic"><xsl:value-of select="@name"/> <fo:basic-link internal-destination="{generate-id($sortedspells/spell[name=$sname])}"> (pag. <fo:page-number-citation ref-id="{generate-id($sortedspells/spell[name=$sname])}" />)</fo:basic-link></fo:inline></xsl:template>
  
  <xsl:template match="table">
    <fo:table>
      <fo:table-header>
        <xsl:for-each select="columns/column">
          <xsl:choose>
            <xsl:when test="@width">
              <xsl:variable name="w" select="@width"/>
              <fo:table-cell width="{$w}"><fo:block font-family="{$textfont}" font-size="8pt" font-weight="bold"><xsl:value-of select="."/></fo:block></fo:table-cell>
            </xsl:when>
            <xsl:otherwise>
              <fo:table-cell><fo:block font-size="8pt" font-family="{$textfont}" font-weight="bold"><xsl:value-of select="."/></fo:block></fo:table-cell>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:for-each>
      </fo:table-header>
      <fo:table-body>
        <xsl:for-each select="row">
          <fo:table-row table-layout="fixed">
            <xsl:for-each select="cell">
              <fo:table-cell><fo:block font-family="{$textfont}" font-size="8pt"><xsl:value-of select="."/></fo:block></fo:table-cell>
            </xsl:for-each>
          </fo:table-row>
        </xsl:for-each>
      </fo:table-body>
    </fo:table>
  </xsl:template>
  
  <xsl:template match="reference"><fo:inline font-style="italic"><xsl:value-of select="."/></fo:inline>
    <xsl:choose>
      <xsl:when test="@page != ''">, pagina <xsl:value-of select="@page"/></xsl:when>
      <xsl:when test="@chapter != ''">, capitolo <xsl:value-of select="@chapter"/></xsl:when>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="spell-guidelines">
    <xsl:value-of select="guideline/modifiers/base"/>
    <xsl:choose>
      <xsl:when test="guideline/@ward = 'true'"></xsl:when>
      <xsl:otherwise>
        <xsl:choose>
          <xsl:when test="range = 'Personale'" />
          <xsl:when test="range = 'Adelphixis'" />
          <xsl:when test="range = 'Tocco'">, +1 Tocco</xsl:when>
          <xsl:when test="range = 'Occhio'">, +1 Occhio</xsl:when>
          <xsl:when test="range = 'Voce'">, +2 Voce</xsl:when>
          <xsl:when test="range = 'Strada'">, +2 Strada</xsl:when>
          <xsl:when test="range = 'Via Acquatica'">, +3 Via Acquatica</xsl:when>
          <xsl:when test="range = 'Visuale'">, +3 Visuale</xsl:when>
          <xsl:when test="range = 'Velo'">, +3 Velo</xsl:when>
          <xsl:when test="range = 'Linea'">, +3 Linea</xsl:when>
          <xsl:when test="range = 'Connessione Arcana'">, +4 Connessione Arcana</xsl:when>
          <xsl:when test="range = 'Simbolo'">, +4 Simbolo</xsl:when>
          <xsl:when test="range = 'Lunare'">, +4 Lunare</xsl:when>
          <xsl:when test="range = 'Terreno'">, +4 Terreno</xsl:when>
          <xsl:when test="range = 'Illimitata'">, +4 Illimitata</xsl:when>
          <xsl:otherwise>RANGE ERROR</xsl:otherwise>
        </xsl:choose>
        <xsl:choose>
          <xsl:when test="duration = 'Istantanea'" />
          <xsl:when test="duration = 'Speciale'" />
          <xsl:when test="duration = 'Sogno'">, +1 Sogno</xsl:when>
          <xsl:when test="duration = 'Concentrazione'">, +1 Concentrazione</xsl:when>
          <xsl:when test="duration = 'Esibizione'">, +1 Esibizione</xsl:when>
          <xsl:when test="duration = 'Diametro'">, +1 Diametro</xsl:when>
          <xsl:when test="duration = 'Fintanto'">, +1 Fintanto</xsl:when>
          <xsl:when test="duration = 'Fuoco'">, +1 Fuoco</xsl:when>
          <xsl:when test="duration = 'Sole'">, +2 Sole</xsl:when>
          <xsl:when test="duration = 'Ore'">, +2 Ore</xsl:when>
          <xsl:when test="duration = 'Cerchio'">, +2 Cerchio</xsl:when>
          <xsl:when test="duration = 'Luna'">, +3 Luna</xsl:when>
          <xsl:when test="duration = 'Mese'">, +3 Mese</xsl:when>
          <xsl:when test="duration = 'Helstar'">, +3 Helstar</xsl:when>
          <xsl:when test="duration = 'Contratto'">, +3 Contratto</xsl:when>
          <xsl:when test="duration = 'Evento'">, +3 Evento</xsl:when>
          <xsl:when test="duration = 'Finchè'">, +4 Finchè</xsl:when>
          <xsl:when test="duration = 'Anno'">, +4 Anno</xsl:when>
          <xsl:when test="duration = 'Anno +1'">, +4 Anno + 1</xsl:when>
          <xsl:when test="duration = 'Simbolo'">, +4 Simbolo</xsl:when>
          <xsl:otherwise>DURATION ERROR</xsl:otherwise>
        </xsl:choose>
        <xsl:choose>
          <xsl:when test="target = 'Singolo'" />
          <xsl:when test="target = 'Figlio non ancora nato'" />
          <xsl:when test="target = 'Gusto'" />
          <xsl:when test="target = 'Circolo'" />
          <xsl:when test="target = 'Gusto'" />
          <xsl:when test="target = 'Sogno'" />
          <xsl:when test="target = 'Circolo Arcano'">+1 Circolo Arcano</xsl:when>
          <xsl:when test="target = 'Parte'">, +1 Parte</xsl:when>
          <xsl:when test="target = 'Sapore'">, +1 Sapore</xsl:when>
          <xsl:when test="target = 'Tocco'">, +1 Tocco</xsl:when>
          <xsl:when test="target = 'Gruppo'">, +2 Gruppo</xsl:when>
          <xsl:when test="target = 'Paio'">, +2 Paio</xsl:when>
          <xsl:when test="target = 'Olfatto'">, +2 Olfatto</xsl:when>
          <xsl:when test="target = 'Profumo'">, +2 Profumo</xsl:when>
          <xsl:when test="target = 'Speciale'">, +2 Speciale</xsl:when>
          <xsl:when test="target = 'Stanza'">, +2 Stanza</xsl:when>
          <xsl:when test="target = 'Vista'">, +3 Vista</xsl:when>
          <xsl:when test="target = 'Udito'">, +3 Udito</xsl:when>
          <xsl:when test="target = 'Suono'">, +3 Suono</xsl:when>
          <xsl:when test="target = 'Barriera'">, +3 Barriera</xsl:when>
          <xsl:when test="target = 'Struttura'">, +3 Struttura</xsl:when>
          <xsl:when test="target = 'Discendenza'">, +3 Discendenza</xsl:when>
          <xsl:when test="target = 'Spectacle'">, +4 Spectacle</xsl:when>
          <xsl:when test="target = 'Confine'">, +4 Confine</xsl:when>
          <xsl:when test="target = 'Comunità'">, +4 Comunità</xsl:when>
          <xsl:when test="target = 'Simbolo'">, +4 Simbolo</xsl:when>
          <xsl:when test="target = 'Visione'">, +4 Visione</xsl:when>
          <xsl:otherwise>TARGET ERROR</xsl:otherwise>
        </xsl:choose>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:for-each select="guideline/modifiers/modifier">, <xsl:value-of select="." /></xsl:for-each>
  </xsl:template>

  <xsl:template match="range">
    <xsl:choose>
      <xsl:when test=". = 'Personale'">Personale</xsl:when>
      <xsl:when test=". = 'Tocco'">Tocco</xsl:when>
      <xsl:when test=". = 'Voce'">Vocale</xsl:when>
      <xsl:otherwise><xsl:value-of select="." /></xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="duration">
    <xsl:choose>
      <xsl:when test=". = 'Istantanea'">Istantanea</xsl:when>
      <xsl:otherwise><xsl:value-of select="." /><xsl:if test="@condition != ''"> (<xsl:value-of select="@condition"/>)</xsl:if></xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <xsl:template name="source">
  <xsl:if test="$source = 'true' and @source != ''">
    <fo:inline font-size="6pt" color="{$handcolour}"><xsl:text> </xsl:text><xsl:value-of select="@source"/><xsl:text> </xsl:text><xsl:value-of select="@page"/></fo:inline>
  </xsl:if>
  </xsl:template>

  <xsl:template match="requisite">
    <xsl:value-of select="." /><xsl:if test="position() &lt; last()">, </xsl:if>
  </xsl:template>

  <xsl:template match="requisite" mode="abbreviation">
    <xsl:choose>
      <xsl:when test=". = 'Animal'">An</xsl:when>
      <xsl:when test=". = 'Corpus'">Co</xsl:when>
      <xsl:when test=". = 'Herbam'">He</xsl:when>
      <xsl:when test=". = 'Ignem'">Ig</xsl:when>
      <xsl:when test=". = 'Auram'">Au</xsl:when>
      <xsl:when test=". = 'Aquam'">Aq</xsl:when>
      <xsl:when test=". = 'Mentem'">Me</xsl:when>
      <xsl:when test=". = 'Imaginem'">Im</xsl:when>
      <xsl:when test=". = 'Terram'">Te</xsl:when>
      <xsl:when test=". = 'Vim'">Vi</xsl:when>

      <xsl:when test=". = 'Creo'">Cr</xsl:when>
      <xsl:when test=". = 'Muto'">Mu</xsl:when>
      <xsl:when test=". = 'Perdo'">Pe</xsl:when>
      <xsl:when test=". = 'Intellego'">In</xsl:when>
      <xsl:when test=". = 'Rego'">Re</xsl:when>
    </xsl:choose><xsl:if test="position() &lt; last()">, </xsl:if>
  </xsl:template>

  <xsl:template match="requisite" mode="guideline">
    , <xsl:choose>
        <xsl:when test="@free = 'true'"><xsl:value-of select="." /> requisito gratuito</xsl:when>
        <xsl:otherwise>+1 <xsl:value-of select="." /> requisito<xsl:if test="@note != ''"><xsl:text> </xsl:text><xsl:value-of select="@note" /></xsl:if></xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="text()"><xsl:copy/></xsl:template>

  <xsl:template match="strong"><fo:inline font-weight="bold"><xsl:value-of select="."/></fo:inline></xsl:template>

  <xsl:template match="self"><fo:inline font-style="italic"><xsl:value-of select="ancestor::spell[1]/name"/></fo:inline></xsl:template>
  
  <xsl:template match="emphasis"><fo:inline font-style="italic"><xsl:value-of select="."/></fo:inline></xsl:template>

  <xsl:template match="p" mode="notes"><fo:block color="{$handcolour}" space-before="2.5pt" text-indent="1em" font-size="9pt"><xsl:apply-templates/></fo:block></xsl:template>

  <xsl:template match="flavour">
    <fo:block text-indent="1em" font-family="{$textfont}" font-size="8pt" font-weight="normal" font-style="italic"><xsl:apply-templates/></fo:block>
  </xsl:template>
  
  <xsl:template match="p" mode="guideline"><fo:block color="{$handcolour}" space-before="2.5pt" text-indent="1em" font-size="9pt"><xsl:apply-templates/><xsl:call-template name="source"/></fo:block></xsl:template>

  <xsl:template name="spells-at-level">
    <xsl:param name="form"/>
    <xsl:param name="technique"/>
    <xsl:param name="level"/>
    <xsl:for-each select="$sortedspells/spell[arts/technique=$technique and arts/form=$form and level=$level]">
      <fo:block page-break-inside="avoid">
        <fo:block id="{generate-id(.)}" font-family="{$textfont}" font-size="9pt" font-weight="bold">
          <fo:inline><xsl:value-of select="name" /></fo:inline><xsl:call-template name="source"/>
        </fo:block>
        <fo:block font-family="{$textfont}" text-indent="1em" font-size="8pt" font-weight="normal">
          P: <xsl:apply-templates select="range" />, D: <xsl:apply-templates select="duration" />, B: <xsl:value-of select="target" />
          <xsl:if test="@type='mystery'">, Misterico</xsl:if>
          <xsl:if test="@ritual='true'">, Rituale</xsl:if>
          <xsl:if test="@faerie='true'">, Fatato</xsl:if>
          <xsl:if test="@subtype != ''">, <xsl:value-of select="@subtype"/></xsl:if>
          <xsl:if test="@atlantean='true'">, Atlantideo</xsl:if>
        </fo:block>
        <xsl:if test="count(arts/requisite) &gt; 0">
          <fo:block font-family="{$textfont}" text-indent="1em" font-size="8pt">Requisito: <xsl:apply-templates select="arts/requisite"><xsl:sort select="."/></xsl:apply-templates></fo:block>
        </xsl:if>
        <xsl:apply-templates select="description"/>
        <fo:block margin-bottom="2mm">
          <fo:block font-family="{$textfont}" font-size="7pt" font-style="italic" font-weight="normal">
            <xsl:choose>
              <xsl:when test="@type = 'standard' or @type = 'mystery'">
                <xsl:choose>
                  <xsl:when test="guideline/@ward = 'true' and guideline/base = ''">(Come per linee guida di Difesa</xsl:when>
                  <xsl:otherwise>
                    (Base <xsl:value-of select="guideline/base" /> 
                  </xsl:otherwise>
                </xsl:choose>
                <xsl:call-template name="spell-guidelines" /> <xsl:apply-templates select="arts/requisite" mode="guideline"/>)
              </xsl:when>
              <xsl:when test="@type = 'non-hermetic'">(Non-Ermetico)</xsl:when>
              <xsl:when test="@type = 'general'">(Effetto base)</xsl:when>
              <xsl:when test="@type = 'unique'">(Incantesimo unico)</xsl:when>
              <xsl:when test="@type = 'mercurian'">(Rituale Mercuriale)</xsl:when>
              <xsl:when test="@type = 'special'">(Incantesimo speciale)</xsl:when>
              <xsl:otherwise>
                ERROR
              </xsl:otherwise>
            </xsl:choose>
          </fo:block>
          <xsl:if test="@link != ''">
          <fo:block margin-top="0.5mm" font-family="{$urlfont}" font-size="7pt" font-weight="normal">
            <xsl:variable name="title" select="@link_title"/>
            <xsl:variable name="link" select="@link"/>
            Vedi <fo:inline color="{$urlcolour}" text-decoration="underline"><fo:basic-link external-destination="{$link}"><xsl:value-of select="@link_title"/></fo:basic-link></fo:inline>
          </fo:block>
          </xsl:if>

        </fo:block>
      </fo:block>
    </xsl:for-each>
  </xsl:template>

  <xsl:template name="formtechnique">
    <xsl:param name="form"/>
    <xsl:param name="technique"/>
    <xsl:variable name="color"><xsl:value-of select="/ars_magica/arts/form[name=$form]/color"/></xsl:variable>
    <fo:block keep-with-next.within-page="always" color="{$color}" font-family="{$artfont}" font-size="12pt" margin-bottom="8px" font-weight="normal">
      <fo:marker marker-class-name="form"><xsl:value-of select="$form"/></fo:marker>
      <fo:marker marker-class-name="technique"><xsl:value-of select="$technique"/></fo:marker>
      <xsl:value-of select="$technique"/><xsl:text> </xsl:text><xsl:value-of select="$form"/> Incantesimi
    </fo:block>
    <xsl:variable name="generalspells" select="$in/ars_magica/spells/spell[arts/technique=$technique and arts/form=$form and level='GENERICO']"/>
    <xsl:variable name="spells" select="$in/ars_magica/spells/spell[arts/technique=$technique and arts/form=$form and level != 'GENERICO']"/>
    <xsl:variable name="levels" select="distinct-values($spells/level)"/>

    <xsl:if test="count($generalspells) &gt; 0">
      <fo:block keep-with-next.within-page="always" font-size="9pt" font-family="{$textfont}" margin-bottom="0.2em">GENERICO</fo:block>
      <xsl:call-template name="spells-at-level">
        <xsl:with-param name="form" select="$form"/>
        <xsl:with-param name="technique" select="$technique"/>
        <xsl:with-param name="level" select="'GENERICO'"/>
      </xsl:call-template>
    </xsl:if>
    <xsl:for-each select="$levels">
        <xsl:sort select="." data-type="number"/>
      <xsl:variable name="slevel" select="."/>
      <fo:block keep-with-next.within-page="always" font-size="9pt" font-family="{$textfont}" margin-bottom="0.2em">LIVELLO <xsl:value-of select="$slevel"/></fo:block>
      <xsl:call-template name="spells-at-level">
        <xsl:with-param name="form" select="$form"/>
        <xsl:with-param name="technique" select="$technique"/>
        <xsl:with-param name="level" select="$slevel"/>
      </xsl:call-template>
    </xsl:for-each>
  </xsl:template>

  <xsl:template name="spellindex">
    <fo:page-sequence master-reference="spell-list">
      <fo:static-content flow-name="xsl-region-before">
        <xsl:if test="$edit = ''">
          <fo:block-container absolute-position="absolute" top="0cm" left="0cm" width="{$width}" height="{$height}">
            <fo:block>
              <fo:external-graphic src="images/index-paper{$wide}.jpg" content-height="scale-to-fit" height="{$height}" content-width="{$width}" scaling="non-uniform"/>
            </fo:block>
          </fo:block-container>
        </xsl:if>
        <fo:block id="spell_index">
          <fo:inline-container vertical-align="top" inline-progression-dimension="49.9%">
            <fo:block></fo:block>
          </fo:inline-container>
          <fo:inline-container vertical-align="top" inline-progression-dimension="49.9%">
            <fo:block></fo:block>
          </fo:inline-container>
        </fo:block>
      </fo:static-content>
      <fo:static-content flow-name="xsl-region-after">
        <fo:block color="{$handcolour}" text-align-last="justify" font-family="{$textfont}" font-size="8pt" font-weight="normal" margin-left="2cm" margin-right="2cm">
          <fo:page-number/><fo:leader leader-pattern="space" /> 
        </fo:block>
      </fo:static-content>
      <fo:flow flow-name="xsl-region-body">
        <xsl:for-each select="$sortedspells/spell[(@type='standard' or @type='general') and name != '']">
          <xsl:variable name="first" select="substring(name,1,1)"/>
          <xsl:variable name="prev" select="preceding-sibling::*[1]"/>
          <xsl:variable name="name" select="name"/>

          <xsl:if test="not(substring($prev/name, 1, 1)=$first)">
            <fo:block keep-with-next.within-page="always" font-family="{$artfont}" font-size="12pt" font-weight="normal" margin-top="0.5em">
              <xsl:choose>
              <xsl:when test="$first = '('"></xsl:when>
              <xsl:otherwise><xsl:value-of select="$first"/></xsl:otherwise>
              </xsl:choose>
            </fo:block>
          </xsl:if>
          <fo:block font-family="{$textfont}" font-size="8pt" font-weight="normal" text-align-last="justify">
            <fo:basic-link internal-destination="{generate-id(.)}">
              <xsl:value-of select="name" />
              <fo:leader leader-pattern="dots" />
              <fo:page-number-citation ref-id="{generate-id(.)}" />              
            </fo:basic-link>
          </fo:block>
        </xsl:for-each>
      </fo:flow>
    </fo:page-sequence>
  </xsl:template>

  <xsl:template name="bookindex">
    <fo:page-sequence master-reference="spell-list">
      <fo:static-content flow-name="xsl-region-before">
        <xsl:if test="$edit = ''">
          <fo:block-container absolute-position="absolute" top="0cm" left="0cm" width="{$width}" height="{$height}">
            <fo:block>
              <fo:external-graphic src="images/index-paper{$wide}.jpg" content-height="scale-to-fit" height="{$height}" content-width="{$width}" scaling="non-uniform"/>
            </fo:block>
          </fo:block-container>
        </xsl:if>
        <fo:block id="book_index">
          <fo:inline-container vertical-align="top" inline-progression-dimension="49.9%">
            <fo:block></fo:block>
          </fo:inline-container>
          <fo:inline-container vertical-align="top" inline-progression-dimension="49.9%">
            <fo:block></fo:block>
          </fo:inline-container>
        </fo:block>
      </fo:static-content>
      <fo:static-content flow-name="xsl-region-after">
        <fo:block color="{$handcolour}" text-align-last="justify" font-family="{$textfont}" font-size="8pt" font-weight="normal" margin-left="2cm" margin-right="2cm">
          <fo:page-number/><fo:leader leader-pattern="space" /> 
        </fo:block>
      </fo:static-content>
      <fo:flow flow-name="xsl-region-body">
        <fo:block keep-with-next.within-page="always" font-family="{$artfont}" font-size="14pt" font-weight="normal" margin-top="0.5em">
          Incantesimi per Libro
        </fo:block>
        <xsl:for-each select="$spellsbybook/spell[(@type='standard' or @type='general') and name != '']">
          <xsl:variable name="name" select="name"/>
          <xsl:variable name="source" select="@source"/>
          <xsl:variable name="prev" select="preceding-sibling::*[1]"/>
          <xsl:variable name="book">
            <xsl:choose>
              <xsl:when test="@source != ''"><xsl:value-of select="$in//book[abbreviation = $source]/name"/></xsl:when>
              <xsl:otherwise>ArM5</xsl:otherwise>
            </xsl:choose>
          </xsl:variable>
          <xsl:variable name="prevbook">
            <xsl:choose>
              <xsl:when test="$prev/@source != ''"><xsl:value-of select="$in//book[abbreviation = $prev/@source]/name"/></xsl:when>
              <xsl:otherwise>ArM5</xsl:otherwise>
            </xsl:choose>
          </xsl:variable>

          <xsl:if test="$prevbook != $book or position() = 1">
            <fo:block keep-with-next.within-page="always" font-family="{$artfont}" font-size="10pt" font-weight="normal" margin-top="0.5em">
              <xsl:value-of select="$book"/>
            </fo:block>
          </xsl:if>
          <fo:block font-family="{$textfont}" font-size="8pt" font-weight="normal" text-align-last="justify">
            <fo:basic-link internal-destination="{generate-id($sortedspells/spell[name=$name][1])}">
              <xsl:value-of select="name" />
            </fo:basic-link>
            <xsl:variable name="link" select="@link"/>
            <fo:leader leader-pattern="dots" /><xsl:if test="@page != ''">Pag. <xsl:value-of select="@page" /></xsl:if>
            <xsl:if test="@link != ''"><fo:inline color="{$urlcolour}"><fo:basic-link external-destination="{$link}">Link</fo:basic-link></fo:inline></xsl:if>
          </fo:block>
        </xsl:for-each>
      </fo:flow>
    </fo:page-sequence>
  </xsl:template>

</xsl:stylesheet>