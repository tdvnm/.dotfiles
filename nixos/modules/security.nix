{ ... }:
{
  # let anyone in the fprint group enrol a finger without a polkit password
  # prompt. hardware.nix runs the daemon this talks to
  security.polkit.extraConfig = ''
    polkit.addRule(function(action, subject) {
        if (action.id == "net.reactivated.fprint.device.enroll" &&
            subject.isInGroup("fprint")) {
            return polkit.Result.YES;
        }
    });
  '';

  # where a fingerprint can stand in for the password. each of these adds a
  # `sufficient` pam_fprintd line, so the reader is tried first and typing
  # the password still works if it fails or you have nothing enrolled.
  # fingerprint stays off for greetd on purpose. at the greeter it races the
  # reader coming up and can lock me out of my own login
  security.pam.services.sudo.fprintAuth = true;
  security.pam.services.polkit-1.fprintAuth = true;
  security.pam.services.swaylock.fprintAuth = true;
  security.pam.services.greetd.fprintAuth = false;

  # asterisks when i type my sudo password so i can see how much ive typed
  security.sudo.extraConfig = ''
    Defaults pwfeedback
  '';

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };
}
