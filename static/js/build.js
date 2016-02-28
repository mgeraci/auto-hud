window.AutoHUD = {
  versionPollTime: 5000,
  init: function(params) {
    window.C = params.C;
    this.model = AutoHUDModel;
    this.view = AutoHUDView;
    this.controller = AutoHUDController;
    this.model.view = this.view;
    this.model.controller = this.controller;
    this.view.model = this.model;
    this.view.controller = this.controller;
    this.controller.model = this.model;
    this.controller.view = this.view;
    this.model.set(params);
    this.view.init();
    this.controller.init();
    return this.watchVersion(params);
  },
  watchVersion: function(params) {
    if (params.version == null) {
      window.location.reload();
    } else {
      this.version = params.version;
    }
    return this.versionWatcher = setInterval((function(_this) {
      return function() {
        return _this.fetchVersion();
      };
    })(this), this.versionPollTime);
  },
  fetchVersion: function() {
    return $.ajax("/version", {
      type: "GET",
      success: (function(_this) {
        return function(data) {
          _this.parseVersion(data);
          return _this.model.set({
            noConnection: false
          });
        };
      })(this),
      error: (function(_this) {
        return function() {
          return _this.model.set({
            noConnection: true
          });
        };
      })(this)
    });
  },
  parseVersion: function(data) {
    if (data.version == null) {
      return;
    }
    if (data.version !== this.version) {
      return window.location.reload();
    }
  }
};

window.AutoHUDController = {
  useTestWeatherData: false,
  watchers: {},
  init: function() {
    var i, len, ref, results, section;
    ref = C.sections;
    results = [];
    for (i = 0, len = ref.length; i < len; i++) {
      section = ref[i];
      results.push(this.makeWatcher(section));
    }
    return results;
  },
  makeWatcher: function(section) {
    var getter, pollTime;
    if (section == null) {
      return;
    }
    getter = this[section + "Getter"];
    if ((getter == null) || !_.isFunction(getter)) {
      return;
    }
    pollTime = C[section + "PollTime"];
    if (!pollTime) {
      return;
    }
    getter.call(this);
    return this.watchers[section] = setInterval((function(_this) {
      return function() {
        return getter.call(_this);
      };
    })(this), pollTime);
  },
  timeGetter: function() {
    var d, month;
    d = new Date();
    month = C.months[d.getMonth()];
    return this.model.set({
      time: {
        hours: this.padZeroes(d.getHours()),
        minutes: this.padZeroes(d.getMinutes()),
        seconds: this.padZeroes(d.getSeconds())
      },
      date: {
        month: month,
        day: d.getDate(),
        year: d.getFullYear()
      }
    });
  },
  padZeroes: function(number) {
    if (number < 10) {
      number = "0" + number;
    }
    return number;
  },
  birthdaysGetter: function() {
    return $.ajax(C.birthdaysUrl, {
      type: "GET",
      success: (function(_this) {
        return function(data) {
          return _this.model.set(data);
        };
      })(this)
    });
  },
  choresGetter: function() {
    return $.ajax(C.choresUrl, {
      type: "GET",
      success: (function(_this) {
        return function(data) {
          return _this.model.set(data);
        };
      })(this)
    });
  },
  birdPodcastsGetter: function() {
    return $.ajax(C.birdPodcastsUrl, {
      type: "GET",
      success: (function(_this) {
        return function(data) {
          var res;
          res = {
            birdPodcastCount: data.program_count
          };
          return _this.model.set(res);
        };
      })(this)
    });
  },
  weatherGetter: function() {
    var url;
    if (this.useTestWeatherData) {
      this.formatWeather(weatherData);
      return;
    }
    url = "" + C.weatherUrl + (this.model.get("forecastioApiKey")) + "/" + (this.model.get("forecastioLatLong"));
    return $.getJSON(url + "?callback=?", (function(_this) {
      return function(data) {
        return _this.formatWeather(data);
      };
    })(this));
  },

  /*
  	Format weather data from forecast.io into something a little more simple:
  	current: 75º, rain
  	today: 65º-77º, rain in the afternoon
   */
  formatWeather: function(data) {
    var dayIndex, preview, weather;
    weather = {
      current: {},
      preview: {}
    };
    weather.current.temperature = this.formatTemperature(data.currently.apparentTemperature);
    weather.current.summary = data.currently.summary;
    weather.current.icon = data.currently.icon;
    if (new Date().getHours() < 16) {
      dayIndex = 0;
    } else {
      dayIndex = 1;
    }
    preview = data.daily.data[dayIndex];
    weather.preview = this.formatDayWeather(preview, dayIndex);
    return this.model.set({
      weather: weather
    });
  },
  formatTemperature: function(temperature) {
    temperature = Math.round(temperature);
    return "<span class=\"degree\">" + temperature + "</span>\n<span class=\"degree-symbol\">º</span>";
  },
  formatDayWeather: function(day, tomorrow) {
    if (tomorrow == null) {
      tomorrow = false;
    }
    return {
      low: this.formatTemperature(day.temperatureMin),
      high: this.formatTemperature(day.temperatureMax),
      summary: day.summary.replace(/\.$/, ""),
      icon: day.icon,
      tomorrow: tomorrow,
      precip: Math.round(day.precipProbability * 100)
    };
  },
  subwayGetter: function() {
    var d, day, hour;
    d = new Date();
    if (C.subwayDayRange != null) {
      day = C.daysJs[d.getDay()];
      if (C.subwayDayRange.indexOf(day) < 0) {
        return;
      }
    }
    if ((C.subwayTimeRange != null) && C.subwayTimeRange.length === 2) {
      hour = d.getHours();
      if (hour < C.subwayTimeRange[0] || hour >= C.subwayTimeRange[1]) {
        this.model.set({
          subway: null
        });
        return;
      }
    }
    return $.ajax(C.subwayUrl, {
      type: "GET",
      dataType: "xml",
      success: (function(_this) {
        return function(data) {
          return _this.parseSubway(data);
        };
      })(this)
    });
  },
  parseSubway: function(data) {
    var i, len, line, name, ref, status, subwayStatus;
    subwayStatus = {};
    if (!data || !$(data).length) {
      return;
    }
    ref = $(data).find("service subway line");
    for (i = 0, len = ref.length; i < len; i++) {
      line = ref[i];
      line = $(line);
      name = line.find("name");
      status = line.find("status");
      if (!name.length || !status.length) {
        continue;
      }
      name = name.text();
      status = status.text();
      if (!C.subwayLinesToShow[name]) {
        continue;
      }
      subwayStatus[name] = {
        lines: this.formatLines(name),
        status: status
      };
    }
    return this.model.set({
      subway: subwayStatus
    });
  },
  formatLines: function(lines) {
    var i, len, line, ref, res;
    res = [];
    ref = lines.split("");
    for (i = 0, len = ref.length; i < len; i++) {
      line = ref[i];
      res.push("<span class=\"hud-section-subway-line\">" + line + "</span>");
    }
    return res.join("");
  }
};

var hasProp = {}.hasOwnProperty;

window.AutoHUDModel = {
  data: {},
  set: function(props) {
    var key, value;
    for (key in props) {
      if (!hasProp.call(props, key)) continue;
      value = props[key];
      this.data[key] = value;
    }
    return this.view.render();
  },
  get: function(prop) {
    return this.data[prop];
  },
  getAll: function() {
    return this.data;
  }
};

window.AutoHUDView = {
  templates: {},
  init: function() {
    var i, len, ref, results, section;
    ref = C.sections;
    results = [];
    for (i = 0, len = ref.length; i < len; i++) {
      section = ref[i];
      results.push(this.templates[section] = _.template($("#" + section + "-template").html()));
    }
    return results;
  },
  render: function() {
    var hasLastProps, hasNextProps, i, len, nextProps, ref, ref1, section;
    nextProps = this.model.getAll();
    if (nextProps == null) {
      return;
    }
    if (_.isEqual({}, this.templates)) {
      return;
    }
    ref = C.sections;
    for (i = 0, len = ref.length; i < len; i++) {
      section = ref[i];
      hasLastProps = ((ref1 = this.lastProps) != null ? ref1[section] : void 0) != null;
      hasNextProps = (nextProps != null ? nextProps[section] : void 0) != null;
      if (hasLastProps && hasNextProps && _.isEqual(this.lastProps[section], nextProps[section])) {
        continue;
      }
      $("#" + section + "-wrapper").html(this.templates[section]({
        d: nextProps
      }));
    }
    return this.lastProps = $.extend(true, {}, nextProps);
  }
};
