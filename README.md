# `wslvscode://` Custom Protocol Launcher

This solution provides a custom URI protocol handler (`wslvscode://`) to open files and folders in Visual Studio Code within your default WSL environment directly from a web browser address bar or application links.

---

## 🛠️ Prerequisites

- Windows 10/11 with a default WSL distribution configured.
- Visual Studio Code installed on Windows with the official WSL extension.
- The VS Code CLI command (`code`) must be accessible within your default WSL distribution.
- The required PowerShell scripts (`Launch-WslVscode.ps1` and `Manage-WslVscodeProtocol.ps1`) must be in the same directory.

---

## 🚀 Installation

1.  **Clone the repository**: Before proceeding, you must clone the repository into a directory on your Windows machine.
2.  **Open PowerShell**: Navigate to the directory where you have cloned the repository.
3.  **Run the management script**:
    ```powershell
    .\Manage-WslVscodeProtocol.ps1
    ```
4.  **Select an option from the menu**:

    - Type `I` and press Enter to **Install** the protocol.
    - Type `U` to **Uninstall** it later.
    - Type `V` to **Verify** that it's installed correctly.

    The script will handle the necessary Windows Registry modifications automatically. You may need to accept a security prompt.

---

## 💡 Usage

Once the protocol is installed, you can use `wslvscode://` links in your browser or other applications:

- **To open a specific file:**
  `wslvscode:///home/{WSL-USER}/projects/my-file.tsx`

- **To open a directory/folder:**
  `wslvscode:///home/{WSL-USER}/projects/`

A security prompt may appear in your browser the first time you use the protocol. Accept it to allow VS Code to launch.

---

## ⚛️ Configure React Developer Tools

Enable "Open in Editor" to jump from a React component in your browser to its code in VS Code (WSL).

1.  **Open Chrome DevTools** (`F12` or "Inspect").
2.  Go to the **"Components" Tab**.
3.  Click the **gear icon (⚙️)** for settings.

![React DevTools Configuration](image-1.png)

4.  In "General" settings, under "Open in Editor URL", select "Custom" and paste:

    `wslvscode:///{path}:{line}:{column}`

    - This `wslvscode://` protocol uses our `Launch-WslVscode.ps1` script.
    - Extra `/` is the Linux root path.
    - `{path}`, `{line}`, `{column}` are placeholders for file location.

![React DevTools Configuration Input](image-2.png)

After configuration, click the "Open in Editor" icon (`<>`) in React DevTools to open the component's source in VS Code (WSL).

![Icon to open your editor](image-3.png)
