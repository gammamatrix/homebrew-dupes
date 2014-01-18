require 'formula'

class Httpd < Formula
  homepage 'http://httpd.apache.org/'
  url 'http://www.apache.org/dist/httpd/httpd-2.2.26.tar.bz2'
  sha1 'ecfa7dab239ef177668ad1d5cf9d03c4602607b8'

  skip_clean :la

  option "with-ldap", "Include support for LDAP"

  def install_args
    args = [
      "--prefix=#{prefix}",
      "--disable-debug",
      "--disable-dependency-tracking",
      "--mandir=#{man}",
      "--localstatedir=#{var}/apache2",
      "--sysconfdir=#{etc}/apache2",
      "--enable-layout=GNU",
      "--enable-mods-shared=all",
      "--with-ssl=/usr",
      "--with-mpm=prefork",
      "--disable-unique-id",
      "--enable-ssl",
      "--enable-dav",
      "--enable-cache",
      "--enable-proxy",
      "--enable-logio",
      "--enable-deflate",
      "--with-included-apr",
      "--enable-cgi",
      "--enable-cgid",
      "--enable-suexec",
      "--enable-rewrite",
    ]

    if build.with? 'ldap'
      args << "--with-ldap"
      args << "--enable-ldap"
      args << "--enable-authnz-ldap"
    end

    args
  end

  def install
    args = install_args

    system "./configure", *args

    system "make"
    system "make install"
    (var/'apache2/log').mkpath
    (var/'apache2/run').mkpath
  end

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple Computer//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
      <key>Label</key>
      <string>#{plist_name}</string>
      <key>ProgramArguments</key>
      <array>
        <string>#{opt_prefix}/sbin/apachectl</string>
        <string>start</string>
      </array>
      <key>RunAtLoad</key>
      <true/>
    </dict>
    </plist>
    EOS
  end
end
