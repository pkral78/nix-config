{ lib, ... }:
{
  # Enable acme for usage with nginx vhosts
  security.acme = {
    defaults.email = "admin@kralovi.net";
    acceptTerms = true;
  };

  # environment.persistence = {
  #   "/persist" = {
  #     directories = [
  #       "/var/lib/acme"
  #     ];
  #   };
  # };
}
