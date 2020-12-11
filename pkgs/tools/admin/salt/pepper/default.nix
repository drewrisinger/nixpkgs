{ lib
, python3Packages
, salt
}:

python3Packages.buildPythonApplication rec {
  pname = "salt-pepper";
  version = "0.7.5";
  src = python3Packages.fetchPypi {
    inherit pname version;
    sha256 = "1wh6yidwdk8jvjpr5g3azhqgsk24c5rlzmw6l86dmi0mpvmxm94w";
  };

  buildInputs = with python3Packages; [ setuptools_scm ];
  propagatedBuildInputs = with python3Packages; [
    salt
    setuptools
  ];
  # Running pytest requires >=2 out-of-Nix packages: pytest-salt, pytest-tempdir
  # checkInputs = with python3Packages; [
  #   pytestCheckHook mock pyzmq pytest-rerunfailures pytestcov cherrypy tornado pytestsalt
  # ];
  checkPhase = ''
    $out/bin/pepper --help > /dev/null
    $out/bin/pepper --version
  '';

  meta = with lib; {
    description = "A CLI front-end to a running salt-api system";
    homepage = "https://github.com/saltstack/pepper";
    maintainers = [ maintainers.pierrer ];
    license = licenses.asl20;
  };
}
