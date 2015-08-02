function plugin_iframe_set_src(tab, loc) {
  loc = loc || 'lux.stashbuckets.com'
  tab[0].title = tab[0].title.replace(/[^\w\-_\s\.]/g,'')
  document.getElementById('plugin_iframe').setAttribute('src', 'http://'+loc+'/plugin?title='+escape(tab[0].title)+'&url='+escape(tab[0].url))
}

document.addEventListener('DOMContentLoaded', function () {
  if (chrome && chrome.tabs) {
    chrome.tabs.query({ active: true, windowId: parent.chrome.windows.WINDOW_ID_CURRENT }, plugin_iframe_set_src)
  } else {
    // plugin_iframe_set_src([{ title:'Test title', url:'http://whatewer.com/foobar'}], 'ubuntu.loc')
  }
});