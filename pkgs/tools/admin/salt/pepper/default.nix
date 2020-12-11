{ lib
, python3Packages
, salt
}:

python3Packages.buildPythonApplication rec {
  pname = "salt-pepper";
  version = "0.7.6";
  src = python3Packages.fetchPypi {
    inherit pname version;
    sha256 = "b75a641d4fd96663ae44fc7ce4aadb7e4c87b8ff30f7ac35479a282b99894749";
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
