{pkgs, ...}: {
  users.users.test = {
    isNormalUser = true;
    password = "";
  };
}
