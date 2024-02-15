deploy:
    python3 scripts/build.py
    tofu -chdir=infrastructure apply -auto-approve