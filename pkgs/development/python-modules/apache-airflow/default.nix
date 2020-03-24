{ lib
, buildPythonPackage
, fetchPypi
, fetchFromGitHub
, fetchpatch
, python
, isPy3k
, alembic
, argcomplete
, cached-property
, configparser
, colorlog
, croniter
, dill
, flask
, flask-appbuilder
, flask-admin
, flask-caching
, flask_login
, flask-swagger
, flask_wtf
, flask-bcrypt
, funcsigs
, future
, GitPython
, graphviz
, gunicorn
, iso8601
, json-merge-patch
, jinja2
, ldap3
, lxml
, lazy-object-proxy
, markdown
, pandas
, pendulum
, psutil
, pygments
, python-daemon
, python-dateutil
, requests
, setproctitle
, sqlalchemy
, tabulate
, tenacity
, termcolor
, text-unidecode
, thrift
, typing-extensions
, tzlocal
, unicodecsv
, werkzeug
, zope_deprecation
# Test Inputs
, nose
, snakebite
}:

buildPythonPackage rec {
  pname = "apache-airflow";
  version = "1.10.9";
  disabled = (!isPy3k);

  src = fetchFromGitHub rec {
    owner = "apache";
    repo = "airflow";
    rev = version;
    sha256 = "19kdaw5842q07fsxvhakh2ws3nq6jgv5s1qc9yimsa7hchlk2mqb";
  };

  # patches = [
  #   # Not yet accepted: https://github.com/apache/airflow/pull/6561
  #   (fetchpatch {
  #     name = "pendulum2-compatibility";
  #     url = https://patch-diff.githubusercontent.com/raw/apache/airflow/pull/6561.patch;
  #     sha256 = "17hw8qyd4zxvib9zwpbn32p99vmrdz294r31gnsbkkcl2y6h9knk";
  #   })
  # ];

  propagatedBuildInputs = [
    alembic
    argcomplete
    cached-property
    colorlog
    configparser
    croniter
    dill
    flask
    flask-admin
    flask-appbuilder
    flask-bcrypt
    flask-caching
    flask_login
    flask-swagger
    flask_wtf
    funcsigs
    future
    GitPython
    graphviz
    gunicorn
    iso8601
    json-merge-patch
    jinja2
    ldap3
    lxml
    lazy-object-proxy
    markdown
    pandas
    pendulum
    psutil
    pygments
    python-daemon
    python-dateutil
    requests
    setproctitle
    sqlalchemy
    tabulate
    tenacity
    termcolor
    text-unidecode
    thrift
    typing-extensions
    tzlocal
    unicodecsv
    werkzeug
    zope_deprecation
  ];

  checkInputs = [
    snakebite
    nose
  ];

  postPatch = ''
    substituteInPlace setup.py \
      --replace "alembic>=1.0, <2.0" "alembic" \
      --replace "argcomplete~=1.10" "argcomplete" \
      --replace "cached_property~=1.5" "cached_property" \
      --replace "configparser>=3.5.0, <3.6.0" "configparser" \
      --replace "colorlog==4.0.2" "colorlog" \
      --replace "dill>=0.2.2, <0.4" "dill" \
      --replace "flask>=1.1.0, <2.0" "flask" \
      --replace "flask-admin==1.5.4" "flask-admin" \
      --replace "flask-caching>=1.3.3, <1.4.0" "flask-caching" \
      --replace "flask-swagger==0.2.13" "flask-swagger" \
      --replace "funcsigs>=1.0.0, <2.0.0" "funcsigs" \
      --replace "future>=0.16.0, <0.17" "future" \
      --replace "graphviz>=0.12" "graphviz" \
      --replace "gunicorn>=19.5.0, <20.0" "gunicorn" \
      --replace "jinja2>=2.10.1, <2.11.0" "jinja2" \
      --replace "markdown>=2.5.2, <3.0" "markdown" \
      --replace "pandas>=0.17.1, <1.0.0" "pandas" \
      --replace "pendulum==1.4.4" "pendulum" \
      --replace "python-daemon>=2.1.1, <2.2" "python-daemon" \
      --replace "sqlalchemy~=1.3" "sqlalchemy" \
      --replace "tenacity==4.12.0" "tenacity" \
      --replace "text-unidecode==1.2" "text-unidecode" \
      --replace "tzlocal>=1.4,<2.0.0" "tzlocal" \
      --replace "werkzeug<1.0.0" "werkzeug"

    # This cause issues with DAG serialization. sqlalchemy_jsonfield is out-of-tree.
    substituteInPlace setup.py \
      --replace 'sqlalchemy_jsonfield~=0.9;python_version>="3.5"' "" \
    # out-of-tree
    substituteInPlace setup.py \
      --replace "cattrs~=0.9" ""

    # Same effective content as PR #6651 (previous patch), but that patch is out of date
    substituteInPlace airflow/settings.py --replace "from pendulum import Pendulum" "from pendulum import DateTime as Pendulum"
    substituteInPlace tests/test_core.py --replace "from pendulum import utcnow" "from pendulum import now"
    echo -e "def utcnow():\n    return now("UTC")\n" >> tests/test_core.py
  '';

  checkPhase = ''
    export HOME=$(mktemp -d)
    export AIRFLOW_HOME=$HOME
    export AIRFLOW__CORE__UNIT_TEST_MODE=True
    export AIRFLOW_DB="$HOME/airflow.db"
    export PATH=$PATH:$out/bin
    export FORCE_ANSWER_TO_QUESTIONS="yes"

    python nix_run_setup test
    # ./scripts/ci/ci_run_airflow_testing.sh
  '';

  meta = with lib; {
    description = "Programmatically author, schedule and monitor data pipelines";
    homepage = "http://airflow.apache.org/";
    license = licenses.asl20;
    maintainers = with maintainers; [ costrouc ingenieroariel ];
  };
}
