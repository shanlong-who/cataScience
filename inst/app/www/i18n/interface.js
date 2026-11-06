/* Localize display text only. Shiny IDs, input values, code and user data keep their originals. */
(() => {
  'use strict';
  const dictionaries = new Map();
  const originals = new WeakMap();
  const attributes = ['title', 'alt', 'placeholder', 'aria-label'];
  const ignored = 'script,style,pre,code,textarea,svg,canvas,.html-widget,.dataTables_wrapper,.dt-container,[contenteditable],#cata-language-switch';
  const fixedSelects = new Set(['join', 'bar_position', 'ds1-missing_params', 'ds2-missing_params',
    'ds1-text_uppercase', 'ds2-text_uppercase', ...['example', 'existing', 'reference', 'relationship',
      'plot_data', 'plot_type', 'style'].map(id => 'workflow-' + id)]);
  let language = 'en';
  let button;
  function protectedText(element) {
    if (element.closest(ignored)) return true;
    const table = element.closest('table');
    if (table && !table.closest('.md-page,.table-sm-tight,#why-cases,#why-ratios')) return true;
    const picker = element.closest('select,.selectize-control,.selectize-dropdown');
    if (picker) {
      const select = picker.tagName === 'SELECT' ? picker : picker.closest('.shiny-input-container')?.querySelector('select');
      const item = element.closest('[data-value],option');
      const value = item && (item.getAttribute('data-value') ?? item.getAttribute('value'));
      if (!select || (!fixedSelects.has(select.id) && value !== '__none__')) return true;
      // Selectize builds its own labels from the original options.
      if (picker.tagName === 'SELECT' && (picker.classList.contains('selectized') || picker.parentElement.querySelector('script[data-for]'))) return true;
    }
    const boxes = element.closest('.shiny-input-checkboxgroup');
    const box = boxes && element.closest('label')?.querySelector('input');
    if (!box || boxes.id === 'quiz-topics') return false;
    return !(box.value === 'All' && /^ds[12]-(missing|outlier)_variable$/.test(boxes.id));
  }
  const tidy = text => text.replace(/\s+/g, ' ').trim();
  function translate(text) {
    const key = tidy(text);
    let result = dictionaries.get(key);
    if (result === undefined) {
      const patterns = [
        [/^Score: (\d+) \/ (\d+)$/, '得分：$1 / $2'],
        [/^Question (\d+) of (\d+)$/, '第 $1 题，共 $2 题'],
        [/^You scored (\d+) out of (\d+) \((\d+)%\)$/, '你答对了 $1 题，共 $2 题（$3%）'],
        [/^Quiz restarted with (\d+) questions\.$/, '测验已重新开始，共 $1 题。'],
        [/^Example data loaded: (.+)$/, '已载入示例数据：$1'],
        [/^Not quite\. The answer is: (.+)$/, (_, answer) => '这道题的正确答案是：' + (dictionaries.get(answer) || answer)]
      ];
      for (const [pattern, replacement] of patterns) {
        if (pattern.test(key)) { result = key.replace(pattern, replacement); break; }
      }
    }
    return result === undefined ? text : text.match(/^\s*/)[0] + result + text.match(/\s*$/)[0];
  }
  function update(node, property, current, set) {
    const values = originals.get(node) || new Map();
    const previous = values.get(property);
    const source = previous && previous.shown === current ? previous.source : current;
    const shown = language === 'zh' ? translate(source) : source;
    if (shown !== current) set(shown);
    if (source !== shown) { values.set(property, {source, shown}); originals.set(node, values); }
    else values.delete(property);
  }
  function visit(node) {
    if (node.nodeType === Node.TEXT_NODE) {
      if (node.parentElement && !protectedText(node.parentElement)) update(node, 'text', node.data, text => { node.data = text; });
      return;
    }
    if (node.nodeType !== Node.ELEMENT_NODE || node.closest(ignored)) return;
    for (const name of attributes) {
      if (node.hasAttribute(name) && !protectedText(node)) update(node, name, node.getAttribute(name), value => node.setAttribute(name, value));
    }
    for (const child of node.childNodes) visit(child);
  }
  function notify() {
    if (window.Shiny && Shiny.setInputValue) Shiny.setInputValue('cata_language', language, {priority: 'event'});
  }
  function select(next) {
    language = next;
    document.documentElement.lang = next === 'zh' ? 'zh-CN' : 'en';
    document.title = next === 'zh' ? '数据科学之旅' : 'A Journey of Data Science';
    button.textContent = next === 'zh' ? 'English' : '中文';
    button.setAttribute('lang', next === 'zh' ? 'en' : 'zh-CN');
    button.setAttribute('aria-label', next === 'zh' ? 'Switch to English' : '切换到简体中文');
    const guide = document.getElementById('cata-browser-guide');
    if (guide) guide.href = next === 'zh' ? guide.dataset.zhHref : guide.dataset.enHref;
    const edition = document.getElementById('cata-browser-edition');
    if (edition) {
      const url = new URL(edition.href);
      url.searchParams.set('lang', next);
      edition.href = url.href;
    }
    visit(document.body);
    notify();
  }
  async function start() {
    button = document.getElementById('cata-language-switch');
    if (!button) return;
    const response = await fetch('i18n/zh.tsv');
    if (!response.ok) throw new Error('Cannot load the bundled language catalogue');
    for (const line of (await response.text()).split(/\r?\n/).slice(1)) {
      if (line) { const [en, zh] = line.split('\t'); dictionaries.set(en, zh); }
    }
    let saved;
    try { saved = localStorage.getItem('cataScience.language'); } catch (_) { /* Private browsing. */ }
    // The two Shinylive editions run inside a same-origin launcher frame.
    let launcherLanguage;
    try { launcherLanguage = window.frameElement?.ownerDocument.body.dataset.cataLaunchLanguage; }
    catch (_) { /* Other hosts can embed the local app across origins. */ }
    const preference = [button.dataset.default, launcherLanguage, saved].find(value => value === 'zh' || value === 'en');
    select(preference || (/^zh\b/i.test(navigator.language) ? 'zh' : 'en'));
    button.addEventListener('click', () => {
      select(language === 'zh' ? 'en' : 'zh');
      try { localStorage.setItem('cataScience.language', language); } catch (_) { /* Session still works. */ }
    });
    if (window.jQuery) jQuery(document).on('shiny:connected', notify);
    new MutationObserver(changes => {
      if (language !== 'zh') return;
      for (const change of changes) {
        if (change.type === 'childList') change.addedNodes.forEach(visit);
        else visit(change.target);
      }
    }).observe(document.body, {subtree: true, childList: true, characterData: true, attributes: true, attributeFilter: attributes});
  }
  if (document.readyState === 'loading') document.addEventListener('DOMContentLoaded', start, {once: true}); else start();
})();
