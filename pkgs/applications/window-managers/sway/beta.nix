{ stdenv, fetchFromGitHub, fetchpatch
, meson, ninja
, pkgconfig, scdoc
, wayland, libxkbcommon, pcre, json_c, dbus, libevdev
, pango, cairo, libinput, libcap, pam, gdk_pixbuf
, wlroots, wayland-protocols
, buildDocs ? true
}:

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "sway";
  version = "1.0";

  src = fetchFromGitHub {
    owner = "swaywm";
    repo = "sway";
    rev = version;
    sha256 = "09cndc2nl39d3l7g5634xp0pxcz60pvc5277mfw89r22mh0j78rx";
  };

  patches = [
    # Fix for a compiler warning that causes a build failure
    # (see https://github.com/swaywm/sway/issues/3862):
    (fetchpatch {
      url = "https://github.com/swaywm/sway/commit/bcde298a719f60b9913133dbd2a169dedbc8dd7d.patch";
      sha256 = "0r583nmqvq43ib93yv6flw8pj833v32lbs0q0xld56s3rnzvvdcp";
    })
  ];

  nativeBuildInputs = [
    pkgconfig meson ninja
  ] ++ stdenv.lib.optional buildDocs scdoc;

  buildInputs = [
    wayland libxkbcommon pcre json_c dbus libevdev
    pango cairo libinput libcap pam gdk_pixbuf
    wlroots wayland-protocols
  ];

  enableParallelBuilding = true;

  mesonFlags = [
    "-Dxwayland=enabled" "-Dgdk-pixbuf=enabled" "-Dtray=enabled"
  ] ++ stdenv.lib.optional buildDocs "-Dman-pages=enabled";

  meta = with stdenv.lib; {
    description = "i3-compatible window manager for Wayland";
    homepage    = https://swaywm.org;
    license     = licenses.mit;
    platforms   = platforms.linux;
    maintainers = with maintainers; [ primeos synthetica ];
  };
}
