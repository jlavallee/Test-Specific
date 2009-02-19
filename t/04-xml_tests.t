#!perl -T

use Test::More tests => 1;

use Test::Specific;

my $xml =  <<'EOXML';
<?xml version="1.0" encoding="UTF-8" ?>
<!DOCTYPE chapter PUBLIC "-//OASIS//DTD DocBook XML V4.2//EN"
		"http://www.oasis-open.org/docbook/xml/4.2/docbookx.dtd">
<chapter id="quickstart">
  <chapterinfo>
    <keywordset>
      <keyword>
	portfile
      </keyword>
    
      <keyword>
        introduction
      </keyword>
      
      <keyword>
        maintainer
      </keyword>
    </keywordset>
  </chapterinfo>
  
  <title>Quick Start</title> 

  <sect1 id="getting_started">
    <title>Getting Stated With DarwinPorts</title>

    <para>This document will provide a short guide to the basics of a
      DarwinPorts <filename>Portfile</filename>.  A
      <filename>Portfile</filename> is actually a Tcl script run by the
      <command>port</command> system.  Despite this, the
      <filename>Portfile</filename> syntax is very
      straightforward.</para>
    
    <para>In order to work with DarwinPorts, you will need to download and
      install it on your system.  The <link linkend='getting_dports'> 
      Obtaining</link> and <link linkend='install_dports'>Installing  
      DarwinPorts</link> sections of this guide describes the process in
      detail. </para>

    <para>Since you're interested in writing a
      <filename>Portfile</filename>, you should invoke the
      <command>port</command> with the <option>-v</option> (verbose
      output) and the <option>-d</option> (debugging option) switches.
      This will display useful messages that are usually suppressed
      while running DarwinPorts.</para>
  </sect1>

  <sect1 id="basics">
    <title>Basic Topics and Examples</title>

    <sect2 id="fetching_sources">
      <title>Fetching the Sources</title>

      <para>The first step is to choose a piece of software to port.  
      For this example, we'll be porting ircII, a popular Internet relay 
      chat client.</para>

      <para>We can start with a simple <filename>Portfile</filename>
        describing the basic attributes of ircII, such as its name,
        version, and the site where we can download the sources.  </para>
        <para>Create a working directory named <filename>ircII</filename> 
        and inside it create a file named <filename>Portfile</filename> 
        with the following contents:</para>

      <example id="ircii">
        <title>ircII <filename>Portfile</filename></title> 
          
        <programlisting># &#x0024;Id: &#x0024;
PortSystem        1.0
name              ircii
version           20020912
categories        irc
maintainers       kevin@opendarwin.org
description       an IRC and ICB client
long_description  The ircII program is a full screen, termcap based \
                  interface to Internet Relay Chat. It gives full access \
                  to all of the normal IRC functions, plus a variety of \
                  additional options.
homepage          http://www.eterna.com.au/ircii/
master_sites      ftp://ircftp.au.eterna.com.au/pub/ircII/</programlisting>
      </example>

      <para>A <filename>Portfile</filename> consists of key/value pairs.
        This example uses the following keys:</para>
 
      <variablelist>
        <varlistentry>
          <term><varname># &#x0024;Id: &#x0024;</varname></term>
          
          <listitem>
            <para>Every <filename>Portfile</filename> starts with
              <varname>#&#x0024;Id: &#x0024;</varname>. This is a RCS
              <varname>Id</varname> tag (commented out with the '#' character
              so that DarwinPorts is not confused by the tag). </para>
          </listitem>
        </varlistentry>

        <varlistentry>
          <term><varname>PortSystem</varname></term>

          <listitem>
            <para>Following the RCS <varname>Id</varname> tag comes the
              <varname>PortSystem</varname> version declaration.  Currently the
              only valid version declaration is <varname>PortSystem
                1.0</varname>.</para>
          </listitem>
        </varlistentry>

        <varlistentry>
          <term><varname>name</varname> and
            <varname>version</varname></term>

          <listitem>
            <para>The <varname>name</varname> and
              <varname>version</varname> keys describe the name and
              version of the software.</para>
          </listitem>
        </varlistentry>
        
        <varlistentry>
          <term><varname>categories</varname></term>
          
          <listitem>
            <para>The <varname>categories</varname> key is a list of the
              logical categories to which the software belongs; this is
              used for organizational purposes.  The first entry in
              <varname>categories</varname> should match the directory
              in which the port's directory resides in the ports
              tree.</para>
          </listitem>
        </varlistentry>

        <varlistentry>
          <term><varname>maintainers</varname></term>

          <listitem>
            <para>The <varname>maintainers</varname> key should contain
              the email address of the person or persons maintaining the port.</para>
          </listitem>
        </varlistentry>

        <varlistentry>
          <term><varname>description</varname> and
            <varname>long_description</varname></term>

          <listitem>
            <para><varname>description</varname> provides a short (one line)
              description of the port, while
              <varname>long_description</varname> holds a more detailed
              description of the software.</para>
          </listitem>
        </varlistentry>

        <varlistentry>
          <term><varname>homepage</varname></term>

          <listitem>
            <para>To refer to the main web site of the software, the
              <varname>homepage</varname> key is used.</para>
          </listitem>
        </varlistentry>

        <varlistentry>
          <term><varname>master_sites</varname></term>
          
          <listitem>
            <para>The <varname>master_sites</varname> key should contain
              a list of sites where the distribution sources may be
              downloaded by the port system. </para>
          </listitem>
        </varlistentry>
      </variablelist>
      
      <para>DarwinPorts uses the terms 'keys' and 'options'
        interchangeably since most keys are used as options of a
        particular task in the porting process.</para>
      
      <para>At this point, the <filename>Portfile</filename> is complete
        enough to download ircII.  By default, DarwinPorts will append
        the <varname>version</varname> to <varname>name</varname> and
        assume sources are in a gzipped tar archive with the 
        <filename>.tar.gz</filename> suffix. </para>
        <para>From your working directory, execute the following command:</para>
      
      <para><userinput>port -d -v checksum</userinput></para>

      <para>The <command>port</command> command (when used without an explicit
      port name operates on the <filename>Portfile</filename> in the current 
      working directory. You should see the following output:</para>

      <para><computeroutput><literallayout>DEBUG: Executing com.apple.main (ircii)
DEBUG: Executing com.apple.fetch (ircii)
--->  ircii-20020912.tar.gz doesn't seem to exist in /opt/local/var/db/dports/distfiles
--->  Attempting to fetch ircii-20020912.tar.gz from ftp://ircftp.au.eterna.com.au/pub/ircII/
DEBUG: Executing com.apple.checksum (ircii)
Error: No checksums statement in Portfile.  File checksums are:
ircii-20020912.tar.gz md5 2ae68c015698f58763a113e9bc6852cc
Error: Target error: com.apple.checksum returned: No checksums statement in Portfile.
</literallayout></computeroutput></para>
    </sect2>

    <sect2 id="checksums">
      <title>Verifying the Downloaded File</title>

      <para>Notice that DarwinPorts first checks for a local copy of
        <filename>ircii-20020912.tar.gz</filename> and doesn't find it,
        so it then downloads from the remove site.  The port doesn't
        finish because of an error: <computeroutput>No checksums
          statement in Portfile.</computeroutput>
        Portfiles must contain an md5 checksum of all distribution
        files--this allows DarwinPorts to verify the accuracy and
        authenticity of the sources.  For convenience, an md5 checksum
        of the downloaded files is printed when the
        <varname>checksums</varname> argument is not specified.  Go back
        and add the following to your
        <filename>Portfile</filename>:</para>

      <programlisting>checksums    md5 2ae68c015698f58763a113e9bc6852cc</programlisting>

      <para>If you have more than one file being fetched you should
        specify the checksum for each in the form:</para>

      <programlisting>checksums    foo md5 ... \
             bar md5 ...</programlisting>
      
    </sect2>

    <sect2 id="extract">
      <title>Extracting the Sources into a Working Directory</title>

      <para>Now that we have a checksum and can verify our sources, we
        can proceed to extracting the sources into our working
        directory.  Execute the following:</para>

      <para><userinput>port -d -v extract</userinput></para>

      <para>Which should display the following output:</para>

      <para><computeroutput><literallayout>DEBUG: Skipping completed com.apple.main (ircii)
DEBUG: Skipping completed com.apple.fetch (ircii)
DEBUG: Executing com.apple.checksum (ircii)
--->  Checksum OK for ircii-20020912.tar.gz
DEBUG: Executing com.apple.extract (ircii)
--->  Extracting for ircii-20020912
--->  Extracting ircii-20020912.tar.gz ... DEBUG: Assembled command: 'cd
/Users/kevin/opendarwin/proj/darwinports/dports/irc/ircii/work &amp;&amp; gzip -dc /opt/local/var/db/dports/distfiles/ircii-20020912.tar.gz | tar -xf -'
Done</literallayout></computeroutput></para>
    </sect2>

    <sect2 id="running_configure">
      <title>Running a <filename>configure</filename> Script</title>

      <para>Now that the sources have been extracted into a
        <filename>work</filename> directory in the Portfile
        directory, we can configure the sources to compile with the
        desired options.  By default DarwinPorts assumes the software
        you're porting uses an autoconf <filename>configure</filename>
        script and  will pass the <option>--prefix=${prefix}</option> 
        argument to <filename>configure</filename>, specifying that the 
        software should be installed in the directory tree used by
        DarwinPorts.</para>

      <para>ircII's standard set of options is fine for a base
        install on Darwin, so we won't add anything to the
        <varname>configure</varname> phase and instead just
        move on to the build phase.  Please look at the
        later chapters in this Guide for more information about
        the <link linkend='configure'>Configuration</link> phase.</para>
    </sect2>

    <sect2 id="building_sources">
      <title>Building the Sources</title>

      <para>To build, type the following:</para>
      
      <para><userinput>port build -v -d</userinput></para>

      <para>By default, the build phase executes the system's
        <command>make</command>(1) utility.  (This can be changed with
        the <varname>build.type</varname> option which accepts an
        argument of <varname>bsd</varname>, <varname>gnu</varname>, or
        <varname>pbx</varname>.  Alternatively, the
        <varname>build.cmd</varname> option may be used to specify an
        arbitrary build command.)  The above step has started
        compiling the sources, when it finishes we'll be ready to
        install the software.</para>
    </sect2>

    <sect2 id="installing">
      <title>Installing the Finished Product on the System</title>

      <para>The former method of including a
        <varname>contents</varname> list has been made obsolete by the
        <varname>destroot</varname> mechanism.  With
        <varname>destroot</varname> the software is installed into a
        directory tree below in the <filename>work</filename>
        directory.  While some software (like ircII) does not require
        any special tweaks to be installed into the destroot, others
        (like ncftp) need the <varname>install.destroot</varname>
        option in order to correctly install into the
        <varname>destroot</varname>.</para>

      <programlisting>destroot.destdir     mandir=${destroot}${prefix}/man prefix=${destroot}${prefix}</programlisting>

      <para>Take a look at some of our ports to see more examples on
        how to use the <varname>destroot.destdir</varname>
        option.</para>

      <para>Now we have a complete <filename>Portfile</filename>.
        Run the installation step to add your port to your own
        registry. </para>
      
      <para><userinput>sudo port -d -v install</userinput></para>

      <para>Which should finish with the output:</para>

      <para><computeroutput><literallayout>
--->  Adding ircii to registry, this may take a moment...</literallayout></computeroutput></para>
    </sect2>
  </sect1>

  <sect1 id="advanced">
    <title>Advanced Topics</title>

    <sect2 id="overriding_targets">
      <title>Overriding Targets</title>

      <para>It's possible to override the functionality of any build
        target with Tcl code.  A common example is the following which
        might be useful for a script without a configure script. 
        <filename>configure</filename> script:</para>

      <programlisting>configure    {}</programlisting>

      <para>In the <filename>Portfile</filename>, this will replace
        the functionality of the <varname>configure</varname> target,
        thus skipping that step.  It is also possible to execute Tcl
        code immediately before or after any of the standard targets.
        This can be accomplished using pre--&lt;target&gt; or 
        post-&lt;target&gt; in the following manner:</para>

      <programlisting>post-configure {
    reinplace "s|change.this.to.a.server|irc.openprojects.net|g" \
              "${worksrcpath}/config.h"
}</programlisting>

      <para>This example replaces the occurrence of
        <varname>change.this.to.a.server</varname> with
        <varname>irc.freenode.net</varname> in the
        <filename>config.h</filename> file that was generated during
        the preceding <varname>configure</varname> phase.  Note this
        is a somewhat contrived example, since the same could have
        been accomplished by specifying
        <varname>--with-default-server=irc.freenode.net</varname>
        in <varname>configure.args</varname>, but the approach is
        generally useful when such configure arguments aren't
        present.</para>
    </sect2>

    <sect2 id="variants">
      <title>Portfile Variants</title>

      <para>Since Darwin 6.0 has ipv6, it would be possible to
        configure with the <varname>--with-ipv6</varname> option.
        This can be done by adding the following option to the
        <filename>Portfile</filename>:</para>

      <programlisting>configure.args      --disable-ipv6

variant ipv6 {
    configure.args-append  --enable-ipv6
}</programlisting>

      <para>Now the default build will not include ipv6 support, but
        if the ipv6 variant is requested, ircII will have it.  Options
        by themselves should be thought of as an assignment operator.
        Since variants may be used in combination with one another,
        it's good practice to only append to options instead of
        overwriting them.  All options may be suffixed with
        <varname>-append</varname> or <varname>-delete</varname> to
        append or delete one term from the list.  You can specify
        building with the ipv6 variant in the following way:</para>

      <para><userinput>port build +ipv6</userinput></para>
    </sect2>
      
    <sect2 id="mirror_sites">
      <title>Mirror Site Lists</title>

      <para>It is possible to use predefined lists of mirror sites in
        your <filename>Portfile</filename>, such as SourceForge or GNU
        mirrors.  The straight-forward usage is:</para>

      <programlisting>master_sites                sourceforge http://distfiles.opendarwin.org/
master_sites.mirror_subdir  ${name}</programlisting>

      <para>In this example, <varname>sourceforge</varname> is the name
        of the mirror site list (See Chapter 3, 'Fetch Phase' for a list
        of all available mirror site lists),
        <varname>http://distfiles.opendarwin.org/</varname> is a normal
        <varname>master_sites</varname> URL, and
        <varname>${name}</varname> (the value of the
        <varname>name</varname> keyword in the
        <filename>Portfile</filename>) is the subdirectory to append to
        any mirror site lists specified.</para>

      <para>This will search all of the mirror sites for SourceForge and
        then http://distfiles.opendarwin.org, appending 
        <varname>${name}</varname> to the end of each SoureForge mirror
        site in the list.  This example will try to fetch from:</para>

      <programlisting>http://us.dl.sourceforge.net/${name}/
ftp://us.dl.sourceforge.net/pub/sourceforge/${name}/
...
http://distfiles.opendarwin.org/</programlisting>

      <para>Note that the value of
        <varname>master_sites.mirror_subdir</varname> is
        <emphasis>not</emphasis> appended to
        <varname>http://distfiles.opendarwin.org/</varname>, this URL is
        treated normally.  In this example
        <varname>master_sites.mirror_subdir</varname> is a required
        key.</para>

      <para>You can also use the mirror site lists in
        <varname>patch_sites</varname> and use
        <varname>patch_sites.mirror_subdir</varname> to specify the
        subdirectory.  For more information and advanced usage of mirror
        site lists (i.e. distfile tags, multiple lists with different
        subdirectories), please see Chapter 3, 'Fetch Phase'.</para>
    </sect2>

    <sect2 id="additional options">
      <title>Additional Options</title>

      <para>There are additional options that are commonly used in
        <filename>Portfile</filename>s.  The following are commonly
        used options that may be useful:</para>

      <variablelist>
        <varlistentry>
          <term><varname>distfiles</varname></term>

          <listitem>
            <para><varname>distfile</varname> is the name and version
              combined with the <varname>extract.suffix</varname> (by
              default <filename>${name}-${version}.tar.gz</filename>) 
              by default, and is used by DarwinPorts to fetch the 
              distribution file.  If the name of the file on the server 
              is not the same as <filename>${name}-${version}.tar.gz
              </filename> you can use this option to override the default
              <varname>distfile</varname> name. </para>
          </listitem>
        </varlistentry>
        
        <varlistentry>
          <term><varname>depends_lib</varname></term>

          <listitem>
            <para><varname>depends_lib</varname> is used if the port
              needs other libraries or binaries to be installed in order
              to <varname>configure</varname> and run.  It takes three
              terms, separated by colons.  The first term is
              <varname>bin</varname> or <varname>lib</varname>.  This
              defines the search path the port system will look for the
              dependency in.  If <varname>bin</varname> is specified,
              <varname>$PATH</varname> is searched for the dependency.
              If <varname>lib</varname> is specified, the library path
              is searched instead.  The second term is a regular
              expression that is used to search the search path for the
              dependency.  Usually the name of the library is good
              enough.  The port system will append
              <filename>.dylib</filename> to the reg-ex so only dynamic
              libraries will be matched.  The third term is the name of
              the port that can provide the dependency if it is not
              satisfied by something already installed on the
              system.</para>
          </listitem>
        </varlistentry>

        <varlistentry>
          <term><varname>patchfiles</varname></term>

          <listitem>
            <para><varname>patchfiles</varname> is a list of patches to
              be applied to the port (needed for the software to
              compile/run or install correctly).  Patches are usually
              provided in a <filename>files/</filename> directory in the
              same directory as the
              <filename>Portfile</filename>.</para>
          </listitem>
        </varlistentry>
      </variablelist>

      <para>Please take a look at the other chapters in this
        Guide for more detailed information about these and other
        options.</para>
    </sect2>
  </sect1>

  <sect1 id="common_mistakes">
    <title>Common Mistakes</title>

    <sect2 id="dont_wrap_brackets">
     <title>Don't quote or wrap items in '{}'.</title> 
        
      <para> Frequently people submit ports with the description or
        configure arguments quoted, or wrapped in curly brackets. In
        general this is not correct.  </para>
    </sect2>
  </sect1>

  <sect1 id="testing_hints">
    <title>Testing <filename>Portfiles</filename>: Tips and Hints</title>

    <sect2 id="debug_verbose_msgs">
      <title>Debugging and Verbose Messages</title>

      <para>You should use the <option>-d</option> and
        <option>-v</option> switches to <command>port</command> to
        enable debugging and verbose messages, respectively.</para>
    </sect2>

    <sect2 id="local_repository">
      <title>Use a Local Portfile Repository</title>

      <para> Enable a second local source
        (<filename>Portfile</filename>) repository for your
        uncommitted ports.  Edit
        <filename>/etc/ports/sources.conf</filename> and
        add:<userinput>file:///User/foo/dports-dev</userinput> (or
        wherever your local dport tree is).</para>

      <para> Create an index file from the local source repository
        root. This will also perform a simple syntax check Portfiles
        contained.</para>
	
      <para><userinput>portindex</userinput></para>
    </sect2>

    <sect2 id="testing_destroot">
      <title>Testing Destroot</title>
      
      <para>First run port install without root privileges, this is a
        good way to check that the port installs into the destroot and
        not directly into the main prefix directory, or elsewhere in
        the system.  This should succeed up to the point darwinports
        attempts to copy the port from the destroot into the
        darwinports prefix. Once you are confident the port is
        correctly destrooted install the port into the darwinports
        prefix using root privileges. </para>
      
      <para><userinput>sudo port install foo</userinput></para>

      <para> Ensure the Port installs into the destroot and does not
        install anything onto the system directly, most software that
        uses autoconf should behave correctly automatically as
        darwinports sets DESTDIR by default. If files are directly
        installed to the system they will not be registered and
        packaging will fail. </para>
    </sect2>

    <sect2 id="test_uninstall">
      <title>Test Uninstall</title>

      <para> Uninstall the port </para>
       
      <para><userinput>sudo port uninstall foo</userinput></para>
    </sect2>

    <sect2 id="try_clean_machine">
      <title>Try the Port on a Clean Machine</title>

      <para> Make sure the port builds, installs and uninstalls on 
      a &quot;clean machine&quot;. A clean machine should have a 
      clean install of the OS, to avoid missing dependencies.  
      Using a chrooted version of the OS to install and test ports 
      makes this much easier, see the chroot 
      <ulink url="http://darwinports.gene-hacker.net/docs/howto/chroot_10.2/index.html">
      HOWTO</ulink> for more details on how to set up the chroot. </para>
    </sect2>
        

    <sect2 id="clean_workdir">
      <title>Clean the Working Directory after an Error</title>

      <para> Clean the working source directory for a port. This will
        allow a clean reinstall if an error was encountered earlier in
        the build process.</para>
      
      <para> <userinput> port clean foo </userinput> </para>
    </sect2>
        
  </sect1>
    
  <sect1 id="advice">
    <title>Where can I ask for advice?</title> 

    <para>Either on the <email>darwinports@opendarwin.org</email>
      mailing list, or on the #opendarwin channel on irc.freenode.net.
      Don't be afraid to ask questions! You should also look at the
      later sections of the <link linkend="details">guide</link>and the
      <filename>portfile</filename>(7) and
      <filename>portstyle</filename>(7) manpages for more information.</para>

  </sect1>

  <sect1 id="submit_ports">
    <title>How do I submit my Ports</title>
      
    <para>See the <link linkend="submission">submission chapter</link> for 
    all the information on how to submit a port properly.</para>
  </sect1>

  <sect1 id="more_examples">
    <title>More Example <filename>Portfile</filename>s</title>

    <example id="expat">
      <title>Expat <filename>Portfile</filename></title>
      <programlisting><![CDATA[
# ]]>&dollar;<![CDATA[Id: Portfile,v 1.14 2003/07/30 14:35:39 fkr Exp ]]>&dollar;<![CDATA[

PortSystem      1.0

name            libxslt
version         1.0.21
homepage        http://www.xmlsoft.org/
description     gnome xslt library and xsltproc
categories      textproc
platforms       darwin
maintainers     mike+libxslt@gene-hacker.net
master_sites    ftp://xmlsoft.org/ \
                ftp://ftp.gnome.org/pub/GNOME/sources/libxslt/1.0/

checksums       md5 9cc0491e2584788748eb7069ea1d5277
depends_lib     lib:libxml2:libxml2
patchfiles      patch-aclocal.m4 patch-configure patch-ltmain.sh

long_description Gnome library for applying XSL stylesheet transformations to \
 xml files, comes with several useful binaries.

]]></programlisting>
    </example>

    <example id="neon">
      <title>Neon <filename>Portfile</filename></title>

<programlisting><![CDATA[
# &dollar;Id: Portfile,v 1.14 2003/07/30 14:35:39 fkr Exp &dollar;
          
PortSystem 1.0 
name            neon 
version         0.23.4
                         
categories      www 
maintainers     rooneg@electricjellyfish.net
description     An HTTP and WebDAV client library with a C interface
                          
master_sites    http://www.webdav.org/neon/
checksums       md5 56b380a7352c68d425b1d3d3d610f994 

depends_lib     lib:libexpat.0.4:expat 
configure.env   LDFLAGS='-L"${prefix}/lib"' CPPFLAGS='-I"${prefix}/include"'

configure.args  --with-ssl \
                --with-force-ssl \
                --enable-xml \
                --enable-shared \ 
                --with-expat

]]></programlisting>
    </example>

    <para>For more examples, you can browse the directory tree of
      DarwinPorts' <filename>dports</filename> directory and have a look
      at the <filename>Portfile</filename>s of your favorite
      ports.</para>
    
    <para>For more information about some options used in these
      <filename>Portfile</filename> examples that were not covered in
      this chapter, please take a look at the following chapters of this
      Guide.</para>
  </sect1>
</chapter>
EOXML




#no tests yet!
ok(1);
