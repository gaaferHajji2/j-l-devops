This error almost always means **`sh` did not recognize the `do` keyword on line 3**. The parser thinks the `while` loop never started, so when it hits `done` on line 7, it complains.

### 🔍 Root Cause: Windows Line Endings (`CRLF`)
If you edited or saved `mailer.sh` on Windows, line 3 actually looks like this to the shell:
```sh
while true; do\r
```
The trailing `\r` (carriage return) turns `do` into `do\r`, which the shell treats as a **command name**, not the required `do` keyword. Hence: `unexpected "done" (expecting "do")`.

### ✅ How to Fix
1. **Strip Windows line endings:**
   ```bash
   sed -i 's/\r$//' mailer.sh
   ```
   *(Or use `dos2unix mailer.sh` if available)*

2. **Verify it worked:**
   ```bash
   cat -A mailer.sh | head -n 3
   ```
   You should see `while true; do$` (the `$` marks a clean `LF` end). If you see `^M$`, the `\r` is still there.

3. **Check syntax:**
   ```bash
   sh -n mailer.sh
   ```
   (Should produce no output if clean)

---

### 📝 Cleaned & Optimized Script
Here's a robust, `busybox`-compatible version. I've replaced backticks with `$()` (POSIX standard) and added a signal trap so `docker stop` works cleanly:

```sh
#!/bin/sh
printf "CH2 Example Mailer has started.\n"

# Handle SIGTERM/SIGINT gracefully for docker stop
cleanup() { printf "Stopping mailer.\n"; exit 0; }
trap cleanup TERM INT

while true; do
    # Use $() instead of backticks for POSIX compliance
    MESSAGE=$(nc -l -p 33333)
    printf "Sending email: %s\n" "$MESSAGE"
    sleep 1
done
```

### ⚠️ Important `busybox` Note
`busybox`'s `nc` (netcat) sometimes uses slightly different flags depending on the version:
- Traditional: `nc -l -p 33333`
- Modern busybox: `nc -l 33333` (no `-p`)

If you get a **runtime error** like `nc: invalid option -- p`, simply change that line to:
```sh
MESSAGE=$(nc -l 33333)
```

Rebuild after fixing line endings, and the syntax error will disappear.