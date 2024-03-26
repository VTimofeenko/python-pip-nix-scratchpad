import subprocess
import sys


def main():
    own_python = sys.executable
    print(own_python)

    process = subprocess.run([own_python, "-m", "pip", "install", "foo"],
                   capture_output=True,
                   text=True
                   )

    print(process.returncode)
    print(process.stderr)


if __name__ == "__main__":
    main()
