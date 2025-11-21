{
  lib,
  fetchFromGitHub,
  python3,
}:
python3.pkgs.buildPythonApplication rec {
  pname = "orchat";
  version = "1.4.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "oop7";
    repo = "OrChat";
    rev = "v${version}";
    hash = "sha256-QUQmbGW/M5P54nptaz0/dbuR6ThhPMjoO/t47mOcjwE=";
  };

  propagatedBuildInputs = with python3.pkgs; [
    pyfzf
    requests
    tiktoken
    rich
    python-dotenv
    colorama
    cryptography
    prompt-toolkit
    packaging
  ];

  nativeBuildInputs = with python3.pkgs; [
    setuptools
    setuptools-scm
  ];

  postPatch = ''
    substituteInPlace main.py \
      --replace-fail \
        'session_dir = os.path.join(os.path.dirname(os.path.abspath(__file__)), "sessions", session_id)' \
        'session_dir = os.path.join(os.getenv("XDG_STATE_HOME", os.path.expanduser("~/.local/state")), "orchat", "sessions", session_id)' \
      --replace-fail \
        "key_file = os.path.join(os.path.dirname(os.path.abspath(__file__)), '.key')" \
        "key_file = os.path.expanduser('~/.config/orchat/.env')" \
      --replace-fail \
      "config_file = os.path.join(os.path.dirname(os.path.abspath(__file__)), 'config.ini')" \
      "config_file = os.path.expanduser('~/.config/orchat/config.ini')"
  '';

  postInstall = ''
    wrapProgram $out/bin/orchat \
      --run "mkdir -p ~/.config/orchat"
  '';

  doCheck = false;

  pythonImportsCheck = [];

  meta = with lib; {
    description = "Terminal LLM client for OpenRouter, OpenAI, Ollama, Groq, Anthropic, etc.";
    homepage = "https://github.com/oop7/OrChat";
    license = licenses.mit;
    mainProgram = "orchat";
    platforms = platforms.all;
  };
}
