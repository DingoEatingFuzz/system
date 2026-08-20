{ pkgs, ... }:
{
  activation = ''
    mkdir -p /opt/cni/bin /etc/cni/net.d
    for p in ${pkgs.cni-plugins}/bin/*; do
      ln -sf $p /opt/cni/bin/$(basename $p)
    done
  '';
}
