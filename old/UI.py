import subprocess
import os

def main():
    BAT_PATH = r"C:\Users\admin\OneDrive\Desktop\MonkeyHeadProject\[BAT]"

    while True:
        print("\n[****|     GenCore AI/OS User Interface (Windows 10 Pro x64)   |****]\n")
        print("[****|     1. Start GenCore                        |****]")
        print("[****|     2. 'Full' Setup (with Kubernetes)      |****]")
        print("[****|     3. 'Mini' Setup                        |****]")
        print("[****|     4. Cleanup Files                       |****]")
        print("[****|     5. Launch Terminal                     |****]")
        print("[****|     6. Update Python Packages              |****]")
        print("[****|     7. Create Container                    |****]")
        print("[****|     8. Create Volume                       |****]")
        print("[****|     9. Build Image                         |****]")
        print("[****|     10. Exit Program                      |****]\n")

        try:
            action = int(input("Please select an option (1-10): "))
            print()

            if action == 1:
                run_script(BAT_PATH, 'start.bat')
            elif action == 2:
                run_script(BAT_PATH, 'full.bat')
            elif action == 3:
                run_script(BAT_PATH, 'mini.bat')
            elif action == 4:
                run_script(BAT_PATH, 'cleanup.bat')
            elif action == 5:
                os.system("start cmd /k")
            elif action == 6:
                run_script(BAT_PATH, 'python.bat')
            elif action == 7:
                run_script(BAT_PATH, 'container.bat')
            elif action == 8:
                run_script(BAT_PATH, 'volume.bat')
            elif action == 9:
                run_script(BAT_PATH, 'build.bat')
            elif action == 10:
                print("[****| Thank you for using GenCore. Exiting now. |****]")
                break
            else:
                print("[****| Invalid Selection. Choose a valid option: |****]")
        except ValueError:
            print("[****| Please enter a valid number. |****]")

def run_script(path, script):
    result = subprocess.run([os.path.join(path, script)], shell=True)
    if result.returncode != 0:
        print(f"[****| {script} failed with error code {result.returncode}. |****]")
    else:
        print(f"[****| {script} completed successfully. |****]")

if __name__ == "__main__":
    main()
