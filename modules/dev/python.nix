{ unstablePkgs, pkgs, ... }:
{
  environment.systemPackages = [
    # UV package manager for Python
    unstablePkgs.uv

    # System Python versions (UV will use these)
    pkgs.python312
    pkgs.python313
    unstablePkgs.python314
  ];

  # Tell UV to prefer system Python
  environment.sessionVariables = {
    UV_PYTHON_PREFERENCE = "only-system";
  };
}
