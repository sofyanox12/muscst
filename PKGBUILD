# Maintainer: Sofyan Pujas <sofyanox12@users.noreply.github.com>
# Contributor: Jan Alexander Steffens (heftig) <heftig@archlinux.org>

pkgname=mutter-muscst
_pkgname=mutter
pkgver=50.2
pkgrel=2
pkgdesc="Window manager and compositor for GNOME with screencast window buffer exclusion & muscst CLI controller (WIP)"
url="https://gitlab.gnome.org/GNOME/mutter"
arch=(x86_64)
license=(GPL-2.0-or-later)
depends=(
  at-spi2-core
  cairo
  colord
  dconf
  egl-wayland
  fontconfig
  fribidi
  gdk-pixbuf2
  glib2
  glibc
  glycin
  gnome-desktop-4
  gnome-settings-daemon
  graphene
  gsettings-desktop-schemas
  gtk4
  harfbuzz
  iio-sensor-proxy
  lcms2
  libcanberra
  libcolord
  libdisplay-info
  libdrm
  libei
  libgcc
  libgirepository
  libglvnd
  libgudev
  libinput
  libpipewire
  libsysprof-capture
  libwacom
  libx11
  libxau
  libxcb
  libxcomposite
  libxcursor
  libxdamage
  libxext
  libxfixes
  libxi
  libxinerama
  libxkbcommon
  libxrandr
  mesa
  pango
  pipewire
  pixman
  python
  python-argcomplete
  python-dbus
  python-gobject
  startup-notification
  systemd-libs
  wayland
  xorg-xwayland
)
makedepends=(
  bash-completion
  gi-docgen
  git
  glib2-devel
  gobject-introspection
  meson
  sysprof
  wayland-protocols
)
provides=(
  mutter=${pkgver}
  muscst=${pkgver}
  libmutter-18.so
)
conflicts=(mutter)
source=(
  "git+https://gitlab.gnome.org/GNOME/mutter.git#tag=${pkgver}"
  "patches/0001-screencast-window-exclusion.patch"
  "bin/muscst"
  "config/state.json.example"
)
sha256sums=(
  'SKIP'
  'f3f20e466e5435895b569e6a1eda2f4300fbf68e859e48703f4874a6d316f16d'
  '5d571159bf2b0f91e6abe461c823d82008b78fc5144cb327e9e2db961b478149'
  '78850cad3298011aadb7c50416d4fd88182790442e6f380b8c758423ae70bf3d'
)

prepare() {
  cd ${_pkgname}

  echo "Applying screencast buffer exclusion patch..."
  patch -Np1 -i "${srcdir}/0001-screencast-window-exclusion.patch"
}

build() {
  local meson_options=(
    -D docs=false
    -D tests=false
    -D sm=false
    -D profiling=false
    -D installed_tests=false
  )

  arch-meson ${_pkgname} build "${meson_options[@]}"
  meson compile -C build
}

package() {
  meson install -C build --destdir "${pkgdir}"

  install -Dm755 "${srcdir}/muscst" "${pkgdir}/usr/bin/muscst"
  install -Dm644 "${srcdir}/state.json.example" "${pkgdir}/usr/share/muscst/state.json.example"
}
