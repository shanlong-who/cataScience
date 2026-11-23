// Old bookmarks point to sections of the technical homepage.
if (location.hash) {
  let id;
  try { id = decodeURIComponent(location.hash.slice(1)); } catch { id = ""; }
  if (id && !document.getElementById(id)) {
    const guide = new URL("technical.html", location.href);
    guide.search = location.search;
    guide.hash = location.hash;
    location.replace(guide);
  }
}
