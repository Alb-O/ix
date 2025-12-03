# Security hardening feature
# Bundles kernel hardening, sudo config, auditing, and intrusion prevention
{ lib, ... }:
{
  boot.kernel.sysctl = {
    "kernel.dmesg_restrict" = true;
    "kernel.kptr_restrict" = 2;
    "net.core.bpf_jit_enable" = false;
    "kernel.unprivileged_bpf_disabled" = true;
  };

  security.sudo.extraConfig = ''
    Defaults timestamp_timeout=15
  '';

  security.auditd.enable = lib.mkDefault true;

  services.fail2ban = {
    enable = true;
    maxretry = 5;
  };
}
