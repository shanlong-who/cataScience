    // Share one pending download so the first query waits for the search index.
    var fuse;
    var searchReady;
    function loadSearchIndex() {
      if (fuse) return Promise.resolve();
      if (searchReady) return searchReady;
      var input = $("#search-input");
      input.addClass("loading");
      searchReady = (async function () {
        try {
          var response = await fetch(input.data("search-index"));
          if (!response.ok) throw new Error("Search index: HTTP " + response.status);
          var data = await response.json();
          fuse = new Fuse(data, {
            keys: ["what", "text", "code"],
            ignoreLocation: true,
            threshold: 0.1,
            includeMatches: true,
            includeScore: true,
          });
        } catch (error) {
          console.warn("Search index could not be loaded. Type again to retry.", error);
        } finally {
          input.removeClass("loading");
          searchReady = null;
        }
      })();
      return searchReady;
    }
    $("#search-input").focus(loadSearchIndex);

