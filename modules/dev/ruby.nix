{ pkgs, ... }:
{
  # Ruby development environment
  # Ruby interpreter needed for try tool and Ruby development
  environment.systemPackages = [
    pkgs.ruby_3_3
  ];
}
