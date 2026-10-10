{ config, lib, ... }:

{
  options.custom.ncalayer.enable = lib.mkEnableOption "NCALayer, the Kazakhstan e-signature client (system side)";

  config = lib.mkIf config.custom.ncalayer.enable {
    # NCALayer needs a live PC/SC context even when signing with file-based
    # keys, otherwise its reader list is null and the JavaFX thread dies on
    # every layout pass.
    services.pcscd.enable = true;

    # NCA RK roots, so gov.kz TLS chains validate outside the browsers' own
    # NSS stores too.
    security.pki.certificateFiles = [
      ../home/ncalayer/certs/root_rsa.pem
      ../home/ncalayer/certs/nca_rsa.pem
    ];
  };
}
