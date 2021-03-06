<?xml version="1.0" encoding="UTF-8"?>
<!--
   Purpose:
     Transforms DocBook document into Novdoc
     
   Parameters:
     * createvalid
       Should the output be valid? 1=yes, 0=no
     * menuchoice.menu.separator (default: " > ")
       String to separate menu components in titles (only for 
       guimenuitem and guisubmenu)
     * menuchoice.separator (default: "+")
       String to separate menu components in titles
     * rootid
       Process only parts of the document
       
   Input:
     DocBook4 document
     
   Output:
     Novdoc document (subset of DocBook)
   
   DocBook 5 compatible:
     No, convert your document to DocBook 4 first
   
   Author:    Thomas Schraitle <toms@opensuse.org>
   Copyright (C) 2012-2015 SUSE Linux GmbH
   
-->

<!DOCTYPE xsl:stylesheet
[
  <!ENTITY dbinline "abbrev|acronym|biblioref|citation|
 citerefentry|citetitle|citebiblioid|emphasis|firstterm|
 foreignphrase|glossterm|termdef|footnote|footnoteref|phrase|orgname|quote|
 trademark|wordasword|personname|link|olink|ulink|action|
 application|classname|methodname|interfacename|exceptionname|
 ooclass|oointerface|ooexception|package|command|computeroutput|
 database|email|envar|errorcode|errorname|errortype|errortext|
 filename|function|guibutton|guiicon|guilabel|guimenu|guimenuitem|
 guisubmenu|hardware|interface|keycap|keycode|keycombo|keysym|
 literal|code|constant|markup|medialabel|menuchoice|mousebutton|
 option|optional|parameter|prompt|property|replaceable|
 returnvalue|sgmltag|structfield|structname|symbol|systemitem|uri|
 token|type|userinput|varname|nonterminal|anchor|author|
 authorinitials|corpauthor|corpcredit|modespec|othercredit|
 productname|productnumber|revhistory|remark|subscript|
 superscript|inlinegraphic|inlinemediaobject|inlineequation|
 synopsis|cmdsynopsis|funcsynopsis|classsynopsis|fieldsynopsis|
 constructorsynopsis|destructorsynopsis|methodsynopsis|indexterm|xref">
]>

<xsl:stylesheet 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:exslt="http://exslt.org/common"
  version="1.0"
  exclude-result-prefixes="exslt">
  
  <xsl:import href="../common/copy.xsl"/>
  <!--<xsl:import href="rootid.xsl"/>-->
  
  <xsl:output method="xml" 
    indent="yes"/>
  <!-- We need to add the internal subset, so adding this is not enough:
    doctype-public="-//Novell//DTD NovDoc XML V1.0//EN"
    doctype-system="novdocx.dtd"/>
  -->
  
  
 
  <xsl:strip-space elements="*"/>
  <xsl:preserve-space elements="screen"/>
  
  <!-- Should the output be valid? 1=yes, 0=no -->
  <xsl:param name="createvalid" select="1"/>
  <xsl:param name="menuchoice.menu.separator"> > </xsl:param>
  <xsl:param name="menuchoice.separator">+</xsl:param>
  <xsl:param name="rootid"/>
  <xsl:param name="pi.profile.uri">urn:x-suse:xslt:profiling:novdoc-profile.xsl</xsl:param>
  
  
  <xsl:key name="id" match="*" use="@id|@xml:id"/>
  

  <!-- Suppressed attributes -->
  <xsl:template match="@continuation"/>
  <xsl:template match="@format"/>
  <xsl:template match="@float"/>
  <xsl:template match="@inheritnum"/>
  <xsl:template match="section/@lang|sect1/@lang"/>
  <xsl:template match="@moreinfo"/>
  <xsl:template match="@significance"/>
  <xsl:template match="@mark"/>
  <xsl:template match="@spacing"/>
  <xsl:template match="*/@status"/>
  <xsl:template match="book/@xml:base"/>
  <xsl:template match="productname/@class"/>
  <xsl:template match="orderedlist/@spacing[. ='normal']"/>
  <xsl:template match="step/@performance[. = 'required']"/>
  <xsl:template match="substeps/@performance[. = 'required']"/>
  <xsl:template match="@rules[. ='all']"/>
  <xsl:template match="@wordsize"/>
  <xsl:template match="screen/@language"/>
  <xsl:template match="filename/@class"/>
  <xsl:template match="literallayout/@class"/>
  <xsl:template match="variablelist/@role"/>
  
  <!-- Suppressed elements -->
  <xsl:template match="abstract/title"/>
  
  <xsl:template name="getrootname">
    <xsl:choose>
      <xsl:when test="$rootid !=''">
        <xsl:if test="count(key('id',$rootid)) = 0">
          <xsl:message terminate="yes">
            <xsl:text>ID '</xsl:text>
            <xsl:value-of select="$rootid"/>
            <xsl:text>' not found in document.</xsl:text>
          </xsl:message>
        </xsl:if>
        <xsl:value-of select="local-name(key('id',$rootid)[1])"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="local-name(/*[1])"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <xsl:template match="/">
    <xsl:apply-templates select="processing-instruction('xml-stylesheet')"/>
    <xsl:text disable-output-escaping="yes">&#10;&lt;!DOCTYPE </xsl:text>
    
   <xsl:call-template name="getrootname"/>
<xsl:text disable-output-escaping="yes"> PUBLIC "-//Novell//DTD NovDoc XML V1.0//EN" "novdocx.dtd"
[
  &lt;!ENTITY % NOVDOC.DEACTIVATE.IDREF "INCLUDE">
  &lt;!ENTITY % entities SYSTEM "entity-decl.ent">
  %entities;
]>
&#10;</xsl:text>
    <xsl:apply-templates select="node()[not(self::processing-instruction('xml-stylesheet'))]"/>
    <!--<xsl:call-template name="process.rootid.node"/>-->
  </xsl:template>
  
  <xsl:template match="/processing-instruction('xml-stylesheet')">
    <xsl:processing-instruction name="xml-stylesheet">href="<xsl:value-of select="$pi.profile.uri"/>" 
 type="text/xml"
 title="Profiling step"</xsl:processing-instruction>
    <xsl:text>&#10;</xsl:text>
  </xsl:template>
  
  <xsl:template match="book/title|book/titleabbrev"/><!-- Don't copy -->
  <xsl:template match="bookinfo">
    <bookinfo>
      <xsl:copy-of select="(title|../title)[1]"/>
      <productname><xsl:text
        disable-output-escaping="yes">&amp;productname;</xsl:text><!--<xsl:value-of select="subtitle"/>--></productname>
      <productnumber><xsl:text disable-output-escaping="yes">&amp;productnumber;</xsl:text></productnumber>
      <date><xsl:processing-instruction name="dbtimestamp">
          <xsl:text>format="B d, Y"</xsl:text>
        </xsl:processing-instruction></date>
      <xsl:copy-of select="legalnotice"/>
      <xsl:apply-templates select="abstract"/>
    </bookinfo>
  </xsl:template>
    
  <xsl:template match="mediaobject/textobject">
    <xsl:message>mediaobject/textobject: <xsl:value-of select="normalize-space(.)"/></xsl:message>
    <xsl:comment>
      <xsl:value-of select="normalize-space(.)"/>
    </xsl:comment>
  </xsl:template>
  
  <xsl:template match="mediaobject/textobject[screen]">
    <xsl:copy-of select="."/>
  </xsl:template>
  
  <xsl:template match="literallayout">
    <screen>
      <xsl:apply-templates/>
    </screen>
  </xsl:template>
  
  <xsl:template name="test4para">
    
    <xsl:choose>
      <!-- Test, if the second element is a section. In that case,
                 insert a para to make it a valid Novdoc source
                 depending on the $createvalid parameter
            -->
      <xsl:when test="*[2][self::sect1 or self::sect2 or self::sect3 or self::sect4 or self::section]">
        <xsl:apply-templates select="title"/>
        <xsl:choose>
          <xsl:when test="$createvalid != 0">
            <para><remark role="fixme">Add a short description</remark></para>
          </xsl:when>
          <xsl:otherwise>
            <xsl:comment>FIXME: Add a short description</xsl:comment>
          </xsl:otherwise>
        </xsl:choose>
        <xsl:apply-templates select="node()[not(self::title)]"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <xsl:template match="section">
    <xsl:variable name="depth" select="count(ancestor::section)+1"/>
  
    <xsl:choose>
      <xsl:when test="$depth &lt; 5">
        <xsl:element name="sect{$depth}">
          <xsl:apply-templates select="@*"/> 
          <xsl:call-template name="test4para"/>
        </xsl:element>
      </xsl:when>
      <xsl:otherwise>
        <!--<xsl:message>***<xsl:value-of select="concat(name(), ' #' , @id)"/>: <xsl:value-of
        select="$depth"/></xsl:message>-->
        <xsl:text>&#10;</xsl:text>
        <xsl:comment>sect5</xsl:comment>
        <bridgehead><!--  id="{@id}" -->
          <xsl:copy-of select="@id"/>
          <xsl:apply-templates select="title"/>
        </bridgehead>   
        <xsl:apply-templates select="node()[not(self::title)]"/>
        <xsl:comment>/sect5</xsl:comment>
        <xsl:text>&#10;</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  
  <xsl:template match="section/section/section/section/section/title|sect5/title">
    <xsl:apply-templates />
  </xsl:template>
  
  
  <xsl:template match="sect1|sect2|sect3|sect4">
    <xsl:copy>
      <xsl:apply-templates select="@*"/>
      <xsl:call-template name="test4para"/>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="sect5">
    <xsl:message>bridgehead: <xsl:value-of select="name()"/></xsl:message>
    <bridgehead>
       <xsl:copy-of select="@id"/>
       <xsl:apply-templates select="title"/>
    </bridgehead>
    <xsl:apply-templates select="node()[not(self::title)]"/>
  </xsl:template>
  
  <xsl:template match="application|abbrev|firstterm|glossterm">
    <xsl:apply-templates />
  </xsl:template>
  
  <xsl:template match="command/command">
    <xsl:apply-templates />
  </xsl:template>
  
  <xsl:template match="guilabel|guibutton|guimenuitem|guiicon|guisubmenu">
    <guimenu>
      <xsl:apply-templates/>
    </guimenu>
  </xsl:template>
  
  <xsl:template match="guilabel/replaceable">
    <xsl:apply-templates/>
  </xsl:template>
  
  <xsl:template match="errorcode|classname|code|computeroutput|methodname|prompt[not(parent::screen)]|sgmltag|returnvalue|uri|userinput">
    <literal>
      <xsl:apply-templates/>
    </literal>
  </xsl:template>
  
  <xsl:template match="errortext">
    <emphasis>
      <xsl:apply-templates/>
    </emphasis>
  </xsl:template>
  
  <xsl:template match="literal[ulink]">
    <xsl:apply-templates/>
  </xsl:template>
  
  <xsl:template match="literal/ulink[normalize-space(.) != '']">
    <xsl:copy>
      <xsl:copy-of select="@*"/>
      <literal>
        <xsl:apply-templates/>
      </literal>
    </xsl:copy>
  </xsl:template>
  
  
  <xsl:template match="entry[&dbinline;] | entry[not(*)][normalize-space(text() != '')]">
    <entry>
      <para>
        <xsl:apply-templates/>
      </para>
    </entry>
  </xsl:template>
  
   
  <xsl:template match="package">
    <systemitem class="resource">
      <xsl:apply-templates/>
    </systemitem>
  </xsl:template>
  
  <xsl:template match="parameter">
    <option>
      <xsl:apply-templates/>
    </option>
  </xsl:template>
    
  <xsl:template match="simplelist[@type='vert']">
    <itemizedlist>
      <xsl:apply-templates/>
    </itemizedlist>
  </xsl:template>
  
  <xsl:template match="itemizedlist[para or note]">
    <xsl:apply-templates select="itemizedlist/para | itemizedlist/note"/>
    <xsl:copy>
      <xsl:copy-of select="@*"/>
      <xsl:apply-templates select="node()[not(self::para or self::note)]"/>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="member">
    <listitem>
      <para>
        <xsl:apply-templates/>
      </para>
    </listitem>
  </xsl:template>
   
  <xsl:template match="note/procedure">
    <orderedlist>
      <xsl:apply-templates/>
    </orderedlist>    
  </xsl:template>
   
  <xsl:template match="note/procedure/step">
    <listitem>
      <xsl:apply-templates/>
    </listitem>
  </xsl:template>
  
  <xsl:template match="note/formalpara">
    <xsl:apply-templates/>
  </xsl:template>
  
  <xsl:template match="step/title">
    <para><emphasis role="bold">
      <xsl:apply-templates/>
    </emphasis></para>
  </xsl:template>
  
  <xsl:template match="systemitem[@class='protocol']">
    <systemitem>
      <xsl:apply-templates/>
    </systemitem>
  </xsl:template>
  
  <xsl:template match="title/menuchoice">
      <xsl:call-template name="process.menuchoice"/>
  </xsl:template>
  
  <xsl:template match="screen/@remap">
    <xsl:attribute name="remap">
      <xsl:value-of select="."/>
    <xsl:if test="../@language">
      <xsl:value-of select="concat('-', ../@language)"/>
    </xsl:if>
    </xsl:attribute>
  </xsl:template>
  
  <xsl:template match="entry/variablelist">
    <itemizedlist>
      <xsl:apply-templates/>
    </itemizedlist>
  </xsl:template>
  
  <xsl:template match="entry/variablelist/varlistentry">
    <listitem>
      <xsl:apply-templates select="term"/>
      <xsl:apply-templates select="node()[not(self::term)]"/>  
    </listitem>
    
  </xsl:template>
  
  <xsl:template match="entry/variablelist/varlistentry/term">
    <para>
      <xsl:apply-templates/>
    </para>
  </xsl:template>
  
  <xsl:template match="entry/variablelist/varlistentry/listitem">
    <xsl:apply-templates/>
  </xsl:template>
  
  <xsl:template name="process.menuchoice">
  <xsl:param name="nodelist" select="guibutton|guiicon|guilabel|guimenu|guimenuitem|guisubmenu|interface"/><!-- not(shortcut) -->
  <xsl:param name="count" select="1"/>

  <xsl:choose>
    <xsl:when test="$count>count($nodelist)"></xsl:when>
    <xsl:when test="$count=1">
      <xsl:apply-templates select="$nodelist[$count=position()]"/>
      <xsl:call-template name="process.menuchoice">
        <xsl:with-param name="nodelist" select="$nodelist"/>
        <xsl:with-param name="count" select="$count+1"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
       <xsl:variable name="node" select="$nodelist[$count=position()]"/>
      <xsl:choose>
        <xsl:when test="local-name($node)='guimenuitem'
                        or local-name($node)='guisubmenu'">
          <xsl:value-of select="$menuchoice.menu.separator"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$menuchoice.separator"/>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="$node"/>
      <xsl:call-template name="process.menuchoice">
        <xsl:with-param name="nodelist" select="$nodelist"/>
        <xsl:with-param name="count" select="$count+1"/>
      </xsl:call-template>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

</xsl:stylesheet>
