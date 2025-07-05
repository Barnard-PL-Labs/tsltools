import subprocess
import re
if __name__ == '__main__':
    # 1. Run the TSL synth command and capture its output
    proc = subprocess.run(
        ["tsl", "synthesize", "-i", "/Users/will/github/tsl_local/tsltools/SingleCopTest.tslmt", "--python"],
        check=True,
        stdout=subprocess.PIPE
    )
    generated_code = proc.stdout.decode("utf-8").strip()

    # 1a. Strip a trailing '}' if it appears alone on its own line
    # This removes exactly one extra closing brace (and any surrounding whitespace/newlines)
    generated_code = re.sub(r"\n*\}\s*$", "", generated_code)

    # 2. Read the target file
    target_path = "./GridGameXAxis.py"
    with open(target_path, "r") as f:
        text = f.read()

    # 3. Replace the region between the markers
    pattern = re.compile(
        r"(# BEGIN UPDATESTATE\n).*?(# END UPDATESTATE)",
        re.DOTALL
    )
    new_text = pattern.sub(
        lambda m: f"{m.group(1)}{generated_code}\n{m.group(2)}",
        text
    )

    # 4. Write it back out
    with open(target_path, "w") as f:
        f.write(new_text)

    print(f"Injected updateState into {target_path}")
