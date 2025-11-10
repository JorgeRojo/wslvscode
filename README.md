# `wslvscode://` Custom Protocol Launcher

This solution provides a custom URI protocol handler (`wslvscode://`) to open files and folders in Visual Studio Code within your specific WSL environment (`kali-linux`) directly from a web browser address bar or application links.

---

## 🛠️ Prerequisites

- Windows 10/11 with WSL installed (`kali-linux` configured).
- Visual Studio Code installed on Windows with the official WSL extension.
- The VS Code CLI command (`code`) must be accessible within your Kali Linux environment.
- The required PowerShell scripts (`Launch-WslVscode.ps1` and `Manage-WslVscodeProtocol.ps1`) must be created and placed as instructed in prior steps.

---

## 🚀 Usage

Once the protocol has been installed using the management script (`Manage-WslVscodeProtocol.ps1`), you can use the `wslvscode://` protocol in your browser address bar or within other applications that support links:

- **To open a specific file:**
  `wslvscode:///home/{WSL-USER}/projects/my-file.tsx`

- **To open a directory/folder:**
  `wslvscode:///home/{WSL-USER}/projects/`

A security prompt will appear in your browser the first time you use it; accept it to launch VS Code directly in your WSL environment.
