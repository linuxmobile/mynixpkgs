{
  lib,
  fetchFromGitHub,
  python3,
}:
python3.pkgs.buildPythonApplication rec {
  pname = "orchats";
  version = "1.4.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "oop7";
    repo = "OrChat";
    rev = "v${version}";
    hash = "sha256-/Dq2oN5d2z8b8tE9uZfWvR4+jXbL9kP7mG3hY6uI0pQ=";
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
  ];

  nativeBuildInputs = with python3.pkgs; [
    setuptools
    setuptools-scm
  ];

  doCheck = false;

  pythonImportsCheck = ["orchats"];

  meta = with lib; {
    description = "Terminal LLM client for OpenRouter, OpenAI, Ollama, Groq, Anthropic, etc.";
    homepage = "https://github.com/oop7/OrChat";
    license = licenses.mit;
    mainProgram = "orchats";
    platforms = platforms.all;
  };
}
