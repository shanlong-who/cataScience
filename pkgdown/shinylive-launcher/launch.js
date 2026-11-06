(() => {
  "use strict";
  const panel = document.getElementById("launch-panel");
  const status = document.getElementById("launch-status");
  const detail = document.getElementById("launch-detail");
  const progress = document.getElementById("launch-progress");
  const error = document.getElementById("launch-error");
  const retry = document.getElementById("retry");
  const base = new URL(document.body.dataset.root, location.href);
  const preferenceKey = "cataScience.language";
  const requested = new URL(location.href).searchParams.get("lang");
  let saved;
  try { saved = localStorage.getItem(preferenceKey); } catch (_) { /* Storage is optional. */ }
  const initial = [requested, saved].find(value => value === "zh" || value === "en");
  let chinese = initial ? initial === "zh" : /^zh\b/i.test(navigator.language);
  let running = false;
  let runtimeStarted = false;
  let phase = "preparing";
  let completed = 0;
  let files = [];
  const received = new Map();
  const prepared = new Set();
  const words = {
    en: {
      preparing: "Preparing your classroom", downloading: "Downloading app files", starting: "Starting the app", failed: "The app could not start",
      intro: "The first visit downloads the app and its R packages. Keep this tab open. Later visits can reuse files saved by your browser.",
      waiting: "Preparing the download", ready: "Files are ready. R is now loading the lessons.",
      slow: "Startup is taking longer than expected. You can keep waiting or use the local R app below.",
      files: (n, total) => `${n} of ${total} files prepared`, retry: "Retry", guide: "User guide", help: "If the app does not start",
      helpText: "Try a current desktop browser. If downloads are blocked or the connection is slow, use the local R app. The commands below install the current GitHub version.",
      failedText: "A required file or browser feature was unavailable. Check your connection, then retry. See the details below or use the local R app."
    },
    zh: {
      preparing: "正在准备课堂", downloading: "正在下载应用文件", starting: "正在启动应用", failed: "应用未能启动",
      intro: "首次访问需要下载应用和 R 包，请保持页面打开。后续访问可复用浏览器已保存的文件。",
      waiting: "正在准备下载", ready: "文件已准备好，R 正在加载课程内容。",
      slow: "启动时间较长。你可以继续等待，或使用下方的本地 R 版。",
      files: (n, total) => `已准备 ${n} / ${total} 个文件`, retry: "重试", guide: "使用指南", help: "无法启动时",
      helpText: "请使用较新的桌面浏览器。如果下载被阻止或网络较慢，可使用本地 R 版。下方命令安装 GitHub 上的当前版本。",
      failedText: "所需文件无法下载，或浏览器不支持所需功能。请检查网络后重试，也可查看下方详情或使用本地 R 版。"
    }
  };
  const text = () => words[chinese ? "zh" : "en"];
  function showProgress() {
    if (!files.length) return;
    const total = files.reduce((sum, file) => sum + file.bytes, 0);
    const loaded = [...received.values()].reduce((sum, bytes) => sum + bytes, 0);
    progress.value = Math.min(100, total ? loaded / total * 100 : 0);
    detail.textContent = `${text().files(completed, files.length)} · ${Math.floor(progress.value)}%`;
  }
  function render() {
    document.documentElement.lang = chinese ? "zh-CN" : "en";
    document.body.dataset.cataLaunchLanguage = chinese ? "zh" : "en";
    const workshop = document.body.dataset.edition === "Workshop";
    const edition = chinese ? (workshop ? "扩展培训版" : "经典版") : document.body.dataset.edition;
    document.title = `cataScience ${edition}`;
    document.getElementById("launch-title").textContent = document.title;
    document.getElementById("launch-subtitle").textContent = chinese ? "数据科学之旅" : "A Journey of Data Science";
    status.textContent = text()[phase];
    document.getElementById("launch-intro").textContent = text().intro;
    document.getElementById("help-title").textContent = text().help;
    document.getElementById("help-text").textContent = text().helpText;
    document.getElementById("guide-link").textContent = text().guide;
    document.getElementById("guide-link").href = `https://shanlong-who.github.io/cataScience/${chinese ? "zh/" : ""}`;
    document.getElementById("language").textContent = chinese ? "English" : "中文";
    retry.textContent = text().retry;
    error.textContent = text().failedText;
    if (phase === "downloading") showProgress();
    else detail.textContent = phase === "starting" ? text().ready : text().waiting;
  }
  document.getElementById("language").addEventListener("click", () => {
    chinese = !chinese;
    try { localStorage.setItem(preferenceKey, chinese ? "zh" : "en"); } catch (_) { /* This visit still works. */ }
    render();
  });

  function deadline(promise, message, milliseconds = 20000) {
    let timer;
    return Promise.race([promise, new Promise((_, reject) => {
      timer = setTimeout(() => reject(new Error(message)), milliseconds);
    })]).finally(() => clearTimeout(timer));
  }
  async function prepareBrowser() {
    if (!window.isSecureContext || !navigator.serviceWorker || !window.WebAssembly) {
      throw new Error("This app needs a secure connection, JavaScript, WebAssembly and Service Worker support.");
    }
    await deadline(navigator.serviceWorker.register(new URL("shinylive-sw.js", base), { type: "module", scope: base.pathname }), "Service Worker registration timed out.");
    await deadline(navigator.serviceWorker.ready, "The browser could not activate the app's Service Worker.");
    if (!navigator.serviceWorker.controller) {
      await deadline(new Promise(resolve => navigator.serviceWorker.addEventListener("controllerchange", resolve, { once: true })), "The browser did not allow the app to control this page.");
    }
  }
  async function download(file) {
    if (prepared.has(file.path)) return;
    received.set(file.path, 0);
    const controller = new AbortController();
    let timer;
    const resetDeadline = () => {
      clearTimeout(timer);
      timer = setTimeout(() => controller.abort(), 45000);
    };
    resetDeadline();
    try {
      // Read the complete response so subsequent webR requests can reuse the HTTP cache.
      // Revalidate the lesson bundle after a deployment; reuse unchanged runtime files.
      const response = await fetch(new URL(file.path, base), {
        cache: file.path.endsWith("app.json") ? "no-cache" : "default", signal: controller.signal
      });
      if (!response.ok) throw new Error(`HTTP ${response.status}`);
      resetDeadline();
      if (response.body) {
        const reader = response.body.getReader();
        let bytes = 0;
        while (true) {
          const chunk = await reader.read();
          if (chunk.done) break;
          resetDeadline();
          bytes += chunk.value.length;
          received.set(file.path, Math.min(file.bytes, bytes));
          showProgress();
        }
      } else {
        clearTimeout(timer);
        timer = setTimeout(() => controller.abort(), 300000);
        await response.arrayBuffer();
      }
      received.set(file.path, file.bytes);
      prepared.add(file.path);
      completed = prepared.size;
      showProgress();
    } catch (cause) {
      throw new Error(`${file.path}: ${cause.message}`);
    } finally {
      clearTimeout(timer);
    }
  }
  async function downloadFiles() {
    let index = 0;
    const failures = [];
    // Four downloads avoid the long sequence of synchronous package requests.
    await Promise.all(Array.from({ length: 4 }, async () => {
      while (index < files.length) {
        const file = files[index++];
        try { await download(file); } catch (cause) { failures.push(cause.message); }
      }
    }));
    if (failures.length) throw new Error(failures.join("\n"));
  }
  function showFailure(cause) {
    phase = "failed";
    render();
    error.hidden = false;
    retry.hidden = false;
    document.getElementById("launch-help").open = true;
    document.getElementById("error-detail").hidden = false;
    document.getElementById("error-detail").textContent = cause.message;
    console.error("cataScience startup:", cause);
    running = false;
  }
  async function start() {
    if (running) return;
    running = true;
    phase = "preparing";
    error.hidden = true;
    retry.hidden = true;
    render();
    try {
      await prepareBrowser();
      const manifestResponse = await deadline(fetch(new URL("launch-manifest.json", base), { cache: "no-cache" }), "The download manifest could not be loaded.");
      if (!manifestResponse.ok) throw new Error(`Download manifest: HTTP ${manifestResponse.status}`);
      const manifest = await manifestResponse.json();
      files = manifest.files.concat(manifest.apps[document.body.dataset.edition.toLowerCase()]);
      files.sort((a, b) => b.bytes - a.bytes);
      phase = "downloading";
      render();
      await downloadFiles();
      phase = "starting";
      render();
      for (const name of ["style-resets.css", "shinylive.css"]) {
        const stylesheet = document.createElement("link");
        stylesheet.rel = "stylesheet";
        stylesheet.href = new URL(`shinylive/${name}`, base);
        document.head.append(stylesheet);
      }
      const module = await import(new URL("shinylive/shinylive.js", base));
      runtimeStarted = true;
      await module.runExportedApp({ id: "root", appEngine: "r", relPath: document.body.dataset.root === "./" ? "" : document.body.dataset.root });
      const slow = setTimeout(() => { detail.textContent = text().slow; retry.hidden = false; document.getElementById("launch-help").open = true; }, 90000);
      const watch = setInterval(() => {
        const runtimeError = document.querySelector("#root .error-alert");
        if (runtimeError) {
          clearInterval(watch);
          clearTimeout(slow);
          showFailure(new Error(runtimeError.textContent));
          return;
        }
        const frame = document.querySelector("#root iframe");
        try {
          if (frame?.contentDocument?.querySelector(".navbar")) {
            clearInterval(watch);
            clearTimeout(slow);
            panel.hidden = true;
          }
        } catch (_) { /* The frame is still being created. */ }
      }, 500);
    } catch (cause) {
      showFailure(cause);
    }
  }
  retry.addEventListener("click", () => runtimeStarted ? location.reload() : start());
  render();
  start();
})();
