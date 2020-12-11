{ stdenv, buildPythonPackage, fetchPypi, pytest, pytest-flakes, tox, pytestCheckHook }:
buildPythonPackage rec {
  pname = "pytest-quickcheck";
  version = "0.8.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "3ef9bde7ba1fe6470c5b61631440186d1254e276c67a527242d91451ab7994e5";
  };

  postPatch = "substituteInPlace setup.py --replace 'pytest>=4.0,<6.0.0' 'pytest'";

  buildInputs = [ pytest ];
  propagatedBuildInputs = [ pytest-flakes tox ];

  checkInputs = [ pytestCheckHook ];

  meta = with stdenv.lib; {
    license = licenses.asl20;
    homepage = "https://pypi.python.org/pypi/pytest-quickcheck";
    description = "pytest plugin to generate random data inspired by QuickCheck";
  };
}
