const { app, BrowserWindow } = require("electron");
const path = require("path");

const iconPath = path.join(__dirname, "../../resources/icon.png");

function createWindow() {
  const win = new BrowserWindow({
    width: 700,
    height: 580,
    title: "ゲーム",
    icon: iconPath,
    autoHideMenuBar: true,
    webPreferences: {
      nodeIntegration: false,
      contextIsolation: true,
    },
  });

  win.loadFile(path.join(__dirname, "../games/index.html"));
}

app.whenReady().then(() => {
  if (process.platform === "darwin") {
    app.dock.setIcon(iconPath);
  }
  createWindow();
});

app.on("window-all-closed", () => {
  if (process.platform !== "darwin") {
    app.quit();
  }
});

app.on("activate", () => {
  if (BrowserWindow.getAllWindows().length === 0) {
    createWindow();
  }
});
