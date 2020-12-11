{ lib
, buildPythonPackage
, fetchFromGitHub
, attrs
# Test inputs
, pytestCheckHook
, hypothesis
# TEMP:
, pytest-timeout
}:

buildPythonPackage rec {
  pname = "cattrs";
  version = "1.1.2";

  src = fetchFromGitHub {
    owner = "tinche";
    repo = "cattrs";
    rev = "v${version}";
    sha256 = "083d5mi6x7qcl26wlvwwn7gsp5chxlxkh4rp3a41w8cfwwr3h6l8";
  };

  propagatedBuildInputs = [ attrs ];

  checkInputs = [ pytestCheckHook hypothesis pytest-timeout ];
  pytestFlagsArray = [
    "-vv"
    "--timeout=10"
    "-x"
    "--durations=20"
  ];

  meta = with lib; {
    description = "Complex custom class converters for attrs";
    homepage = "https://cattrs.readthedocs.io/en/latest/";
    changelog = "https://cattrs.readthedocs.io/en/latest/history.html";
    license = licenses.mit;
  };
}
