# Create a new virtual environment.
python3.8 -m venv .venv

# Activate it.
. .venv/bin/activate

# Upgrade pip and install the dependencies.
pip install --upgrade pip
poetry install

# And finally...
deactivate
